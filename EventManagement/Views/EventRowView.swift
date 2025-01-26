import SwiftUI

struct EventRowView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let event: Event
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let timeString = dateFormatter.string(from: date)
        
        if calendar.isDateInToday(date) {
            return "Today, \(timeString)"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow, \(timeString)"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM, \(timeString)"
            return formatter.string(from: date)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let image = UIImage(contentsOfFile: event.mediaPath) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(4/5, contentMode: .fit)
                        .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.09), Color.blue.opacity(0.3)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .overlay(
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue.opacity(0.6))
                        )
                }
            }
            .frame(width: 160, height: 200) // Matches the size from the "else" case
            .cornerRadius(8)

            Text(event.community)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(event.title)
                .font(.headline)
                .lineLimit(2)
                .truncationMode(.tail)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Text(formatDate(event.startDate))
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(event.location)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .background(GeometryReader { geometry in
            Color.clear
                .preference(key: RowHeightPreferenceKey.self, value: geometry.size.height)
        })
    }
}

struct RowHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
