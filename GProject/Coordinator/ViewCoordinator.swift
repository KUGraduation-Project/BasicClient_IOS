//
//  ViewCoordinator.swift
//  GProject
//
//  Created by sangmin han on 2021/10/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


protocol ObjectSelectionCoordinatorProtocol : AnyObject {
    func objectSelected(object : VirtualObject)
    
}

class ViewCoordinator  {
    
    var isMe: Bool = true
    
    var disposebag = DisposeBag()
    
    var rootView = ARViewController()
    let viewmodel = ARViewModel()
    var bottomsheet :  ObjectSelectViewController!
    
    func start(projectId : Int){
        viewmodel.coordinator = self
        rootView.viewmodel = viewmodel
        viewmodel.getCoordinates(projectId : projectId)
            .map { [unowned self] data,width,height -> (Bool, String ) in
                viewmodel.setUpScene(data: data,width: width,height: height)
                if width == -1 {
                    return (false,"도면의 가로 길이를 구하지 못하였습니다")
                }
                if height == -1 {
                    return (false,"도면의 세로 길이를 구하지 못하였습니다")
                }
                return (!(data.count == 0),"잠시 후 시도해 주세요")
            }
            .subscribe(onNext : { [unowned self] done,msg in
                if done {
                    guard let scene = UIApplication.shared.connectedScenes.first else { return }
                    guard let del = scene.delegate as? SceneDelegate else { return }
                    
                    let navController = del.window?.rootViewController as? UINavigationController
                   
                    navController?.pushViewController(rootView, animated: true)
                }
                else {
                    ToastView.shared.short(txt_msg: msg)
                }
            })
            .disposed(by: disposebag)
  
        self.showObjectselectionViewController()
    }
    
    
    private func showObjectselectionViewController(){
        if !isMe {
            return
        }
        
        bottomsheet = ObjectSelectViewController(frame: .zero, viewmodel: ObjectSelectViewModel())
        bottomsheet.viewModel.coordinator = self
        rootView.view.addSubview(bottomsheet)
        bottomsheet.frame = rootView.view.frame
        
    }
    
    
    func goback(){
        rootView.navigationController?.popViewController(animated: true)
    }
    
}

extension ViewCoordinator : ObjectSelectionCoordinatorProtocol {
    func objectSelected(object: VirtualObject) {
        bottomsheet.animateDismissbottomSheet()
        rootView.loadObject(object: object)
    }
    
    
}
