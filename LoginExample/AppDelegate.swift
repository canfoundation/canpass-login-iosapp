//
//  AppDelegate.swift
//  LoginExample
//
//  Created by Tran Trung Tin on 5/29/19.
//  Copyright © 2019 Tran Trung Tin. All rights reserved.
//

import UIKit
import AppAuth
import Apollo

let kAuthorizationEndpoint  = "https://accounts.cryptobadge.app/oauth2/authorize";
let kTokenEndpoint          = "https://accounts.cryptobadge.app/oauth2/token";
let kGraphQLEndpoint        = "https://api.cryptobadge.app/graphql";
let kClientID               = "YOUR_CLIENT_ID";
let kRedirectURI            = "app.cryptobadge.oauth2:/oauth2redirect/sample-provider";
let kScopes                 = ["email"]
let kAppAuthStateKey        = "authState";

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var currentAuthorizationFlow: OIDExternalUserAgentSession?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
    if let authorizationFlow = self.currentAuthorizationFlow, authorizationFlow.resumeExternalUserAgentFlow(with: url) {
      self.currentAuthorizationFlow = nil
      return true
    }
    
    return false
  }

}

