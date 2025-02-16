# DigiPal - Your Friend in the Digital World 🫱🏻‍🫲🏻

📱 **Digital Literacy App - SW-02**

## 📌 Problem Statement
In a digital-first world, underserved communities, older populations, and rural areas struggle with digital literacy, limiting access to education, employment, healthcare, and social inclusion. Our app bridges this gap by providing an **interactive, step-by-step learning experience** in regional languages. It ensures accessibility for users with minimal digital knowledge through voice guidance, simple navigation, and interactive practice modules.

---

## 🎯 Features
✅ **Learn Digital Basics** – Navigate smartphones, use emails, and fill online forms effortlessly with real-world examples.  
✅ **Practice Levels** – Choose from **Easy, Medium, and Hard** levels to enhance digital skills at your own pace.  
✅ **Step-by-Step Guidance** – Paste a form link and receive a detailed, guided walkthrough with simulated practice.  
✅ **Voice Assistance** – Integrated voice guidance ensures accessibility for non-readers and visually impaired users.  
✅ **Feedback & Collaboration** – Users can share experiences, and companies can collaborate to drive digital inclusion.  
✅ **Multilingual Support** – The app offers regional language options to cater to diverse users.

---

## 🖥️ Screenshots
🖼️ _[Add app screenshots here]_

---

## 🎨 Figma Prototype
🔗 _[[DigiPal Figma File](https://www.figma.com/design/seG5njl0PI11THUhGabYzj/digipal?node-id=0-1&t=CBeiTjwPawYKx8c9-1)]_

## 📽️ Presentation File
🔗 _[https://docs.google.com/presentation/d/11QIHzXpT1NMfA8OJEVEh-4nymqWGnjQLqU_cU6QvYCM/edit?usp=sharing]_

## 📱 APK Download
🔗 _[https://drive.google.com/file/d/1uCSCVVuPlAvxq2CAyM1t-evnvNhZ-gQF/view?usp=sharing]_

---

## 🛠️ Tech Stack
### **Frontend**
- Flutter (Dart)
- Firebase Authentication & Firestore (for real-time data sync)
- Voice Assistance with **flutter_tts**
- Speech Recognition with **speech_to_text**

### **Backend**
- Firebase Realtime DB (NoSQL real-time database)
- Firebase Authentication (for user management)

---

## 🔌 Flutter Plugins Used
- **firebase_core** – Core Firebase SDK integration
- **firebase_auth** – Secure authentication and user management
- **cloud_firestore** – NoSQL real-time database
- **flutter_tts** – Text-to-speech for voice assistance
- **speech_to_text** – Speech recognition for interactive learning
- **file_picker** – For uploading user documents
- **url_launcher** – To open web pages and external apps
- **video_player** – For playing tutorial videos
- **webview_flutter** – To embed interactive web-based lessons
- **geolocator** – To fetch user location (optional)

---

## 🖥️ **Frontend Overview**
### **UI Screens**
✅ **Welcome Page** – Introduction to DigiPal & language selection  
✅ **Dashboard** – Learning modules, practice exercises & progress tracking  
✅ **Step-by-Step Guide** – Users can input forms, and DigiPal guides them through filling them out  
✅ **Voice Assistant Integration** – Reads instructions aloud for accessibility  

---

## ⚙️ **Backend Overview**
### **API Endpoints (Firebase Functions)**
1️⃣ **User Authentication API**
- Endpoint: `/authenticate`
- Request Body: `{ "email": "tejas@example.com", "password": "Tejas@123" }`
- Functionality: Handles user registration & login

2️⃣ **Lesson Retrieval API**
- Endpoint: `/get-lessons`
- Request Body: `{ "language": "Marathi" }`
- Functionality: Fetches lessons based on the selected language

3️⃣ **Feedback Submission API**
- Endpoint: `/submit-feedback`
- Request Body: `{ "user_id": "12345", "feedback": "Loved the app!" }`
- Functionality: Stores feedback to improve learning modules

---

## 📂 **Firebase Database Structure**
```
users/
   userID1/
      - name: "Anisha Shankar"
      - email: "anisha@example.com"
      - progress: { "Easy Level": "10", "Medium Level": "8" }

---

## 🚀 **Deployment Guide**
### 1️⃣ **Frontend (Flutter App Deployment)**
#### **For Android:**
```sh
flutter build apk
flutter install
```


### 2️⃣ **Backend (Firebase Setup)**
#### **Step 1: Initialize Firebase**
```sh
firebase login
firebase init
```
#### **Step 2: Deploy Firebase Functions**
```sh
firebase deploy --only functions
```

---

## 👥 **Contributors**
**Made by:**
- _[[Tejas Gadge](https://github.com/tejasgadge2504)]_
- _[[Anisha Shankar](https://github.com/hahaanisha)]_
- _[[Ganesh Shelar](https://github.com/ganeshelar0010)]_

---

## 📬 **Feedback & Support**
💌 Have suggestions? Found a bug? Let us know! _[Provide contact details if needed]_

📢 **Join us in making digital literacy accessible to all!** 🚀
