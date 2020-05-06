import Foundation
import UIKit

extension UIView {
    func setGradientColor(colorOne: UIColor, colorTwo: UIColor, startPosition: CGPoint) {
        let gradient = CAGradientLayer()
        
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradient.startPoint = startPosition
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    func setCorner(with radius: CGFloat, borderWidth: CGFloat, color: UIColor){
        self.layer.cornerRadius = radius
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
}

