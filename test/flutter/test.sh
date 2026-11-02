#!/bin/bash
cd "$(dirname "$0")"

source test-utils.sh

check "flutter" flutter --version
check "dart" dart --version
check "java" java -version
check "adb" adb version
check "sdkmanager" sdkmanager --version
check "emulator" emulator -version
check "Android system image installed" bash -c 'ls -d "${ANDROID_HOME}"/system-images/android-*/google_apis/x86_64'
check "flutter doctor: Android toolchain" bash -c 'flutter doctor -v | grep -q "\[✓\] Android toolchain"'
check "platform folders generated" test -f ../android/settings.gradle.kts
check "release INTERNET permission" grep -q 'android.permission.INTERNET' ../android/app/src/main/AndroidManifest.xml
check "release signing configured" grep -q 'key.properties' ../android/app/build.gradle.kts
check "starter app checks" bash -c 'cd .. && ./scripts/agent-check.sh'
check "node" node --version
check "claude" claude --version
check "opencode" bash -c "command -v opencode"
check "CLAUDE_CONFIG_DIR is set" test -n "${CLAUDE_CONFIG_DIR}"
check "Claude config dir is writable" bash -c 'touch "${CLAUDE_CONFIG_DIR}/.write-test" && rm "${CLAUDE_CONFIG_DIR}/.write-test"'
check "shared Claude settings installed" test -f /etc/claude-code/managed-settings.d/ai-tools.json
check "agent harness copied" test -f ../AGENTS.md

reportResults
