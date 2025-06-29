# MoveInSync – Carpooling System

This repository implements a complete ride-sharing platform using **Flutter** and **Firebase**, consisting of:

- 🚗 **User App** – For passengers to book rides  
- 🚕 **Driver App** – For drivers to receive and manage ride requests  
- 🛠️ **Admin Panel** – For platform management, including blocking/unblocking users or drivers  



⚠️ **Important Note**:  
To run the application, you **must provide valid Google Maps and Directions API keys**, which are **not free** under Google's current pricing. These APIs are essential for live location tracking and path rendering.

---

## 🔑 Authentication

- Email and password authentication for both users and drivers
- Firebase Auth ensures secure and verified logins
- Admin-controlled access: blocked users/drivers cannot log into the app

---

## 📱 User App

- Signup with email and password
- Location permission prompt on first entry
- Book rides by entering destination
- Live ride status tracking
- Wait for driver acceptance and arrival

---

## 🚘 Driver App

- Registration includes email, password, and vehicle details
- Toggle **Online/Offline** status
- Receive and accept ride requests from users
- View highlighted path from driver to user using Google Maps
- Complete ride and process (currently hardcoded) payment
- View **trip history** and **total earnings**

---

## 🧑‍💼 Admin Panel

- Login-protected dashboard
- View and manage:
  - All users and drivers
  - Block/unblock any user/driver
- If blocked, users are denied access to the app

---

## 📊 Features Matching Evaluation Criteria

### ✅ 1. Authentication
- Robust Firebase-based authentication
- Admin-level access control

### ✅ 2. Time and Space Complexity
- Efficient Flutter Firebase integrations
- Lightweight queries and listeners to optimize resource use

### ✅ 3. System Failure Handling
- Basic exception handling via Firebase error codes
- Restricts access in failure scenarios (e.g., no auth token)

### ✅ 4. Object-Oriented Programming
- Built using Flutter (Dart), leveraging OOP principles:
  - Modular widgets
  - Stateful/stateful component architecture

### ✅ 5. Trade-offs Documented
- **Trade-off:** Payment integration is hardcoded for simplicity
- **Design Decision:** Realtime Firebase + Maps API chosen over custom backend for ease and speed

### ✅ 6. System Monitoring
- Firebase console enables real-time logs and analytics
- Admin has access to usage data indirectly

### ✅ 7. Error and Exception Handling
- In-app validations and Firebase auth error messaging
- Users notified on failed login, network issues, or blocked access

---

## 🗺️ Technologies Used

| Feature            | Tools & Libraries                               |
|--------------------|--------------------------------------------------|
| **Frontend**        | Flutter (Dart)                                  |
| **Backend**         | Firebase (Auth, Firestore, Realtime DB, Storage) |
| **Maps & Location** | `google_maps_flutter`, `geolocator`, `polyline_points` |
| **Permissions**     | `permission_handler`                            |
| **Auth**            | `firebase_auth`, `google_sign_in`               |
| **UI Enhancements** | `loading_animation_widget`, `shimmer`, `rounded_loading_button` |
| **Others**          | `connectivity_plus`, `restart_app`, `http`, `url_launcher` |

---

## 📈 Future Enhancements

- Stripe payment integration (to replace hardcoded logic)
- State management with Provider or Riverpod
- Intelligent ride matching (based on distance, route similarity, preferences)
- Live chat between user and driver
- Route match % and filters for better UX
- Admin analytics dashboard
- SOS button and contact masking for privacy

---

## 🚀 Running the Project

> **Note**: You **must** supply your own **Google Maps API Key** and **Directions API Key** in the appropriate `.env` or config files. Without these, maps and location-based features will not work.

---

## 📩 Contact

For feedback or queries, feel free to reach out:

📧 **Email**: lci2022017@iiitl.ac.in  
🔗 **Repo Link**: [MoveInSync-Asst](https://github.com/Sreekar456/MoveInSync-Asst)
