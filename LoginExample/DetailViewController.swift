//
//  DetailViewController.swift
//  LoginExample
//
//  Created by Tran Trung Tin on 5/30/19.
//  Copyright © 2019 Tran Trung Tin. All rights reserved.
//

import UIKit
import Apollo

class UserInfo : NSObject {
  var id: String?
  var name: String?
  var email: String?
  var path: String?
  var resourceUrl: String?
}

class DetailViewController: UIViewController {
  
  // MARK: - Properties
  var accessToken: String?
  lazy private var apollo: ApolloClient = {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(accessToken ?? "")"]
    let graphQLUrl = URL(string: kGraphQLEndpoint)!
    return ApolloClient(networkTransport: HTTPNetworkTransport(url: graphQLUrl, configuration: configuration))
  }()
  private var userInfoWatcher: GraphQLQueryWatcher<UserInfoQuery>?

  @IBOutlet weak var txtID: UITextField!
  @IBOutlet weak var txtName: UITextField!
  @IBOutlet weak var txtEmail: UITextField!
  @IBOutlet weak var txtPath: UITextField!
  @IBOutlet weak var txtResourceURL: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.updateUI()
    self.fetchData()
  }
  
}

extension DetailViewController {
  
  private func updateUI() {
    self.navigationItem.setHidesBackButton(true, animated: false)
    let logOutButton:UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DetailViewController.logOut))
    self.navigationItem.setRightBarButtonItems([logOutButton], animated: true)
  }
  
  private func fetchData() {
    userInfoWatcher = apollo.watch(query: UserInfoQuery(), queue: DispatchQueue.global(qos: .userInitiated)){ (result, error) in
      if let error = error {
        NSLog("Error while fetching query: \(error.localizedDescription)")
        self.handleError(error)
        return
      }
      
      guard let me = result?.data?.me else {
        NSLog("Could not get user info: \(result?.errors?.description ?? "")")
        self.handleError(result?.errors?.first)
        return
      }
      
      let userInfo = UserInfo()
      userInfo.id           = me.id
      userInfo.name         = me.name
      userInfo.email        = me.email
      userInfo.path         = me.path
      userInfo.resourceUrl  = me.resourceUrl
      NSLog("User info: \(userInfo)")
      self.performSelector(onMainThread: #selector(self.updateUserInfo), with: userInfo, waitUntilDone: false)
    }
  }
  
  @objc private func updateUserInfo(userInfo: UserInfo) {
    self.title          = userInfo.name
    txtID.text          = userInfo.id
    txtName.text        = userInfo.name
    txtEmail.text       = userInfo.email
    txtPath.text        = userInfo.path
    txtResourceURL.text = userInfo.resourceUrl
  }
  
  @objc private func logOut() {
    self.clearData()
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  private func clearData() {
    UserDefaults.standard.set(nil, forKey: kAppAuthStateKey)
    UserDefaults.standard.synchronize()
  }
  
  private func handleError(_ error: Error?) {
    NSLog("Error: \(error?.localizedDescription ?? "(empty)")")
    
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in self.logOut() }))
      self.present(alertController, animated: true, completion: nil)
    }
  }
}
