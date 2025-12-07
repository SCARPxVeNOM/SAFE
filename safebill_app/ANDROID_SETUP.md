# Quick Android Setup for OnePlus 6T

## Option 1: Install Android SDK (Recommended - 10 minutes)

### Quick Install:
1. **Download Android Studio** (or just SDK tools):
   - Full: https://developer.android.com/studio
   - Command line tools: https://developer.android.com/studio#command-tools

2. **If installing Android Studio:**
   - Install and open it
   - Go to Settings → Appearance & Behavior → System Settings → Android SDK
   - Install Android SDK Platform-Tools
   - Note the SDK path (usually `C:\Users\YourName\AppData\Local\Android\Sdk`)

3. **Set Environment Variable:**
   ```powershell
   # In PowerShell (Run as Administrator):
   [System.Environment]::SetEnvironmentVariable("ANDROID_HOME", "C:\Users\YourName\AppData\Local\Android\Sdk", "User")
   [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:ANDROID_HOME\platform-tools", "User")
   ```

4. **Restart terminal and verify:**
   ```powershell
   adb devices
   ```

### Then Run App:
```powershell
cd C:\Users\aryan\Desktop\SAFE\safebill_app
flutter run --dart-define=API_BASE_URL=http://192.168.0.5:8080/api
```

---

## Option 2: Use Web Version (Quick - 2 minutes)

The app is running on web! Access it from your phone:

1. **Make sure backend is running:**
   ```powershell
   cd C:\Users\aryan\Desktop\SAFE
   npm run dev
   ```

2. **Access from phone browser:**
   - Open browser on OnePlus 6T
   - Go to: `http://192.168.0.5:3000`
   - The app should load!

3. **Note:** Web version works but native app is better for camera/OCR

---

## Option 3: Build APK After SDK Setup

Once Android SDK is installed:

```powershell
cd C:\Users\aryan\Desktop\SAFE\safebill_app
flutter build apk --release --dart-define=API_BASE_URL=http://192.168.0.5:8080/api
```

Then install APK on phone:
```powershell
adb install build\app\outputs\flutter-apk\app-release.apk
```

---

## Current Status

✅ Backend running: http://192.168.0.5:8080  
✅ All databases connected  
✅ App code ready  
⏳ Android SDK needed for native app

---

**Quickest path:** Install Android Studio → Set ANDROID_HOME → Run flutter run

