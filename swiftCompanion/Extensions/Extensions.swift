//
//  Extensions.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/14/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = 20
        clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    func downloaded(from url: URL) {
        contentMode = .scaleAspectFill
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
}
extension UIAlertController {
    
    func returnAlert(title: String, message: String, action: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: action, style: .default) { (UIAlertAction) in }
        alert.addAction(actionOk)
        return alert
    }

}

extension UIView {
    func setGradientColor(colorOne: UIColor, colorTwo: UIColor, startPosition: CGPoint) {
        let gradient = CAGradientLayer()
        
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradient.startPoint = startPosition
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        layer.insertSublayer(gradient, at: 0)
    }
}

extension Double {
    var roundDouble:String {
        return String(format: "%.2f", self)
    }
}

