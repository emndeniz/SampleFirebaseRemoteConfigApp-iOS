//
//  SampleFirebaseRemoteConfigAppApp.swift
//  SampleFirebaseRemoteConfigApp
//
//  Created by Mehmet Emin Deniz on 10.10.2023.
//

import SwiftUI
import Firebase

@main
struct SampleFirebaseRemoteConfigAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}
