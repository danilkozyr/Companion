import RealmSwift

// MARK: TODO: Handle Errors correctly

class Storage {
    func saveObject<T: Object>(_ object: T) {
        do {
            let realm = try Realm()

            do {
                try realm.write {
                    realm.add(object)
                }
            } catch {
                print("errror saving")
            }
            
        } catch {
            print("errror realm")
        }
    }

    func readObject<T: Object>() -> [T] {
        do {
            let realm = try Realm()

            return Array(realm.objects(T.self))
        } catch {
            print("errror reading")
            return []
        }
    }
}
