Expense Tracker
A professional Flutter expense tracking application built with Material 3 design, clean architecture, and local persistence.
Features
Material 3 Design - Modern UI with light/dark theme support
Local Persistence - Data saved locally using SharedPreferences
Expense Management - Add, edit, and delete expenses
Categories - Organize expenses by category with emoji icons
Filtering - Filter expenses by category
Total Calculation - View total expenses and category totals
Swipe to Delete - Intuitive gesture-based deletion
Dark Mode - Automatic system theme detection
Responsive Design - Works on mobile, tablet, and desktop
Tech Stack
Flutter 3.16+ - Cross-platform framework
Dart 3.2+ - Programming language
Material 3 - Modern design system
SharedPreferences - Local storage
Clean Architecture - Scalable folder structure
Project Structure
text
expense_tracker/
├── lib/
│   ├── models/
│   │   └── expense_model.dart      # Data model with JSON serialization
│   ├── services/
│   │   └── expense_service.dart    # Business logic & persistence
│   ├── screens/
│   │   ├── expense_list_screen.dart    # Main screen
│   │   └── add_edit_expense_screen.dart # Add/edit screen
│   ├── widgets/
│   │   ├── expense_card.dart       # Reusable expense card
│   │   ├── category_chip.dart      # Category filter chip
│   │   └── empty_state.dart        # Empty state widget
│   └── main.dart                   # App entry point
├── pubspec.yaml                    # Dependencies
└── README.md                       # Documentation
Getting Started
Prerequisites
Flutter SDK (>=3.16.0)
Dart SDK (>=3.2.0)
Git
Installation
Clone the repository
bash
git clone https://github.com/KunalNepali/flutter.git
cd flutter/expense_tracker
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
Models: Data layer with business entities
Services: Business logic and data persistence
Screens: Presentation layer (UI)
Widgets: Reusable UI components
Key Design Patterns
Single Responsibility Principle: Each class has one reason to change
Separation of Concerns: UI, business logic, and data persistence separated
Repository Pattern: Centralized data access through ExpenseService
Observer Pattern: setState() for reactive UI updates
Code Quality Features
 Type Safety: Strongly typed with Dart's null safety
 Error Handling: Comprehensive try-catch blocks
 Form Validation: User input validation
 Code Documentation: Clear comments and documentation
 Performance: Efficient data handling and UI rendering
Usage Guide
Adding an Expense
Tap the + button in the bottom right
Enter expense details (title, amount, category, date)
Tap Save or press Enter
Editing an Expense
Tap on any expense card
Modify the details
Tap Save
Deleting an Expense
Swipe left or right on an expense card
Confirm deletion
Or use undo if deleted by mistake
Filtering Expenses
Scroll the category chips at the top
Tap any category to filter
Tap "All" to show all expenses
Testing
Run unit tests:
bash
flutter test
Run integration tests:
bash
flutter test integration_test
Future Enhancements
Planned Features
Charts and visual analytics
Export to CSV/PDF
Recurring expenses
Budget tracking
Cloud sync with Firebase
Receipt image capture
Multi-currency support
Data backup/restore
Technical Improvements
State management with Riverpod
Integration testing
CI/CD pipeline
Internationalization (i18n)
Accessibility improvements
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
Material Design team for Material 3
All open-source contributors
Portfolio Summary
Built a Flutter Expense Tracker application using Material 3 with clean architecture, implementing:
 Local data persistence with SharedPreferences
 Swipe-to-delete gestures with Dismissible widgets
 System-based light/dark theme detection
 Reusable widget architecture (ExpenseCard, CategoryChip, EmptyState)
 Service-layer storage abstraction
 Form validation and error handling
 Filterable category-based expense lists
 Production-ready project structure
Developed by Kunal Nepali
Flutter Developer | Clean Architecture Enthusiast


