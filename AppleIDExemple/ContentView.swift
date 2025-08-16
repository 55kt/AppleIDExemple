//
//  ContentView.swift
//  AppleIDExemple
//
//  Created by Vlad on 15/8/25.
//

import SwiftUI
import AuthenticationServices

/// Main user interface of the app.
///
/// - If the user is authenticated → shows a welcome message + sign-out button.
/// - If the user is not authenticated → shows the "Sign in with Apple" button.
/// - Handles Apple sign-in via `AuthViewModel`.
/// - Displays error alerts if authentication fails.
struct ContentView: View {
    @EnvironmentObject private var auth: AuthViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            if auth.isAuthenticated {
                Text("Welcome Back").font(.largeTitle)
                Button("Sign Out", role: .destructive) { auth.signOut() }
            } else {
                SignInWithAppleButton(.signIn) { req in
                    req.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    auth.handleAppleSignIn(result)
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .padding(.horizontal)
            }
        }
        .padding()
        .alert("Authentication Error",
               isPresented: $auth.showError,
               actions: { Button("OK", role: .cancel) { } },
               message: { Text(auth.errorMessage ?? "unknown error") })
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
