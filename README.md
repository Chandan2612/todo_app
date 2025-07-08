# 📋 To-Do App

The *To-Do App* is a simple and user-friendly productivity tool designed to help you manage your daily tasks. It features a clean interface with support for *light and dark mode, and securely uses **Firebase Authentication and Firestore* for real-time task management and data persistence. The app uses the *BLoC pattern* for efficient and scalable state management.

---

## ✨ Features

- ✅ Add, edit, and delete To-Do items  
- 🔄 All tasks are stored in *Firebase Firestore*, so your data is synced across sessions and devices  
- 🌗 Toggle between *Light Mode* and *Dark Mode*  
- 🔐 User Authentication using *Firebase*
- 🚀 Auto-login if the user is already signed in
- 🔁 Logout functionality which brings you back to the login screen

---

## 🔐 Authentication Flow

- When you *open the app*, it checks if you're already logged in:
  - ✅ If *yes, it directly takes you to the **main To-Do screen*
  - ❌ If *no, it shows the **Login/Registration page*
- You can choose to *sign out* any time, and it will redirect you back to the *Login page*

---

## ☁ Data Persistence

- Your tasks are securely stored in *Firebase Firestore*
- Even if you *close or restart the app*, your previously added or edited tasks will reappear when you reopen the app
- All changes are synced in real-time

---

## 🛠 Tech Stack

- *Flutter* (Frontend)
- *Firebase Authentication* (Login/Logout)
- *Firebase Firestore* (Task storage and sync)
- *BLoC Pattern* (State Management)
- *Light/Dark Theme Toggle*

---

## 📱 Screenshots (optional)

Add screenshots of your app UI here to showcase design and features.

---

## 🚧 Future Improvements

- ⏰ Add reminders and due dates  
- 📊 Task categories and filtering  
- 🔔 Push notifications for task reminders  
- 📁 Attachments or notes per task

---

## 🙌 Contribution

Feel free to fork the project and suggest improvements!

---

## 📧 Contact

If you have any questions or suggestions, feel free to reach out.

---