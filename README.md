# 🍎 Apple Sign In Example (SwiftUI + Keychain)

This repository is a **production-ready template** for implementing **Sign in with Apple** authentication in a SwiftUI application.  
It uses **Keychain** to securely store the Apple user identifier and automatically restores the login state on app launch.

---

## ✨ Features
- 🔒 Secure authentication with **Sign in with Apple**  
- 📦 **Keychain** integration for persistent and safe storage of user credentials  
- 🔄 Automatic sign-in on app launch if credentials are still valid  
- 🚪 Sign-out support (removes credentials from Keychain)  
- 🛠 Simple, clean, and reusable architecture with `AuthViewModel`  

---

## 📸 Screenshots
_Add your screenshots here_

## 🚀 How It Works
1. On first launch, the user signs in with Apple.  
   - The **user identifier** (`credential.user`) is securely saved in **Keychain**.  
2. On app relaunch, the app automatically checks if the credentials are still valid.  
   - If valid → user is authenticated  
   - If revoked / not found → user is signed out  
3. Credentials can be revoked at any time, and the app listens for changes.  
4. User can **sign out manually**, which clears the Keychain entry.  

---

## 🛠 Requirements
- iOS 18+  
- Xcode 16+  
- Swift 5.9+  

📜 License
MIT License. Feel free to use and adapt it in your projects.

## ⚡ Notes
- Make sure **Sign in with Apple** capability is enabled in your Xcode project settings.  
- Add the following entry to your **Info.plist** (Targets → Info → Custom iOS Target Properties):
  - **Privacy - Face ID Usage Description** → `"Use Face ID for quick start"`  
  _(This ensures iOS will properly ask permission if Face ID is used for quick authentication.)_
- Keychain stores only the **user identifier** — no sensitive data like tokens or passwords.  
- This template is suitable as a starting point for real apps.
