//
//  ProjectHeaderReusableView.swift
//  GProject
//
//  Created by 서정 on 2022/04/29.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ProjectHeaderReusableView: UICollectionReusableView {
    
    static let identifier = "ProjectHeaderIdentifier"
    
    var addProjectButton = AddingProjectButton()
    var buttonTappedHandler: (() -> Void)?
    var disposeBag = DisposeBag()
    
    var titleLabel = UILabel()
        .then {
            $0.text = "내 프로젝트"
            $0.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
            $0.textColor = .white
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
        bindView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layoutView()
        bindView()
    }
    
    func layoutView() {
        self.addSubview(addProjectButton)
        addProjectButton.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(addProjectButton.snp.bottom).offset(20.0)
            $0.left.right.equalTo(addProjectButton)
            $0.bottom.equalToSuperview().offset(-10.0)
        }
    }
    
    func bindView() {
        addProjectButton.rx.tap
            .bind { [weak self] _ in
                self?.buttonTappedHandler?()
            }
            .disposed(by: disposeBag)
    }
}
