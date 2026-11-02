# LUNARA Flutter Frontend

Desktop-first Flutter + Material 3 frontend. The 3D view is deliberately implemented with Flutter Canvas painting instead of a fragile external 3D engine, matching the 36-hour prototype constraint.

## Run

```bash
flutter pub get
flutter run -d chrome --web-port 8080
```

Backend default: `http://localhost:8000`.

For an Android/emulator/device, update `ApiService.baseUrl` to the machine address reachable by that device.
