//
//  ChatMessageCell.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 30.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    var textView: UITextView = {
       let tv = UITextView()
       tv.text = "SIMPLEEEEE"
       tv.font = UIFont.systemFont(ofSize: 16)
       tv.textAlignment = .right
       tv.translatesAutoresizingMaskIntoConstraints = false
       tv.backgroundColor = .blue
       return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textView)
        [
            textView.rightAnchor.constraint(equalTo: self.rightAnchor),
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.widthAnchor.constraint(equalToConstant:200),
            textView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ].forEach { $0.isActive=true}
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
