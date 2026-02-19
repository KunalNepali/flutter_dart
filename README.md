# Flutter & Dart Projects

This repository contains multiple **Flutter & Dart projects** built for learning and portfolio purposes. Each project follows **clean architecture**, **Material 3 design**, and is structured to be **production-ready**.

---

## Projects Included

| Project | Description |
|---------|-------------|
|  **Todo App** | A modern To-Do list app with task completion, swipe-to-delete, persistent local storage, and system-based light/dark theme. |
|  **BMI Calculator** | Calculates Body Mass Index based on user input. Material 3 UI with responsive design. |
|  **Expense Tracker** | Track daily expenses with add/delete functionality, local storage, and simple analytics. |
|  **Registration Form App** | A simple Flutter app demonstrating user registration form with: Input fields: Name, Email, Password, Confirm Password, Validation for empty fields and email format, Submit button (prints values in console), Basic responsive UI  |
|  **Loksewa Quiz Application** | A production-quality Flutter application designed for Nepal Police (Loksewa) exam preparation, featuring comprehensive quiz system with local persistence, clean architecture, and Material 3 design. |  
|  **Log Screen Application** |  A production-quality Flutter application featuring a sophisticated logging interface with local persistence, clean architecture, and Material 3 design. Designed as a reusable component for any Flutter project requiring structured logging capabilities. |  
|  **Login/Signup Auth System** |  A production-ready Flutter authentication application with complete login/register flow, featuring SharedPreferences local persistence, clean architecture with Cubit state management, Material 3 design, and JSON serialization for user data management.|
|  **Course Application** | An application where UI and templates were uploaded from existing github repository of mitesh77. Just the initial implementation was done to see how it actually functions. |
|  **Currency Converter** | A hard coded application, to convert USD into NPR. Basically, multiplies given number by 144.
i.e. Today's exchange rate. |


> Each project has its own **README.md** with detailed instructions.

---

## Tech Stack (Common Across Projects)

- **Flutter (Stable)**  
- **Dart**  
- **Material 3** UI components  
- **SharedPreferences** for local persistence  
- **Git & GitHub** for version control  
- Clean folder-based architecture (models, services, widgets, screens)

---

## How to Run Projects

1. Clone the repository:

```bash
git clone https://github.com/KunalNepali/flutter_dart.git
cd flutter_dart

2. 
    Navigate to the project folder you want to run. For example:

cd todo_app

    Get dependencies:

flutter pub get

    Run the app:

flutter run

    Repeat steps 2–4 for other projects (bmi_calculator, expense_tracker, etc.)

Folder Structure (Example)

flutter_dart/
├── todo_app/
│   ├── lib/
│   ├── pubspec.yaml
│   └── README.md
├── bmi_calculator/
│   ├── lib/
│   ├── pubspec.yaml
│   └── README.md
├── expense_tracker/
│   ├── lib/
│   ├── pubspec.yaml
│   └── README.md
├── registration_form_app/
│   ├── lib/
│   ├── pubspec.yaml
│   └── README.md
├── loksewa_quiz_app/
│   ├── lib/
│   ├── pubspec.yaml
│   └── README.md
├── login_page/
│   ├── lib/
│   ├── pubspec.yaml
│   └── README.md
├── log_screen_ui/
│   ├── lib/
│   ├── pubspec.yaml
│   └── README.md
├── course_app/
│   ├── lib/
│   ├── pubspec.yaml
│   └── README.md
├── currency_converter/
│   ├── lib/
│   ├── pubspec.yaml
│   └── README.md
└── README.md   <-- (This file)

Best Practices Followed

    Clean architecture (separate models, services, screens, widgets)

    Material 3 & dark mode support

    Persistent storage via SharedPreferences

    Reusable widgets and components

    Version control via Git & GitHub

    Structured for easy portfolio showcase

Author

Kunal Nepali
GitHub: https://github.com/KunalNepali
License
MIT License — open source and free to use.