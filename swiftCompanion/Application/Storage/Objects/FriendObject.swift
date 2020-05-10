import Foundation
import RealmSwift

class Friend: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var level = ""
    @objc dynamic var levelProgress: Float = 0.0
    @objc dynamic var imageURL = ""
    @objc dynamic var image: Data? = nil
}

