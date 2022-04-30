//
//  AddingProjectButton.swift
//  GProject
//
//  Created by 서정 on 2022/04/29.
//

import UIKit
import SnapKit
import Then

class AddingProjectButton: UIButton {

    var horizontalRect = UIView()
        .then {
            $0.backgroundColor = .white
        }
    
    var verticalRect = UIView()
        .then {
            $0.backgroundColor = .white
        }
    
    var textLabel = UILabel()
        .then {
            $0.text = "Add project"
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 13)
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        layoutView()
    }
    
    func configureView() {
        self.backgroundColor = UIColor.appColor(.mainBlue)
        self.layer.cornerRadius = 10
    }
    
    func layoutView() {
        self.addSubview(horizontalRect)
        horizontalRect.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(30.0)
            $0.height.equalTo(5.0)
        }
        
        self.addSubview(verticalRect)
        verticalRect.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(30.0)
            $0.width.equalTo(5.0)
        }
        
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.equalTo(verticalRect.snp.bottom).offset(10.0)
            $0.bottom.equalToSuperview().offset(-30.0)
            $0.centerX.equalToSuperview()
        }
    }
}
