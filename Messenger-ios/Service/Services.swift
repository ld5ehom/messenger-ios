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
    
    // Task 3: Image Cache Service
    var imageCacheService: ImageCacheServiceType { get set }
    
    // Task 3: Other(Friend) Chat room service
    var chatRoomService: ChatRoomServiceType { get set }
    
    // Task 4: Chat Service
    var chatService: ChatServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    var contactService: ContactServiceType
    var photoPickerService: PhotoPickerServiceType
    var uploadService: UploadServiceType
    var imageCacheService: ImageCacheServiceType
    var chatRoomService: ChatRoomServiceType
    var chatService: ChatServiceType
    
    init() {
        self.authService = AuthenticationService()
        self.userService = UserService(dbRepository: UserDBRepository(reference: DBReference()))
        self.contactService = ContactService()
        self.photoPickerService = PhotoPickerService()
        self.uploadService = UploadService(provider: UploadProvider())
        self.imageCacheService = ImageCacheService(memoryStorage: MemoryStorage(), diskStorage: DiskStorage())
        self.chatRoomService = ChatRoomService(dbRepository: ChatRoomDBRepository())
        self.chatService = ChatService(dbRepository: ChatDBRepository())
    }
}

class StubServices: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
    var contactService: ContactServiceType = StubContactService()
    var photoPickerService: PhotoPickerServiceType = StubPhotoPickerService()
    var uploadService: UploadServiceType = StubUploadService()
    var imageCacheService: ImageCacheServiceType = StubImageCacheService()
    var chatRoomService: ChatRoomServiceType = StubChatRoomService()
    var chatService: ChatServiceType = StubChatService()
}
