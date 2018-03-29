//
//  NewMessageController.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 29.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users = [user]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        self.tableView.register(Usercell.self, forCellReuseIdentifier: cellId)
        
        
        fetchUser()
       
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String:Any]{
                let user_ = user()
                user_.setValuesForKeys(dictionary)
             /*   //Be careful dictionary names set as ur object
                user_.name = dictionary["name"] as? String
                user_.email = dictionary["email"] as? String
                user_.profileImageUrl = dictionary["profileImageUrl"] as? String*/
                print(user_.name ?? "",user_.email ?? "")
                
                self.users.append(user_)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }

    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! Usercell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            
            let url = URL(string: profileImageUrl)
            cell.profileImageView.kf.setImage(with: url!)
           /* URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                DispatchQueue.main.async {
                    cell.profileImageView.image = UIImage(data: data!)
                }
                
            }).resume()*/
           
        
        }
        //cell.imageView?.image =
        return cell
    }
    

}

class Usercell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.size.width, height: textLabel!.frame.size.height)
        detailTextLabel?.frame =  CGRect(x: 64, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.size.width, height: detailTextLabel!.frame.size.height)
    }
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        [
            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant : 8),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 48),
            profileImageView.heightAnchor.constraint(equalToConstant: 48),
            
        ].forEach { $0.isActive=true}
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
