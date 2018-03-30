//
//  ViewController.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 28.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit
import Firebase


class MessagesViewController: UITableViewController {
    
    var cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
 
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
       checkIfUserLoggedIn()
       
       tableView.register(Usercell.self, forCellReuseIdentifier: cellId)
        
      // observeMessages()
        observeUserMessages()
    }
    
    var messages = [Message]()
    var messagesDictionary = [String : Message]()
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String:Any] {
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    // self.messages.append(message)
                    
                    if let chatPartnerId = message.chatPartnerId() {
                        self.messagesDictionary[chatPartnerId] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort {$0.timeStamp!.intValue > $1.timeStamp!.intValue }
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any] {
                let message = Message()
                message.setValuesForKeys(dictionary)
               // self.messages.append(message)
                
                if let messageToId = message.toId {
                     self.messagesDictionary[messageToId] = message
                     self.messages = Array(self.messagesDictionary.values)
                     self.messages.sort {$0.timeStamp!.intValue > $1.timeStamp!.intValue }
                }
               
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {return}
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observe(.value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            let user_ = user()
            user_.id = chatPartnerId
            user_.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user: user_)
            
            
            
        }, withCancel: nil)
        
        //showChatControllerForUser(user: <#T##user#>)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! Usercell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    
    @objc func  handleNewMessage () {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navBar = UINavigationController(rootViewController: newMessageController)
        present(navBar, animated: true, completion: nil)
        
    }
    
    func  checkIfUserLoggedIn () {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
           fetchUserAndSetupNavBarTitle()
            
        }
    }

    func fetchUserAndSetupNavBarTitle()
    {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String:Any] {
                
                let user_ = user()
                user_.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user: user_)
            }
        })
    }
    
    func setupNavBarWithUser(user: user)
    {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
        
        
        
        self.navigationItem.title = user.name
        
        let containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let titleView: UIButton = {
            let view = UIButton()
            view.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
          //  view.addTarget(self, action: #selector(showChatController), for: .touchUpInside)
            return view
        }()
        
        titleView.addSubview(containerView)
        
        
        [
            containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
        ].forEach { $0.isActive = true}
        
       
        
        let navProfileImage: UIImageView = {
            let imgView = UIImageView()
            if let profileImageUrl = user.profileImageUrl {
                imgView.kf.setImage(with:  URL(string:profileImageUrl))
            }
            imgView.translatesAutoresizingMaskIntoConstraints = false
            imgView.contentMode = .scaleAspectFit
            imgView.layer.cornerRadius = 20
            imgView.layer.masksToBounds = true
            return imgView
        }()
        
        containerView.addSubview(navProfileImage)
        //Constraints
        [
            navProfileImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            navProfileImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            navProfileImage.heightAnchor.constraint(equalToConstant: 40),
            navProfileImage.widthAnchor.constraint(equalToConstant: 40),

        ].forEach { $0.isActive = true}
        
        
        let nameLabel: UILabel = {
            let lbl = UILabel()
            lbl.text = user.name
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        containerView.addSubview(nameLabel)
        //Constraints
        [
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: navProfileImage.trailingAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalTo: navProfileImage.heightAnchor),
            nameLabel.centerYAnchor.constraint(equalTo:containerView.centerYAnchor)
            
        ].forEach { $0.isActive = true}
        

        self.navigationItem.titleView = titleView
        
        
        
        
    }
    
    @objc func showChatControllerForUser(user: user) {
        let chatLogController =  ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let vc = LoginController()
        vc.messagesController = self
        present(vc, animated: true, completion: nil)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    

}



