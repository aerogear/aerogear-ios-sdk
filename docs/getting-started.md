# End user documentation

## Prerequisites

To get started with the Mobile.Next()IOS SDK, you can set up the SDK in your existing or new project. SDK is written in Swift language. You can also run the example to see how the SDK works.

To use the AeroGear SDK for iOS, you will need the following installed on your development machine:

* iOS 9 or later
* Xcode 9 or later
* [CocoaPods](https://cocoapods.org/)

### CocoaPods

1. The AeroGear Mobile SDK for iOS is available through [CocoaPods](http://cocoapods.org)
If you have not installed CocoaPods, install CocoaPods by running the command:

        $ gem install cocoapods
        $ pod setup

1. In your project directory (the directory where your `*.xcodeproj` file is), create a plain text file named `Podfile` (without any file extension) and add the lines below. Replace `YourTarget` with your actual target name.

        source 'https://github.com/CocoaPods/Specs.git'
        
        platform :ios, '9.0'
        use_frameworks!
        
        target :'YourTarget' do
            pod 'AeroGearCore'
            pod 'AeroGearSync'
        end
        
1. Then run the following command:
    
        $ pod install

1. Open up `*.xcworkspace` with Xcode and start using the SDK.

    **Note**: Do **NOT** use `*.xcodeproj`. If you open up a project file instead of a workspace, dependencies will not be correctly configured.

## Getting Started with Swift

1. Import the AgsCore in the application .

        import AgsCore

1. In Swift file you want to use the SDK, import the appropriate library for the services you are using. The header file import convention is `import AgsServiceName`, as in the following examples:

        import AgsServiceName

        
1. Use imported service library

Please follow each individual service documentation for more information 
about usage.