# Arogya AI - Flutter Project Mentor Guide

Welcome to your Flutter project! This guide will break down your app's structure, files, UI flow, and code in simple terms so you can confidently build new features and modify the UI without fear of breaking things.

---

## 1. Project Structure Explanation

When you look at your project folders, it might seem overwhelming. Here is what each main folder does:

*   **`lib/` (CRITICAL)**: This is where **100% of your Dart code and UI lives**. You will spend all your time here. If you want to change a screen, button, or logic, it is in `lib/`.
*   **`android/` & `ios/`**: These folders contain the native code for Android and iOS apps respectively. **DO NOT modify** these manually unless you are adding native permissions (like camera access) or specific native plugins.
*   **`web/`**: Contains files necessary to run your app on web browsers. Generally, you leave this alone.
*   **[build/](file:///c:/Arogya%20AI/lib/main.dart#15-109)**: This folder contains generated files when you compile/run your app. **DO NOT modify**. You can even delete it safely (it regenerates).
*   **`test/`**: If you write automated tests for your app, they go here.
*   **`.dart_tool/`**: A generated folder used by the Dart toolchain. **DO NOT modify**.

### Summary of what to touch:
*   **YES**: `lib/`, [pubspec.yaml](file:///c:/Arogya%20AI/pubspec.yaml)
*   **NO**: Everything else.

---

## 2. File-by-File Breakdown

Let's dive into the most important files inside your `lib/` directory and project root.

### [pubspec.yaml](file:///c:/Arogya%20AI/pubspec.yaml)
*   **What it does:** The control center for your project's settings and dependencies. 
*   **Why it exists:** It tells Flutter what packages to download (like `google_fonts`, `lucide_icons`), sets the app version, and defines assets (images, fonts).
*   **Safe to edit?** Yes, but **be careful with indentation**, as YAML is very strict. If you want to add a new library (e.g., a chart package), you add it here.

### [lib/main.dart](file:///c:/Arogya%20AI/lib/main.dart)
*   **What it does:** This is the starting point of your application. When the app launches, it immediately runs the [main()](file:///c:/Arogya%20AI/lib/main.dart#7-10) function here.
*   **Why it exists:** It sets up the `MaterialApp` (the core app wrapper), defines your global theme (colors, fonts, button styles), and tells the app which screen to show first (in your case, the `SplashScreen`).
*   **Safe to edit?** Yes. Edit this if you want to change the primary global colors, default font (using `GoogleFonts.interTextTheme`), or change the starting screen.

### [lib/theme/colors.dart](file:///c:/Arogya%20AI/lib/theme/colors.dart)
*   **What it does:** A centralized place defining all colors (`AppColors.primary`, `AppColors.background`, etc.).
*   **Why it exists:** So you don't have to write `#00A3FF` everywhere. If you want to change the app's brand color, you change it here once, and it updates everywhere!
*   **Safe to edit?** Yes! Changing values here is the safest way to re-theme your app.

### `lib/screens/`
This folder contains all your UI pages, organized by feature:
*   **`auth/`**: Contains `splash_screen.dart`, `login_screen.dart`, and `signup_screen.dart`.
*   **`home/`, `prescriptions/`, `profile/`, `stress/`**: Folders containing the specific screens for those tabs/features.
*   **`layout/`**: Likely contains structures like your main bottom navigation bar `AppLayout` that connects the home, prescriptions, stress, and profile screens.
*   **Safe to edit?** **Absolutely.** These are the files you will edit most often to change how the app looks.

---

## 3. UI Flow Understanding

Here is how your screens are connected (the "Navigation Flow"):

1.  **App Launch**: `main.dart` runs and loads `SplashScreen`.
2.  **Initial Loading**: `SplashScreen` shows your logo for a few seconds, then uses navigation (`Navigator.pushReplacement`) to move to the Auth flow or the Main App.
3.  **Authentication**: If logged out, the user goes to `LoginScreen`. From there, they can navigate to `SignupScreen`.
4.  **Main Application Layout**: After login, the user is sent to your main layout (likely in `screens/layout/`). This layout file contains a **BottomNavigationBar**.
5.  **Tab Navigation**: The BottomNavigationBar doesn't open new screens in a traditional way; instead, it swaps out the middle part of the screen between:
    *   Home Tab (`screens/home/`)
    *   Prescriptions Tab (`screens/prescriptions/`)
    *   Stress Analysis Tab (`screens/stress/`)
    *   Profile Tab (`screens/profile/`)

### How does navigation happen in code?
When you click a button, you usually see code like this:
```dart
Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
```
This implies: "Push a new screen on top of the current one." If the user presses the 'Back' button on their phone, it pops the top screen off and goes back to the previous one.

---

## 4. Code Explanation

Let's break down the most common components you will see in your `.dart` UI files.

Flutter builds UI using **Widgets**. Everything is a widget—a button, a text, a row, and even padding!

### `Scaffold`
Think of `Scaffold` as the blank canvas or skeleton of a single page. It provides slots for an `AppBar` (top bar), `body` (main content area), and `bottomNavigationBar`. Every single screen usually starts with a `Scaffold`.

### `Column` and `Row`
*   **`Column`**: Stacks widgets vertically (top to bottom). If you have a title, an image, and a button, you put them in a `Column`.
*   **`Row`**: Stacks widgets horizontally (left to right). If you want an icon next to some text, use a `Row`.

### UI Building Example
Here is a very basic structure of a screen:
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(               // The blank canvas
      appBar: AppBar(              // The Top Navigation Bar
        title: Text('My Page'),
      ),
      body: Column(                // Stacks things vertically
        children: [
          Text('Welcome!'),        // First item
          ElevatedButton(          // Second item
            onPressed: () { 
               // Do something when clicked
            },
            child: Text('Click Me'),
          ),
        ],
      ),
    );
  }
}
```

---

## 5. How to Modify the App

### A. How to change Text, Colors, or Buttons
1.  Open the file inside `lib/screens/` that corresponds to the page you want to change (e.g., `login_screen.dart`).
2.  Find the `Text('Login')` widget or the `ElevatedButton`.
3.  Change the text string inside the quotes.
4.  To change a specific color, find the `style` property and change `color: AppColors.primary` to something else (or update `AppColors.primary` in `colors.dart`).

### B. How to add a new screen
1.  Create a new file in `lib/screens/`, for example, `lib/screens/settings_screen.dart`.
2.  Type `stless` and press Tab to auto-generate a `StatelessWidget`. Name it `SettingsScreen`.
3.  Return a `Scaffold` in the `build` method.
4.  To go to this screen from an existing button, use:
    `Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));`

### C. How to add a new feature safely
1.  Always create a new file for a new feature to avoid making existing files too heavily crowded (which we call "spaghetti code").
2.  Build the UI first using dummy data.
3.  Once the UI looks good, connect the logic (buttons, APIs, navigation).

---

## 6. Best Practices & Common Mistakes

### Which files to edit?
*   **UI Tweaks**: Edit files in `lib/screens/`.
*   **Global Styling**: Edit `lib/theme/colors.dart` or `lib/main.dart` (ThemeData).
*   **Setup**: Edit `pubspec.yaml`.

### Common Mistakes Beginners Make:
1.  **Forgetting Commas**, `)` or `}`: Flutter code uses heavy nesting. ALWAYS put a comma `,` after the end of a widget before the closing bracket. This allows your IDE to auto-format the code cleanly when you save.
2.  **Editing Android/iOS folders**: Thinking they need to modify `android/app/src/main/AndroidManifest.xml` just to change an app color. Do not do this.
3.  **RenderFlex Overflow (The Yellow/Black Caution Tape)**: If you put too many things in a `Column` or `Row` and it exceeds the screen size, Flutter throws an error. Fix this by wrapping your `Column` in a `SingleChildScrollView` (which makes the page scrollable) or using `Expanded` inside a Row.
4.  **Capitalization**: Class names (like `MyScreen`) are PascalCase. Variables and filenames (like `my_screen.dart`) are snake_case.

You are fully equipped to start building! Remember, breaking things is part of the learning process. You can change text, move widgets around, hit save, and instantly see the results in your simulator.
