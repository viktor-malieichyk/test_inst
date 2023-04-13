//
//  UIImage.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import UIKit

extension UIImage {
    static var placeholderImageSmall: UIImage? = {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .ultraLight)
        var image = UIImage(systemName: "photo", withConfiguration: config)
        image = image?.withTintColor(.white, renderingMode: .alwaysTemplate)
        
        return image
    }()
    
    static var placeholderImageLarge: UIImage? = {
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .ultraLight)
        var image = UIImage(systemName: "photo", withConfiguration: config)
        image = image?.withTintColor(.white, renderingMode: .alwaysTemplate)
        
        return image
    }()
}

