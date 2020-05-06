import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        view.setGradientColor(colorOne: .customDark,
                              colorTwo: .customPurple,
                              startPosition: CGPoint(x: 0, y: 0))
    }
}
