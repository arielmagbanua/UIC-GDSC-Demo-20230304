# UIC-GDSC-Demo-20230304
My Flutter and Firebase Demo Projects for UIC-GDSC Event


# Add Firebase to Your Flutter App

## Install the Required Command Line Tools

1. [Install Flutter SDK](https://medium.com/@arielmagbanua/how-to-install-flutter-sdk-for-windows-2208453e067b).

2. Setup Your Preferred IDE / Editor (`VSCode` / `Android Studio`).

3. Install [Node.js](https://nodejs.org/en/).

4. Install the Firebase CLI via `npm` by running the command `npm install -g firebase-tools`.

5. Log into Firebase using your Google account by running the following command:
    
    ```shell
    firebase login
    ```

6. Install the FlutterFire CLI by running the following command from any directory:
    
    ```shell
    dart pub global activate flutterfire_cli
    ```

## Configure your apps to use Firebase

    Configure Your Flutter App to Connect to Firebase using the following command:
    
    ```shell
    flutterfire configure
    ```
   
   FlutterFire CLI will create configuration files such as the [Firebase Options](todo/README.md#firebase-options) based on the platform your will support.

## Initialize Firebase in your Flutter App

1. From your Flutter project directory, run the following command to install the core plugin:
    
    ```shell
    flutter pub add firebase_core
    ```

2. From your Flutter project directory, run the following command to ensure that your Flutter app's Firebase configuration is up-to-date:
    ```shell
    flutterfire configure
    ```

3. In your `lib/main.dart` file, import the Firebase core plugin and the configuration file you generated earlier:
    ```dart
    import 'package:firebase_core/firebase_core.dart';
    import 'firebase_options.dart';
    ```

4. Also in your lib/main.dart file, initialize Firebase using the DefaultFirebaseOptions object exported by the configuration file:
    ```dart
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    ```

## Register SHA Certificate Fingerprint for Android

When your app uses firebase authentication, it is required that you will provide SHA certificate fingerprint for each Android app in the Firebase project
and later on it is also needed when you are ready to deploy your flutter project as android app.

You can generate the SHA certificate fingerpring using your debug keystore but later on you should generate as well using the production keystore.

```bash
keytool -list -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android -v
```
