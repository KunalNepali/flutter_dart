# Nepal Police Exam Preparation App

A Flutter-based mobile application for Nepal Police exam preparation with offline-first approach.

## Features

### Core Features
- 📱 **Category Selection**: 10+ exam categories
- ❓ **MCQ Questions**: Single correct answer format
- 📊 **Progress Tracking**: Save and resume quizzes
- 🎯 **Score Calculation**: Real-time scoring with explanations
- 📈 **Results Screen**: Detailed performance analysis
- 🔄 **Restart Option**: Retry quizzes anytime
- 📚 **Syllabus**: Complete exam syllabus reference

### Categories
1. Geography
2. History
3. Current Affairs
4. Mathematics
5. Critical Thinking
6. First Paper
7. Second Paper
8. Third Paper
9. ASI
10. Inspector

### UX Features
- 🎨 Material 3 Design
- 🌓 Dark/Light mode support
- ✨ Visual feedback for answers
- 👆 Swipe navigation
- 📱 Responsive design
- ⚡ Offline-first
- 💾 Auto-save progress

## Tech Stack

- **Flutter** 3.0+
- **Dart** 3.0+
- **Material 3** Design System
- **SharedPreferences** for local storage
- **JSON Serialization** for data handling

## Project Structure
lib/
├── models/ # Data models (QuizCategory, Question, QuizResult)
├── services/ # Business logic & storage
├── screens/ # UI screens (Splash, Categories, Quiz, Results, Syllabus)
├── widgets/ # Reusable components
└── main.dart # App entry point
text


## How to Run

### Prerequisites
- Flutter SDK 3.0+
- Android Studio / VS Code
- Android emulator or physical device

### Installation
```bash
# Clone repository (if applicable)
# git clone <repository-url>

# Navigate to project
cd application_for_police_prep

# Install dependencies
flutter pub get

# Run the app
flutter run

Generate APK
bash

# Build release APK
flutter build apk --release

# Build app bundle
flutter build appbundle --release