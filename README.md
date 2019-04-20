# Skeleton Extension
The Skeleton Extension is a bare bones Adobe Experience Platform Mobile SDK V5 third party extension allowing you to write your own custom extension. The contained projects are not full examples of using a third party extension, but instead contain common boilerplate implementations which you may use to start your own custom extension. 

<hr>

## iOS - Getting Started

**Prerequisites**

- Xcode v10.x and iPhone Simulator running iOS 10+.

**How to run the project**

1. Download or clone the [acp-mobile-extension](https://github.com/Adobe-Marketing-Cloud/acp-mobile-extension)
2. Navigate to the `iOS/ACPSkeletonExtension` directory in terminal and run `pod install`
3. Open `ACPSkeletonExtension.xcworkspace`
4. The `ACPSkeletonExtension` project has two targets in it:
  - `ACPSkeletonExtension` - a target to produce a static library output
  - `TestApp` - a simple app used for testing the `ACPSkeletonExtension` extension with the Adobe Mobile SDK
5. If you want to run the test app, do the following:
  - (Optional) If your extension is already published in Launch, in `AppDelegate.m` for the `TestApp`, fill in the value of `LaunchEnvironmentId` with your environment ID
  - Select the `TestApp` scheme and press `Run`

## Android - Getting Started

**Prerequisites**

- Android Studio 3.+ with an Android emulator running Android 7.0+
- Gradle 4.10.1+

**How to run the project**

1. Download or clone the [acp-mobile-extension](https://github.com/Adobe-Marketing-Cloud/acp-mobile-extension)
2. Navigate to the `/Android/skeleton-extension-android` directory and open the `build.gradle` file as a project in Android Studio.
3. Sync the gradle project to download the required dependencies.
4. The `skeleton-extension-android` project has two modules in it:

- `skeletonextension` - produces an Android library
- `app` - a simple app used for testing the `SkeletonExtension` extension with the Adobe Mobile SDK

5. If you want to run the test app, do the following:

- (Optional) If your extension is already published in Launch, in `TestApplication.java`, fill in the value of `LAUNCH_ENVIRONMENT_ID` with your environment ID
- Select the `app` Run Configuration and press `Run`

## Extension Documentation

[View the SDK Documentation](https://aep-sdks.gitbook.io/docs/resources/building-mobile-extensions) for information on how to build your own extension.

## Next Steps

Beyond this client-side extension, take some time to explore the Launch UI extension to see how you can define Configuration keys, Data Elements, Events, Conditions and Actions that are all used in the Launch rules engine. 

[Here](https://github.com/Adobe-Marketing-Cloud/reactor-mobile-examples) you can find an example of how to write the Launch UI mobile extension associated with your client-side extension.

## Resources

There is a great deal of information available to learn more about the Adobe Experience Platform Mobile SDK and Launch. Below are some resources that may be helpful:

- [Adobe Mobile SDK documentation and extension developer guide](https://aep-sdks.gitbook.io/docs/)
- [Launch documentation](https://docs.adobelaunch.com/)
- [Launch extension developer docs](https://developer.adobelaunch.com/extensions/)
- [Launch developers slack channel](http://join.launchdevelopers.chat/)
- [Weather Extension sample application](https://github.com/Adobe-Marketing-Cloud/acp-sdks/tree/weather-example)

