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

    func deleteObject<T: Object>(type: T.Type, with id: Int) {
        
        do {
            let realm = try Realm()
            let result = realm.objects(Friend.self).filter("id == \(id)")

            try realm.write {
                realm.delete(result)
            }

        } catch {
            print("error deleting")
        }
    }
}
