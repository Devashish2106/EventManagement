import SwiftUI
import RealmSwift

class EventListingViewModel: ObservableObject {
    @Published var events: [Event] = []
    private var realm: Realm?
    private var notificationToken: NotificationToken?

    init() {
        configureRealm()
        fetchEvents()
        observeEvents()
    }
    
    private func configureRealm() {
        do {
            self.realm = try Realm()
        } catch {
            print("Error initializing Realm: \(error.localizedDescription)")
        }
    }

    private func fetchEvents() {
        guard let realm = realm else { return }
        let results = realm.objects(Event.self).sorted(byKeyPath: "startDate", ascending: true)
        self.events = Array(results)
    }

    private func observeEvents() {
        guard let realm = realm else { return }
        let results = realm.objects(Event.self)
        notificationToken = results.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.fetchEvents()
            case .update:
                self?.fetchEvents()
            case .error(let error):
                print("Error observing events: \(error)")
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }
}
