//
//  AppleIDExempleApp.swift
//  AppleIDExemple
//
//  Created by Vlad on 15/8/25.
//

import SwiftUI

/// Main entry point of the app.
///
/// - Creates and holds the `AuthViewModel` as a `@StateObject`.
/// - Injects it into the environment so that all views can access it.
/// - On launch → triggers automatic sign-in from Keychain.
/// - On app becoming active → re-checks AppleID credential state.
@main
struct AppleIDExempleApp: App {
    @StateObject private var auth = AuthViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(auth)
                .onAppear {
                    auth.handleAppLaunch()
                }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                auth.refreshCredentialStateIfNeeded()
            }
        }
    }
}
