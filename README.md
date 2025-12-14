# 📱 UMTC Events - Campus Event Finder & RSVP

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

A feature-rich Flutter application for discovering and managing campus events at the University of Mindanao Tagum College (UMTC). Built with modern architecture, this app empowers students to discover events and administrators to manage event operations efficiently.

**[Download Latest Release](https://github.com/yourusername/cce106_app/releases)** • **[Documentation](./DEVELOPMENT.md)** • **[Contributing](#contributing)**

---

## ✨ Features

### 👥 For Students
- 🔍 **Event Discovery** - Browse and search events by college and category
- ✅ **Smart RSVP System** - Reserve spots with real-time capacity tracking
- 📅 **My Events** - Manage all your confirmed RSVPs in one place
- 🎯 **Advanced Filtering** - Filter by college, category, and date range
- 🔄 **Live Updates** - Real-time attendance tracking and event notifications
- 👤 **User Profile** - Secure authentication and personal dashboard

### 🛠️ For Administrators
- 📊 **Event Management** - Create, edit, update, and delete events seamlessly
- 📈 **Dashboard Analytics** - Track event statistics and attendance metrics
- 👥 **Capacity Control** - Set and monitor event capacity limits and occupancy
- 🏆 **Trending Events** - Identify most popular events by attendance
- 🔐 **Admin Controls** - Role-based access management

### 🖼️ Key Features
- **Multi-College Support** - Organize events by different college departments
- **Real-time Synchronization** - Instant updates across all user devices
- **Responsive UI** - Beautiful Material Design 3 interface
- **Offline Compatibility** - Works seamlessly with or without internet connection

---

## 🛠️ Technology Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter 3.x / Dart |
| **Backend** | Firebase (Firestore, Auth, Storage) |
| **State Management** | Provider pattern |
| **UI Framework** | Material Design 3 |
| **Database** | Cloud Firestore (NoSQL) |
| **Authentication** | Firebase Authentication |

## 📂 Project Structure

```
lib/
├── main.dart                           # Application entry point
├── firebase_options.dart               # Firebase configuration & credentials
│
├── models/
│   ├── user_model.dart                # User data model & serialization
│   └── event_model.dart               # Event data model & serialization
│
├── services/                           # Business logic & data layer
│   ├── auth_service.dart              # Firebase authentication service
│   ├── event_service.dart             # Firestore event CRUD operations
│   └── demo_data_service.dart         # Sample test data generator
│
├── providers/                          # State management (Provider pattern)
│   ├── auth_provider.dart             # Authentication state notifier
│   └── event_provider.dart            # Event state notifier
│
├── screens/                            # UI screens
│   ├── login_screen.dart              # Login & authentication UI
│   ├── create_account_screen.dart     # User registration form
│   ├── home_screen.dart               # Main event discovery interface
│   ├── my_events_screen.dart          # User's RSVP'd events
│   ├── admin_dashboard_screen.dart    # Admin control panel
│   └── create_event_screen.dart       # Event creation & editing
│
└── widgets/
    └── event_card.dart                # Reusable event display component
```

---

## 🚀 Getting Started

### 📋 Prerequisites

- **Flutter SDK** v3.10.1 or higher ([Installation Guide](https://flutter.dev/docs/get-started/install))
- **Firebase Account** ([Create Free Project](https://console.firebase.google.com/))
- **IDE**: Android Studio, VS Code, or Xcode with Flutter extensions
- **Git** for version control

### 🔧 Environment Setup

#### 1. Install Flutter Dependencies
```bash
# Activate FlutterFire CLI for Firebase setup
flutter pub global activate flutterfire_cli

# Get project dependencies
flutter pub get
```

#### 2. Firebase Project Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing one
3. Enable these services:
   - ✅ **Authentication** (Email/Password method)
   - ✅ **Cloud Firestore** (Production mode)
   - ✅ **Cloud Storage** (for event images)
4. Configure for Flutter:
   ```bash
   flutterfire configure
   ```
   - Select your Firebase project
   - Choose platforms (Android/iOS/Web)
   - This auto-updates `lib/firebase_options.dart`

#### 3. Clone & Setup Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/cce106_app.git
cd c🧪 Demo & Testing

**Test Credentials** (Pre-configured demo users):
- **Admin Account**: `admin@umtc.edu` / `admin123`
- **Student Account**: `student@umtc.edu` / `student123`

Or create your own account during first launch.

---

## 📝 Database Schema
flutterfire configure
```

#### 4. Run the Application

```bash
# List available devices
flutter devices

# Run on Android device/emulator
flutter run

# Run on iOS device/simulator
flutter run -d ios

# Run in release mode for production
flutter run --release
```

### Demo Credentials
For testing purposes, the app includes demo credentials:
- **Admin**: admin@umtc.edu / admin123
- **Student**: Use any email / any password

## Firebase Firestore Database Structure

### Users Collection
```json
{
  "id": "user_uid",
  "email": "user@umtc.edu",
  "fullName": "John Doe",
  "college": "College of Science & Engineering",
  "courseProgram": "Computer Science",
  "userType": "student" // or "admin"
}
```

### Events Collection
```json
{
  "id": "event_id",
  "title": "AI & Machine Learning Workshop",
  "description": "Event description...",
  "date": "2024-12-01T00:00:00.000Z",
  "startTime": "2:00 PM",
  "endTime": "4:00 PM",
  "location": "Keller Hall, Room 3-180",
  "college": "College of Science & Engineering",
  "category": "Workshop",
  "organizer": "CS Student Association",
  "capacity": 50,
  "imageUrl": "https://example.com/image.jpg",
  "tags": ["AI", "Tech"],
  "attendees": ["user1", "user2"],
  "createdAt": "2024-11-25T00:00:00.000Z"
}
```

## Colleges and Categories

### Colleges
- College of Science & Engineering
- College of Business
- College of Arts & Letters
- College of Education

### Event Categories
- Workshop
- Seminar
- Conference
---

## 🎨 UI/UX Design

Built with Material Design 3 and UMTC branding:
- **Primary Color**: Red and Maroon
- **Secondary Colors**: Gold accents, Light gray backgrounds
- **Typography**: Responsive layouts for all screen sizes
---

## 💡 Implementation Highlights

### 🔄 Real-time Synchronization
- Firestore stream listeners for live updates
- Automatic UI refresh on data changes
- Optimistic updates for better UX

### ✅ RSVP System
- One-click event registration
- Real-time capacity tracking
- Prevents overbooking with atomic transactions
- Visual attendance indicators
- Easy RSVP cancellation

### 📊 Admin Dashboard
- Event creation/editing/deletion
- Real-time attendance analytics
- Event popularity tracking
- Capacity management

## 🚀 Roadmap & Future Enhancements

- [ ] 🔔 Push Notifications for upcoming events
- [ ] 💬 Event comment section and attendee discussions
- [ ] 📱 QR code check-in for event organizers
- [ ] 📅 Calendar integration (Google Calendar, Apple Calendar)
- [ ] 🔍 Advanced full-text event search
- [ ] 📸 Event image gallery and upload
- [ ] 📈 Advanced analytics dashboard
- [ ] 🌐 Multi-language support (Filipino, English)
- [ ] 🗺️ Event location map view
- [ ] 🎫 Ticketing system integration

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Development Workflow

1. **Fork** the repository
   ```bash
   git clone https://github.com/yourusername/cce106_app.git
   ```

2. **Create** a feature branch
   ```bash
   git checkout -b feature/AmazingFeature
   ```

3. **Commit** your changes
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```

4. **Push** to the branch
   ```bash
   git push origin feature/AmazingFeature
   ```

5. **Open** a Pull Request

### Code Guidelines
- Follow Dart [effective practices](https://dart.dev/guides/language/effective-dart)
- Format code: `dart format .`
- Run analysis: `dart analyze`
- Write meaningful commit messages
- Add comments for complex logic

---

## 🙏 Acknowledgments

- University of Mindanao Tagum College for the inspiration
- Flutter & Firebase communities
---

<div align="center">

**[⬆ Back to Top](#-umtc-events---campus-event-finder--rsvp)**

</div>
1. **Push Notifications**: Remind users of upcoming events
2. **Event Comments**: Allow attendee feedback and questions
3. **QR Code Check-in**: Quick event check-in for organizers
4. **Calendar Integration**: Sync events with device calendars
5. **Advanced Search**: Search events by keywords and filters
6. **Event Images**: Upload and display custom event images
7. **Analytics Dashboard**: Detailed event and user analytics
8. **Multi-language Support**: Support for Filipino/English

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

