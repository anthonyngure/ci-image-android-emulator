#!/usr/bin/env bash
set -e
set -x

start-emulator.sh
git clone --depth 1 https://code.briarproject.org/briar/briar.git briar
cd briar
./gradlew -Djava.security.egd=file:/dev/urandom connectedAndroidTest -Pandroid.testInstrumentationRunnerArguments.package=org.briarproject.briar.android -Pandroid.testInstrumentationRunnerArguments.notAnnotation=androidx.test.filters.LargeTest
