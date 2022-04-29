//
//  RegisterViewModel.swift
//  GProject
//
//  Created by 서정 on 2021/10/09.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
    let disposeBag = DisposeBag()
    private let service: DataServiceType = DataService()
    
    let emailTextRelay = BehaviorRelay<String>(value: "")
    let passwdTextRealy = BehaviorRelay<String>(value: "")
    let nicknameTextRelay = BehaviorRelay<String>(value: "")
    let birthDateRelay = PublishRelay<Date>()
    
    var requestingUser = UserInfo(nickname: "", birth: "")
    
    var validation = false
    
//    init(service: DataServiceType = DataService()) {
//        self.service = service
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
         
        return Observable
            .combineLatest(emailTextRelay, passwdTextRealy, nicknameTextRelay, birthDateRelay)
            .map { email, passwd, nickname, birth in
                if emailTest.evaluate(with: email) && passwd.count > 6 {
                
                    self.requestingUser.nickname = nickname
                    self.requestingUser.birth = dateFormatter.string(from: birth)
                    return true
                } else {
                    return false
                }
            }
    }
    
    func submitRegisterInfo() -> Observable<Bool> {
        return self.service.addUser(userInfo: requestingUser)
            .map { res -> Bool in
                return res
            }
    }
}
