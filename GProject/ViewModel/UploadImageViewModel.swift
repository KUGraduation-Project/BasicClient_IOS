////
////  BoradComposeViewModel.swift
////  GProject
////
////  Created by 서정 on 2021/07/15.
////
//
import Foundation
import RxSwift
import RxCocoa

class UploadImageViewModel {

    var title: String?
    var content: String?

    let disposeBag = DisposeBag()

  
    // 매개변수 전달 대신 Relay로 바꿔야함
    func postImageToServer(image: UIImage) -> Observable<Int> {
        
        return ProjectService.shared.postUploadFile(imageData: image.pngData()!)
    }

}
