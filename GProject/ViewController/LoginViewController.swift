//
//  ViewController.swift
//  GProject
//
//  Created by 서정 on 2021/07/11.
//

import UIKit
import RxSwift


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
    

    lazy var stackView: UIStackView = {
        let stackV = UIStackView(arrangedSubviews: [self.appNameLabel ,self.emailForm, self.passwdForm, self.loginButton, self.registerButton, self.kakaoLoginButton, self.kakaoRegisterButton])
        
        stackV.axis = .vertical
        stackV.spacing = 15
        stackV.alignment = .fill
        stackV.distribution = .fillProportionally
        return stackV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.backgroundBlack)
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
        
        stackView.setCustomSpacing(50, after: appNameLabel)
        stackView.setCustomSpacing(25, after: passwdForm)
    }
    
    private func setAppNameLabel() {
        appNameLabel.text = "3D home"
        appNameLabel.textColor = .white
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 50)
//        appNameLabel.font = UIFont(name: "ArialMT", size: 40)
        appNameLabel.textAlignment = .center
    }
    
    private func setForm() {
        emailForm.borderStyle = .roundedRect
        
        emailForm.placeholder = "email"
        emailForm.text = "catbus@konkuk.ac.kr"
        emailForm.textColor = .white
        emailForm.backgroundColor = UIColor(rgb: 0x566573)
        
        passwdForm.borderStyle = .roundedRect
       
        passwdForm.isSecureTextEntry = true
        passwdForm.placeholder = "password"
        passwdForm.text = "password"
        passwdForm.textColor = .white
        
        passwdForm.backgroundColor = UIColor(rgb: 0x566573)
    }
    
    private func setLoginButton() {
        loginButton.setContentHuggingPriority(.required, for: .vertical)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.textColor = .white
        loginButton.layer.cornerRadius = 5
        loginButton.titleEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        loginButton.backgroundColor = UIColor.appColor(.buttonBlue)
    }
    
    private func setRegisterButton() {
        registerButton.setTitle("회원가입하기", for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        registerButton.setTitleColor(UIColor(rgb: 0x909497), for: .normal)
        
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
                if(!(userDataRes.data?.authorities?.isEmpty ?? false)) {
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
                    self.viewModel.requestLogin()
                    
                } else {
                    print("로그인 형식에 맞지 않음")
                }
            }
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .bind {
                self.moveToRegisterPage()
            }
            .disposed(by: disposeBag)
        
    }
    
    func moveToMainPage() {
        
//        let listPage: ProjectListViewController = ProjectListViewController()
        
        let listPage = TabBarViewController()
        
        let navController = UINavigationController(rootViewController: listPage)
        
        navController.interactivePopGestureRecognizer?.isEnabled = true
        navController.isNavigationBarHidden = true
        
        guard let scene = UIApplication.shared.connectedScenes.first else { return }
        guard let del = scene.delegate as? SceneDelegate else { return }

        del.window?.rootViewController = navController
        
    }
    
    func moveToRegisterPage() {
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(registerVC, animated: true)
    }

}


