# Registration Form App

A Flutter application built with Clean Architecture, Material 3, and local persistence using SharedPreferences. This app demonstrates professional Flutter development practices suitable for portfolio and production use.

## Features

-  **User Registration**: Add new users with form validation
-  **User Management**: Edit, delete, and toggle user status
-  **Local Persistence**: Data persists across app restarts using SharedPreferences
-  **Material 3 Design**: Modern UI with Material 3 components
-  **Dark/Light Mode**: Supports system theme
-  **Filtering**: Toggle between all users and active users only
-  **Form Validation**: Comprehensive input validation
-  **Responsive Design**: Works on all screen sizes
-  **Clean Architecture**: Well-organized folder structure
-  **Reusable Widgets**: Modular UI components
## Tech Stack

- **Flutter** (Stable version)
- **Dart** (Null safety enabled)
- **Material 3** (Material Design 3 components)
- **SharedPreferences** (Local storage)
- **Git & GitHub** (Version control)

## Project Structure
lib/
├── models/ # Data models with JSON serialization
│ └── user_model.dart
├── services/ # Business logic & storage
│ └── storage_service.dart
├── screens/ # Main UI screens
│ ├── home_screen.dart
│ └── registration_screen.dart
├── widgets/ # Reusable UI components
│ ├── custom_button.dart
│ ├── custom_text_field.dart
│ └── user_card.dart
└── main.dart # App entry point & theme
text


## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extension

### Installation

1. Clone the repository:
```bash
git clone <your-repository-url>
cd registration_form_app

    Install dependencies:

flutter pub get

    Run the app:

flutter run

For Web

flutter run -d chrome

For Release Build

flutter build apk --release
# or for web
flutter build web --release

Screenshots
Light Mode

https://screenshots/home_light.png
https://screenshots/registration_light.png
Dark Mode

https://screenshots/home_dark.png
https://screenshots/registration_dark.png
Key Implementation Details
Clean Architecture

    Models: Pure data classes with JSON serialization

    Services: Business logic separated from UI

    Screens: Focus on presentation logic only

    Widgets: Reusable, stateless components

Local Storage

    Uses SharedPreferences for persistent storage

    JSON serialization/deserialization

    All operations are async and handle errors

State Management

    Uses setState for simplicity (can be upgraded to Provider/Riverpod)

    Data loaded in initState()

    Auto-refresh after CRUD operations

Form Handling

    Comprehensive validation

    Real-time feedback

    Keyboard-appropriate input types

Portfolio Summary

Built a production-ready Flutter application using Material 3 with clean architecture principles. Implemented:

    Complete CRUD operations with local data persistence using SharedPreferences

    Material 3 design system with light/dark theme support

    Clean folder-based architecture separating models, services, screens, and widgets

    Reusable UI components with proper state management

    Form validation and user-friendly error handling

    Filtering functionality and swipe-to-delete gestures

    Professional project structure suitable for enterprise applications

Future Enhancements

    State Management: Migrate to Riverpod/Provider

    Cloud Sync: Add Firebase integration

    Offline Support: Implement offline-first logic

    Animations: Add smooth transitions

    Testing: Add unit & widget tests

    Internationalization: Support multiple languages

    Search: Add user search functionality

    Export: Export data as CSV/PDF

License

MIT License - feel free to use this project for your portfolio!
text


## Additional Setup Commands

```bash
# Add required dependencies to pubspec.yaml
# Add these to your pubspec.yaml under dependencies:

dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
  intl: ^0.19.0

# Then run:
flutter pub get

# Initialize Git (if not already done)
git init
git add .
git commit -m "Initial commit: Registration Form App with Clean Architecture"

