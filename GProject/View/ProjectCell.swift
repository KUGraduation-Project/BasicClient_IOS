//
//  CollectionViewCell.swift
//  GProject
//
//  Created by 서정 on 2021/08/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ProjectCell: UICollectionViewCell {
    
    static let identifier = "ProjectCell"
    
    var disposeBag = DisposeBag()
    var downloadButtonTapHandler: (() -> ())?
    
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var downloadButton = UIButton()
        .then {
            $0.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
            $0.tintColor = .white
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        imageView.clipsToBounds = true
        
        self.addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor,constant: 3).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -3).isActive = true
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        self.addSubview(downloadButton)
        downloadButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-5.0)
            $0.centerY.equalTo(titleLabel)
        }
        
        bindView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [unowned self] in
            imageView.layer.cornerRadius = 10.0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bindView() {
        downloadButton.rx.tap
            .bind { [weak self] in
                self?.downloadButtonTapHandler?()
            }
            .disposed(by: disposeBag)
    }
}
