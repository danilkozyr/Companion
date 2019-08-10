//
//  RoundedView.swift
//  swiftCompanion
//
//  Created by Ксения on 8/10/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
