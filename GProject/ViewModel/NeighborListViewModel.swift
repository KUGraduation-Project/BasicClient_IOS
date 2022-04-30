//
//  NeighborListViewModel.swift
//  GProject
//
//  Created by 서정 on 2022/04/29.
//

import RxSwift
import RxCocoa
import RxDataSources

class NeighborListViewModel {
    let nickname = BehaviorRelay<String>(value: "")
    let applyingNeighbor = BehaviorRelay<Neighbor>(value: Neighbor(nickname: "", userId: 0))
    
    let neighborList = BehaviorRelay<[SectionModel<String, NeighborDetail>]>(value: [])
    
    let appliedNeighborList = BehaviorRelay<[SectionModel<String, NeighborDetail>]>(value: [])
    
    let searchNeighborList = BehaviorRelay<[SectionModel<String, Neighbor>]>(value: [])
    
    var disposeBag = DisposeBag()
    
    func bindNeighborList() {
        NeighborService.shared.getNeighborList()
            .bind { [weak self] response in
                self?.neighborList.accept([SectionModel(model: "", items: response.data ?? [])])
            }
            .disposed(by: disposeBag)
    }
    
    func bindAppliedNeighborList() {
        NeighborService.shared.getNeighborApplicationList()
            .bind { [weak self] response in
                self?.appliedNeighborList.accept([SectionModel(model: "", items: response.data ?? [])])
            }
            .disposed(by: disposeBag)
            
    }
    
    func bindSearchNeighborList() {
        NeighborService.shared
            .getSearchNeighbor(nickname: nickname.value)
            .bind { [weak self] response in
                self?.searchNeighborList.accept([SectionModel(model: "", items: response.data ?? [])])
            }
            .disposed(by: disposeBag)
    }
    
    func bindApplyButton(neighbor: Neighbor) {
        NeighborService.shared.postRequestNeighbor(neighbor: neighbor)
            .bind { response in
                ToastView.shared.short(txt_msg: response.data ?? "이웃 신청 실패")
            }
            .disposed(by: disposeBag)
    }
    
    func bindDeleteNeighborButton(neighborId: Int) {
        NeighborService.shared.deleteNeighbor(neighborId: neighborId)
            .bind { [weak self] response in
                self?.neighborList.accept([SectionModel(model: "", items: response.data ?? [])])
            }
            .disposed(by: disposeBag)
    }
    
    func bindApplyNeighborButton(neighborDetail: NeighborDetail) {
        NeighborService.shared.postApproveNeighbor(neighborDetail: neighborDetail)
            .bind { [weak self] response in
                self?.appliedNeighborList.accept([SectionModel(model: "", items: response.data ?? [])])
            }
            .disposed(by: disposeBag)
    }
    
}
