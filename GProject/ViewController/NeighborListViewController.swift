//
//  NeighborListViewController.swift
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

class NeighborListViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    let viewModel = NeighborListViewModel()
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, NeighborDetail>>(configureCell: { _, tableView, indexPath, element in

        let cell = tableView.dequeueReusableCell(withIdentifier: NeighborTableViewCell.identifier, for: indexPath) as! NeighborTableViewCell

        cell.firstButton.isHidden = true
        cell.secondButton.setTitle("삭제", for: .normal)
        cell.nicknameLabel.text = element.nickname ?? "NaN"
        
        cell.secondButtonTappedHandler = { [weak self] in
            self?.viewModel.bindDeleteNeighborButton(neighborId: element.neighborId ?? 0)
            self?.neighborListTableView.reloadData()
        }
        
        return cell
    })
    
    let titleLabel = UILabel()
        .then {
            $0.text = "이웃들의 프로젝트"
            $0.font = UIFont.systemFont(ofSize: 27.0, weight: .bold)
            $0.textColor = .white
        }
    
    let searchButton = UIButton()
        .then {
            $0.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    
    let noticeButton = UIButton()
        .then {
            $0.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    
    let neighborListTableView = UITableView()
        .then {
            $0.backgroundColor = .clear
            $0.register(NeighborTableViewCell.self, forCellReuseIdentifier: NeighborTableViewCell.identifier)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layoutView()
        bindView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.bindNeighborList()
    }
    
    func configureView() {
        view.backgroundColor = UIColor.appColor(.backgroundBlack)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func layoutView() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10.0)
            $0.left.equalToSuperview().offset(20.0)
        }
        
        view.addSubview(noticeButton)
        noticeButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20.0)
            $0.centerY.equalTo(titleLabel)
        }
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.right.equalTo(noticeButton.snp.left).offset(-10.0)
            $0.centerY.equalTo(titleLabel)
        }
        
        view.addSubview(neighborListTableView)
        neighborListTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5.0)
            $0.left.equalToSuperview().offset(20.0)
            $0.right.equalToSuperview().offset(-20.0)
        }
    }
    
    func bindView() {
        neighborListTableView.rx
            .modelSelected(NeighborDetail.self)
            .asSignal()
            .emit(onNext: moveToNeighborDetailPage)
            .disposed(by: disposeBag)
        
        noticeButton.rx.tap
            .asSignal()
            .emit(onNext: moveToNoticePage)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .asSignal()
            .emit(onNext: moveToSearchPage)
            .disposed(by: disposeBag)
        
        viewModel.neighborList
            .asDriver()
            .drive(neighborListTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func moveToNoticePage() {
        let vc = NeighborNoticeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToSearchPage() {
        let vc = NeighborSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToNeighborDetailPage(neighborDetail: NeighborDetail) {
        let vc = NeighborProjectListViewController()
        vc.viewModel.neighbor.accept(neighborDetail)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
