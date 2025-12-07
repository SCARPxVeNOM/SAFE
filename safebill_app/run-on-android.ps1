# Run SafeBill on OnePlus 6T (Android)
# Make sure Android SDK is installed first!

param(
    [string]$deviceId = "android"
)

$apiUrl = "http://192.168.0.5:8080/api"

Write-Host "🚀 Running SafeBill on Android Device..." -ForegroundColor Cyan
Write-Host ""
Write-Host "📡 Backend API: $apiUrl" -ForegroundColor Yellow
Write-Host ""

# Check for devices
Write-Host "🔍 Checking for connected devices..." -ForegroundColor Cyan
flutter devices

Write-Host ""
Write-Host "📱 Starting app on Android device..." -ForegroundColor Cyan
Write-Host ""

# Run the app
flutter run `
    --dart-define=API_BASE_URL=$apiUrl `
    --device-id=$deviceId

