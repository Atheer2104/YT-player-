//
//  customButton.swift
//  Music
//
//  Created by Atheer on 2018-07-14.
//  Copyright © 2018 Atheer. All rights reserved.
//

import UIKit

class customButton: UIButton {
    
    let startImage: String
    
    init(startImage: String) {
        self.startImage = startImage
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "\(startImage)")?.withRenderingMode(.alwaysTemplate)
        self.setImage(image, for: .normal)
        self.tintColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
