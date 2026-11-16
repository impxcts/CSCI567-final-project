# StudySpot 📚

**Find study groups that are actually happening on campus, right now.**

Ever wanted to study with other people in your class but had no idea if a group was meeting today, or showed up somewhere only to find nobody there? StudySpot fixes that. It's a Flutter app that shows you live study groups near you and lets organizers prove their group is really meeting.

Built by **Jesse Ortiz** for CSCI 567.

> 🚧 **Early draft.** Accounts and the basic app structure work. The study group features are next. See [Current draft](#current-draft) for exactly what's done.

---

## The idea

1. **Post a group.** Pick your class, choose a real spot on campus (a study room, a library floor, etc.), and set a time.
2. **Find a group.** Search by class or browse groups nearby, sorted by how far away they are.
3. **Ask to join.** Send a join request to the organizer.
4. **Check in.** When the session starts, the organizer snaps a photo from the meeting spot. The app checks that they're actually there, and the photo shows up on the post so others know the group is legit before heading over.

**Who it's for:** students who want to study with others but don't have an easy way to know whether an in-person group is real.

---

## Current draft

### ✅ What works right now

- **Sign up** with your name, email, and password. The form checks for a valid email, a password of at least 6 characters, and matching passwords.
- **Log in and log out.** The app remembers you between launches and switches between the login and home screens automatically.
- **Forgot password.** Sends a reset email through Firebase.
- **User profiles.** Signing up saves a profile to Firestore (`users` collection) with your name, email, and an empty class list for later.
- **Friendly error messages** for common problems like a wrong password, an email that's already used, or no internet.
- **Placeholder home feed.** Lists study groups from Firestore live. There's no way to create one in the app yet, but any group added through the Firebase console shows up right away.
- **Security rules.** Only signed-in users can read data, users can only edit their own profile, and only the organizer can change their group.
- **Unit tests** for the sign-up and login form checks.

### 🔜 Not built yet

- Creating a study group post (the "New group" button is a placeholder)
- Filtering the feed by your classes and sorting by distance
- Join requests
- Photo check-ins with location verification
- Camera and location permissions

### Progress

- [x] Flutter project set up and connected to Firebase
- [x] Sign-up and login with Firebase Authentication
- [x] User profiles saved to Firestore
- [x] Live feed that reads study groups (placeholder)
- [ ] Create a study group post
- [ ] Feed filtered by class and sorted by distance
- [ ] Join requests
- [ ] Photo check-ins with location verification

---

## Planned features

- **Live feed** – Everything comes from real user activity. New posts, join requests, and check-ins show up as they happen.
- **Personalized** – The feed is filtered to your classes and sorted by distance from you.
- **Photo check-ins** – Organizers take a photo with the device camera when the session starts. It's saved to that session for everyone to see.
- **Location verification** – A check-in only counts if the organizer is actually at the posted meeting spot, which cuts down on fake or inaccurate check-ins.

**Stretch goals, if time allows:**

- **Organizer history** – Show a host's past check-ins so people can build trust over time.
- **Notifications** – Opt-in alerts when a group for one of your classes starts nearby.

---

## Tech stack

| What | How | Status |
|------|-----|--------|
| App framework | Flutter (Dart) | ✅ In use |
| Accounts | Firebase Authentication (email/password) | ✅ In use |
| Database & live sync | Cloud Firestore | ✅ In use |
| Photos | Device camera + Firebase Storage | 🔜 Planned |
| Location | Device GPS | 🔜 Planned |

## Data model

**`users/{userId}`** (in use)

| Field | Type | Notes |
|-------|------|-------|
| `displayName` | string | Name from sign-up |
| `email` | string | |
| `classes` | list of strings | Empty for now; used later to filter the feed |
| `createdAt` | timestamp | Set by the server |

**`study_groups/{groupId}`** (model is ready; the create screen comes next)

| Field | Type | Notes |
|-------|------|-------|
| `classCode` | string | e.g. "CSCI 567" |
| `title` | string | e.g. "Midterm review" |
| `locationName` | string | e.g. "Library, 3rd floor" |
| `location` | GeoPoint | Coordinates for distance and check-in checks |
| `startTime` | timestamp | |
| `organizerId` / `organizerName` | string | Who posted it |
| `memberIds` | list of strings | People who joined |
| `status` | string | `scheduled`, `active` (checked in), or `ended` |
| `checkInPhotoUrl` | string | Added at check-in |

## Permissions

Once camera and location features are added, StudySpot will ask before using:

- **Camera** – for check-in photos
- **Location** – for sorting nearby groups and verifying check-ins

The current draft doesn't ask for either yet.

---

## Getting started

You'll need [Flutter](https://docs.flutter.dev/get-started/install), the [Firebase CLI](https://firebase.google.com/docs/cli), and a Firebase project.

1. **Clone this repo** and `cd` into it.
2. **Generate the Android/iOS folders** (this keeps the existing `lib/` code):
   ```bash
   flutter create . --project-name studyspot --platforms android,ios
   ```
3. **Set up Firebase.** In the [Firebase console](https://console.firebase.google.com/), create a project, then turn on:
   - **Authentication** → Sign-in method → **Email/Password**
   - **Firestore Database** → Create database
4. **Connect the app to Firebase** (creates `lib/firebase_options.dart`):
   ```bash
   dart pub global activate flutterfire_cli
   firebase login
   flutterfire configure
   ```
5. **Add the security rules.** Copy `firestore.rules` into Firestore → Rules and publish.
6. **Run it:**
   ```bash
   flutter pub get
   flutter run
   ```

**Run the tests:** `flutter test`

**Try the feed:** sign up in the app, then add a document to `study_groups` in the Firebase console with the fields above. It shows up on the home screen right away.

### Troubleshooting

- **Package version errors on `pub get`:** run `flutter pub add firebase_core firebase_auth cloud_firestore` to grab the latest compatible versions.
- **Android "minSdk" error:** set `minSdk = 23` in `android/app/build.gradle.kts`.
- **"Missing or insufficient permissions":** make sure you published `firestore.rules` and you're signed in.

## Project structure

```
lib/
├── main.dart                 # Starts Firebase and the app
├── auth_gate.dart            # Shows login or home depending on sign-in
├── models/
│   └── study_group.dart      # Study group post data model
├── screens/
│   ├── login_screen.dart     # Log in + forgot password
│   ├── sign_up_screen.dart   # Create an account
│   └── home_screen.dart      # Live feed of study groups (placeholder)
├── services/
│   └── auth_service.dart     # Firebase Auth + user profile setup
└── utils/
    └── validators.dart       # Form checks for email, password, name
test/
└── widget_test.dart          # Tests for the form checks
firestore.rules               # Firestore security rules
ai-usage/                     # AI prompts, responses, and how I used them
```

## References

- [Flutter docs](https://docs.flutter.dev/)
- [Add Firebase to a Flutter app](https://firebase.google.com/docs/flutter/setup)
- [Firebase Authentication for Flutter](https://firebase.google.com/docs/auth/flutter/start)
- [Cloud Firestore for Flutter](https://firebase.google.com/docs/firestore/quickstart)
- **Generative AI:** I used Claude Opus to help prototype features. Prompts, responses, and notes on how I used them are in [`ai-usage/`](ai-usage/).
