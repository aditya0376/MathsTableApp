# Maths Tables Practice App

A hybrid (Android & iOS) maths practice app built with **Flutter**. It includes general practice (addition, subtraction, multiplication, division, combined), dedicated multiplication table practice, and higher-order maths topics — all with a timer, scoring system, on-screen number pad, multiple themes, and persistent history.

## Tech Stack
- **Framework:** Flutter (single codebase for Android & iOS)
- **Language:** Dart
- **Storage:** SQLite (sqflite) for session history, SharedPreferences for settings
- **State:** Provider

## Project Structure
```
MathsTablesApp/
  lib/
    main.dart                 # App entry + theme/settings state
    screens/
      home_screen.dart        # Mode selection
      practice_screen.dart    # Practice + on-screen number pad + timer
      results_screen.dart     # Post-session results
      history_screen.dart     # Session history + statistics
      settings_screen.dart    # Theme & sound settings
      table_practice_screen.dart
      higher_math_screen.dart
    data/
      database.dart           # SQLite setup
      history_dao.dart        # History data access
    models/
      session.dart
    utils/
      problem_generator.dart
      scoring_engine.dart
    theme/
      app_theme.dart          # Material 3 themes
  test/
    maths_test.dart           # Unit tests
  codemagic.yaml              # Cloud build config
  .github/workflows/build.yml # GitHub Actions alternative
```

## Development Workflow (no local environment)
This project is designed to be coded with **OpenWork** (using a user-selected AI model) and built with a **cloud build service** — no IDE or local Flutter SDK installation required.

### 1. Code
Use OpenWork to write and manage the Dart code in this directory.

### 2. Build (cloud)
Push this project to a Git repository (e.g., GitHub), then use one of:

**Option A — Codemagic** (config included in `codemagic.yaml`):
- Connect your repo to [Codemagic](https://codemagic.io)
- It auto-builds the Android APK and iOS app

**Option B — GitHub Actions** (workflow included in `.github/workflows/build.yml`):
- Push to the `main` branch
- Go to the **Actions** tab → the build runs automatically
- Download the `android-apk` / `ios-build` artifacts

### 3. Test on mobile devices
- **Android:** download the `.apk` and install it directly on your phone (enable "Install unknown apps").
- **iOS:** the unsigned `.ipa` is for testing; for a device install you'll need a signing certificate (Apple Developer account) configured in the cloud build.

## Local testing (optional)
If you ever want to run locally, install the Flutter SDK and run:
```bash
flutter pub get
flutter test        # run unit tests
flutter run         # run on a connected device
```

## Scoring Rules
- Correct answer: **+10** points
- Streak bonus: **+2** per streak (max **+10**)
- Wrong answer: **-20** points (score never goes below 0)
- Rating: Excellent (>90%), Good (70-90%), Needs Practice (<70%)