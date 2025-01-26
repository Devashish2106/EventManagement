import SwiftUI

struct EventListingView: View {
    @StateObject private var viewModel = EventListingViewModel()
    @State private var isPresentingAddEvent = false
    @State private var rowHeight: CGFloat = 0

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: rowHeight > 0 ? 16 : 0) {
                        ForEach(viewModel.events) { event in
                            EventRowView(event: event)
                                .onPreferenceChange(RowHeightPreferenceKey.self) { height in
                                    rowHeight = max(rowHeight, height)
                                }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Events")
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresentingAddEvent = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        .padding()
                        .sheet(isPresented: $isPresentingAddEvent) {
                            CreateEventView()
                        }
                    }
                }
            }
        }
    }
}
