# Messenger iOS App

## Project Overview
- Developed a messenger app for iOS, implementing user authentication with Firebase, including secure login, registration, and logout functionalities.
- Designed and built profile management features, including profile image updates using PhotosUI and real-time synchronization with Firebase Cloud Storage.
- Created a chat interface with real-time message updates, message grouping by date, and customizable UI settings for light/dark mode.
- Integrated Core Data to manage recent search terms and user preferences, ensuring a seamless and personalized user experience.
- Utilized: Swift, SwiftUI, UIKit, MVVM, CoreData, Firebase


## Milestones
- M1: Core Functionality Development
- M2: Advanced Features and Testing

-----

## Task List
### M1: Core Functionality Development

**Task 1. Login View**
   - **Issues** : [task-1-login](https://github.com/ld5ehom/messenger-ios/tree/task-1-login)
   - **Estimated Duration**: 3 days
   - **Status** : Completed (August 13–August 15, 2024)
   - **Details (commit 5a76f48)** : Updated the login UI view and implemented user authentication with secure login, registration features, and logout functionality using Firebase, including Google and Apple sign-in.

   
**Task 2. Home View**
   - **Issues** : [task-2-home](https://github.com/ld5ehom/messenger-ios/tree/task-2-home)
   - **Estimated Duration**: 3 days
   - **Status** : Completed (August 15–August 17, 2024)
   - **Details (commit 2957173)**:  
     - **Home UI and Phase**: Displays context-appropriate loading screens using Home UI and phase management.  
     - **Firebase Integration**: Implements login and logout functionalities with Firebase Realtime Database.  
     - **Contact Framework**: Integrates the Contact framework to enable friend-adding functionality.


**Task 3. Profile View**
   - **Issues** : [task-3-profile](https://github.com/ld5ehom/messenger-ios/tree/task-3-profile)
   - **Estimated Duration** : 4 days
   - **Status** : Completed (August 17–August 20, 2024)
   - **Details** : 
     - **MyProfileView UI (commit 257b9ff)**: Implemented the UI and functionalities for the My Profile section.
     - **MyProfileDescView UI (commit 257b9ff**: Created a user profile status view with functionality to update and sync the profile status with Firebase DB.
     - **MyProfile Image Update with PhotosUI (commit 833f25d)**: Added functionality to update the profile image using a photo picker. Users can click on the profile image to select and update it.
     - **Firebase Cloud Storage Integration (commit 0d27e8d)**: Implemented functionality to upload the selected profile image to Firebase Cloud Storage.
     - **Upload Provider Implementation (commit 0d27e8d)**: Integrated an upload provider to manage data uploads to Firebase Storage.
     - **Profile Image Display (commit 0d27e8d)**: Implemented a feature to display the profile image using an asynchronous image view with a URL.
     - **Image Cache Service (commit 51a7644)**: Developed an image cache service to manage memory efficiently.
     - **URL Image View (commit 51a7644)**: Created a view that replaces asynchronous images with cached images using the image cache service.
     - **Task-3-profile (commit bc9b04d) details**
         - **Navigation Management (commit bc9b04d)**: Created an enum for common navigation paths across the app. Developed a navigation router to manage these paths, using NavigationLink and NavigationDestination to handle navigation between views.     
         - **Other Profile View (commit bc9b04d)**: Developed the user interface and functionalities for viewing other users' profiles. Added features for initiating chats with other users.
         - **Chat and Search UI (commit bc9b04d)**: Designed the basic structure for the chat user interface (UI) and search UI.
     - **Chat List UI Implementation (commit 0f17277)**: Integrated the search button with the chat list UI into a unified view and reused the UI by utilizing navigation.


**Task 4. Chat View**
   - **Issues** : [task-4-chat](https://github.com/ld5ehom/messenger-ios/tree/task-4-chat)
   - **Estimated Duration** : 3 days
   - **Status** : Completed (August 20–August 21, 2024)
   - **Details** : 
     - **Chat Room UI (commit cf4f234)**: The chat interface is organized into sections by date, with each section header displaying the chat date. Messages within each section are grouped accordingly.
     - **Chat Item VIew (commit cf4f234)**: Differentiated the color and position of messages to distinguish between the user's and the recipient's messages.    
     - **Text Field (commit cf4f234)**: Implemented a text field for message input, along with an input view that includes an image picker for attaching photos.
     - **Date Extension (commit cf4f234)**: Added methods for converting Date objects to and from formatted strings, optimized for use in chat applications.
     - **Keyboard Toolbar (commit cf4f234)**: A view modifier that adds a customizable toolbar above the keyboard, facilitating additional actions within the chat interface.
     - **Real-Time Chat Updates (commit eec6591)**: Implemented real-time updates for chat messages using Firebase Realtime Database, ensuring that changes in the chat message storage path are immediately reflected in the view.


**Task 5. Search View**
   - **Issues** : [task-5-search](https://github.com/ld5ehom/messenger-ios/tree/task-5-search)
   - **Estimated Duration** : 2 day
   - **Status** : Completed (August 21–August 22, 2024)
   - **Details** : 
     - **SearchBar Integration (commit c5dd76e)**: Integrated UISearchBar(UIKit) into SwiftUI for search functionality
     - **Recent Searches Section (commit c5dd76e)**: Implemented a feature to store and manage recent search terms using Core Data, allowing users to view their recent searches.
     - **CoreData (commit cd61615)**: Implemented recent search functionality using Core Data. This includes creating a new SearchResult entity, setting its properties (ID, name, date) and saving it to CoreData.


**Task 6. Settings View**
   - **Issues** : [task-6-setting](https://github.com/ld5ehom/messenger-ios/tree/task-6-setting)
   - **Estimated Duration** : 2 day
   - **Status** : Completed (August 22, 2024)
   - **Details** : 
     - **User Interface Style (commit 5d1915a)**: Implemented functionality to toggle between light and dark modes. The selected style is saved to UserDefaults and applied across different views within the app.

### M2: Advanced Features and Testing

**Task 7. Comprehensive Testing and Debugging**
   - **Issues** : [task-7-test](https://github.com/ld5ehom/messenger-ios/tree/task-7-test)
   - **Details** : 
     - **Unit Testing**: Conducted unit tests for the repository, service, and view model layers to verify their accuracy.  
     - **DIContainer Refactoring**: Refactored NavigationRouter, SearchDataController, and AppearanceController into the DIContainer to centralize dependency management.
     - **UserDBRepository Layer**: Created a protocol to abstract communication with Firebase and refactored the repository to conform to this protocol.
     - **Google Sign-In Test Error**: Encountered errors with the Google Sign-In library during testing. The issue was resolved by removing the library.
     
     
     
-----
## Progress Tracking

- **Overall Progress** : M2 Comprehensive Testing and Debugging - In Progress 

-----
## Reference Site
- Firebase Structure Data : https://firebase.google.com/docs/database/ios/structure-data?hl=en
- Firebase Database Reference : https://firebase.google.com/docs/database/ios/lists-of-data?hl=en

-----
## Getting Started
### Install 

**Homebrew** : 
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
**Clone the repository** : 
```
git clone https://github.com/ld5ehom/messenger-ios.git
``` 
