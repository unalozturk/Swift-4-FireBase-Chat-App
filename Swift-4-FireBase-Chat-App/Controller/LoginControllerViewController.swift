//
//  LoginControllerViewController.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 28.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit

import Firebase

class LoginControllerViewController: UIViewController {
    
    let inputContainerView : UIView =  {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginRegisterButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text , let name = nameTextField.text else {
            return
        }
        
       
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
            if error != nil
            {
                print(error  ?? "")
                return
            }
        }
        
        let uid = Auth.auth().currentUser!.uid
        
        //successfully auth
        let ref = Database.database().reference(fromURL: "https://gameofchat-fd3cc.firebaseio.com/")
        let values = ["name":name, "email": email]
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values) { (error, ref) in
            if error != nil
            {
                print(error ?? "")
                return
            }
        }
        //ref = Database.database().reference(fromURL: "https://gameofchat-fd3cc.firebaseio.com/")
        //ref.updateChildValues(["someValues" : 123432])
        
        
    }
    
    let nameTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Name";
        return tf
    }()
    
    let nameSeperatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 200)
        return view
    }()

    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        return tf
    }()
    
    let emailSeperatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 200)
        return view
    }()
    
    let  passwordTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.isSecureTextEntry=true
        return tf
    }()
    
    let  profileImage : UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        imgv.image = UIImage(named: "got")
        imgv.translatesAutoresizingMaskIntoConstraints = false
        return imgv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImage)
       
        
        setupInputContainerView()
        setupLoginRegisterButton()
        setupProfileImage()
        
       
        
    }
    
    func setupInputContainerView() {
        [
            inputContainerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            inputContainerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            inputContainerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: -24),
            inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        ].forEach { $0.isActive=true}
        
        inputContainerView.addSubview(nameTextField)
        
        
        [
            nameTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
            nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3, constant: 0)
          ].forEach { $0.isActive=true}
        
        inputContainerView.addSubview(nameSeperatorView)
        
        [
            nameSeperatorView.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            nameSeperatorView.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            nameSeperatorView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameSeperatorView.heightAnchor.constraint(equalToConstant:0.5)
        ].forEach { $0.isActive=true}
        
        
        ////
        inputContainerView.addSubview(emailTextField)
        
        
        [
            emailTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor),
            emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3, constant: 0)
            ].forEach { $0.isActive=true}
        
        inputContainerView.addSubview(emailSeperatorView)
        
        [
            emailSeperatorView.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            emailSeperatorView.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            emailSeperatorView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailSeperatorView.heightAnchor.constraint(equalToConstant:0.5)
        ].forEach { $0.isActive=true}
        
        ////
        inputContainerView.addSubview(passwordTextField)
        
        
        [
            passwordTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3, constant: 0)
        ].forEach { $0.isActive=true}
        
        
        
    }
    
    func setupLoginRegisterButton() {
        [
            loginRegisterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginRegisterButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: -24),
            loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12),
            loginRegisterButton.heightAnchor.constraint(equalToConstant:50)
        ].forEach { $0.isActive=true}
    }
    
    func setupProfileImage() {
        [
            profileImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            profileImage.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12),
            profileImage.widthAnchor.constraint(equalToConstant:150),
            profileImage.heightAnchor.constraint(equalToConstant:150)
        ].forEach { $0.isActive=true}
        
    }

}
extension UIColor {
    convenience init(r:CGFloat, g:CGFloat , b:CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
