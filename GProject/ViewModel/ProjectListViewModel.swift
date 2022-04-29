//
//  ProjectListViewModel.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation
import RxSwift
import RxCocoa
import Differentiator


class ProjectListViewModel {
    let disposeBag = DisposeBag()
    
    //output
    let projectList = BehaviorRelay<[SectionModel<String, ProjectListObjectData>]>(value: [])
    
    var projectListBehaviorSubject = BehaviorRelay<[ProjectListObjectData]>(value: [ProjectListObjectData(projectId: -1, name: "", date: "", imageFileUri: imageIconName, imageFileId: -1)])
    
    func getProjectList() {
        ProjectService.shared.getShowProjectList()
            .bind { [weak self] response in
                
//                self?.projectListBehaviorSubject.accept([ProjectListObjectData(projectId: -1, name: "", date: "", imageFileUri: imageIconName, imageFileId: -1)] + (response.data ?? []))
                
                self?.projectList.accept(
                    [SectionModel(
                        model: "",
                        items: response.data ?? [])
                    ]
                )
            }
            .disposed(by: disposeBag)
    }
    
    func getProjectId(index : Int) -> Int {
        return projectListBehaviorSubject.value[index].projectId ?? 0
    }
}
