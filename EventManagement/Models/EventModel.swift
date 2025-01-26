import RealmSwift
import UIKit

class Event: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var startDate: Date = Date()
    @Persisted var endDate: Date = Date()
    @Persisted var location: String = ""
    @Persisted var descriptionText: String = ""
    @Persisted var mediaPath: String = ""
    @Persisted var community: String = "No Community"

    var thumbnailImage: UIImage? {
        guard !mediaPath.isEmpty else { return nil }
        return UIImage(contentsOfFile: mediaPath)
    }
}
