//
//  ChatLogController.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Ünal Öztürk on 29.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController : UICollectionViewController, UITextFieldDelegate {
    
    var user : user? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    lazy var inputTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter Text"
        tf.delegate = self
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor  = .white
        
        setupInputComponents()
    }
    
    func setupInputComponents() {
        let containerView: UIView = {
            let view =  UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        view.addSubview(containerView)
        
        [
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50)
        ].forEach {$0.isActive=true}
        
        
        let sendButton : UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Send", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
            return button
        }()
        containerView.addSubview(sendButton)
        [
            sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ].forEach {$0.isActive=true}
        
        
        containerView.addSubview(inputTextField)
        [
            inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant : 8),
            inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ].forEach {$0.isActive=true}
        
        let seperatorView: UIView = {
            let view =  UIView()
            view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        containerView.addSubview(seperatorView)
        
        [
            seperatorView.bottomAnchor.constraint(equalTo: containerView.topAnchor),
            seperatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5),
            seperatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ].forEach {$0.isActive=true}
        
    }
    
    @objc func handleSend () {
        let ref  = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp: Any =  Int(Date().timeIntervalSince1970)
        let values = ["text": inputTextField.text! ,"toId": toId,"fromId": fromId,"timeStamp": timeStamp]
       // childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error, dataBaseReference) in
            if error != nil {
                print(error ?? "" )
                return
            }
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId:1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
            recipientUserMessagesRef.updateChildValues([messageId:1])
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
