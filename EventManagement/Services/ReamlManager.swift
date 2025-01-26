import RealmSwift

class RealmManager {
    static let shared = RealmManager()

    private init() {}

    func getRealm() -> Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
}
