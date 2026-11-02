#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/frontend"
flutter pub get
flutter run -d chrome --web-port 8080
