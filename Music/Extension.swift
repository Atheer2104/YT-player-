//
//  Extension.swift
//  Music
//
//  Created by Atheer on 2018-06-10.
//  Copyright © 2018 Atheer. All rights reserved.
//

import UIKit

// we set up image chache
let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView:UIImageView {
    
    // declare imageUrlString as type os string
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        // make sure the url is not nil
        guard let url = URL(string: urlString) else { return }
        
        // UIImageView.image is nil so we start we an empty image
        image = nil
        
        // we delcare this value so we don't every time have to reload and download the image again and again
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: {
                
                guard let data = data else { return }
                
                // image to chache is any image and that image comes from the data also where we download images
                let imageToCache = UIImage(data: data)
                
                // we make sure that the imageurlstring is equal equal to the urlstring so we don't apply a random image to another video
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                // if image from chache didn't like for the first we download the data
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            })
            
        }).resume()
    }
}

// this function checks the array if the is any duplicate and gets rid of them
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}


