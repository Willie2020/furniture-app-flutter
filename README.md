# simple_flutter

A Flutter mobile application built with BLoC state management and local SQLite storage. Supports Android and iOS.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Project Setup](#project-setup)
- [Running the App](#running-the-app)
- [Building the App](#building-the-app)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)

---

## Prerequisites

Before getting started, make sure the following tools are installed on your machine:

1. **Flutter SDK** (version `^3.6.0` or higher)
   - [Install Flutter](https://docs.flutter.dev/get-started/install)
2. **Dart SDK** — bundled with Flutter, no separate install needed.
3. **Git** — to clone the repository.
4. A supported IDE (recommended):
   - [VS Code](https://code.visualstudio.com/) with the [Flutter extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
   - [Android Studio / IntelliJ IDEA](https://developer.android.com/studio) with the Flutter plugin

Verify your Flutter installation is set up correctly:

```sh
flutter doctor
```

Resolve any issues reported before continuing.

---

## Project Setup

### 1. Clone the repository

```sh
git clone <repository-url>
cd simple_flutter
```

### 2. Install dependencies

```sh
flutter pub get
```

This installs all packages listed in `pubspec.yaml`, including:
- `flutter_bloc` — BLoC state management
- `sqflite` — Local SQLite database
- `equatable` — Value equality for BLoC states/events
- `cupertino_icons` — iOS-style icons

### 3. Platform-specific setup

#### Android
- Install [Android Studio](https://developer.android.com/studio) and the Android SDK.
- Accept Android licenses:
  ```sh
  flutter doctor --android-licenses
  ```
- Connect a physical device or start an Android emulator.

#### iOS (macOS only)
- Install [Xcode](https://developer.apple.com/xcode/) from the Mac App Store.
- Install CocoaPods:
  ```sh
  sudo gem install cocoapods
  ```
- Install iOS dependencies:
  ```sh
  cd ios && pod install && cd ..
  ```
- Connect a physical device or start an iOS simulator.

---

## Running the App

List connected devices and emulators:

```sh
flutter devices
```

Run on a specific device:

```sh
flutter run -d <device-id>
```

Run in debug mode (default):

```sh
flutter run
```

Run in release mode:

```sh
flutter run --release
```

---

## Building the App

### Android

**Debug APK:**
```sh
flutter build apk --debug
```

**Release APK:**
```sh
flutter build apk --release
```

**App Bundle (recommended for Play Store):**
```sh
flutter build appbundle --release
```

Output: `build/app/outputs/`

---

### iOS (macOS only)

```sh
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode to archive and distribute the app.

---

## Project Structure

```
simple_flutter/
├── lib/
│   ├── blocs/        # BLoC classes (events, states, blocs)
│   ├── models/       # Data models
│   ├── pages/        # App screens / pages
│   ├── services/     # Business logic & data services (SQLite, etc.)
│   ├── styles/       # App-wide theme and style constants
│   ├── widgets/      # Reusable UI components
│   └── main.dart     # App entry point
├── android/          # Android platform files
├── ios/              # iOS platform files
├── test/             # Unit and widget tests
└── pubspec.yaml      # Project dependencies and metadata
```

---

## Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^8.1.6 | State management |
| `sqflite` | ^2.4.0 | Local SQLite database |
| `equatable` | ^2.0.7 | Value equality for BLoC |
| `path` | ^1.9.0 | File path utilities |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

---

For more information on Flutter development, visit the [Flutter documentation](https://docs.flutter.dev/).
