//
//  ImageListCell.swift
//  GProject
//
//  Created by sangmin han on 2021/10/24.
//

import Foundation
import UIKit

class ImageListCell: UICollectionViewCell {
    
    
    var image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .none
        makeimage()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [unowned self] in
            image.layer.cornerRadius = 8.0
            image.clipsToBounds = true
        }

    }
    
}
extension ImageListCell {
    private func makeimage(){
        self.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        image.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        image.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
    }
}
