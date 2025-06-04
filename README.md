# Flutter User Hub

A mobile application built with Flutter that provides a comprehensive user management system with profile viewing, searching, and detailed user information.

![App Banner](assets\screenshorts\Screenshot_1748974184.png)

## Try It Now

[![Download APK](https://img.shields.io/badge/Download-APK-green.svg)](https://drive.google.com/file/d/1V41SC-nH0cI9xWpVKPLlRCD-beaKCixw/view?usp=drive_link)


## Overview

Flutter User Hub is a feature-rich application that allows users to browse through a directory of users, view detailed profiles, search for specific users, and save favorites. The app demonstrates best practices in Flutter development including state management, API integration, caching strategies, and responsive UI design.

## Features

- 📋 **User Directory**: Browse through a paginated list of users
- 🔍 **Search Functionality**: Find users by name, username, or email
- 👤 **Detailed Profiles**: View comprehensive user information
- ❤️ **Favorites System**: Save and manage your favorite users
- ✏️ **Post Management**: View and create user posts
- ✅ **Todo Management**: Track user todos with completion status

## Screenshots

<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
  <img src="assets\screenshorts\Screenshot_1748974184.png" alt="Onboarding 1" width="250"/>
  <img src="assets\screenshorts\Screenshot_1748974189.png" alt="Onboarding 2" width="250"/>
  <img src="assets\screenshorts\Screenshot_1748974199.png" alt="Onboarding 3" width="250"/>
  <img src="assets\screenshorts\Screenshot_1748974203.png" alt="Sign in" width="250"/>
  <img src="assets\screenshorts\Screenshot_1748974145.png" alt="Home Screen" width="250"/>
  <img src="assets\screenshorts\Screenshot_1748974158.png" alt="Search Feature" width="250"/>
  <img src="assets\screenshorts\Screenshot_1748974211.png" alt="User Posts" width="250"/>
  <img src="assets\screenshorts\Screenshot_1748974214.png" alt="Todo List" width="250"/>
</div>

## App Screens

### User Management
- **User List**: Browse through all users with infinite scrolling
- **User Details**: View comprehensive profiles including posts and todos
- **Search**: Find users quickly with real-time search functionality

### Content Features
- **Posts**: Read and create user posts with title and body content
- **Todos**: View and manage user todo items with completion status
- **Tags**: Posts are categorized with relevant tags (mystery, fiction, etc.)

### Architecture Highlights
- **BLoC Pattern**: Clean separation of business logic and UI
- **API Integration**: Seamless connection to DummyJSON API
- **Elegant Design**: Modern neomorphic UI with attention to detail

## Project Structure

```
flutter_user_hub/
├── lib/
│   ├── api/              # API service classes
│   ├── models/           # Data models
│   ├── providers/        # State management
│   ├── screens/          # UI screens
│   ├── widgets/          # Reusable UI components
│   ├── utils/            # Helper functions and constants
│   ├── themes/           # App themes
│   └── main.dart         # Entry point
├── assets/               # Images, fonts, and other static files
│   └── screenshorts/     # App screenshots
├── test/                 # Unit and widget tests
└── build/
    └── app/
        └── outputs/
            └── apk/      # Generated APK files
```

## Technologies

- **Flutter**: UI toolkit for building natively compiled applications
- **BLoC Pattern**: State management solution for clean architecture
- **Dio**: HTTP client for API requests
- **Hive**: Lightweight and fast key-value database
- **Flutter Test**: Testing framework for Flutter applications

## Installation

### Option 1: Build from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/DevNebula6/flutter_user_hub.git
   ```

2. Navigate to the project directory:
   ```bash
   cd flutter_user_hub
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Option 2: Install APK Directly

1. Download the latest APK from the [Releases](https://github.com/yourusername/flutter_user_hub/releases) section.

2. On your Android device, enable installation from unknown sources in your security settings.

3. Open the downloaded APK file to install the application.

## Usage

1. **Browse Users**: Open the app and scroll through the list of users
2. **View User Details**: Tap on any user to see their detailed profile
3. **Search**: Use the search bar to find specific users
4. **Favorites**: Tap the heart icon to add users to your favorites
5. **Create Posts**: Add new posts to a user's profile
6. **Manage Todos**: View and toggle completion status of todos

## Acknowledgments

- Data provided by [JSONPlaceholder](https://jsonplaceholder.typicode.com/)
- Icons from [Font Awesome](https://fontawesome.com/)

## License

This project is licensed under the MIT License - see the LICENSE file for details.
