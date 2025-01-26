# EventManagement iOS App

EventManagement is an iOS application built using **SwiftUI** to help users manage events following MVVM Architecture. The app supports local data persistence using **Realm** and provides a clean, intuitive user interface for creating and listing events. The app is fully functional, adheres to the provided requirements, and supports both light and dark modes.

---

## Features

### Event Listing
- Displays a scrollable list of all created events.
- Each event shows:
  - **Title**
  - **Event Date and Time** (e.g., "Today", "Tomorrow", or the specific date)
  - **Thumbnail** of the associated image.
  - **Location** (if specified).

### Event Creation
- A "+" button on the bottom-right corner of the main screen navigates to the event creation screen.
- Event creation is implemented as a **slide-over sheet**.
- Fields available:
  - **Event Title** (mandatory)
  - **Event Start and End Date/Time** (mandatory)
  - **Event Description** (mandatory)
  - **Location** (optional)
  - **Media Upload** (via the native picker)
    - Uploaded media is resized to maintain a **4:5 aspect ratio** and stored locally.
- **Input validation:**
  - Mandatory fields are highlighted in red if left empty.
  - Users must fix errors to successfully add an event.
- Once successfully added, the new event appears on the main event listing screen.

---

## Technical Details

### Technologies Used
- **SwiftUI** for the UI and app design.
- **Realm** for efficient local data persistence.
- Followed **MVVM** architecture for file structuring.
- Native **UIImagePickerController** for image/video selection.
- **Custom Views** and layouts for responsiveness across devices and orientations.

### Key Features
1. **Local Data Storage:**
   - Event details (title, date, description, media file paths, etc.) are stored in Realm.
   - Media files (images/videos) are saved locally in the app's **Documents** directory, and only file paths are stored in the database.
2. **Dark Mode Support:**
   - The app automatically adapts to the system's light or dark appearance.

---

## Challenges Faced
- **Maintaining Aspect Ratio:** 
  - Ensuring that uploaded media consistently maintained the required 4:5 aspect ratio without overflowing in event listing or creation screens.
  - This was solved using SwiftUI’s `.scaledToFill()` and `.aspectRatio()` modifiers.
- **Realm Persistence:**
  - Changes in the Realm schema during development caused issues requiring the database to be reloaded or the app data to be reset.

---

## How to Use
1. **Event Listing:**
   - Launch the app to view the list of events.
   - Each event displays the title, date, thumbnail, and location (if provided).

2. **Add an Event:**
   - Tap the "+" button in the bottom-right corner.
   - Enter all the required fields (Title, Start Time, End Time, Description).
   - Optionally, add a location and upload an image or video.
   - Fix any validation errors (fields highlighted in red) before submitting.
   - Once added, the new event will be displayed on the main screen.

---

## Conclusion
This app provides a simple, user-friendly interface for managing events locally on iOS devices. It effectively demonstrates SwiftUI concepts, local data persistence using Realm, and efficient media handling.

---

Thank you for reviewing the app!
