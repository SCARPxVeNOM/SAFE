# Build and Install SafeBill APK on OnePlus 6T

Write-Host "📱 Building SafeBill APK for Android..." -ForegroundColor Cyan
Write-Host ""

$apiUrl = "http://192.168.0.5:8080/api"
Write-Host "📡 Backend API URL: $apiUrl" -ForegroundColor Yellow
Write-Host ""

# Build APK with API URL
Write-Host "🔨 Building APK..." -ForegroundColor Cyan
flutter build apk --release --dart-define=API_BASE_URL=$apiUrl

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ APK built successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📍 APK Location: build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📲 To install on your phone:" -ForegroundColor Cyan
    Write-Host "   1. Copy the APK to your phone" -ForegroundColor White
    Write-Host "   2. Enable 'Install from Unknown Sources' in Settings" -ForegroundColor White
    Write-Host "   3. Tap the APK file to install" -ForegroundColor White
    Write-Host ""
    Write-Host "💡 Or use ADB to install directly:" -ForegroundColor Yellow
    Write-Host "   adb install build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "❌ Build failed. Check the errors above." -ForegroundColor Red
}

