# Flutter User Hub

A mobile application built with Flutter that provides a comprehensive user management system with profile viewing, searching, and detailed user information.

![App Banner](screenshots/welcome_screen.png)

## Overview

Flutter User Hub is a feature-rich application that allows users to browse through a directory of users, view detailed profiles, search for specific users, and save favorites. The app demonstrates best practices in Flutter development including state management, API integration, caching strategies, and responsive UI design.

## Features

- 📋 **User Directory**: Browse through a paginated list of users
- 🔍 **Search Functionality**: Find users by name, username, or email
- 👤 **Detailed Profiles**: View comprehensive user information
- ❤️ **Favorites System**: Save and manage your favorite users
- 🌓 **Theme Support**: Choose between light and dark themes
- 🔄 **Offline Support**: Cache data for offline access
- ✏️ **Post Management**: View and create user posts
- ✅ **Todo Management**: Track user todos with completion status

## Screenshots

<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
  <img src="screenshots/user_list.png" alt="User List" width="250"/>
  <img src="screenshots/user_details_olivia.png" alt="User Details - Olivia" width="250"/>
  <img src="screenshots/user_details_emily.png" alt="User Details - Emily" width="250"/>
  <img src="screenshots/search_results.png" alt="Search Results" width="250"/>
  <img src="screenshots/create_post.png" alt="Create Post" width="250"/>
  <img src="screenshots/todo_list.png" alt="Todo List" width="250"/>
  <img src="screenshots/login_screen.png" alt="Login Screen" width="250"/>
  <img src="screenshots/onboarding_bloc.png" alt="BLoC Architecture" width="250"/>
  <img src="screenshots/onboarding_api.png" alt="API Integration" width="250"/>
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
├── test/                 # Unit and widget tests
└── screenshots/          # App screenshots for documentation
```

## Technologies

- **Flutter**: UI toolkit for building natively compiled applications
- **BLoC Pattern**: State management solution for clean architecture
- **Dio**: HTTP client for API requests
- **Hive**: Lightweight and fast key-value database
- **Flutter Test**: Testing framework for Flutter applications

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
