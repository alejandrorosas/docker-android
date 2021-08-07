FROM openjdk:11

ENV ANDROID_COMPILE_SDK=30 \
    ANDROID_BUILD_TOOLS=30.0.3 \
    ANDROID_HOME=${PWD}/android-sdk \
    ANDROID_NDK_HOME=${PWD}/android-ndk \
    ANDROID_NDK_VERSION=r22b \
    GRADLE_URL="https://services.gradle.org/distributions/gradle-7.1.1-bin.zip"

RUN apt-get --quiet update --yes \
 && apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 git

RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip
RUN mkdir android-sdk && unzip android-sdk.zip -d android-sdk && rm android-sdk.zip

ENV PATH ${PATH}:${ANDROID_HOME}/cmdline-tools

RUN yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME --licenses
RUN yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME --update
RUN yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "platform-tools"
RUN yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "build-tools;${ANDROID_BUILD_TOOLS}"
RUN yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "platforms;android-${ANDROID_COMPILE_SDK}"

# Install Gradle
RUN wget $GRADLE_URL -O gradle.zip \
 && unzip gradle.zip \
 && mv gradle-7.1.1 gradle \
 && rm gradle.zip \
 && mkdir .gradle

ENV PATH ${PATH}:${ANDROID_HOME}/platform-tools:${PWD}/gradle/bin

# Run gradle to avoid Welcome message
RUN gradle --version

# Install Android NDK
RUN apt-get --quiet update --yes && apt-get --quiet install --yes --no-install-recommends \
    build-essential

RUN mkdir ${ANDROID_NDK_HOME} \
 && wget --quiet --output-document=android-ndk.zip https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip \
 && unzip android-ndk.zip -d ${ANDROID_NDK_HOME} \
 && mv -f ${ANDROID_NDK_HOME}/*/* ${ANDROID_NDK_HOME}

ENV PATH ${PATH}:${ANDROID_NDK_HOME}
