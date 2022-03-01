//
//  customCell.swift
//  Music
//
//  Created by Atheer on 2018-06-07.
//  Copyright © 2018 Atheer. All rights reserved.
//

import UIKit

class customCell : UITableViewCell{
    var title: String?
    var mainImage: UIImage?
    var descriptionVideo: String?
    var videosID: String?
    var channelTitle: String?
    
    // programatically constructing the image, titlelabel and artist label
    
    let mainImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let TitleLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.boldSystemFont(ofSize: 14)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    let videoDescription: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 10)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    // have to do this override init here we specify autolayout and we add it to the subview
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(TitleLabel)
        self.addSubview(mainImageView)
        self.addSubview(videoDescription)
        
        // mainImageView autolayout
        
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
     
        mainImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //titleLabel autolayout
        
        TitleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        TitleLabel.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor, constant: 5).isActive = true
        
        TitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        TitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //channelTitleLabel autolayout
        
        videoDescription.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
    
        
        videoDescription.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor, constant: 5).isActive = true
        
        videoDescription.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        videoDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    // we are doing so the title is eual to the message and the mesage is equal to the text, title and message are the same becauase the are equal
    override func layoutSubviews() {
        super.layoutSubviews()
        if let videoTitle = title {
            TitleLabel.text = videoTitle
        }
        
        if let image = mainImage {
            mainImageView.image = image
        }
        
        if let description = descriptionVideo {
            videoDescription.text = description
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






