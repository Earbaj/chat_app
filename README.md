# 🤖 AI Topic Assistant (Flutter Chat App)

[![Flutter](https://img.shields.io/badge/Flutter-3.6.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Gemini AI](https://img.shields.io/badge/Google_Gemini-3_Flash-8E44AD?style=for-the-badge&logo=google&logoColor=white)](https://aistudio.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

**AI Topic Assistant** হলো একটি আধুনিক ফ্ল্যাটার (Flutter) অ্যাপ্লিকেশন যা **Google Gemini AI** (`gemini-3-flash-preview`) ব্যবহার করে যেকোনো টপিক বা বিষয়ের ওপর বিস্তারিত ও বুদ্ধিমান উত্তর প্রদান করে। 

---

## 📸 Screenshots (স্ক্রিনশট)

| 💬 Chat Screen | ⏳ Gemini Thinking |
| :---: | :---: |
| ![Chat Screen](screenshots/chat_screen.png) | ![Thinking State](screenshots/thinking_state.png) |

> 📌 *নোট: অ্যাপের স্ক্রিনশট দেখতে `screenshots/` ফোল্ডারে আপনার অ্যাপের স্ক্রিনশট যুক্ত করুন (`chat_screen.png` এবং `thinking_state.png` নামে)।*

---

## ✨ Features (বৈশিষ্ট্যসমূহ)

- 🤖 **Google Gemini AI পাওয়ার্ড:** `dartantic_ai` প্যাকেজের মাধ্যমে Gemini `gemini-3-flash-preview` মডেলের সাথে সংযুক্ত।
- 💬 **ইন্টারেক্টিভ চ্যাট ইউআই:** ইউজার এবং AI-এর জন্য পৃথক ও দৃষ্টিনন্দন মেসেজ বাব্‌ল।
- ⏳ **রিয়েল-টাইম লোডিং স্টেট:** AI উত্তর প্রস্তুত করার সময় সুন্দর লোডিং ইন্ডিকেটর (`Gemini Thinking...`) প্রদর্শিত হয়।
- 📜 **অটো-স্ক্রল সুবিধা:** নতুন মেসেজ আসলে চ্যাট লিস্ট স্বয়ংক্রিয়ভাবে নিচে স্ক্রল হয়ে যায়।
- 🔐 **নিরাপদ API Key সুরক্ষা:** `flutter_dotenv` ব্যবহার করে `.env` ফাইলে API Key সংরক্ষণ করা হয়, যা গিট (Git) ডিপোজিটরিতে এক্সপোজ হয় না।
- 🎨 **Material 3 ডিজাইন:** Deep Purple কালার স্কিমসহ আধুনিক ও মার্জিত ইউআই ডিজাইন।

---

## 🛠️ Tech Stack & Packages (টেকনোলজি স্ট্যাক)

- **Framework:** [Flutter](https://flutter.dev) (Dart SDK `^3.6.0`)
- **AI Integration:** [`dartantic_ai`](https://pub.dev/packages/dartantic_ai) (Google Gemini API Agent)
- **Environment Management:** [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv)
- **Design:** Material 3 UI Components

---

## 📁 Project Structure (প্রজেক্ট স্ট্রাকচার)

```text
chat_app/
├── android/                 # Android প্ল্যাটফর্ম স্পেসিফিক কোড
├── ios/                     # iOS প্ল্যাটফর্ম স্পেসিফিক কোড
├── lib/
│   └── main.dart            # মেইন অ্যাপ্লিকেশন কোড ও AI ইন্টিগ্রেশন
├── screenshots/             # অ্যাপের স্ক্রিনশট সংরক্ষণের ফোল্ডার
│   ├── chat_screen.png
│   └── thinking_state.png
├── .env.example             # এনভায়রনমেন্ট ভ্যারিয়েবলের টেমপ্লেট
├── .env                     # আপনার গোপন API Key (Git-এ ট্র্যাক হবে না)
├── .gitignore               # গিট ইগনোর কনফিগারেশন
├── pubspec.yaml             # প্রজেক্ট নির্ভরতা ও ডিপেন্ডেন্সি
└── README.md                # প্রজেক্টের ডকুমেন্টেশন
```

---

## 🚀 Setup & Installation Guide (ধাপে ধাপে সেটআপ এবং রান করার উপায়)

অ্যাপ্লিকেশনটি আপনার লোকাল মেশিনে সেটআপ ও রান করার জন্য নিচের ধাপগুলো অনুসরন করুন:

### 1️⃣ পূর্বশর্ত (Prerequisites)

শুরু করার আগে আপনার কম্পিউটারে নিচের টুলগুলো ইনস্টল করা থাকতে হবে:
- **Flutter SDK** (v3.6.0 বা তার পরবর্তী ভার্সন) - [ইনস্টল নির্দেশিকা](https://docs.flutter.dev/get-started/install)
- **Dart SDK**
- **Android Studio** অথবা **VS Code** (Flutter extension সহ)
- **Google Gemini API Key** - [Google AI Studio](https://aistudio.google.com/) থেকে বিনামূল্যে আপনার API Key সংগ্রহ করুন।

---

### 2️⃣ ক্লোন ডিপোজিটরি (Clone Repository)

প্রথমে ডিপোজিটরিটি ক্লোন করুন অথবা ডাউনলোড করুন:

```bash
git clone https://github.com/your-username/chat_app.git
cd chat_app
```

---

### 3️⃣ ডিপেন্ডেন্সি ইনস্টল (Install Dependencies)

প্রজেক্টের প্রয়োজনীয় প্যাকেজসমূহ ইনস্টল করতে নিচের কমান্ডটি রান করুন:

```bash
flutter pub get
```

---

### 4️⃣ API Key কনফিগারেশন (Configure API Key)

১. প্রজেক্টের রুট ডিরেক্টরিতে থাকা `.env.example` ফাইলটি কপি করে `.env` নামে একটি নতুন ফাইল তৈরি করুন:

```bash
cp .env.example .env
```

২. এবার `.env` ফাইলটি যেকোনো টেক্সট এডিটরে ওপেন করুন এবং আপনার আসল Gemini API Key বসান:

```env
GEMINI_API_KEY=AIzaSyYourActualGeminiApiKeyHere
```

> ⚠️ **গুরুত্বপূর্ণ:** `.env` ফাইলটি কখনো গিট-এ পুশ (push) করবেন না। এটি `.gitignore` ফাইলে যুক্ত করা আছে।

---

### 5️⃣ অ্যাপটি রান করুন (Run Application)

আপনার অ্যান্ড্রয়েড ইমুলেটর, আইওএস সিমুলেটর অথবা ফিজিক্যাল ডিভাইস কানেক্ট করুন এবং নিচের কমান্ডটি দিয়ে অ্যাপটি রান করুন:

```bash
flutter run
```

ওয়েব বা নির্দিষ্ট ডিভাইসে রান করতে:
```bash
# Chrome ব্রাউজারে রান করতে:
flutter run -d chrome

# নির্দিষ্ট ডিভাইসে রান করতে:
flutter run -d <device-id>
```

---

## 🧪 Testing (টেস্টিং)

প্রজেক্টের ইউনিট ও উইজেট টেস্ট রান করতে:

```bash
flutter test
```

---

## 💡 How it Works (কীভাবে কাজ করে)

1. `main()` ফাংশনে `dotenv.load(fileName: ".env")` এর মাধ্যমে এনভায়রনমেন্ট ফাইল লোড হয়।
2. ইউজার প্রম্পট (যেমন: "Flutter", "Space") টাইপ করে সেন্ড বাটনে চাপ দিলে `fetchAiResponse()` কল হয়।
3. `dartantic_ai` প্যাকেজের `GoogleProvider` ও `Agent` তৈরি করে Gemini `gemini-3-flash-preview` মডেলের কাছে রিকোয়েস্ট পাঠানো হয়।
4. AI-এর রেসপন্স রিসিভ করে চ্যাট স্ক্রিনে ডায়নামিকভাবে মেসেজ বাব্‌ল আপডেট করা হয়।

---

## 🤝 Contributing

যেকোনো বাগ রিপোর্ট, পরামর্শ বা ফিচার রিকোয়েস্টের জন্য Pull Request পাঠাতে পারেন অথবা Issue তৈরি করতে পারেন।

---

## 📄 License

এই প্রজেক্টটি MIT লাইসেন্সের অধীনে উন্মুক্ত। বিস্তারিত জানতে [LICENSE](LICENSE) ফাইল দেখুন।
