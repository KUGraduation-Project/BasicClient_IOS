//
//  ListViewController.swift
//  GProject
//
//  Created by 서정 on 2021/07/12.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown
import SnapKit
import Then
import RxDataSources

class ProjectListViewController: UIViewController {
  
    let coordinator = ViewCoordinator()
    
    let viewModel = ProjectListViewModel()
    var disposeBag = DisposeBag()
    
    let titleLabel = UILabel()
        .then {
            $0.text = "3D Modeling"
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 30.0, weight: .bold)
        }
    
    var projectCV: UICollectionView!
    
    let layout = UICollectionViewFlowLayout()
        .then {
            $0.scrollDirection = .vertical
            $0.minimumInteritemSpacing = 5.0
            $0.minimumLineSpacing = 12.0
            
            $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 200)
            
            let width = (UIScreen.main.bounds.width - 45) / 2
            $0.itemSize = CGSize(width: width, height: width+15)
            $0.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
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
        cell.downloadButton.isHidden = true

        return cell
    },
    configureSupplementaryView: { _, collectionView, _, indexPath in
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProjectHeaderReusableView.identifier, for: indexPath) as! ProjectHeaderReusableView
        
        headerView.buttonTappedHandler = { [weak self] in
            self?.moveToImageListPage()
        }

        return headerView
    })
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getProjectList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        layoutView()
        bindView()
        
//        viewModel.getProjectList()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor.appColor(.backgroundBlack)
        navigationController?.navigationBar.isHidden = true
//        let leftBtnItem = UIBarButtonItem()
//        leftBtnItem.title = "내 정보"
//        leftBtnItem.tintColor = .black
//
//        let rightBtnItem = UIBarButtonItem()
//        rightBtnItem.title = "선택"
//        rightBtnItem.tintColor = .black
//
//        self.navigationItem.leftBarButtonItem = leftBtnItem
//        self.navigationItem.rightBarButtonItem = rightBtnItem
        
        projectCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        projectCV.backgroundColor = .clear
        projectCV.register(ProjectCell.self,
                           forCellWithReuseIdentifier: ProjectCell.identifier)
        projectCV.register(ProjectHeaderReusableView.self,
                           forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                           withReuseIdentifier: ProjectHeaderReusableView.identifier)
    }
    
    private func layoutView() {
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20.0)
            $0.left.equalToSuperview().offset(20.0)
            $0.right.equalToSuperview().offset(-20.0)
        }
        
        view.addSubview(projectCV)
        projectCV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20.0)
            $0.right.equalToSuperview().offset(-20.0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(25.0)
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
                    coordinator.start(projectId: model.projectId ?? 0)
//                }
            })
            .disposed(by: disposeBag)
    }

  
    private func moveToImageListPage() {
        let vc = ImageListViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func bindLeftNavButton() {
        self.navigationItem.leftBarButtonItem?
            .rx.tap
            .bind { _ in
                self.moveToSettingVC()
            }
            .disposed(by: disposeBag)    }
    
    private func moveToSettingVC() {
        let settingPage = SettingViewController()
        settingPage.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(settingPage, animated: true)
    }
    
}
