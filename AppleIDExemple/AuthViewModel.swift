//
//  AuthViewModel.swift
//  AppleIDExemple
//
//  Created by Vlad on 16/8/25.
//

import Foundation
import SwiftUI
import AuthenticationServices

/// View model responsible for handling Sign in with Apple flow,
/// persisting the Apple user identifier in Keychain, and exposing
/// authentication state to SwiftUI views.
///
/// - Important: This VM does **not** store any Apple password/token.
/// It only stores the stable `userIdentifier` that Apple returns for your app.
@MainActor
final class AuthViewModel: ObservableObject {
    /// Indicates whether the current user session is authenticated
    /// and the app should show the protected UI.
    @Published var isAuthenticated: Bool = false

    /// Controls presentation of the generic error alert in the UI.
    @Published var showError: Bool = false

    /// Holds the last authentication error message to display.
    @Published var errorMessage: String?

    /// Logical namespace (service) for Keychain records.
    /// Prefer using your app bundle id or a dedicated suffix.
    private let service = "com.yourapp.auth"

    /// Account key (record name) used to store the Apple user identifier.
    private let account = "appleUserID"

    // MARK: - App Lifecycle

    /// Called on app launch to automatically restore the user session if possible.
    ///
    /// Reads the previously stored Apple user identifier from Keychain and
    /// asks Apple for the current credential state. If the state is `.authorized`,
    /// we mark the session as authenticated; otherwise we sign out and clean up.
    func handleAppLaunch() {
        if let userID = KeychainHelper.shared.read(service: service, account: account) {
            checkAppleCredentialState(for: userID)
        } else {
            isAuthenticated = false
        }
    }

    // MARK: - Sign in with Apple

    /// Handles the completion of the Sign in with Apple flow.
    /// - Parameter result: Authorization result from `ASAuthorizationController`.
    ///
    /// On success, extracts the `ASAuthorizationAppleIDCredential`, stores the
    /// unique `user` identifier in Keychain, and marks the session as authenticated.
    /// On failure, surfaces the error message to the UI.
    func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                let userID = credential.user
                // Persist the stable Apple user identifier in Keychain
                KeychainHelper.shared.save(userID, service: service, account: account)
                isAuthenticated = true
            } else {
                showErrorMessage("Invalid AppleID credential")
            }
        case .failure(let error):
            showErrorMessage(error.localizedDescription)
        }
    }
    
    /// Proactively refreshes the Apple credential state when the app
    /// returns to foreground or when you want to revalidate the session.
    ///
    /// If the credential is revoked/transferred/not found, the user is signed out
    /// and the stored identifier is removed from Keychain.
    func refreshCredentialStateIfNeeded() {
        // Read the stored Apple user id from Keychain
        guard let uid = KeychainHelper.shared.read(service: service, account: account),
              !uid.isEmpty else { return }

        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: uid) { [weak self] state, _ in
            DispatchQueue.main.async {
                switch state {
                case .authorized:
                    // Everything is fine — keep the user authenticated
                    self?.isAuthenticated = true
                case .revoked, .notFound, .transferred:
                    // Credential was revoked/not found → log out and clean Keychain
                    self?.signOut()
                @unknown default:
                    self?.signOut()
                }
            }
        }
    }

    // MARK: - Sign Out

    /// Signs the user out locally and removes the saved Apple user id from Keychain.
    func signOut() {
        KeychainHelper.shared.delete(service: service, account: account)
        isAuthenticated = false
    }

    // MARK: - Internal Helpers

    /// Checks the credential state for a specific Apple user identifier
    /// and updates authentication state accordingly.
    /// - Parameter userID: The Apple `userIdentifier` returned during SIWA.
    private func checkAppleCredentialState(for userID: String) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID) { [weak self] state, _ in
            DispatchQueue.main.async {
                switch state {
                case .authorized:
                    self?.isAuthenticated = true
                case .revoked, .notFound, .transferred:
                    self?.signOut()
                @unknown default:
                    self?.signOut()
                }
            }
        }
    }

    /// Sets the error message and flips the alert flag to present it in the UI.
    /// - Parameter message: A human-readable error description.
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}
