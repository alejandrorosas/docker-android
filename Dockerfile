FROM openjdk:8

ENV ANDROID_COMPILE_SDK=30 \
    ANDROID_BUILD_TOOLS=30.0.3 \
    ANDROID_HOME=${PWD}/android-sdk \
    GRADLE_URL="https://services.gradle.org/distributions/gradle-6.8.1-all.zip"

RUN apt-get --quiet update --yes \
 && apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 git

RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip
RUN mkdir android-sdk && unzip android-sdk.zip -d android-sdk/cmdline-tools && rm android-sdk.zip

ENV PATH ${PATH}:${ANDROID_HOME}/cmdline-tools

RUN yes | $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --licenses
RUN yes | $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --update
RUN yes | $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager "platform-tools"
RUN yes | $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}"
RUN yes | $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}"

# Install Gradle
RUN wget $GRADLE_URL -O gradle.zip \
 && unzip gradle.zip \
 && mv gradle-6.8.1 gradle \
 && rm gradle.zip \
 && mkdir .gradle

ENV PATH ${PATH}:${PWD}/sdk/platform-tools:${PWD}/gradle/bin

# Run gradle to avoid Welcome message
RUN gradle --version
