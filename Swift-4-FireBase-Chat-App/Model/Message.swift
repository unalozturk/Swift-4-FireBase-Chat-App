//
//  Message.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 30.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit
import FirebaseAuth

@objcMembers
class Message: NSObject {
    var fromId : String?
    var text : String?
    var timeStamp: NSNumber?
    var toId:String?

    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
