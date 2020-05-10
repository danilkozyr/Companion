import UIKit

class SectionCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet private weak var sectionName: UILabel!

    // MARK: Configuration

    func configure(with name: String) {
        sectionName.text = name
    }
}
