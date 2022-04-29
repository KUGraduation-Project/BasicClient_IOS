//
//  PersonalInfoViewModel.swift
//  GProject
//
//  Created by 서정 on 2021/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class PersonalInfoViewModel {
    
    private let service: DataServiceType = DataService()
    let disposeBag = DisposeBag()
    
    var infoSubject = BehaviorSubject<[String]>(value: [])
    
//    init(service: DataServiceType = DataService()) {
//        self.service = service
//    }
    
    func getMyInfo() {
        UserService.shared.getUserInfo()
            .bind { result in
                var list: [String] = []
                list.append("이메일: \(result.data?.email ?? "" )")
                list.append("닉네임: \(result.data?.nickname ?? "" )")
                list.append("생일: \(result.data?.birth ?? "" )")
                
                self.infoSubject.onNext(list)
                
            }
            .disposed(by: disposeBag)
        
    }
}
