//
//  ChatMessageCell.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 30.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    var bubbleWidthAnchor : NSLayoutConstraint?
    
    let textView: UITextView = {
       let tv = UITextView()
       tv.font = UIFont.systemFont(ofSize: 16)
     //  tv.textAlignment = .center
       tv.backgroundColor = .clear
       tv.textColor = .white
       tv.translatesAutoresizingMaskIntoConstraints = false
       
       return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant:200)
        [
            bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            bubbleView.topAnchor.constraint(equalTo: self.topAnchor),
            bubbleWidthAnchor!,
            bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ].forEach { $0.isActive=true}
        
        
        addSubview(textView)
        [
            textView.leftAnchor.constraint(equalTo: self.bubbleView.leftAnchor,constant: 8),
            textView.topAnchor.constraint(equalTo: self.bubbleView.topAnchor),
            textView.bottomAnchor.constraint(equalTo:self.bubbleView.bottomAnchor),
            textView.rightAnchor.constraint(equalTo: self.bubbleView.rightAnchor)
        ].forEach { $0.isActive=true}
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
