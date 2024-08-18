//
//  ContactService.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/17/24.
//

import Foundation
import Combine
import Contacts

/**
 Task 2: Contacts Framework
 */
enum ContactError: Error {
    case permissionDenied
}

protocol ContactServiceType {
    func fetchContacts() -> AnyPublisher<[User], ServiceError>
}

class ContactService: ContactServiceType {
    
    /**
     Contacts are fetched using a completion handler since Combine is not directly supported, then wrapped in a Future for Combine compatibility.
     */
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        Future { [weak self] promise in
            self?.fetchContacts {
                promise($0)
            }
        }
        .mapError { .error($0) }
        .eraseToAnyPublisher()
    }
    
    // Fetches the user's contact list
    private func fetchContacts(completion: @escaping (Result<[User], Error>) -> Void) {
        let store = CNContactStore()
        
        // Request user permission to access contacts
        store.requestAccess(for: .contacts) { granted, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard granted else {
                completion(.failure(ContactError.permissionDenied))
                return
            }
            
            // Fetches the friends list (private - contact usage description)
            DispatchQueue.global().async { [weak self] in
                self?.fetchContacts(store: store, completion: completion)
            }
        }
    }
    
    // Fetch contacts asynchronously and return as an array of User objects
    private func fetchContacts(store: CNContactStore, completion: @escaping (Result<[User], Error>) -> Void) {
        let keyToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        
        let request = CNContactFetchRequest(keysToFetch: keyToFetch)
        
        var users: [User] = []
        
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                let user: User = .init(id: UUID().uuidString, name: name, phoneNumber: phoneNumber)
                
                users.append(user)
            }
            completion(.success(users))
        } catch {
            completion(.failure(error))
        }
    }
}

class StubContactService: ContactServiceType {
    
    func fetchContacts() -> AnyPublisher<[User], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
