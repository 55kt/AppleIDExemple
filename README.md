# 🍎 Apple Sign In Example (SwiftUI + Keychain)

## ✨ Features
- 🔒 Secure authentication with **Sign in with Apple**  
- 📦 **Keychain** integration for persistent and safe storage of user credentials  
- 🔄 Automatic sign-in on app launch if credentials are still valid  
- 🚪 Sign-out support (removes credentials from Keychain)  
- 🛠 Simple, clean, and reusable architecture with `AuthViewModel`  

---

## 📸 Screenshots
<p align="center">
  <img width="200" alt="Image" src="https://github.com/user-attachments/assets/1315625e-fde4-4ff0-82ad-35f60bd428fd" />
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/c604e35e-ec62-41a0-b9ad-0e9ff0e382a0" />
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/09ef3977-cb9a-4574-8e56-83c3b4e33754" />
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/805d3344-809d-4f4f-9c94-251eb20203d0" />
<img width="200" alt="Image" src="https://github.com/user-attachments/assets/d846fd91-c67e-41c8-ab10-36828d46d279" />
</p>

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

- **Face ID / Touch ID support**  
  Local Authentication (Face ID / Touch ID) works properly only on a real device.  
  In the iOS Simulator you can simulate biometrics via **Features → Face ID / Touch ID → Matching / Non-Matching**, but some flows (e.g., Sign in with Apple system sheet) may not trigger biometrics at all.  
  For production testing always use a physical iPhone

- Make sure **Sign in with Apple** capability is enabled in your Xcode project settings.  
- Add the following entry to your **Info.plist** (Targets → Info → Custom iOS Target Properties):
  - **Privacy - Face ID Usage Description** → `"Use Face ID for quick start"`  
  _(This ensures iOS will properly ask permission if Face ID is used for quick authentication.)_
- Keychain stores only the **user identifier** — no sensitive data like tokens or passwords.  
- This template is suitable as a starting point for real apps.
