import Foundation
import RealmSwift

class Friend: Object {
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var level = ""
    @objc dynamic var levelProgress = 0.0
    @objc dynamic var picture: Data? = nil
}

