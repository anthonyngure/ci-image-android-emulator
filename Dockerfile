FROM briar/ci-image-android:latest

# the emulator can't find its own libraries from the SDK with LD_LIBRARY_PATH.
ENV LD_LIBRARY_PATH=$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib:$LD_LIBRARY_PATH
ENV PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

ENV AVD="system-images;android-29;default;x86_64"
ENV NAME_AVD="ci_test"

WORKDIR /opt/briar-ci

ADD install.sh ./
ADD test.sh ./

COPY start-emulator.sh /usr/bin/
COPY wait-for-emulator.sh /usr/bin/

RUN ./install.sh
