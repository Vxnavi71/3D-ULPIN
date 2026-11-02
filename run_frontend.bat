@echo off
cd /d %~dp0frontend
flutter pub get
flutter run -d chrome --web-port 8080
