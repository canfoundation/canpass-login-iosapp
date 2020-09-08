# CANpass Login for the iOS app

This is a simple example iOS app written in [AppAuth](https://appauth.io/) and [Apollo GraphQL](https://www.apollographql.com/), and demonstrates how to 'Login with CANpass' for an iOS app.

## Setup & Open the Project

1. In the `LoginExample` folder, run the following command to install the dependencies.

```
pod install
```

2. Open the `LoginExample.xcworkspace` workspace.

```
open LoginExample.xcworkspace
```

This workspace is configured to include AppAuth and Apollo via CocoaPods.

## Configuration

### Information You'll Need

* Authorization Endpoint
* Token Endpoint
* GraphQL Endpoint
* Client ID
* Redirect URI
* Scopes

### Configure the Example

#### In the file `AppDelegate.swift`

```swift
let kAuthorizationEndpoint  = "https://canpass.me/oauth2/authorize";
let kTokenEndpoint          = "https://canpass.me/oauth2/token";
let kGraphQLEndpoint        = "https://api.cryptobadge.app/graphql";
let kClientID               = "YOUR_CLIENT_ID";
let kRedirectURI            = "app.cryptobadge.oauth2:/oauth2redirect/sample-provider";
let kScopes                 = ["email"]
```

#### How to update the redirect URI

To allow your user to be re-directed back to LoginExample, you’ll needs to associate a custom URL scheme with your app. The schema is everything before the colon (`:`). In web pages, for example, the scheme is usually http or https. iOS apps can specify their own custom URL schemes. For example, if the redirect URI is `app.cryptobadge.oauth2:/oauth2redirect/sample-provider`, then the scheme would be `app.cryptobadge.oauth2`. 

##### In the file `Info.plist`

Go to the `LoginExample\Supporting Files` group in Xcode and find `Info.plist`. Right click on it and choose `Open As\Source Code`.

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>app.cryptobadge.oauth2</string>
        </array>
    </dict>
</array>
```


#### In the file `UserInfo.graphql`

```
query UserInfo{
  me {
    id
    name
    email
    path
    resourceUrl
  }
}
```


### GraphQL Usage

Once you create or update graphql files, the API.swift file will be subsequently updated. You can setup Apollo GraphQL by following this guide `https://www.apollographql.com/docs/ios/installation`


#### Update the `schema.json` file

Our GraphQL service is developing so maybe this schema will out-of-date, so it may be updated manual. (TODO)

`apollo-codegen` will search for GraphQL code in the Xcode project and generate the Swift types.

```sh
npm install -g apollo-codegen
apollo-codegen download-schema http://api.cryptobadge.app/graphql --output schema
```
