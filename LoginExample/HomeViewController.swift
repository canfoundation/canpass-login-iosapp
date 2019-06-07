//
//  HomeViewController.swift
//  LoginExample
//
//  Created by Tran Trung Tin on 5/30/19.
//  Copyright © 2019 Tran Trung Tin. All rights reserved.
//

import UIKit
import AppAuth

let kAuthenticationID = "authentication";

class HomeViewController: UIViewController {
  
  private var authState: OIDAuthState?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.verifyConfig()
    self.loadState()
    self.updateUI()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == kAuthenticationID {
      if let destinationVC = segue.destination as? DetailViewController {
        destinationVC.accessToken = authState?.lastTokenResponse?.accessToken
      }
    }
  }
}

//MARK: IBActions
extension HomeViewController {

  @IBAction func loginWithCryptobadge(_ sender: UIButton) {
    
    guard let authorizationEndpoint = URL(string: kAuthorizationEndpoint) else {
        NSLog("Error creating URL for : \(kAuthorizationEndpoint)")
        return
    }
    
    guard let tokenEndpoint = URL(string: kTokenEndpoint) else {
        NSLog("Error creating URL for : \(kTokenEndpoint)")
        return
    }
    
    let configuration = OIDServiceConfiguration.init(authorizationEndpoint: authorizationEndpoint, tokenEndpoint: tokenEndpoint)
    NSLog("Got configuration: \(configuration)")
    self.doAuthWithAutoCodeExchange(configuration, kClientID, kScopes)
  }
}

//MARK: AppAuth Methods
extension HomeViewController {
  
  private func verifyConfig() {
    assert(kClientID != "YOUR_CLIENT_ID",
           "Update kClientID with your own client ID.");
    
    assert(kRedirectURI != "app.cryptobadge.oauth2:/oauth2redirect/sample-provider",
           "Update kRedirectURI with your own redirect URI.");
    
    // verifies that the custom URI scheme has been updated in the Info.plist
    guard let urlTypes: [AnyObject] = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [AnyObject], urlTypes.count > 0 else {
      assertionFailure("No custom URI scheme has been configured for the project.")
      return
    }
    
    guard let items = urlTypes[0] as? [String: AnyObject],
      let urlSchemes = items["CFBundleURLSchemes"] as? [AnyObject], urlSchemes.count > 0 else {
        assertionFailure("No custom URI scheme has been configured for the project.")
        return
    }
    
    guard let urlScheme = urlSchemes[0] as? String else {
      assertionFailure("No custom URI scheme has been configured for the project.")
      return
    }
    
    assert(urlScheme != "app.cryptobadge.oauth2",
           "Configure the URI scheme in Info.plist (URL Types -> Item 0 -> URL Schemes -> Item 0) " +
            "with the scheme of your redirect URI.")
  }
  
  func doAuthWithAutoCodeExchange(_ configuration: OIDServiceConfiguration,_ clientID: String,_ scopes: [String]) {
    guard let redirectURI = URL(string: kRedirectURI) else {
      NSLog("Error creating URL for : \(kRedirectURI)")
      return
    }
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      NSLog("Error accessing AppDelegate")
      return
    }
    
    // builds authentication request
    let request = OIDAuthorizationRequest(configuration: configuration,
                                          clientId: clientID,
                                          clientSecret: nil,
                                          scopes: scopes,
                                          redirectURL: redirectURI,
                                          responseType: OIDResponseTypeCode,
                                          additionalParameters: nil)
    
    // performs authentication request
    NSLog("Initiating authorization request with scope: \(request.scope ?? "DEFAULT_SCOPE")")
    
    appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: self) { authState, error in
      
      if let authState = authState {
        self.setAuthState(authState)
        NSLog("Got authorization tokens. Access token: \(authState.lastTokenResponse?.accessToken ?? "DEFAULT_TOKEN")")
      } else {
        NSLog("Authorization error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
        self.setAuthState(nil)
      }
    }
  }
  
}

//MARK: OIDAuthState Delegate
extension HomeViewController: OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate {
  
  func didChange(_ state: OIDAuthState) {
    self.stateChanged()
  }
  
  func authState(_ state: OIDAuthState, didEncounterAuthorizationError error: Error) {
    NSLog("Received authorization error: \(error)")
  }
}

//MARK: Helper Methods
extension HomeViewController {
  
  func saveState() {
    
    var data: Data? = nil
    
    if let authState = self.authState {
      data = NSKeyedArchiver.archivedData(withRootObject: authState)
    }
    
    UserDefaults.standard.set(data, forKey: kAppAuthStateKey)
    UserDefaults.standard.synchronize()
  }
  
  func loadState() {
    guard let data = UserDefaults.standard.object(forKey: kAppAuthStateKey) as? Data else {
      return
    }
    
    if let authState = NSKeyedUnarchiver.unarchiveObject(with: data) as? OIDAuthState {
      self.setAuthState(authState)
    }
  }
  
  func setAuthState(_ authState: OIDAuthState?) {
    if (self.authState == authState) {
      return;
    }
    self.authState = authState;
    self.authState?.stateChangeDelegate = self;
    self.stateChanged()
  }
  
  func stateChanged() {
    self.saveState()
    self.updateUI()
  }
  
  func updateUI() {
    if self.authState?.lastTokenResponse != nil {
        self.performSegue(withIdentifier: kAuthenticationID, sender: nil)
    }
  }
}
