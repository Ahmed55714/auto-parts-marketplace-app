
# 🚗 Auto Parts Marketplace App

Introducing our innovative auto parts marketplace app, designed to streamline the procurement process for both clients and service providers. This app connects auto parts employees with an extensive network of suppliers, enabling them to efficiently request specific parts. Service providers can review these requests and submit competitive offers directly to the clients.

## 🌟 Overview

### Key Features:
- **Interactive Maps**: Clients can view all service providers' locations on a map, while providers can see where their potential customers are located. This geolocation feature enhances connectivity and responsiveness.
- **Dynamic Request Status**: Real-time updates on the status of each order – whether it's pending, shipped, or received – all managed by the service provider.
- **Secure Payment Gateway**: Facilitates transactions through the 'My Fatoorah' payment system, ensuring a secure and seamless process.
- **Comprehensive Admin Control Panel**: Admins have robust control, including oversight of requests, managing user accounts, addressing complaints, and monitoring financials.
- **Detailed Reviews and Profiles**: Clients can access reviews and profiles of service providers before finalizing transactions, building trust and ensuring quality service.
- **PDF Generation for Providers**: Service providers can generate PDFs detailing requests and transactions for easy record-keeping.
- **Order Returns**: The app supports a simple return process, enhancing customer satisfaction and accountability.

---

## 🎥 Video for product
https://github.com/user-attachments/assets/b356768b-f166-4099-8f9d-7ae17596213c




---

## 📂 Project Structure

Here’s the structure of the `lib` folder in this Flutter app:

```
lib/
├── constants/          # Constant values used across the app
├── generated/          # Generated files (e.g., localizations)
├── getx/               # GetX state management files
├── l10n/               # Localization support
├── screens/            # UI screens for various app functionalities
│   ├── client/         # Screens related to client functionality
│   ├── intro/          # Onboarding and introductory screens
│   ├── vendor/         # Vendor-specific screens and UI elements
├── widgets/            # Custom reusable widgets
├── main.dart           # Main entry point of the Flutter app
```

### Key Folder Descriptions:
- **constants/**: Stores all the constant values used across the application.
- **generated/**: Contains files generated by the localization tools.
- **getx/**: State management using GetX, handling the business logic and UI interaction.
- **l10n/**: Houses localization files to support multiple languages.
- **screens/**: Contains all the screens for different app functions, split into client-specific, vendor-specific, and onboarding.
- **widgets/**: Houses reusable widgets that can be utilized across various screens and components.
- **main.dart**: The main entry point of the app where the Flutter app initialization occurs.

---

## 🛠️ Technologies Used

- **Frontend**:
  - **Flutter**: Cross-platform mobile development framework.
  - **Dart**: Programming language for Flutter apps.
  - **GetX**: State management for managing the app state efficiently.

- **Backend**:
  - **PHP**: Server-side development for API logic.
  - **MySQL**: Relational database for data storage.

- **Geolocation**:
  - **Google Maps API**: Used to integrate maps and geolocation functionality.

- **Real-Time Communication**:
  - **Firebase OTP Authentication**: Secure authentication using Firebase for OTP verification.

---

## 🚀 Getting Started

### Prerequisites

To run this project locally, ensure you have the following installed:
- **Flutter**
- **Dart SDK**
- **PHP** (for the backend)
- **MySQL** (locally installed or a cloud-based MySQL service)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-repo/auto-parts-marketplace-app.git
   ```

2. **Install Flutter dependencies**:
   Navigate to the root of the Flutter app and install dependencies:
   ```bash
   cd auto-parts-marketplace-app
   flutter pub get
   ```

3. **Run the Flutter app**:
   Make sure you have a device or emulator running, and execute:
   ```bash
   flutter run
   ```

---

### Running Tests

Run Flutter unit and widget tests using the following command:
```bash
flutter test
```

---


Thank you for exploring our **Auto Parts Marketplace App**! We hope this app will streamline your procurement process and enhance your overall experience. For any questions or issues, feel free to reach out.

