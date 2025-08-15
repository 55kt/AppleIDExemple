//
//  ContentView.swift
//  AppleIDExemple
//
//  Created by Vlad on 15/8/25.
//

import SwiftUI
import AuthenticationServices
import LocalAuthentication // for biometric login

struct ContentView: View {
    
    @State private var isAuthenticated: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            
            if isAuthenticated {
                Text("Welcome Back")
                    .font(.largeTitle)
                // logic for taking the user to the rest of the app would be here
                Button("Sign Out") {
                    isAuthenticated = false
                }
                .tint(.red)
            } else {
                SignInWithAppleButton(.signIn) {
                    request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    // handle request of the apple sign in process
                    handleAppleSignIn(result)
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .padding()
                
                Button {
                    authenticateWithBioMetrics()
                } label: {
                    Text("Login with touch / fase id")
                        .bold()
                        .frame(width: 370, height: 50)
                        .foregroundStyle(.white)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .padding(.horizontal)
                }
            }
        }
        .alert(isPresented: $showError) {
            // show an alert if authentication is fails
            Alert(title: Text("Authentication Error"), message: Text(errorMessage ?? "unknown error"), dismissButton: .default(Text("OK")))
        }
    }
    
    func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let _ = authorization.credential as? ASAuthorizationAppleIDCredential {
                // mark the user as authenticated if the apple id sign in is valid
                isAuthenticated = true
            }
        case .failure(let error):
            // capture and display any errors from the apple id sign in
            errorMessage = error.localizedDescription
            showError = true
            print("Apple id error \(error.localizedDescription)")
        }
    }
    
    func authenticateWithBioMetrics() {
        let context = LAContext()
        var error: NSError?
        
        // check if biometric authentication is avaliable
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticae with Face ID or Touch ID"
            // attempt to authenticate w/ biometrics
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        // if successful mark as authentacted
                        isAuthenticated = true
                    } else {
                        // show an error if not authenticated
                        errorMessage = error?.localizedDescription ?? "Biometric failure"
                        showError = true
                    }
                }
            }
        } else {
            // show an error if biometric is not avaliable
            errorMessage = error?.localizedDescription ?? "Biometric failure"
            showError = true
        }
    }
}

#Preview {
    ContentView()
}
