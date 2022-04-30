//
//  NeighborSearchViewController.swift
//  GProject
//
//  Created by 서정 on 2022/04/29.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class NeighborSearchViewController: UIViewController {
    
    let viewModel = NeighborListViewModel()
    var disposeBag = DisposeBag()
    
    var searchBar = SearchBarView()
    
    var searchListTableView = UITableView()
        .then {
            $0.backgroundColor = .clear
            $0.isUserInteractionEnabled = true
            $0.register(NeighborTableViewCell.self, forCellReuseIdentifier: NeighborTableViewCell.identifier)
        }
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Neighbor>>(configureCell: { _, collectionView, indexPath, element in

        let cell = collectionView.dequeueReusableCell(withIdentifier: NeighborTableViewCell.identifier, for: indexPath) as! NeighborTableViewCell

        cell.firstButton.isHidden = true
        cell.secondButton.setTitle("신청", for: .normal)
        
        cell.nicknameLabel.text = element.nickname ?? "NaN"

        cell.secondButtonTappedHandler = { [weak self] in
            let neighbor = Neighbor(
                nickname: element.nickname,
                userId: element.userId
            )
            self?.viewModel.bindApplyButton(neighbor: neighbor)
        }
        
        return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        layoutView()
        bindView()
    }

    func configureView() {
        view.backgroundColor = UIColor.appColor(.backgroundBlack)
        searchListTableView.allowsSelection = false
    }
    
    func layoutView() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60.0)
            $0.left.equalToSuperview().offset(20.0)
            $0.right.equalToSuperview().offset(-20.0)
            $0.height.equalTo(47.0)
        }
        
        view.addSubview(searchListTableView)
        searchListTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20.0)
            $0.left.equalToSuperview().offset(20.0)
            $0.right.equalToSuperview().offset(-20.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5.0)
        }

    }
    
    func bindView() {
        searchBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        searchBar.searchField.rx.text
            .orEmpty
            .filter { !$0.isEmpty }
            .bind(to: viewModel.nickname)
            .disposed(by: disposeBag)
        
        searchBar.searchButton.rx.tap
            .asSignal()
            .emit(onNext: viewModel.bindSearchNeighborList)
            .disposed(by: disposeBag)
        
        viewModel.searchNeighborList
            .asDriver()
            .drive(searchListTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}
