//
//  customLabel.swift
//  Music
//
//  Created by Atheer on 2018-07-12.
//  Copyright © 2018 Atheer. All rights reserved.
//

import UIKit

class customLabel: UILabel {
    
    let startText: String
    let fontSize: CGFloat
    let isBold: Bool
    
    init(startText: String, isBold: Bool, fontSize: CGFloat) {
        self.startText = startText
        self.fontSize = fontSize
        self.isBold = isBold
        super.init(frame: .zero)
        
        self.text = startText
        self.translatesAutoresizingMaskIntoConstraints = false
        if isBold == true{
            self.font = UIFont.boldSystemFont(ofSize: fontSize)
        }
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
