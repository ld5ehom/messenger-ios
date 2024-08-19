//
//  Services.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/13/24.
//

import Foundation

protocol ServiceType {
    // Task 1: Add AuthenticationService
    var authService: AuthenticationServiceType { get set }
    
    // Task 2: Firebase DB user service
    var userService: UserServiceType { get set }
    
    // Task 2: Contact Framework
    var contactService: ContactServiceType { get set }
    
    // Task 3: PhotosUI Photo Picker Service - My profile image 
    var photoPickerService: PhotoPickerServiceType { get set }
    
    // Task 3: Firebase DB upload provider
    var uploadService: UploadServiceType { get set }
    
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    var contactService: ContactServiceType
    var photoPickerService: PhotoPickerServiceType
    var uploadService: UploadServiceType
    
    init() {
        self.authService = AuthenticationService()
        self.userService = UserService(dbRepository: UserDBRepository())
        self.contactService = ContactService()
        self.photoPickerService = PhotoPickerService()
        self.uploadService = UploadService(provider: UploadProvider())
    }
}

class StubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
    var contactService: ContactServiceType = StubContactService()
    var photoPickerService: PhotoPickerServiceType = StubPhotoPickerService()
    var uploadService: UploadServiceType = StubUploadService()
}
