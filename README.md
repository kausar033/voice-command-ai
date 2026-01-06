# Voice Command AI 🎙️☕

A premium Flutter application that demonstrates a fully hands-free voice command interface. Designed for high-end user experiences, it allows users to place orders (like coffee) using natural voice interaction, powered by a sophisticated state machine.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)

## ✨ Features

- **Wake Word Detection**: Activated by "Hey Bad" using Picovoice Porcupine.
- **Natural Voice Ordering**: Uses Speech-to-Text (STT) for capturing complex commands.
- **Voice Feedback**: Uses Text-to-Speech (TTS) for order confirmation and status updates.
- **Interactive UI**: Features premium aesthetics with `AvatarGlow`, custom animations, and Google Fonts (`Inter`).
- **State Machine Architecture**: Handles transitions between `Idle`, `Listening`, and `Confirming` states seamlessly.
- **Local Notifications**: Provides visual feedback for placed orders.
- **Scalable Infrastructure**: Clean Architecture with dependency injection using `GetIt`.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Android Studio / VS Code
- [Picovoice AccessKey](https://console.picovoice.ai/) (Free Tier)

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/voice-command-ai.git
    cd voice-command-ai
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Configure AccessKey**:
    Open `lib/core/constants/app_constants.dart` and replace the `picovoiceAccessKey` with your own key from the Picovoice Console.

4.  **Run the app**:
    ```bash
    flutter run
    ```

## 🛠️ Project Structure

```text
lib/
├── core/
│   ├── constants/       # App-wide constants & API keys
│   └── services/        # Service layer (STT, TTS, WakeWord, Notifications)
├── models/              # Data models (OrderModel)
├── presentation/
│   ├── screens/         # UI Screen layers (Home, All Orders)
│   └── widgets/         # Reusable UI components
└── injection_container.dart # Dependency Injection setup
```

## 📱 Release Configuration (Android)

To ensure the wake word detection works in production (Release Mode), specialized configurations are included:

- **Proguard Rules**: Specific rules in `android/app/proguard-rules.pro` to prevent the Picovoice SDK from being stripped or obfuscated.
- **Resource Optimization**: Custom `aaptOptions` in `build.gradle.kts` to ensure `.ppn` files (wake word models) are not compressed.
- **Shrinking Settings**: `isShrinkResources` is disabled in release builds to protect native library dependencies.

> [!IMPORTANT]
> When building for release, ensure you run `flutter clean` before `flutter build apk --release` to apply the latest Proguard rules.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.
