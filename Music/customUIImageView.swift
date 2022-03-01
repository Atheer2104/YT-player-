//
//  customUIImageView.swift
//  Music
//
//  Created by Atheer on 2018-07-15.
//  Copyright © 2018 Atheer. All rights reserved.
//

import UIKit

class customUIImageView: UIImageView {
    
    let startImage: String
    
    init(startImage: String) {
        self.startImage = startImage
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = UIImage(named: "\(startImage)")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
