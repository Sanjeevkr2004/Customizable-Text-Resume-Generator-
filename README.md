# Customizable Text Resume Generator

A Flutter-based Android application that fetches a pre-generated resume from an API and allows users to dynamically customize its appearance (font size, font color, background color). No manual data entry or PDF generation—just plain, customizable text.

---

## 🚀 Features

1. **Home Screen**  
   - Fetches and displays resume details (name, phone, email, Twitter, address, summary, skills, projects) from the API endpoint:
     ```
     https://expressjs-api-resume-random.onrender.com/resume?name=<your-name>
     ```
   - No manual form input—data is fully pulled from the API.  
   - Displays resume as plain text.

2. **Dynamic Customization**  
   - **Font Size** adjustment via a `Slider` widget.  
   - **Font Color** selection via a `ColorPicker` dialog.  
   - **Background Color** selection via a `ColorPicker` dialog.  
   - Changes take effect immediately without refetching data.

3. **Error Handling & Logging**  
   - Graceful handling of API failures with user-friendly messages.  
   - Verbose logging using the `logging` package for easier debugging.

4. **Testing**  
   - Widget tests using `flutter_test` and `mockito` to verify:  
     - Successful data fetch and rendering.  
     - Slider and color picker interactions.  
     - Error scenarios (404s, empty data).

---

## 📦 Prerequisites

- Flutter SDK (>= 3.0.0)  
- Dart SDK (bundled with Flutter)  
- Android SDK or a connected Android device/emulator

---

## 🛠 Installation & Setup

1. **Clone the repository**  
   ```bash
   git clone https://github.com/your-username/customizable-text-resume.git
   cd customizable-text-resume
