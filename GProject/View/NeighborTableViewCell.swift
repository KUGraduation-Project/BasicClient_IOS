//
//  TableViewCell.swift
//  GProject
//
//  Created by 서정 on 2021/07/19.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class NeighborTableViewCell: UITableViewCell {
    
    static let identifier = "NeighborTableViewCellIdentifier"
    
    var nicknameLabel = UILabel()
        .then {
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        }
    
    var firstButton = UIButton()
        .then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 5.0
            $0.setTitle("추가", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
            $0.setTitleColor(.white, for: .normal)
        }
    
    var secondButton = UIButton()
        .then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 5.0
            $0.setTitle("삭제", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
            $0.setTitleColor(.white, for: .normal)
        }
    
    var firstButtonTappedHandler: (() -> Void)?
    
    var secondButtonTappedHandler: (() -> Void)?
 
    var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        layoutView()
        bindView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        layoutView()
        bindView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configureView()
        disposeBag = DisposeBag()
    }
    
    func configureView() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }

    
    func layoutView() {
        contentView.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5.0)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(secondButton)
        secondButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-5.0)
            $0.width.equalTo(50.0)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(firstButton)
        firstButton.snp.makeConstraints {
            $0.right.equalTo(secondButton.snp.left).offset(-15.0)
            $0.width.equalTo(50.0)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bindView() {
        firstButton.rx.tap
            .bind { [weak self] in
                self?.firstButtonTappedHandler?()
            }
            .disposed(by: disposeBag)

        secondButton.rx.tap
            .bind { [weak self] in
                self?.secondButtonTappedHandler?()
            }
            .disposed(by: disposeBag)
    }
}
