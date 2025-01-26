import SwiftUI
import RealmSwift

class EventCreationViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var location: String = ""
    @Published var descriptionText: String = ""
    @Published var selectedImage: UIImage?
    @Published var showImagePicker = false
    @Published var locationLabel: String = "Choose Location"
    @Published var descriptionLabel: String = "Write a brief description about this event"
    @Published var showLocationField: Bool = false
    @Published var showDescriptionField: Bool = false
    
    private var realm: Realm?

    init() {
        configureRealm()
    }

    private func configureRealm() {
        do {
            self.realm = try Realm()
        } catch {
            print("Error initializing Realm: \(error.localizedDescription)")
        }
    }

    func saveEvent(community: String) {
        guard let realm = realm else { return }
        guard !title.isEmpty,
              !descriptionText.isEmpty,
              let selectedImage = selectedImage else {
            print("Validation failed: Essential fields missing")
            return
        }

        let imagePath = saveImageToDocuments(selectedImage)

        let event = Event()
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.location = location
        event.descriptionText = descriptionText
        event.mediaPath = imagePath
        event.community = community

        do {
            try realm.write {
                realm.add(event)
            }
            print("Event added successfully")
        } catch {
            print("Error saving event: \(error.localizedDescription)")
        }
    }

    private func saveImageToDocuments(_ image: UIImage) -> String {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentsURL.appendingPathComponent(fileName)

        if let imageData = image.jpegData(compressionQuality: 0.8) {
            try? imageData.write(to: fileURL)
        }

        return fileURL.path
    }
}
