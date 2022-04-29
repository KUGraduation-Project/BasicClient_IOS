//
//  ComposeViewController.swift
//  GProject
//
//  Created by 서정 on 2021/07/19.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Then
import SnapKit

class UploadImageViewController: UIViewController {
    
    var imageView = UIImageView()
    var uploadButton = UIButton()
    var okayButton = UIButton()
    var imagePicker = UIImagePickerController()
    
    var indicator = UIActivityIndicatorView()
    
    var capturedImage: UIImage!
    
    let viewModel = UploadImageViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        setView()
    }

    private func setView() {
        setImageView()
        setIndicator()
        setOkayButton()
        setUploadButton()
    }
    
    private func setImageView() {
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "image_default")?.resize(newWidth: UIScreen.main.bounds.width*3/4)
        imageView.contentMode = .scaleAspectFit
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setIndicator() {
        indicator.hidesWhenStopped = true
        indicator.style = .large
        view.addSubview(indicator)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setUploadButton() {
        uploadButton.setTitle("사진 선택하기", for: .normal)
        uploadButton.backgroundColor = .lightGray
        uploadButton.layer.cornerRadius = 5
        uploadButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        view.addSubview(uploadButton)
        
        uploadButton.translatesAutoresizingMaskIntoConstraints = false

        uploadButton.bottomAnchor.constraint(equalTo: okayButton.topAnchor, constant: -20).isActive = true
        uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        uploadButton.rx.tap
            .bind { _ in
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func setOkayButton() {
        okayButton.setTitle("확인", for: .normal)
        okayButton.backgroundColor = .lightGray
        okayButton.layer.cornerRadius = 5
        okayButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        view.addSubview(okayButton)
        
        okayButton.translatesAutoresizingMaskIntoConstraints = false
        okayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        okayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        
        okayButton.rx.tap
            .bind { _ in
                if(self.imageView.image != nil) {
                    self.indicator.startAnimating()
                    self.viewModel.postImageToServer(image: self.capturedImage)
                        .bind { id in
                            self.indicator.stopAnimating()
                            self.navigationController?.popViewController(animated: true)
                        }
                        .disposed(by: self.disposeBag)
                } else {
                    print("이미지를 업로드해주세요")
                }
            }
            .disposed(by: disposeBag)
    }


}

extension UploadImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        capturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        capturedImage = capturedImage.resize(newWidth: UIScreen.main.bounds.width*3/4)
        self.imageView.image = capturedImage

        self.dismiss(animated: true, completion: nil)
        
    }
}

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}


