import Foundation
import UIKit

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = 20
        clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    func downloaded(from url: URL?) {
        guard let url = url else {
            return
        }

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
