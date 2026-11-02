#!/usr/bin/env bash
set -Eeuo pipefail

# Runs on container creation. The first time, generates the platform folders around the
# starter app (flutter create never overwrites existing files), then applies the Android
# defaults this template relies on. Later runs only fetch dependencies.

cd "$(dirname "$0")/.."

PROJECT_NAME='${templateOption:projectName}'
ORGANIZATION='${templateOption:organization}'

manifest=android/app/src/main/AndroidManifest.xml
app_gradle=android/app/build.gradle.kts

# Flutter only declares INTERNET in the debug/profile manifests: without this, HTTP calls
# work while developing and fail in release builds.
add_internet_permission() {
  if ! grep -q 'android.permission.INTERNET' "${manifest}"; then
    sed -i '0,/<manifest[^>]*>/s//&\n    <uses-permission android:name="android.permission.INTERNET" \/>/' "${manifest}"
  fi
}

# Release builds are signed with android/key.properties when it exists, with the debug key otherwise.
add_release_signing() {
  if grep -q 'key.properties' "${app_gradle}"; then
    return
  fi
  if ! grep -q 'signingConfig = signingConfigs.getByName("debug")' "${app_gradle}"; then
    echo "WARN: ${app_gradle} has an unexpected layout; add release signing by hand (see .claude/rules/release.md)."
    return
  fi
  perl -0pi -e '
    s/^android \{\n/val keystoreProperties = java.util.Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
/m;
    s/^    buildTypes \{\n/    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
/m;
    s/signingConfig = signingConfigs\.getByName\("debug"\)/signingConfig =
                if (keystorePropertiesFile.exists()) signingConfigs.getByName("release")
                else signingConfigs.getByName("debug")/;
  ' "${app_gradle}"
}

if [[ ! -f android/settings.gradle.kts ]]; then
  echo "==> Generating platform folders for ${ORGANIZATION}.${PROJECT_NAME}"
  flutter create \
    --org "${ORGANIZATION}" \
    --project-name "${PROJECT_NAME}" \
    --platforms android,ios,linux,web \
    --no-pub \
    .
  add_internet_permission
  add_release_signing
  dart format lib test integration_test > /dev/null
fi

flutter pub get
