import SwiftUI
import PhotosUI
import RealmSwift

struct CreateEventView: View {
    @StateObject private var viewModel = EventCreationViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var selectedCommunity: String = "No Community Selected"
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var titleFieldError = false
    @State private var descriptionFieldError = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    Text("Create New Event")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    sectionOne(geometry: geometry)
                    Divider().background(Color.gray).frame(height: 1)
                    sectionTwo
                    Divider().background(Color.gray).frame(height: 1)
                    sectionThree
                    Divider().background(Color.gray).frame(height: 1)
                    sectionFour
                }
                .padding()
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Event Creation Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: viewModel.title) { _ in
            titleFieldError = false
        }
        .onChange(of: viewModel.descriptionText) { _ in
            descriptionFieldError = false
        }
    }
    
    func sectionOne(geometry: GeometryProxy) -> some View {
        VStack(spacing: 15) {
            ZStack(alignment: .bottom) {
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) * 5/4)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.09), Color.blue.opacity(0.3)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(width: geometry.size.width - 32, height: (geometry.size.width - 32) * 5/4)
                        .overlay(
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue.opacity(0.6))
                        )
                }
                
                Button(action: { viewModel.showImagePicker = true }) {
                    HStack(spacing: 5) {
                        Image(systemName: "square.and.arrow.up")
                        Text(viewModel.selectedImage == nil ? "Upload Photo" : "Replace Image")
                    }
                    .font(.subheadline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .cornerRadius(8)
                }
                .padding(10)
            }
            .aspectRatio(4/5, contentMode: .fit)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Community")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Menu {
                    Button("No Community Selected", action: { selectedCommunity = "No Community Selected" })
                    Button("Indiranagar Run Club", action: { selectedCommunity = "Indiranagar Run Club" })
                    Button("Koramangala Sports Club", action: { selectedCommunity = "Koramangala Sports Club" })
                    Button("Mumbai Run Club", action: { selectedCommunity = "Mumbai Run Club" })
                } label: {
                    HStack {
                        Text(selectedCommunity)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 1)
                    )
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Event Title")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("*")
                        .foregroundColor(.red)
                }
                TextField("", text: $viewModel.title)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .stroke(titleFieldError ? Color.red : colorScheme == .dark ? Color.white : Color.black, lineWidth: 1)
                    )
            }
        }
    }
    
    var sectionTwo: some View {
        VStack(alignment: .leading, spacing: -4) {
            HStack {
                Image(systemName: "chevron.up")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Text("Starts")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                DatePicker("", selection: $viewModel.startDate, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
            }
            .padding(.leading, 4)
            .padding(.bottom, -10)
            
            VStack(alignment: .center, spacing: -10) {
                Text(".")
                Text(".")
                Text(".")
            }
            .font(.title3)
            .padding(.leading, 10)
            
            HStack {
                Image(systemName: "chevron.down")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Text("Ends")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                DatePicker("", selection: $viewModel.endDate, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
            }
            .padding(.leading, 4)
            .padding(.top, -10)
        }
    }
    
    var sectionThree: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "mappin")
                Text(viewModel.locationLabel)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: viewModel.showLocationField ? "chevron.down" : "chevron.right")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if viewModel.showLocationField && !viewModel.location.isEmpty {
                    viewModel.locationLabel = viewModel.location
                }
                viewModel.showLocationField.toggle()
            }
            
            if viewModel.showLocationField {
                TextField("Enter Location", text: $viewModel.location)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 0.1)
                    )
            }
        }
    }
    
    var sectionFour: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "pencil")
                VStack(alignment: .leading) {
                    HStack {
                        Text("Add Description")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("*")
                            .foregroundColor(.red)
                    }
                    Text(viewModel.descriptionLabel)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: viewModel.showDescriptionField ? "chevron.down" : "chevron.right")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if viewModel.showDescriptionField && !viewModel.descriptionText.isEmpty {
                    viewModel.descriptionLabel = viewModel.descriptionText
                }
                viewModel.showDescriptionField.toggle()
            }
            
            if viewModel.showDescriptionField {
                TextField("Write your description here", text: $viewModel.descriptionText, axis: .vertical)
                    .lineLimit(4...4)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(descriptionFieldError ? Color.red : colorScheme == .dark ? Color.white : Color.black, lineWidth: 1)
                    )
            }
            
            Button(action: {
                validateAndCreateEvent()
            }) {
                Text("Create Event")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color.blue)
                    )
            }
            .padding(.top, 20)
        }
    }
    
    private func validateAndCreateEvent() {
        var missingFields: [String] = []
        
        if viewModel.title.isEmpty {
            missingFields.append("Event Title")
            titleFieldError = true
        }
        
        if viewModel.descriptionText.isEmpty {
            missingFields.append("Description")
            descriptionFieldError = true
        }
        
        if viewModel.selectedImage == nil {
            missingFields.append("Please select an image")
        }
        
        if viewModel.startDate >= viewModel.endDate {
            missingFields.append("End Date must be after Start Date")
        }
        
        if !missingFields.isEmpty {
            alertMessage = "Please complete the following fields:\n" + missingFields.joined(separator: "\n")
            showAlert = true
        } else {
            viewModel.saveEvent(community: selectedCommunity)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
    }
}
