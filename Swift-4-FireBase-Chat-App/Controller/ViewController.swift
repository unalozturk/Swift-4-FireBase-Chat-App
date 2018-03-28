//
//  ViewController.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 28.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* var ref: DatabaseReference!
        ref = Database.database().reference(fromURL: "https://gameofchat-fd3cc.firebaseio.com/")
        ref.updateChildValues(["someValues" : 123432])
        */
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    @objc func handleLogout() {
        present(LoginControllerViewController(), animated: true, completion: nil)
    }

}


