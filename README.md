# 🤖 AI Topic Assistant (Flutter Chat App)

[![Flutter](https://img.shields.io/badge/Flutter-3.6.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.6.1-0553B1?style=for-the-badge&logo=flutter&logoColor=white)](https://riverpod.dev)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean--Architecture-green?style=for-the-badge)](https://blog.cleancoder.com)
[![Gemini AI](https://img.shields.io/badge/Google_Gemini-3_Flash-8E44AD?style=for-the-badge&logo=google&logoColor=white)](https://aistudio.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

**AI Topic Assistant** হলো **Clean Architecture**, **Riverpod (State Management)** এবং **Dependency Injection (DI)** অনুসরণে তৈরি একটি অত্যন্ত স্কেলেবল Flutter অ্যাপ। এটি **Google Gemini AI** (`gemini-3-flash-preview`) ব্যবহার করে যেকোনো বিষয়ের ওপর তথ্যবহুল উত্তর প্রদান করে।

---

## 📸 Screenshots (স্ক্রিনশট)

| 💬 Chat Screen | ⏳ Gemini Thinking |
| :---: | :---: |
| ![Chat Screen](screenshots/chat_screen.png) | ![Thinking State](screenshots/thinking_state.png) |

> 📌 *নোট: অ্যাপের স্ক্রিনশট দেখতে `screenshots/` ফোল্ডারে আপনার স্ক্রিনশট যুক্ত করুন (`chat_screen.png` এবং `thinking_state.png` নামে)।*

---

## 🏗️ Clean Architecture Structure (আর্কিটেকচার স্ট্রাকচার)

প্রজেক্টটি **Clean Architecture** নীতি এবং **Separation of Concerns** কঠোরভাবে মেনে ৩টি মূল লেয়ার ও Dependency Injection-এ বিভক্ত:

```text
lib/
├── core/
│   └── di/
│       └── injection_container.dart     # Riverpod Compile-safe Dependency Injection (DI)
│
├── data/                                # 1. DATA LAYER (ডেটা সোর্স ও মডেল)
│   ├── datasources/
│   │   └── chat_remote_data_source.dart # Gemini API integration via dartantic_ai
│   ├── models/
│   │   └── chat_message_model.dart      # Data Model & JSON mapping
│   └── repositories/
│       └── chat_repository_impl.dart    # Concrete Repository implementation
│
├── domain/                              # 2. DOMAIN LAYER (বিজনেস লজিক ও ইউজকেস)
│   ├── entities/
│   │   └── chat_message_entity.dart     # Pure Domain Entity
│   ├── repositories/
│   │   └── chat_repository.dart         # Abstract Repository Interface
│   └── usecases/
│       └── send_chat_message_usecase.dart # Single Responsibility UseCase
│
└── presentation/                        # 3. PRESENTATION LAYER (ইউআই ও স্টেট)
    ├── state/
    │   └── chat_state.dart              # Immutable UI State
    ├── viewmodel/
    │   └── chat_viewmodel.dart          # Riverpod StateNotifier (ViewModel)
    ├── views/
    │   └── chat_view.dart               # Main UI View (ConsumerStatefulWidget)
    └── widgets/
        ├── chat_bubble_widget.dart      # Chat Bubble Component
        └── chat_input_field.dart        # Input Field & Send Button Component
```

---

## ✨ Features (বৈশিষ্ট্যসমূহ)

- 🏛️ **Clean Architecture & SOLID Principles:** ডেটা, ডোমেইন এবং প্রেজেন্টেশন লেয়ার সম্পূর্ণরূপে আলাদা।
- 🔄 **Riverpod State Management:** `flutter_riverpod` দিয়ে রিয়েক্টিভ ও টাইপ-সেফ স্টেট পরিচালনা।
- 💉 **Dependency Injection (DI):** Riverpod Provider Containers দিয়ে স্কেলেবল ডিকাপল্ড ডিপেন্ডেন্সি ইনজেকশন।
- 🤖 **Google Gemini AI Integration:** `dartantic_ai` এর মাধ্যমে Gemini `gemini-3-flash-preview` পাওয়ার্ড।
- 🔐 **নিরাপদ API Key নিরাপত্তা:** `.env` ফাইলের মাধ্যমে সিকিউর API key ব্যবস্থাপনা।
- 🎨 **Material 3 Design System:** আধুনিক ও দৃষ্টিনন্দন রেসপন্সিভ ইউআই।

---

## 🚀 Setup & Installation Guide (ধাপে ধাপে সেটআপ নির্দেশিকা)

### 1️⃣ পূর্বশর্ত (Prerequisites)

- **Flutter SDK** (v3.6.0 বা তার পরবর্তী ভার্সন)
- **Dart SDK**
- **Google Gemini API Key** - [Google AI Studio](https://aistudio.google.com/) থেকে সংগ্রহ করুন।

### 2️⃣ ইনস্টলেশন কমান্ডসমূহ (Commands)

```bash
# ১. ডিপোজিটরি ক্লোন করুন
git clone https://github.com/your-username/chat_app.git
cd chat_app

# ২. ডিপেন্ডেন্সি ইনস্টল করুন
flutter pub get

# ৩. Environment ফাইল তৈরি করুন
cp .env.example .env
```

`.env` ফাইলে আপনার আসল Gemini API Key টি দিন:
```env
GEMINI_API_KEY=AIzaSyYourActualGeminiApiKeyHere
```

# ৪. অ্যাপ রান করুন
```bash
flutter run
```

---

## 📄 License

MIT License © 2026
