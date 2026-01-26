BMI Calculator

A professional Flutter BMI calculator application built with Material 3 design, clean architecture, and local persistence.
Features

    Material 3 Design - Modern UI with light/dark theme support

    Local Persistence - Save BMI history using SharedPreferences

    BMI Calculation - Calculate BMI using height (cm) and weight (kg)

    BMI Categories - Automatic classification (Underweight, Normal, Overweight, Obese)

    Visual Feedback - Color-coded BMI results for quick assessment

    History Tracking - View past BMI calculations with timestamps

    Swipe to Delete - Intuitive gesture-based deletion from history

    Dark Mode - Automatic system theme detection

    Responsive Design - Works on mobile, tablet, and desktop

Tech Stack

    Flutter 3.16+ - Cross-platform framework

    Dart 3.2+ - Programming language with null safety

    Material 3 - Modern design system

    SharedPreferences - Local storage solution

    Clean Architecture - Scalable folder-based structure

Project Structure
text

bmi_calculator/
├── lib/
│   ├── models/
│   │   └── bmi_record.dart         # Data model with JSON serialization
│   ├── services/
│   │   └── storage_service.dart    # Business logic & persistence
│   ├── screens/
│   │   └── home_screen.dart        # Main BMI calculation screen
│   ├── widgets/
│   │   ├── bmi_card.dart           # Reusable BMI history card
│   │   └── input_section.dart      # Height/weight input component
│   └── main.dart                   # App entry point & theme configuration
├── pubspec.yaml                    # Dependencies configuration
└── README.md                       # Project documentation

Getting Started
Prerequisites

    Flutter SDK (>=3.16.0)

    Dart SDK (>=3.2.0)

    Git

Installation

    Clone the repository

bash

git clone https://github.com/KunalNepali/flutter.git
cd flutter/bmi_calculator

    Install dependencies

bash

flutter pub get

    Run the application

bash

flutter run

Build Instructions

For Android:
bash

flutter build apk --release

For iOS:
bash

flutter build ios --release

For Web:
bash

flutter build web --release

For Linux:
bash

flutter build linux --release

Architecture
Clean Architecture Pattern

    Models: Data layer with BMI calculation logic

    Services: Business logic and data persistence layer

    Screens: Presentation layer with UI components

    Widgets: Reusable UI components for consistency

Key Design Patterns

    Single Responsibility Principle: Each class has one reason to change

    Separation of Concerns: UI, business logic, and data persistence separated

    Repository Pattern: Centralized data access through StorageService

    Observer Pattern: setState() for reactive UI updates

Code Quality Features

    Type Safety: Strongly typed with Dart's null safety

    Error Handling: Comprehensive try-catch blocks in storage operations

    Form Validation: Input range validation (height: 100-250cm, weight: 20-200kg)

    Code Documentation: Clear comments and documentation

    Performance: Efficient list handling with lazy loading

Usage Guide
Calculating BMI

    Adjust the height slider (100-250 cm)

    Adjust the weight slider (20-200 kg)

    Tap "Calculate BMI" button

    View your BMI result and category

Viewing History

    All previous calculations appear in chronological order

    Each entry shows date, measurements, BMI, and category

    Color coding indicates BMI category

Deleting Records

    Swipe left on any BMI history card to delete

    Use the trash icon in the app bar to clear all history

Understanding BMI Categories

    Underweight: BMI < 18.5 (Blue indicator)

    Normal: BMI 18.5–24.9 (Green indicator)

    Overweight: BMI 25–29.9 (Orange indicator)

    Obese: BMI ≥ 30 (Red indicator)

Testing

Run unit tests:
bash

flutter test

Run integration tests:
bash

flutter test integration_test

Future Enhancements
Planned Features

    BMI Trends - Visual charts showing BMI progression

    Unit Conversion - Switch between metric and imperial units

    Health Goals - Set and track weight goals

    Reminders - Schedule regular BMI checks

    Export Data - Export history to CSV or PDF

    Multi-user Profiles - Track BMI for family members

    Health Integration - Connect to Google Fit/Apple Health

Technical Improvements

    State management with Provider/Riverpod

    Integration testing suite

    CI/CD pipeline with GitHub Actions

    Internationalization (i18n) support

    Accessibility improvements

    Animation enhancements

    Unit testing coverage

Contributing

    Fork the repository

    Create a feature branch (git checkout -b feature/AmazingFeature)

    Commit your changes (git commit -m 'Add some AmazingFeature')

    Push to the branch (git push origin feature/AmazingFeature)

    Open a Pull Request

License

This project is licensed under the MIT License - see the LICENSE file for details.
Acknowledgments

    Flutter team for the amazing framework

    Material Design team for Material 3 specifications

    All open-source contributors

    Health organizations for BMI classification standards

Portfolio Summary

Built a production-ready Flutter BMI Calculator using Material 3 with clean architecture, implementing:

    Local data persistence with SharedPreferences for BMI history

    Swipe-to-delete gestures using Dismissible widgets with visual feedback

    System-based theming with automatic light/dark mode detection

    Reusable widget architecture (BmiCard, InputSection) for maintainability

    Service-layer abstraction for data storage operations

    Real-time BMI calculation with instant visual feedback

    Color-coded categorization for immediate health assessment

    Professional project structure following clean architecture principles
Developed by Kunal Nepali
Flutter Developer | Clean Architecture Enthusiast