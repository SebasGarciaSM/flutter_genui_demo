# flutter_genui_demo

Flutter demo that integrates GenUI and Firebase (AI) to showcase examples
of using generated models and UI components. This repository contains a
small sample application intended for experimenting with the
integration of `genui`, `genui_firebase_ai`, and related packages.

Main contents
- `lib/main.dart` — Application entry point.
- `lib/home_screen.dart` — Main screen / UI example.
- `lib/comments_screen.dart` — Example comments screen.
- `lib/firebase_options.dart` — Generated Firebase configuration.

Project context
This app is a demo/prototype for testing integration between:
- GenUI (UI and component generation).
- Firebase AI / inference capabilities (related packages).

The project contains platform configurations for Android and iOS and is
prepared to use the Firebase configuration files included in the project
(for example `android/app/google-services.json` and
`ios/Runner/GoogleService-Info.plist`).

Dependencies (extracted from `pubspec.yaml`)

Production dependencies:
- `flutter` (SDK)
- `firebase_ai: ^3.5.0`
- `firebase_core: ^4.2.1`
- `genui_firebase_ai: ^0.5.1`
- `genui: ^0.5.1`
- `json_schema_builder: ^0.1.3`
- `logging: ^1.3.0`

Dev dependencies:
- `flutter_test` (SDK)
- `flutter_lints: ^6.0.0`

SDK environment:
- `sdk: ^3.10.0-290.4.beta`

Quick start
1. Install dependencies:

```bash
flutter pub get
```

2. Run the app on an emulator or connected device:

```bash
flutter run
```

Notes and recommendations
- If you use Firebase features, make sure `google-services.json` and
  `GoogleService-Info.plist` are configured correctly.
- `lib/firebase_options.dart` is often generated with the `flutterfire`
  tooling; if you remove it, regenerate it before running the app.
- This repository is a demo — adjust package versions for your project's
  needs and SDK compatibility.

What next?
- I can add deployment instructions, API usage examples, or screen
  documentation. Tell me which you prefer.
