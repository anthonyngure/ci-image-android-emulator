#!/usr/bin/env bash
set -e
set -x

emulator -version | head -n 1
emulator -accel-check

emulator -avd "$NAME_AVD" \
  -gpu swiftshader_indirect \
  -no-qt \
  -no-audio \
  -no-boot-anim \
  -no-snapshot \
  -no-snapstorage \
  -no-window \
  -wipe-data \
  -skip-adb-auth \
  -detect-image-hang \
  -restart-when-stalled \
  -verbose \
  -shell-serial file:kernel.log \
  -logcat-output logcat.txt \
  &
# the last & is important to bring the emulator to the background

wait-for-emulator.sh

# disable animations (might interfere with espresso tests)
adb shell settings put global window_animation_scale 0
adb shell settings put global transition_animation_scale 0
adb shell settings put global animator_duration_scale 0

# turn on the screen
adb shell input keyevent 82 && adb shell wm dismiss-keyguard
# set screen timeout to 30min to prevent the screen from turning off
adb shell settings put system screen_off_timeout 1800000

# sometimes a system dialog (e.g. launcher stopped) is showing and taking focus
adb shell am broadcast -a android.intent.action.CLOSE_SYSTEM_DIALOGS
