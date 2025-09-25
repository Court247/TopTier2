# TopTier 🌟

![Version](https://img.shields.io/badge/version-1.0.18-pink?style=flat-square)
![Status](https://img.shields.io/badge/status-practice_project-blue?style=flat-square)
![Flutter](https://img.shields.io/badge/flutter-3.x-02569B?style=flat-square)
![License](https://img.shields.io/badge/access-restricted-red?style=flat-square)

> 🧪 Practice Flutter/Dart app exploring character tier info & gear references (Epic7x + Gachax sources). Not for production.

---

## 📚 Table of Contents
- 🌈 [Overview](#-overview)
- ✨ [Features](#-features)
- 🧰 [Tech Stack](#-tech-stack)
- ✅ [Prerequisites](#-prerequisites)
- 📦 [Installation](#-installation)
- 🔐 [Environment Setup](#-environment-setup)
- ▶️ [Run the App](#️-run-the-app)
- 🗂 [Project Structure](#-project-structure)
- 🛠 [Common Commands](#-common-commands)
- 🖼 [Screenshots](#-screenshots)
- 🗺 [Roadmap](#-roadmap)
- 🔒 [Access / Data Policy](#-access--data-policy)
- ⚖️ [License Notice](#️-license-notice)
- 📬 [Contact](#-contact)

---

## 🌈 Overview
TopTier lets users:
- View character tier info
- See suggested gear focus
- Mark favorites
- Explore basic metadata  
All data is manually curated for learning. No automated scraping.

---

## ✨ Features
- 🔎 Character browsing
- ⭐ Favorites (in-memory currently)
- 🧾 Tier + gear reference
- ☁️ Firestore-backed dataset (restricted)
- 🧩 Modular Flutter widgets

---

## 🧰 Tech Stack
- Flutter + Dart
- Provider (ChangeNotifier)
- Firebase Firestore
- Android emulator (primary target)

---

## ✅ Prerequisites
Run:
```bash
flutter doctor
```
Need installed:
- Git
- Flutter SDK
- Android SDK / Emulator
- Firestore access (granted manually)

---

## 📦 Installation
```bash
git clone https://github.com/Court247/TopTier2.git
cd TopTier2
flutter pub get
```

---

## 🔐 Environment Setup
Create `.env` (not committed):
```
FIREBASE_API_KEY=
FIREBASE_APP_ID=
FIREBASE_PROJECT_ID=
FIREBASE_MESSAGING_SENDER_ID=
FIREBASE_STORAGE_BUCKET=
```
Firestore credentials provided only on approval.

---

## ▶️ Run the App
```bash
flutter run
```
If issues:
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🗂 Project Structure
Only requested top-level + android + lib (current files):

```
TopTier2/
├── .gitignore
├── CHANGELOG.md
├── LICENSE.txt
├── README.md
├── pubspec.yaml
├── pubspec.lock
├── android/
│   ├── build.gradle
│   ├── settings.gradle
│   └── app/
│       └── build.gradle
└── lib/
    ├── CharacterRemove.dart
    ├── GameInfo.dart
    ├── GameParser.dart
    ├── Games.dart
    ├── Gaming.dart
    ├── Info.dart
    ├── WebClient.dart
    ├── addcollections.dart
    ├── characterprofile.dart
    ├── charactertierlistpage.dart
    ├── createaccount.dart
    ├── favorites.dart
    ├── favoritesprovider.dart
    ├── gamelistpage.dart
    ├── main.dart
    ├── settingspage.dart
    ├── signin.dart
    └── userpreferences.dart
```

---

## 🛠 Common Commands
```bash
flutter analyze
dart format lib
flutter test
flutter pub upgrade
```

---

## 🖼 Screenshots
| UI Samples |
|------------|
| ![1](https://github.com/user-attachments/assets/ede20d23-9ab4-4e87-ba4c-5d427e208f97) |
| ![2](https://github.com/user-attachments/assets/e013f100-07d6-4cfc-821b-a491e8e4330d) |
| ![3](https://github.com/user-attachments/assets/554f46fa-1ab7-41f4-b166-fe76fe1d6e67) |
| ![4](https://github.com/user-attachments/assets/ab88d610-0e06-4830-833e-062dee88f0b0) |
| ![5](https://github.com/user-attachments/assets/86427d46-4237-4c14-a3ef-0390dfa671bf) |
| ![6](https://github.com/user-attachments/assets/cadb107e-8a8e-422d-b7d3-d351fefae00e) |

---

## 🗺 Roadmap
- 💾 Persist favorites locally
- 🧮 Sorting & filtering
- 🌙 Theme switch
- ✅ Add tests + CI
- 📊 Expand data model

---

## 🔒 Access / Data Policy
- Firestore write access restricted
- No redistribution of curated data
- Educational use only

---

## ⚖️ License Notice
Not affiliated with any game sources. Permission required for modifications.

---

## 📬 Contact
Access / questions: courtney.woodsjobs@gmail.com  
Professional inquiries only.

---

