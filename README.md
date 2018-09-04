Direct Assemblée for iOS 
===============

Download on the [App Store](https://itunes.apple.com/fr/app/direct-assembl%C3%A9e/id1334882270?mt=8).

## Setup

### Building the code

> __This project requires Xcode 9.3.__

1. Install the latest [Xcode developer tools](https://developer.apple.com/xcode/downloads/) from Apple.
2. Install Cocoapods
    ```shell
    sudo gem install cocoapods
    ```
3. Clone the repository:
    ```shell
    git clone <URL>
    ```
4. Install the project dependencies:
    ```shell
    pod install
    ```
5. Open `direct-assemblee.xcworkspace` in Xcode.
6. This project uses Firebase for push notifications and analytics. See **Firebase** section below to configure project.
7. This project uses Fabric to report crashes in release mode. See **Fabric** section below to configure project.
8. Build the `direct-assemblee` scheme in Xcode.

###  Firebase

This project uses Firebase. You should register your own Firebase account and generate `GoogleService-Info.plist` files if you want to use push notifications and analytics. We use two Firebase projects : one for developments in progress and one for production.

So, the existing configuration use two `GoogleService-Info.plist` files : 
1) One for `DADEV` scheme, located in `Resources/Debug` folder, corresponding to development Firebase project.
2) One for `direct-assemblee` scheme, located in `Resources/Release` folder, corresponding to production Firebase project.

###  Fabric

This project uses Fabric to report crashes in release mode. You should register with Crashlytics and get your own API key and build secret if you want to build it with crashes reporting.
To set these informations, do the following :

1. Create two files named  `fabric.apikey` and  `fabric.buildsecret` in `config` folder and it to Xcode project.
2. In `fabric.apikey` put the API key provided by Fabric
3. In `fabric.buildsecret` put the build key provided by Fabric
4. You can now run the project with Crashlytics.

##  API

### Production

The `direct-assemblee` scheme use the production API, available if you want to test your application changes with the latest stable API version.

### Development

The `DADEV` scheme use the development API, which isn't available because the Direct Assemblée teams uses it as sandbox.  You can use mocks (see above), or you can setup our API on your computer (See README on API project : < URL PROJET API >).

If you run API on your computer, you have to specify its URL. Create a file named `api.url.dev` in `config` folder, add it to Xcode project and put the local API URL inside. Then, asddbuild and launch the `DADEV` scheme.

### Mocks

You don't have Internet access or you want easily test different responses types from API ? You can use the mock embedded in sources. Simply replace  <code>RealApi()</code> by <code>MockApi()</code> in `SingletonManager.swift` and build `DADEV` scheme. All mock files are located in `Resources/Mock` folder. 

##  Contribute

Pull request are more than welcome ! If you want to do it, use a feature branch and please make sure to use a descriptive title and description for your pull request. 

The project use unit tests (`direct-assembleeTests` scheme). You must update them depending on your changes in the code. All unit tests should be OK in your pull request.


## Used Resources

Some icons are licensed under CC BY-ND 3.0 and provided by  [icons8](http://icons8.com/).

## License

Direct Assemblée for IOS is under the GPLv3 and the MPLv2 license.

See  [LICENSE](https://github.com/direct-assemblee/DirectAssemblee-iOS/blob/master/LICENSE)  for more license info.

## Contact

For any question or if you need help, you can send contact us at contact@direct-assemblee.org.
