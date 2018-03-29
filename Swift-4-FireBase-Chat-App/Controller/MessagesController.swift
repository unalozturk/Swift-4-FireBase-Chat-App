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

    override func viewDidLoad() {
        super.viewDidLoad()
 
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
       checkIfUserLoggedIn()
    }
    @objc func  handleNewMessage () {
        let newMessageController = NewMessageController()
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
        self.navigationItem.title = user.name
        
        let containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let titleView: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
            return view
        }()
        
        titleView.addSubview(containerView)
        
        
        [
            containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
        ].forEach { $0.isActive = true}
        
        self.navigationItem.titleView = titleView
        
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
            nameLabel.leadingAnchor.constraint(equalTo: navProfileImage.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalTo: navProfileImage.heightAnchor),
            nameLabel.centerYAnchor.constraint(equalTo:containerView.centerYAnchor)
            
        ].forEach { $0.isActive = true}
        
        
       
        
        
        
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



