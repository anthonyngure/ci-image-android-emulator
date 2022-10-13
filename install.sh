#!/usr/bin/env bash
set -e
set -x

# update package sources
apt-get update
apt-get -y upgrade

# install Debian packages
# mesa-utils needs to be installed instead of libgl1, so that libgl1
# comes from stretch and not stretch-backports.
apt-get install -y --no-install-recommends \
  file \
  libpulse0 \
  pciutils \
  mesa-utils \
  libc6 \
  libdbus-1-3 \
  libfontconfig1 \
  libgcc1 \
  libnss3 \
  libpulse0 \
  libtinfo5 \
  libx11-6 \
  libxcb1 \
  libxcomposite1 \
  libxcursor1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  pulseaudio \
  socat \
  zlib1g

# clean up for smaller image size
apt-get -y autoremove --purge
apt-get clean
rm -rf /var/lib/apt/lists/*

# install emulator and system image
echo y | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "emulator"
echo y | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "$AVD"

# update all installed components
echo y | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --update
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --list

# create emulator
echo no | $ANDROID_HOME/cmdline-tools/latest/bin/avdmanager --verbose create avd --name "$NAME_AVD" --package "$AVD" --device "pixel"

# starting will fail on non-KVM host, but can show linking issues early
start-emulator.sh || true
