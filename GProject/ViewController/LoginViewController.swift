//
//  ViewController.swift
//  GProject
//
//  Created by 서정 on 2021/07/11.
//

import UIKit
import Alamofire

import RxSwift

import KakaoSDKAuth


class LoginViewController: UIViewController {
    
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()

    let appNameLabel = UILabel()
    
    let emailForm = UITextField()
    let passwdForm = UITextField()
    let loginButton = UIButton()
    let registerButton = UIButton()
    let kakaoLoginButton = UIButton()
    let kakaoRegisterButton = UIButton()
    
    var user = PublishSubject<UserInfo>()
    
//    var accessToken:OAuthToken?
//    var nickname:String?
//    var userInfo: UserInfo?
    
    lazy var stackView: UIStackView = {
        let stackV = UIStackView(arrangedSubviews: [self.appNameLabel ,self.emailForm, self.passwdForm, self.loginButton, self.registerButton, self.kakaoLoginButton, self.kakaoRegisterButton])
        
        stackV.axis = .vertical
        stackV.spacing = 20
        stackV.alignment = .fill
        stackV.distribution = .fillEqually
        return stackV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        setStackView()
        bindViewModel()
        
 
        
    }
    
    func setStackView() {
        setAppNameLabel()
        setForm()
        setLoginButton()
        setRegisterButton()
//        setKakaoButton()
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setAppNameLabel() {
        appNameLabel.text = "3D home"
        appNameLabel.font.withSize(30)
        appNameLabel.textAlignment = .center
    }
    
    private func setForm() {
        emailForm.borderStyle = .roundedRect
        emailForm.placeholder = "email"
        
        passwdForm.borderStyle = .roundedRect
        passwdForm.isSecureTextEntry = true
        passwdForm.placeholder = "password"
    }
    
    private func setLoginButton() {
        loginButton.setTitle("로그인", for: .normal)
        loginButton.backgroundColor = .black
        loginButton.titleLabel?.textColor = .white
        loginButton.layer.cornerRadius = 5
    }
    
    private func setRegisterButton() {
        registerButton.setTitle("회원가입", for: .normal)
        registerButton.titleLabel?.textColor = .white
        registerButton.backgroundColor = .black
        registerButton.layer.cornerRadius = 5
    }
    
    private func setKakaoButton() {
        kakaoLoginButton.setImage(UIImage(named: "kakao_login_medium_narrow.png"), for: .normal)
        kakaoRegisterButton.setImage(UIImage(named: "kakao_signup_medium_narrow.png"), for: .normal)
    }
    
    func bindViewModel() {

        self.viewModel.userData
            .bind { user in
                self.moveToMainPage()
            }
            .disposed(by: self.disposeBag)

        emailForm.rx.text
            .orEmpty
            .bind(to: viewModel.emailTextRelay)
            .disposed(by: disposeBag)
        
        passwdForm.rx.text
            .orEmpty
            .bind(to: viewModel.passwdTextRealy)
            .disposed(by: disposeBag)
        
        viewModel.setFormValidation()
        
        viewModel.userData
            .bind { userDataRes in
                if(!userDataRes.authorities.isEmpty) {
                    self.moveToMainPage()
                }
                else {
                    print("로그인 실패")
                }
            }
            .disposed(by: self.disposeBag)
        
        loginButton.rx.tap
            .bind { _ in
                if self.viewModel.validation == true {
                    //서버에 로그인 요청
                    self.viewModel.requestLogin()
                    
                } else {
                    print("로그인 형식에 맞지 않음")
                }
            }
            .disposed(by: disposeBag)
        
        registerButton.rx.tap.bind {
            self.moveToRegisterPage()
        }
        .disposed(by: disposeBag)
        
    }
    
    func moveToMainPage() {
        
        let listPage: BoardListViewController = BoardListViewController()

        let navigationVC = UINavigationController(rootViewController: listPage)
        listPage.title = "게시글"
        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.modalPresentationStyle = .fullScreen

        self.present(navigationVC, animated: true, completion: nil)
    }
    
    func moveToRegisterPage() {
        
        
        
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(registerVC, animated: true)
    }

}

