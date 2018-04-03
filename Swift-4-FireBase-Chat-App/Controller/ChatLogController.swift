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
        guard let uid = Auth.auth().currentUser?.uid , let toId = user?.id else{return}
        
        let userMessageRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else{return}
                
                let message = Message()
                
                //potential of crashing if key don't match
                message.setValuesForKeys(dictionary)
                
                //Do we need to append filtering anymore
               // if message.chatPartnerId() == self.user?.id {
                self.messages.append(message)
                DispatchQueue.main.async { self.collectionView?.reloadData() }
                //}
                
                
                
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
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom:58 , right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom:8 , right: 0)
        collectionView?.translatesAutoresizingMaskIntoConstraints=false
        /*[
         collectionView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         collectionView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         collectionView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         collectionView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         
        ].forEach{$0?.isActive=true}*/
        
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        //Keyboard will hide with swipe down
        collectionView?.keyboardDismissMode = .interactive
        
        
       // setupInputComponents()
        
       // setupKeyboardObservers()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
                
                self.containerViewBottomAnchor?.constant = -keyboardSize.height
                UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                    self.view.layoutIfNeeded()
                })
               
            }
            
        }
    }
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        if let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            
            self.containerViewBottomAnchor?.constant = 0
            UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    lazy var inputContainerView: UIView = {
       let containerView = UIView()
       containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
       containerView.backgroundColor = .white
        
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
        
        
        containerView.addSubview(self.inputTextField)
        [
            self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            self.inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            self.inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant : 8),
            self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor)
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
        
        
       return containerView
       
        
    }()
    
    override var inputAccessoryView: UIView? {
        get {
          return inputContainerView
        }
    }
    override var canBecomeFirstResponder: Bool
    {
        return true
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell , message: Message)
    {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.kf.setImage(with: URL(string:profileImageUrl))
        }
        
        
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = .white
            cell.bubbleRightAnchor?.isActive = true;
            cell.bubbleLeftAnchor?.isActive = false;
            cell.profileImageView.isHidden = true;
        }else {
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false;
            cell.bubbleRightAnchor?.isActive = false;
            cell.bubbleLeftAnchor?.isActive = true;
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 80
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text:String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var containerViewBottomAnchor : NSLayoutConstraint?
    
    func setupInputComponents() {
        let containerView: UIView = {
            let view =  UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        view.addSubview(containerView)
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        [
            containerViewBottomAnchor!,
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
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
            self.inputTextField.text = ""
            
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId:1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId:1])
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
