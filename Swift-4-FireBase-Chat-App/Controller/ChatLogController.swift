//
//  ChatLogController.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Ünal Öztürk on 29.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController : UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var cellId = "cellId"
    
    var user : user? {
        didSet {
            navigationItem.title = user?.name
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let userMessageRef = Database.database().reference().child("user-messages").child(uid)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else{return}
                
                let message = Message()
                
                //potential of crashing if key don't match
                message.setValuesForKeys(dictionary)
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async { self.collectionView?.reloadData() }
                }
                
                
                
            }, withCancel: nil)
            
            
        }, withCancel: nil)
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
    
        
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        
        setupInputComponents()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        
        return cell
    }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    
    func setupInputComponents() {
        let containerView: UIView = {
            let view =  UIView()
            view.backgroundColor = .white
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
