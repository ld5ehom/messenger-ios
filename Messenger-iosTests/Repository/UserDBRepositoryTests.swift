//
//  UserDBRepositoryTests.swift
//  Messenger-iosTests
//
//  Created by TaeWook Park on 8/23/24.
//

import XCTest
import Combine
@testable import Messenger_ios

final class UserDBRepositoryTests: XCTestCase {
    
    private var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Success case
    func test_getUser_success() {
        let stubData = [
            "id": "user1_id",
            "name": "user1"
        ]
        
        let userDBRepository = UserDBRepository(reference: StubUserDBReference(value: stubData))
        
        userDBRepository.getUser(userId: "user1_id")
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTFail("Unexpected fail: \(error)")
                }
            } receiveValue: { userObject in
                XCTAssertNotNil(userObject)
                XCTAssertEqual(userObject.id, "user1_id")
                XCTAssertEqual(userObject.name, "user1")
            }.store(in: &subscriptions)

        // Create an XCTestExpectation to wait for the asynchronous operation to complete
        /*let exp = XCTestExpectation(description: "getUser")
        
        userDBRepository.getUser(userId: "user1_id")
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTFail("Unexpected fail: \(error)")
                    exp.fulfill()
                }
            } receiveValue: { userObject in
                XCTAssertNotNil(userObject)
                XCTAssertEqual(userObject.id, "user1_id")
                XCTAssertEqual(userObject.name, "user1")
                exp.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [exp], timeout: 2)*/
    }
    
    // fail case 
    func test_getUser_empty() {
        let userDBRepository = UserDBRepository(reference: StubUserDBReference(value: nil))
        
        userDBRepository.getUser(userId: "user1_id")
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error.localizedDescription, DBError.emptyValue.localizedDescription)
                }
            } receiveValue: { userObject in
                XCTFail("Unexpected success: \(userObject)")
            }.store(in: &subscriptions)
    }
    
    func test_getUser_fail() {
        let stubData = [
            "id_modified": "user1_id",
            "name_modified": "user1"
        ]
        
        let userDBRepository = UserDBRepository(reference: StubUserDBReference(value: stubData))
        
        userDBRepository.getUser(userId: "user1_id")
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTAssertNotNil(error)
                }
            } receiveValue: { userObject in
                XCTFail("Unexpected success: \(userObject)")
            }.store(in: &subscriptions)
    }
}

struct StubUserDBReference: DBReferenceType {
    
    let value: Any?
    
    func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError> {
        Just(()).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func fetch(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
        Just(value).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func setValue(key: String, path: String?, value: Any) async throws {
    }
    
    func setValues(_ values: [String : Any]) -> AnyPublisher<Void, Messenger_ios.DBError> {
        Just(()).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func fetch(key: String, path: String?) async throws -> Any? {
        return value
    }
    
    func filter(key: String, path: String?, orderedName: String, queryString: String) -> AnyPublisher<Any?, Messenger_ios.DBError> {
        Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func childByAutoId(key: String, path: String?) -> String? {
        return nil
    }
    
    func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, Messenger_ios.DBError> {
        Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
    }
    
    func removeObservedHandlers() {
    }
}
