//
//  String.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 9/12/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation


extension String {
    
    func transformToDate() -> Date {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = iso.date(from: self)
        return date!
    }
    
}
