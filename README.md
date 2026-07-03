# Task Manager App

A simple and responsive Task Manager application built with Flutter. The app allows users to create, update, complete, archive, and manage tasks with local data persistence.

## Features

- Create new tasks
- Edit existing tasks
- Mark tasks as complete/incomplete
- Archive and restore tasks
- Permanently delete archived tasks
- Local storage using SharedPreferences
- Responsive UI for Mobile, Tablet, and Web

## Tech Stack

- Flutter
- Dart
- GetX (State Management & Navigation)
- SharedPreferences
- Material 3

## Project Setup

### 1. Clone the repository

```bash
git clone https://github.com/your-username/task-manager.git
```

### 2. Navigate to the project

```bash
cd task-manager
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the application

```bash
flutter run
```

### Build for Web

```bash
flutter build web
```

## Project Structure

```
lib/
├── config/
├── constant/
├── extensions/
├── model/
├── screens/
├── services/
├── utils/
└── main.dart
```

## Approach

The application follows a simple architecture using **GetX** for state management.

- A single `DashboardController` manages all task-related operations.
- Tasks are stored locally using **SharedPreferences**, so no backend is required.
- The UI is reactive using GetX observables, ensuring automatic updates whenever data changes.
- Tasks are categorized into All, Completed, Incomplete, and Archived views.
- The application is responsive and adapts its layout for mobile, tablet, and desktop screens.

## Data Persistence

All tasks are stored locally using SharedPreferences. Changes such as adding, updating, completing, or archiving tasks are automatically saved and restored when the app restarts.

## Screens

- Dashboard
- Add/Edit Task Dialog
- Archive Screen

## Author

**Divyesh Rathod**
