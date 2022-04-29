//
//  NeighborProjectListViewModel.swift
//  GProject
//
//  Created by 서정 on 2022/04/29.
//

import RxSwift
import RxCocoa
import RxDataSources

class NeighborProjectListViewModel {
    
    let neighbor = BehaviorRelay<NeighborDetail>(value: NeighborDetail(
        nickname: "", neighborId: 0, userId: 0, isApprove: false)
    )
    let projectList = BehaviorRelay<[SectionModel<String, ProjectListObjectData>]>(value: [])
    
    var disposeBag = DisposeBag()
    
    func getProjectList() {
        ProjectShareService.shared.getShowNeighborProject(
            neighborId: neighbor.value.neighborId ?? -1
        )
            .bind { [weak self] response in
                
                self?.projectList.accept(
                    [SectionModel(
                        model: "",
                        items: response.data ?? [])
                    ]
                )
            }
            .disposed(by: disposeBag)
    }
    
    func downloadProject(projectId: Int) {
        ProjectShareService.shared.getDownloadProject(projectId: projectId)
            .bind { response in
                ToastView.shared.short(txt_msg: response.data ?? "오류 발생")
            }
            .disposed(by: disposeBag)
    }
    
    
}
