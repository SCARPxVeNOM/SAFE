# Build SafeBill APK with Render backend URL
param(
    [Parameter(Mandatory=$true)]
    [string]$RenderUrl
)

Write-Host "🔨 Building SafeBill APK..." -ForegroundColor Cyan
Write-Host "Backend URL: $RenderUrl" -ForegroundColor Yellow
Write-Host ""

$apiUrl = "$RenderUrl/api"
Write-Host "API Base URL: $apiUrl" -ForegroundColor Green
Write-Host ""

cd safebill_app

Write-Host "📦 Installing dependencies..." -ForegroundColor Cyan
flutter pub get

Write-Host ""
Write-Host "🏗️  Building APK..." -ForegroundColor Cyan
flutter build apk --release --dart-define=API_BASE_URL=$apiUrl

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ APK built successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📍 APK Location:" -ForegroundColor Yellow
    Write-Host "   build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📱 To install on your phone:" -ForegroundColor Yellow
    Write-Host "   1. Copy the APK to your phone" -ForegroundColor White
    Write-Host "   2. Enable 'Install from Unknown Sources' in Settings" -ForegroundColor White
    Write-Host "   3. Tap the APK file to install" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "❌ Build failed. Check the errors above." -ForegroundColor Red
}

cd ..

