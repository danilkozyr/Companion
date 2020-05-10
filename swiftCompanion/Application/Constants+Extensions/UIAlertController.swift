import Foundation
import UIKit

extension UIAlertController {
    func create(title: String, message: String, action: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: action, style: .default) { (UIAlertAction) in }
        alert.addAction(actionOk)
        return alert
    }
}
