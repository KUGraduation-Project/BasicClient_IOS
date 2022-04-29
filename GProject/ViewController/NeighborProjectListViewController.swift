//
//  NeighborProjectListViewController.swift
//  GProject
//
//  Created by 서정 on 2022/04/29.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown
import SnapKit
import Then
import RxDataSources

class NeighborProjectListViewController: UIViewController {

    let viewModel = NeighborProjectListViewModel()
    
    let coordinator = ViewCoordinator()
   
    var disposeBag = DisposeBag()
    
    var projectCV: UICollectionView!
    
    let titleLabel = UILabel()
        .then {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        }
    
    let layout = UICollectionViewFlowLayout()
        .then {
            $0.scrollDirection = .vertical
            $0.minimumInteritemSpacing = 10.0
            $0.minimumLineSpacing = 10.0
            
            let width = (UIScreen.main.bounds.width - 50) / 2
            $0.itemSize = CGSize(width: width, height: width+10)
            $0.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, ProjectListObjectData>>(configureCell: { _, collectionView, indexPath, element in

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.identifier, for: indexPath) as! ProjectCell
        
        if element.imageFileUri == imageIconName {
            cell.imageView.image = UIImage(named: imageIconName)
            
        }
        else {
            if let url = URL(string: element.imageFileUri ?? "") {
                cell.imageView.kf.setImage(with: url)
            }
        }

        cell.titleLabel.text = element.name ?? "NaN"
        cell.downloadButtonTapHandler = { [weak self] in
            self?.viewModel.downloadProject(projectId: element.projectId ?? -1)
        }

        return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        layoutView()
        bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getProjectList()
    }
    
    private func configureView() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.appColor(.backgroundBlack)
        
        titleLabel.text = "\(viewModel.neighbor.value.nickname ?? "NaN")님의 프로젝트"
        
        projectCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        projectCV.backgroundColor = .clear
        projectCV.register(ProjectCell.self,
                           forCellWithReuseIdentifier: ProjectCell.identifier)
    }
    
    private func layoutView() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20.0)
            $0.right.equalToSuperview().offset(-20.0)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20.0)
        }
        
        view.addSubview(projectCV)
        projectCV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20.0)
            $0.right.equalToSuperview().offset(-20.0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20.0)
        }
    }
    
    private func bindView() {
        viewModel.projectList
            .asDriver()
            .drive(projectCV.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        projectCV.rx.modelSelected(ProjectListObjectData.self)
            .subscribe(onNext : { [unowned self] model in
//                if model.imageFileId == -1 || model.projectId == -1 {
//                    moveToImageListPage
//                }
//                else {
                coordinator.isMe = false
                coordinator.start(projectId: model.projectId ?? 0)
//                }
            })
            .disposed(by: disposeBag)
    }

  
}
