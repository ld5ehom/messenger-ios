//
//  AuthenticationService.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/13/24.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

// Authentication Error Type list
enum AuthenticationError: Error {
    case clientIDError
    case tokenError
    case invalidated
}

// Add Authentication service protocol and class
protocol AuthenticationServiceType {
    func checkAuthenticationState() -> String?
    func signInWithGoogle() -> AnyPublisher<User, ServiceError>
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, none: String) -> AnyPublisher<User, ServiceError>
    func logout() -> AnyPublisher<Void, ServiceError>
}

class AuthenticationService: AuthenticationServiceType {
    
    // Checks if the current user information is available
    func checkAuthenticationState() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            return nil
        }
    }
    
    /**
     Function to initiate Google Sign-In and return a publisher for asynchronous handling
     */
    func signInWithGoogle() -> AnyPublisher<User, ServiceError> {
        
        // Calling the signInWithGoogle function to start the sign-in process
        Future { [weak self] promise in
            self?.signInWithGoogle { result in
                switch result {
                case let .success(user):
                    promise(.success(user))
                case let .failure(error):
                    promise(.failure(.error(error)))
                }
            }
            //Convert the Future into an AnyPublisher for easier handling by subscribers
        }.eraseToAnyPublisher()
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
        request.requestedScopes = [.fullName, .email]
        
        // Util.RandomNonceString and SHA256
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        
        // Return nonce for verification later
        return nonce
        
    }
    
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, none: String) -> AnyPublisher<User, ServiceError> {
        Future { [weak self] promise in
            self?.handleSignInWithAppleCompletion(authorization, nonce: none) { result in
                switch result {
                case let .success(user):
                    promise(.success(user))
                case let .failure(error):
                    promise(.failure(.error(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, ServiceError> {
        Future { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(.error(error)))
            }
        }.eraseToAnyPublisher()
    }
    
}

/*
 * Since Google Sign-In does not support Combine. 
 * So implement completion handler and publisher for the response
 */
extension AuthenticationService {
    
    private func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        
        // Retrieves the client ID through Firebase
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(AuthenticationError.clientIDError))
            return
        }
        
        // Set up configuration with clientID
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Extract the root view controller from the window to present the Google Sign-In view
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        /**
         Create credentials with ID token and access token for Firebase authentication
         */
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            /**
             The user object, idToken, and accessToken are all successfully retrieved from the sign-in result.
             */
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(.failure(AuthenticationError.tokenError))
                return
            }

            let accessToken = user.accessToken.tokenString
            
            /**
             Using the retrieved idToken and accessToken, a Firebase AuthCredential is created using GoogleAuthProvider.credential(withIDToken:accessToken:).
             */
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            // When Google Sign-In is completed
            self?.authenticateUserWithFirebase(credential: credential, completion: completion)
            
        }
    }
    
    // Handle Apple Sign-In completion by creating a Future publisher with a completion handler
    private func handleSignInWithAppleCompletion(_ authorization: ASAuthorization,
                                                 nonce: String,
                                                 completion: @escaping (Result<User, Error>) -> Void) {
        
        // Check for Apple ID Credential and Token
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let appleIDToken = appleIDCredential.identityToken else {
            completion(.failure(AuthenticationError.tokenError))
            return
        }
        
        // appleIDToken convert to string
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            completion(.failure(AuthenticationError.tokenError))
            return
        }
        
        // Create Firebase Credential
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        
        // Authenticate with Firebase
        authenticateUserWithFirebase(credential: credential) { result in
            switch result {
            case var .success(user):
                user.name = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")
                completion(.success(user))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    // Function to perform Firebase authentication
    private func authenticateUserWithFirebase(credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void) {
        
        // This method signs in the user with the provided credentials.
        Auth.auth().signIn(with: credential) { result, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            // If the sign-in is successful, it extracts the user information from the result.
            guard let result else {
                completion(.failure(AuthenticationError.invalidated))
                return
            }

            let firebaseUser = result.user
            
            /**
             A User object is created using the information retrieved from Firebase, and the success case is returned via the completion handler.
             */
            let user: User = .init(id: firebaseUser.uid,
                                   name: firebaseUser.displayName ?? "",
                                   phoneNumber: firebaseUser.phoneNumber,
                                   profileURL: firebaseUser.photoURL?.absoluteString)
            
            completion(.success(user))
        }
    }
    
}

class StubAuthenticationService: AuthenticationServiceType {
    
    // Mock Date for AuthenticatedView.swift #Preview
    func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        // Provide a mock result for testing
        let mockUser = User(id: "ld5ehom", name: "Taewook", phoneNumber: "123-456-7890", profileURL: nil)
        completion(.success(mockUser))
    }
    
    func checkAuthenticationState() -> String? {
        return nil
    }
    
    func signInWithGoogle() -> AnyPublisher<User, ServiceError> {
        Empty<User, ServiceError>().eraseToAnyPublisher()
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
        return ""
    }
    
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, none: String) -> AnyPublisher<User, ServiceError> {
        Empty<User, ServiceError>().eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, ServiceError>  {
        Empty().eraseToAnyPublisher()
    }
}
