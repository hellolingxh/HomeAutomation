# flutterapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# This is a project for mobile app with flutter framework

# Install the flutter
- Follow the official website to set up.
	- https://flutter.dev/docs/get-started/install/linux
# Commands:
- flutter doctor: to validate the dependencies if it is complete.
- Run flutter doctor with VS Code, Ctrl+Shift+P to run "Flutter: Run Flutter Doctor"
```
	[flutter] flutter doctor -v
[✓] Flutter (Channel stable, v1.12.13+hotfix.5, on Linux, locale en_IE.UTF-8)
    • Flutter version 1.12.13+hotfix.5 at /usr/local/my/flutter
    • Framework revision 27321ebbad (4 days ago), 2019-12-10 18:15:01 -0800
    • Engine revision 2994f7e1e6
    • Dart version 2.7.0

[✓] Android toolchain - develop for Android devices (Android SDK version 28.0.3)
    • Android SDK at /home/gray/Android/Sdk
    • Android NDK location not configured (optional; useful for native profiling support)
    • Platform android-28, build-tools 28.0.3
    • Java binary at: /usr/local/my/android-studio/jre/bin/java
    • Java version OpenJDK Runtime Environment (build 1.8.0_152-release-1024-b01)
    • All Android licenses accepted.

[✓] Android Studio (version 3.1)
    • Android Studio at /usr/local/my/android-studio
    • Flutter plugin version 27.0.1
    • Dart plugin version 173.4700
    • Java version OpenJDK Runtime Environment (build 1.8.0_152-release-1024-b01)

[✓] IntelliJ IDEA Community Edition (version 2019.3)
    • IntelliJ at /usr/local/my/idea-IC-192.7142.36
    • Flutter plugin version 42.1.4
    • Dart plugin version 193.5731

[✓] VS Code (version 1.40.2)
    • VS Code at /usr/share/code
    • Flutter extension version 3.7.1

[!] Connected device
    ! No devices available

! Doctor found issues in 1 category.
```
- To create a new project with Command Platette, run "Flutter:New Project"
- To run the flutter app, execute the command "flutter run"
    - if you had the error with ADB version is too old need to install version 1.0.39 or later. run "~/Android/Sdk/tools/android update sdk -t platform-tool --no-ui


# Flutter: Custom Icon in Your Project
- 1. Go to http://fluttericon.com/ or http://fontello.com/
- 2. Click on the icons that you want, upload custom SVG files, font-files, or JSON files
- 3. Insert your own name like ‘Custom’, ‘Icecons’ etc.
- 4. Click ‘Download’ and extract files
- 5. The config.json is absolute genius, it saves all your selections and custom icons, so when you revisit the website just drag and drop it in and it’s all there again.
- 6. Move the ttf file into your desired directory (e.g. fonts/CustomIcons.ttf)
- 7. Move the dart file into your desired directory in lib (I did lib/presentation/custom_icons_icons.dart )
- 8. Follow the instructions at the top of your dart file and copy the fonts code into pubspec.yml (I put mine underneath flutter: uses-material-design)
- 9. flutter run to ensure project compiles and app starts expectedly


