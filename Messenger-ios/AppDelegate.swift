//
//  AppDelegate.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/13/24.
//

// Firebase AppDelegate
import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
