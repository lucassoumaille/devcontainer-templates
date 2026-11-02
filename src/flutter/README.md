
# Flutter (Android, iOS) (flutter)

Flutter with Android SDK (devices over adb, no emulator or KVM), Linux desktop (WSLg) and web targets, a starter app, Claude Code (shared login) and OpenCode.

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| projectName | Dart package name (lowercase_with_underscores), also the last part of the application ID: | string | my_app |
| organization | Reverse domain used for the Android application ID and iOS bundle ID (com.example is rejected by the stores): | string | com.example |
| flutterVersion | Flutter stable version: | string | 3.47.9 |

## Requirements (Windows + WSL2)

The container uses WSLg for the Linux desktop app window. `devcontainer.json` passes `/dev/dxg` and mounts `/tmp/.X11-unix`, `/mnt/wslg`, `/usr/lib/wsl`: the container does not start where they do not exist (macOS, CI).

The container does not need KVM: there is no Android emulator inside it. The app runs on an Android phone or on an emulator installed on Windows, both reached over adb (see below).

## First start

`scripts/bootstrap.sh` runs on container creation. The first time, it runs `flutter create` around the starter app to generate `android/`, `ios/`, `linux/` and `web/`, adds the `INTERNET` permission to the release manifest and release signing to `android/app/build.gradle.kts`. Commit the generated folders.

## Running the app

| Target | How | Use for |
|---|---|---|
| Android phone (Wi-Fi) | see below, then `flutter run -d <id>` | camera, biometrics, notifications, performance |
| Android emulator on Windows | see below, then `flutter run -d <id>` | full Android behavior, plugins |
| Linux desktop | `flutter run -d linux` | fast UI iteration (no Android plugins) |
| Web | `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080`, open http://localhost:8080 in Windows | UI preview in a browser |

VS Code: **Run and Debug** has `dev`, `dev (web-server :8080)` and `prod (profile)` configurations that pass `config/<env>.json`.

The debug keystore and adb keys are kept in the `flutter-android-home` volume, shared by every Flutter container.

### Physical Android phone

USB devices are not visible in the container. Use wireless debugging (Android 11+, phone and PC on the same network):

1. On the phone: **Developer options > Wireless debugging > Pair device with pairing code**.
2. In the container: `adb pair <ip>:<pairing-port>` and enter the code.
3. `adb connect <ip>:<port>` (the port shown on the Wireless debugging screen, not the pairing port), then `flutter devices`.

USB alternative: share the device with WSL using `usbipd-win` (`usbipd attach --wsl --busid <id>`), then add `"--device=/dev/bus/usb"` to `runArgs`.

### Android emulator on Windows

Install Android Studio on Windows (enable the **Windows Hypervisor Platform** Windows feature), create an AVD in Device Manager and start it. The emulator only listens on `127.0.0.1` (adb port `5555` for the first one), so relay it once in an administrator PowerShell:

```powershell
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=15555 connectaddress=127.0.0.1 connectport=5555
```

Allow inbound TCP `15555` in the Windows firewall from the WSL network only: adb on this port has no authentication. Then, in the container:

```bash
adb connect host.docker.internal:15555   # Docker Desktop; with Docker Engine in WSL, use the Windows host IP
flutter devices
```

The adb server runs in the container, so `flutter run`, hot reload and the debugger work. Do not point the container at the Windows adb server (`ADB_SERVER_SOCKET`): ports Flutter forwards would open on Windows and `flutter run` could not attach. Remove the relay with `netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=15555`.

Without the relay: `flutter build apk --debug` in the container, then `adb install build\app\outputs\flutter-apk\app-debug.apk` on Windows (no hot reload or debugger).

### iPhone

iOS builds need macOS and Xcode; nothing iOS runs in this container. The generated `.github/workflows/ci.yaml` compiles the iOS app without signing on a GitHub macOS runner. To run on an iPhone or publish to TestFlight you need a Mac (or a hosted macOS CI such as Codemagic) and an Apple Developer account.

## Tests

```bash
./scripts/agent-check.sh                          # format, analyze, unit and widget tests
INTEGRATION_DEVICE=linux ./scripts/agent-check.sh   # plus integration tests (or an Android id from `flutter devices`)
```

## Release builds

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols --dart-define-from-file=config/prod.json
```

Create the upload keystore once and keep it outside the repository, e.g. in the persistent `~/.android` volume (back it up):

```bash
mkdir -p ~/.android/keystores
keytool -genkey -v -keystore ~/.android/keystores/upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Then create `android/key.properties` (ignored by git):

```properties
storeFile=/home/vscode/.android/keystores/upload.jks
storePassword=...
keyAlias=upload
keyPassword=...
```

In CI, set the `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` and `ANDROID_STORE_PASSWORD` secrets.

## Caches

Gradle (`flutter-gradle-cache`) and pub (`flutter-pub-cache`) caches are named volumes shared by every Flutter container. Delete them with `docker volume rm` if a cache gets corrupted.

## Claude Code login

The `ai-tools` feature mounts the named volume `claude-code-config` and sets `CLAUDE_CONFIG_DIR`. Log in once with `claude`: every container built from these templates reuses the same login and user settings. Do not add another Claude mount or `CLAUDE_CONFIG_DIR` in `devcontainer.json`, it would override the shared one.

## Hardening

The container runs with `--cap-drop=ALL` and `no-new-privileges`: `sudo`, `apt-get` and `chown` do not work inside it. Add system packages in `.devcontainer/Dockerfile` instead.


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/lucassoumaille/devcontainer-templates/blob/main/src/flutter/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
