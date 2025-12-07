# Run SafeBill App on OnePlus 6T
# Make sure your phone is connected via USB with USB debugging enabled

Write-Host "🚀 Preparing to run SafeBill on OnePlus 6T..." -ForegroundColor Cyan
Write-Host ""

# Set API base URL to your computer's IP address
$apiUrl = "http://192.168.0.5:8080/api"
Write-Host "📡 Backend API URL: $apiUrl" -ForegroundColor Yellow
Write-Host ""

# Check for devices
Write-Host "🔍 Checking for connected devices..." -ForegroundColor Cyan
flutter devices

Write-Host ""
Write-Host "📱 Attempting to run on Android device..." -ForegroundColor Cyan
Write-Host ""

# Run with API URL as environment variable
flutter run `
    --dart-define=API_BASE_URL=$apiUrl `
    --device-id=android

Write-Host ""
Write-Host "💡 If device is not found:" -ForegroundColor Yellow
Write-Host "   1. Enable USB Debugging on your phone" -ForegroundColor White
Write-Host "   2. Connect phone via USB" -ForegroundColor White
Write-Host "   3. Authorize the computer on your phone" -ForegroundColor White
Write-Host "   4. Make sure phone and computer are on the same WiFi network" -ForegroundColor White

