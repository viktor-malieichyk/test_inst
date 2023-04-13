//
//  PrimitiveImageCache.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class ImageCache {
    static func loadImage(withUrl urlString: String?, completion:  @escaping (UIImage) -> Void) {
        guard let urlString, let url = URL(string: urlString) else {
            return
        }
        
        loadImage(withUrl: url, completion: completion)
    }
    
    static func loadImage(withUrl url: URL, completion:  @escaping (UIImage) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        }
        
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        completion(image)
                    }
                }
                
            }.resume()
        }
    }
    
}
