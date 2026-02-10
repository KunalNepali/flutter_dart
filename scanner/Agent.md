Project: Flutter Image Scanner App
Goal

Build a modern, modular Android app using Flutter that:

Captures images via device camera

Previews and optionally saves images

Maintains an extendable architecture for future features like:

OCR (text extraction)

Filters & image editing

Cloud storage / sync

Uses clean architecture principles

Is scalable, maintainable, and production-ready

Tech Stack
Frontend / App

Flutter 3+ (stable)

Dart 3+

Material 3 design

Provider (or Riverpod) for state management

Reusable widgets for UI consistency

Backend / Storage

Local storage using path_provider

Optional: SQLite (for metadata)

Optional: Firebase Storage / Cloud (future extension)

Device Integration

camera – capture images

image_picker – optional, pick from gallery

permission_handler – manage camera/storage permissions

flutter_image_compress – optional, compress images

Repository Structure
/image_scanner_app
├── agent.md
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── scanned_image.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── scan_screen.dart
│   │   └── gallery_screen.dart
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   └── image_card.dart
│   ├── services/
│   │   ├── camera_service.dart
│   │   ├── storage_service.dart
│   │   └── ocr_service.dart  # placeholder for future
│   ├── providers/
│   │   └── image_provider.dart
│   └── utils/
│       └── file_utils.dart
└── README.md

Local Storage & Database Setup

Requirements: Android device or emulator, storage permissions

Images are stored locally in app-specific directories using path_provider

Optional future database for metadata: SQLite / Hive

File naming convention: YYYYMMDD_HHMMSS.jpg

Core Features (MVP)
Camera Capture

Access device camera

Capture image

Return image as File object

Image Preview & Acceptance

Preview captured image

Accept or retake image

Save accepted image locally

Image Gallery

Display all saved images

Scrollable list or grid

Click to view full image

State Management

Provider or Riverpod

Notify UI when new images are added

Future Extensions

OCR (extract text from image) using MLKit / Tesseract

Filters: grayscale, crop, brightness, rotate

Cloud upload: Firebase Storage / AWS S3

Sharing images via social media

Tagging, categorizing, or annotating images

Multi-platform support (iOS / Web)

UI / UX Guidelines

Material 3 components

Clean, minimal, intuitive interface

Prominent scan button

Quick access to gallery

Responsive layout for small and large screens

Modular widgets for future reusability

Screens to Build

Home Screen – launch scan, view gallery

Scan Screen – camera preview, capture button

Gallery Screen – saved images in grid or list, tap to view

Optional Screens – OCR result, filter editor, cloud upload

App Logic

Camera service handles all camera operations

Storage service handles file saving / retrieval

Provider manages image list and updates UI

Future services (OCR / filters / cloud) plug into same structure

Development Rules
Environment

Use .env for secrets (e.g., Firebase keys if added)

Keep camera/storage permissions explicit

Code Quality

Single responsibility per file

Modular & reusable widgets/services

No hardcoded paths or data

Easy to extend for new features

Non-Goals (v1 MVP)

Cloud sync (can add later)

Advanced editing & filters

OCR results

Multi-user support

Success Criteria

The project is successful when:

User can launch the app and capture images

Captured images preview correctly

Images can be saved locally and viewed in gallery

Code is modular and ready for extensions

Agent Execution Order

Initialize Flutter project & set Material 3 theme

Add required dependencies (camera, provider, path_provider)

Implement Camera Service & basic scan functionality

Build Home Screen & Scan Screen

Implement Storage Service & Gallery Screen

Implement Provider for state management

Test MVP functionality

Structure code for future extensions (OCR, filters, cloud)

Polish UI/UX and ensure responsiveness

Document architecture & usage in README.md

Project Codename: PixelScan
Domain Concept: Image scanning, extendable to OCR & cloud
Design Ethos: Clean, modular, intuitive, future-proof
