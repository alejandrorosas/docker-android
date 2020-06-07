FROM openjdk:8

ENV ANDROID_COMPILE_SDK=29 \
    ANDROID_BUILD_TOOLS=29.0.3 \
    ANDROID_HOME=${PWD}/android-sdk \
    GRADLE_URL="https://services.gradle.org/distributions/gradle-6.5-all.zip"

RUN apt-get --quiet update --yes \
 && apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 git

RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-6514223_latest.zip
RUN unzip android-sdk.zip -d android-sdk && rm android-sdk.zip

RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --update
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager "platform-tools"
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}"
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}"

# Install Gradle
RUN wget $GRADLE_URL -O gradle.zip \
 && unzip gradle.zip \
 && mv gradle-6.5 gradle \
 && rm gradle.zip \
 && mkdir .gradle

ENV PATH ${PATH}:${PWD}/sdk/platform-tools:${PWD}/gradle/bin

# Run gradle to avoid Welcome message
RUN gradle --version
