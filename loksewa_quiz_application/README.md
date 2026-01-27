# Loksewa Tayari - Nepal Police Exam Preparation App

A production-quality Flutter application for Loksewa preparation with clean architecture, Material 3, and local persistence.

## Features

### Core Features
- ✅ Category-based quiz system
- ✅ MCQ questions with single correct answer
- ✅ Progress tracking and persistence
- ✅ Score calculation and result history
- ✅ Question navigation (Next/Previous)
- ✅ Restart quiz functionality

### Categories
1. Geography - Nepal and world geography
2. History - Nepal and world history
3. Current Affairs - Latest national/international news
4. Mathematics - Basic and advanced mathematics
5. Critical Thinking - Logical reasoning and problem solving

### UX Enhancements
- ✅ Swipe gestures for question navigation
- ✅ Visual feedback for correct/incorrect answers
- ✅ Snackbar notifications
- ✅ Graceful empty states
- ✅ Minimal, distraction-free UI

### Technical Features
- ✅ Clean architecture with single responsibility
- ✅ Material 3 design system
- ✅ Light/Dark theme support
- ✅ Local persistence with SharedPreferences
- ✅ JSON serialization
- ✅ Stateless widgets where possible
- ✅ No business logic in UI widgets

## Tech Stack

- **Framework**: Flutter (Stable)
- **Language**: Dart
- **Design**: Material 3
- **Storage**: SharedPreferences
- **Serialization**: JSON
- **Architecture**: Clean folder-based structure

## Folder Structure
lib/
├── models/ # Data models with JSON serialization
│ ├── question.dart
│ ├── quiz_category.dart
│ └── quiz_result.dart
├── services/ # Business logic & storage services
│ ├── storage_service.dart
│ └── quiz_service.dart
├── screens/ # Main UI screens
│ ├── home_screen.dart
│ ├── category_screen.dart
│ ├── quiz_screen.dart
│ └── result_screen.dart
├── widgets/ # Reusable UI components
│ ├── category_card.dart
│ ├── quiz_option_tile.dart
│ ├── primary_button.dart
│ └── result_summary.dart
└── main.dart # App entry point & theme config
text


## How to Run

1. **Prerequisites**
   - Flutter SDK (latest stable version)
   - Android Studio / VS Code
   - Android Emulator or physical device

2. **Setup**
   ```bash
   git clone <repository-url>
   cd loksewa_quiz_application
   flutter pub get

    Run the app
    bash

    flutter run

    Build for release
    bash

    flutter build apk --release

Data Models
QuizCategory

    id, name, description

    questionCount, icon

    isCompleted, highestScore

Question

    id, categoryId, text

    options, correctAnswerIndex

    selectedAnswerIndex, explanation

QuizResult

    id, categoryId, date

    totalQuestions, correctAnswers

    score, timeTaken, userAnswers

Local Persistence

The app uses SharedPreferences to store:

    Quiz categories and progress

    User answers and selections

    Quiz results and scores

    Highest scores per category

All data is serialized using JSON and loaded in initState().
Architecture Rules

    Single Responsibility: Each file has one primary responsibility

    Separation of Concerns: No business logic in UI widgets

    Stateless First: Use StatelessWidget where possible

    Clean Callbacks: Pass callbacks and data via constructors

    Immutability: Models are immutable with JSON serialization

Future Enhancements
Planned Features

    Advanced Filters

        Filter questions by difficulty

        Filter by sub-topics

        Time-based filtering

    Analytics Dashboard

        Progress charts and graphs

        Performance trends

        Weak areas identification

    Cloud Synchronization

        Multi-device sync

        Backup and restore

        Cloud question bank

    Study Materials

        PDF viewers

        Video tutorials

        Study notes

    Exam Simulation

        Timed mock tests

        Previous year papers

        Exam pattern practice

Technical Improvements

    State management (Riverpod/Bloc)

    Offline-first database (Hive/SQLite)

    Firebase integration

    CI/CD pipeline

    Unit and widget tests

Contributing

    Fork the repository

    Create a feature branch

    Commit changes

    Push to the branch

    Create a Pull Request

License

MIT License - see LICENSE file for details

Support

For issues and feature requests, please create an issue in the GitHub repository.
text


## 8. Running the Application

1. Create a new Flutter project:
```bash
flutter create loksewa_quiz_application

    Replace the default files with the code provided above.

    Add dependencies in pubspec.yaml:

bash

flutter pub add shared_preferences

    Run the app:

bash

flutter run

Key Features Implemented:

    Clean Architecture - Separated models, services, screens, and widgets

    Material 3 - Full Material 3 theming with light/dark mode

    Local Persistence - SharedPreferences with JSON serialization

    Production Quality - Error handling, loading states, empty states

    Scalable - Easy to add new categories and features

    Portfolio Ready - Clean code, professional UI, proper documentation