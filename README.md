# Messenger iOS App

## Project Overview
- Developed a messenger app for iOS, implementing user authentication with Firebase, including secure login and registration functionalities.
- Designed and built profile management features, incorporating profile image updates using PhotosUI and real-time synchronization with Firebase Cloud Storage.
- Created a chat interface with real-time message updates, message grouping by date, and customizable UI settings for light and dark modes.
- Integrated Core Data to manage recent search terms and user preferences, ensuring a seamless and personalized user experience.
- Refactored DIContainer to centralize dependency management, abstracted Firebase communication in the service layer, and performed unit tests across all layers to ensure code accuracy and reliability.
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
   - **Details** :
     - **User Authentication with Firebase and Social Login Integration.** - [commit 5a76f48](https://github.com/ld5ehom/messenger-ios/commit/5a76f488f5ec02f678ae53bf61b156fb29ee11cf) : 
       - Updated the login UI view and implemented user authentication with secure login, registration, and logout functionality using Firebase, with support for Google and Apple sign-in.

   
**Task 2. Home View**
   - **Issues** : [task-2-home](https://github.com/ld5ehom/messenger-ios/tree/task-2-home)
   - **Estimated Duration**: 3 days
   - **Status** : Completed (August 15–August 17, 2024)
   - **Details** :
     - **UI Enhancements, Firebase Integration, and Contact Framework Implementation.** - [commit 2957173](https://github.com/ld5ehom/messenger-ios/commit/2957173b1354876d937ff240aebe4e563d87d9bf) : 
       - **Home UI and Phase**: Displays context-appropriate loading screens using Home UI and phase management.  
       - **Firebase Integration**: Implements login and logout functionalities with Firebase Realtime Database.  
       - **Contact Framework**: Integrates the Contact framework to enable friend-adding functionality.


**Task 3. Profile View**
   - **Issues** : [task-3-profile](https://github.com/ld5ehom/messenger-ios/tree/task-3-profile)
   - **Estimated Duration** : 4 days
   - **Status** : Completed (August 17–August 20, 2024)
   - **Details** : 
     - **MyProfileView and MyProfileDescView UI Enhancements.** - [commit  257b9ff](https://github.com/ld5ehom/messenger-ios/commit/257b9ff118043232b1e5d70b1672e5b4b628e029) : 
       - **MyProfileView UI**: Implemented the UI and functionalities for the My Profile section.
       - **MyProfileDescView UI**: Created a user profile status view with functionality to update and sync the profile status with Firebase DB.
       
     - **MyProfile Image Update with PhotosUI.** - [commit  833f25d](https://github.com/ld5ehom/messenger-ios/commit/833f25d2425da2c092d0c803ea9acafeaae499a7) :  
       - Added functionality to update the profile image using a photo picker. Users can click on the profile image to select and update it.
       
     - **Firebase Cloud Storage Integration and Profile Image Handling.** - [commit  0d27e8d](https://github.com/ld5ehom/messenger-ios/commit/0d27e8d63666b0f227b002f37297d22ae76175bb) :      
       - **Firebase Cloud Storage Integration**: Implemented functionality to upload the selected profile image to Firebase Cloud Storage.
       - **Upload Provider Implementation**: Integrated an upload provider to manage data uploads to Firebase Storage.
       - **Profile Image Display**: Implemented a feature to display the profile image using an asynchronous image view with a URL.
       
     - **Image Caching and Asynchronous Image View Enhancement.** - [commit  51a7644](https://github.com/ld5ehom/messenger-ios/commit/51a7644783ffacee287e90d692b5e10153cc37ae) :       
       - **Image Cache Service**: Developed an image cache service to manage memory efficiently.
       - **URL Image View**: Created a view that replaces asynchronous images with cached images using the image cache service.
     
     - **Profile and Navigation Management Enhancements.** - [commit  bc9b04d](https://github.com/ld5ehom/messenger-ios/commit/bc9b04d9940815725879d31912cac5ecd8f1f93b) : 
       - **Navigation Management**: Created an enum for common navigation paths across the app. Developed a navigation router to manage these paths, using NavigationLink and NavigationDestination to handle navigation between views.     
       - **Other Profile View**: Developed the user interface and functionalities for viewing other users' profiles. Added features for initiating chats with other users.
       - **Chat and Search UI**: Designed the basic structure for the chat user interface (UI) and search UI.
         
     - **Chat List UI Implementation.** - [commit  0f17277](https://github.com/ld5ehom/messenger-ios/commit/0f17277e647ab8188caf51e654225c6763d4de7d) :  
       - Integrated the search button with the chat list UI into a unified view and reused the UI by utilizing navigation.


**Task 4. Chat View**
   - **Issues** : [task-4-chat](https://github.com/ld5ehom/messenger-ios/tree/task-4-chat)
   - **Estimated Duration** : 3 days
   - **Status** : Completed (August 20–August 21, 2024)
   - **Details** : 
     - **Chat UI Enhancements and Input Features.** - [commit  cf4f234](https://github.com/ld5ehom/messenger-ios/commit/cf4f234b15ddb15b5caaa085cbdd4d63b2a6dfd5) : 
       - **Chat Room UI**: The chat interface is organized into sections by date, with each section header displaying the chat date. Messages within each section are grouped accordingly.
       - **Chat Item VIew**: Differentiated the color and position of messages to distinguish between the user's and the recipient's messages.    
       - **Text Field**: Implemented a text field for message input, along with an input view that includes an image picker for attaching photos.
       - **Date Extension**: Added methods for converting Date objects to and from formatted strings, optimized for use in chat applications.
       - **Keyboard Toolbar**: A view modifier that adds a customizable toolbar above the keyboard, facilitating additional actions within the chat interface.
     
     - **Real-Time Chat Updates.** - [commit  eec6591](https://github.com/ld5ehom/messenger-ios/commit/eec65913dba8e045a85ea98a3ff1afc0841bc86e) :  
       - Implemented real-time updates for chat messages using Firebase Realtime Database, ensuring that changes in the chat message storage path are immediately reflected in the view.


**Task 5. Search View**
   - **Issues** : [task-5-search](https://github.com/ld5ehom/messenger-ios/tree/task-5-search)
   - **Estimated Duration** : 2 day
   - **Status** : Completed (August 21–August 22, 2024)
   - **Details** : 
     - **Search Functionality and Recent Searches Management.** - [commit  c5dd76e](https://github.com/ld5ehom/messenger-ios/commit/c5dd76e23f0cc6e0fe078e23c51374d05db73d2b) :  
       - **SearchBar Integration**: Integrated UISearchBar(UIKit) into SwiftUI for search functionality
       - **Recent Searches Section**: Implemented a feature to store and manage recent search terms using Core-Data, allowing users to view their recent searches.
     
     - **Core Data Integration for Recent Search Functionality.** - [commit  cd61615](https://github.com/ld5ehom/messenger-ios/commit/cd61615d775d6daa707f9b3ce2b976b675093f02) :  
       - Implemented recent search functionality using Core Data. This includes creating a new SearchResult entity, setting its properties (ID, name, date), and saving it to Core Data.


**Task 6. Settings View**
   - **Issues** : [task-6-setting](https://github.com/ld5ehom/messenger-ios/tree/task-6-setting)
   - **Estimated Duration** : 2 day
   - **Status** : Completed (August 22, 2024)
   - **Details** : 
     - **User Interface Style.** - [commit  5d1915a](https://github.com/ld5ehom/messenger-ios/commit/5d1915a72bb15f3d5bd7549a489063625f371286) :  
       - Implemented functionality to toggle between light and dark modes. The selected style is saved to UserDefaults and applied across different views within the app.

### M2: Advanced Features and Testing

**Task 7. Comprehensive Testing and Debugging**
   - **Issues** : [task-7-test](https://github.com/ld5ehom/messenger-ios/tree/task-7-test)
   - **Details** : 
     - **Unit Testing and Refactoring for Dependency Management and Repository Layer.** - [commit  603b591](https://github.com/ld5ehom/messenger-ios/commit/603b59136e88439b1de8085f1cb386c2bc53ca92) :
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
**CocoaPods**:
```
pod install
```
