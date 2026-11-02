#!/usr/bin/env bash
set -Eeuo pipefail

# Start the Android emulator in a WSLg window, creating the AVD on first use.
# AVDs live in ~/.android, a named volume shared by every Flutter container.
# Run it in its own terminal, then `flutter run` picks the emulator up.

AVD_NAME="${AVD_NAME:-pixel_api36}"
AVD_IMAGE="${AVD_IMAGE:-system-images;android-36;google_apis;x86_64}"
AVD_DEVICE="${AVD_DEVICE:-pixel_7}"
# swiftshader_indirect renders on the CPU and always works; try EMULATOR_GPU=host for the WSL GPU.
EMULATOR_GPU="${EMULATOR_GPU:-swiftshader_indirect}"

if [[ ! -r /dev/kvm || ! -w /dev/kvm ]]; then
  cat >&2 <<'EOF'
/dev/kvm is not accessible: the emulator needs hardware acceleration.
In a WSL terminal (outside the container):
  sudo chmod 666 /dev/kvm
To make it permanent, add this udev rule and restart WSL (wsl --shutdown):
  echo 'KERNEL=="kvm", GROUP="kvm", MODE="0666"' | sudo tee /etc/udev/rules.d/99-kvm.rules
EOF
  exit 1
fi

if ! avdmanager list avd -c | grep -qx "${AVD_NAME}"; then
  echo "==> Creating AVD ${AVD_NAME} (${AVD_IMAGE}, ${AVD_DEVICE})"
  echo no | avdmanager create avd --name "${AVD_NAME}" --package "${AVD_IMAGE}" --device "${AVD_DEVICE}"
fi

exec emulator -avd "${AVD_NAME}" -gpu "${EMULATOR_GPU}" -no-boot-anim "$@"
