# Box't Out

An open source food delivery product and service that will be developed on the [FilledStacks YouTube channel](https://youtube.com/playlist?list=PLdTodMosi-BzqMe7fU9Bin3z14_hqNHRA). The repo will contain all the software required to run the open source Box't Out food delivery product. This is not a "product for a tutorial", this will be an actual product. It just so happens that I'll be making a tutorial and video for every part of it that is developed as well as make all the code available through this repository.

## Setup

The source code to run the product can be found in the `src/` folder. The code is split into two major sections, backend and clients. The backend folder contains firebase code required to run the backend. Clients are the front facing clients that will be connected to the backend.

## Update the project to latest release

The recent android supports the embedding V2. Now, we have to transform the original project to V2. Please follow the steps below.

### Updating Customer App

1. Open your desired terminal and go to boxtout/src/clients/customer`.
2. Run `flutter create .` command to update the entire project with the latest files import.
3. Go to `android/app/build.gradle` and changed **compileSdkVersion** and **targetSdkVersion** to 31.
4. Update the kotlin_version to latest 1.6.10.
5. Update the gradle version to latest 7.1.2. _Note: You need to open Android Studio to download the new gradle version data._
6. On **AndroidManifest.xml** file:
   - Changed `io.flutter.app.FlutterApplication` to `${applicationName}`.
   - Add `android:exported=true` in the activity
7. Run `flutter pub upgrade --major-versions` to download and upgrade the dependencies.
8. Run `flutter pub get`.

### Use Firebase Emulator Suite (Optional)

1. Install the [cli](https://firebase.flutter.dev/docs/cli/) and follow their guide.
