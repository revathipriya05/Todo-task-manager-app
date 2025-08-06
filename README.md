# ✅ Todo Task Management App (Flutter)

This is a **Flutter-based mobile application** built for managing daily tasks. It supports full CRUD (Create, Read, Update, Delete) functionality with a sleek UI and Firebase integration. Developed as part of a hackathon hosted by [Katomaran](https://www.katomaran.com).

## Features
- Google Login using Firebase Authentication
- Create, Read, Update, Delete (CRUD) tasks
- Room database for local storage
- Firebase Crashlytics for crash reporting
- RecyclerView with swipe-to-delete and animations

## 📱 Tech Stack

- Flutter (Dart)
- Firebase Authentication
- Firebase Crashlytics (optional)

## 📦 Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Create a new Firebase project.
3. Enable **Google Sign-In** under **Authentication**.
4. Download the `google-services.json` file.
5. Place it inside your project’s `android/app/` directory.
6. Make sure to configure your `android/build.gradle` and `android/app/build.gradle` as per Firebase setup.
7. Run `flutter pub get` and launch the app.

## 🏗️ Architecture

This app is built using the MVVM (Model-View-ViewModel) pattern to ensure scalability and maintainability.

## Hackathon Note
This project is a part of a hackathon run by https://www.katomaran.com

