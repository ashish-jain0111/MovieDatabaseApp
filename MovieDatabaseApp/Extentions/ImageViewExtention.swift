//
//  ImageViewExtention.swift
//  MovieDatabaseApp
//
//  Created by Ashish Jain on 31/07/23.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func load(url: URL, defaultImage: String? = nil) {
        if let image = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = image
            return
        }
        if let defaultImage = defaultImage {
            self.image = UIImage(named: defaultImage)
        }
        else {
            self.image = nil
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}
