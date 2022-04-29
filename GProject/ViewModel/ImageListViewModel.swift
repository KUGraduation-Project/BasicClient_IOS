//
//  ImageListViewModel.swift
//  GProject
//
//  Created by sangmin han on 2021/10/24.
//

import Foundation
import RxSwift
import RxCocoa



class ImageListViewModel {
    
    //data
    let coordinate = ViewCoordinator()
    private var projectName = ""
    private var currenSelectedImageId : Int = 0
    private var projectId:Int = 0
    
    //output
     var imageListData = BehaviorRelay<[ImageListData]>(value: [])
    
    
    //input
    var currentSelectedImage = PublishSubject<Int>()

    
    
//    private let service: DataServiceType!
    private var disposebag = DisposeBag()
    
    init(service : DataServiceType = DataService()){
//        self.service = service
        
//        fetchdata()
        
        currentSelectedImage
            .subscribe(onNext : { [unowned self] imageFileId in
                self.currenSelectedImageId = imageFileId
                guard let scene = UIApplication.shared.connectedScenes.first else { return }
                guard let del = scene.delegate as? SceneDelegate else { return }
                
                let waitmodal = ProjectNameInputPopup(frame: del.window!.frame)
                waitmodal.textinput.text = "3D 모델링중..."
                waitmodal.confirmBtn.setTitle("확인하기", for: .normal)
                waitmodal.closeBtn.rx.tap
                    .subscribe(onNext : { [unowned self] in
                        waitmodal.removeFromSuperview()
                    })
                    .disposed(by: disposebag)
                
                waitmodal.confirmBtn.rx.tap
                    .subscribe(onNext : { [unowned self] in
                    // 서버에 OCR 결과 요청
                        ProjectService.shared.getCheck3DModel(imageFileId: currenSelectedImageId)
                            .bind { [weak self]response in
                                if response.data?.modelExist ?? false {
                                    waitmodal.removeFromSuperview()
                                    self?.coordinate.start(projectId: self?.projectId ?? 0)
                                }
                                else {
                                    ToastView.shared.short(txt_msg: "잠시만 기다려주세요.")
                                    FunctionClass.shared.showdialog(show: false)
                                }
                                
                            }
                            .disposed(by: disposebag)
                    })
                    .disposed(by: disposebag)
                
                
                
                let popup = ProjectNameInputPopup(frame: del.window!.frame)
                popup.textinput.becomeFirstResponder()
                popup.textinput.rx.text.orEmpty
                    .subscribe(onNext : { [unowned self] name in
                        self.projectName = name
                    })
                    .disposed(by: disposebag)
                
                popup.closeBtn.rx.tap
                    .subscribe(onNext : { [unowned self] in
                        popup.removeFromSuperview()
                    })
                    .disposed(by: disposebag)
                
                popup.confirmBtn.rx.tap
                    .subscribe(onNext : { [unowned self] in
                        popup.removeFromSuperview()
//                        del.window?.addSubview(waitmodal)
                        
                        ProjectService.shared.postCreateProject(data: ProjectRequestData(projectId: currenSelectedImageId, projectName: projectName))
                            .subscribe(onNext : { [unowned self] response in
                                print("DATA: ", response.data ?? "No Data")
                                if !(response.data?.isModelExist ?? false) {
                                    del.window?.addSubview(waitmodal)
                                }
                                
                                else {
                                    self.projectId = response.data?.projectId ?? 0
                                    self.coordinate.start(projectId: response.data?.projectId ?? 0)
                                }
                                
                                //else: 모델 존재한다면 AR로 이동
                                
                                self.coordinate.goback()
                            })
                            .disposed(by: disposebag)
                    })
                    .disposed(by: disposebag)
                
                del.window?.addSubview(popup)
                
                
                
//                coordinate.start()
            })
            .disposed(by: disposebag)
    }
    

    func fetchdata(){
        FunctionClass.shared.showdialog(show: true)
        ProjectService.shared.getImageList()
            .subscribe(onNext : { [unowned self] response in
                print(response.data ?? "No image")
                imageListData.accept(response.data ?? [])
                FunctionClass.shared.showdialog(show: false)
            })
            .disposed(by: disposebag)
    }
    
    
    
}


