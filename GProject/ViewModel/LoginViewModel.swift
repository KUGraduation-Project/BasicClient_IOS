//
//  LoginViewModel.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation
import RxSwift
import RxCocoa


class LoginViewModel {
    
    let disposeBag = DisposeBag()
    
    //Input
    let emailTextRelay = BehaviorRelay<String>(value: "")
    let passwdTextRealy = BehaviorRelay<String>(value: "")
    
    //Output
    var requestingUser = BehaviorRelay<LoginRequestDTO>(value: LoginRequestDTO(email: "", password: ""))

    var userData = PublishSubject<UserInfoResponse>()
    
    var validation = false
    
    

//    private let service : DataServiceType!
//    init(service : DataServiceType = DataService()) {
//        self.service = service
//
//    }
 
    func setFormValidation() {
        isFormValid()
            .bind { v in
                self.validation = v
            }
            .disposed(by: disposeBag)
    }
    
    private func isFormValid() -> Observable<Bool> {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return Observable
            .combineLatest(emailTextRelay, passwdTextRealy)
            .map { [weak self] email, passwd in
                if emailTest.evaluate(with: email) && passwd.count > 6 {
                    
                    self?.requestingUser.accept(LoginRequestDTO(email: email, password: passwd))
                 
                    return true
                } else {
                    return false
                }
            }
    }
    
    func requestLogin() {
        FunctionClass.shared.showdialog(show: true)
     
        UserService.shared.postGetToken(user: requestingUser.value)
            .subscribe(onNext : { [weak self] result in
                
                if let token = result.data?.token {
                    TokenUtils.shared.createJwt(value: token)
                    self?.requestMyInfo()
                } else {
                    ToastView.shared.short(txt_msg: "login failed")
                    FunctionClass.shared.showdialog(show: false)
                }
                
            },onError: { error  in
                ToastView.shared.short(txt_msg: "login failed")
                FunctionClass.shared.showdialog(show: false)
            })
            .disposed(by: disposeBag)

    }
    
    func requestMyInfo() {
        UserService.shared.getUserInfo()
            .subscribe(onNext : { [weak self] user in
                self?.userData.onNext(user)
                FunctionClass.shared.showdialog(show: false)
            }, onError: { error  in
                ToastView.shared.short(txt_msg: "me failed")
                FunctionClass.shared.showdialog(show: false)
            })
            .disposed(by: self.disposeBag)
    }

}

