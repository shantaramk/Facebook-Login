//
//  FacebookLoginInteractor.swift
//  HomeServices
//
//  Created by Shantaram Kokate on 11/3/18.
//  Copyright © 2018 Shantaram Kokate. All rights reserved.
//

import UIKit
import FBSDKLoginKit

protocol FacebookLoginDelegate: class {
    var facebookInfo: FacebookLoginModel? {get set}
    func didLogInWithUserInformation(facebookId: String, accessToken: String)
}

class FacebookLoginInteractor: NSObject {
    static let shared = FacebookLoginInteractor()
    let loginManager = FBSDKLoginManager()
    weak var delegate: FacebookLoginDelegate?
    var view: LoginViewController?

}

// MARK: - Facebook Login

extension FacebookLoginInteractor {
    
    func pushToFacebookView() {
        loginManager.loginBehavior = .web
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: view) { (loginResult, error) in
            if error == nil {
                let fbloginresult: FBSDKLoginManagerLoginResult = loginResult!
                if fbloginresult.grantedPermissions != nil {
                    if fbloginresult.grantedPermissions.contains("email") {
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    
    func getFBUserData() {
        showLoader()
        if FBSDKAccessToken.current() != nil {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (_, result, error) -> Void in
                                dismissLoader()
                                if error == nil {
                                    if let info = result as? [String: AnyObject] {
                                        let accessToken = FBSDKAccessToken.current().tokenString
                                        let facebookInfo: FacebookLoginModel = FacebookLoginModel().initWithInfo(info: info)
                                        self.delegate?.facebookInfo = facebookInfo
                                        self.delegate?.didLogInWithUserInformation(facebookId: facebookInfo.id, accessToken: accessToken!)
                                    }
                                }
                              })
        }
    }
    func clearSession() {
        loginManager.logOut()
        
    }
}

// MARK: - Facebook login delegate

extension FacebookLoginInteractor {

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error == nil {
            if FBSDKAccessToken.current() != nil {
                getFBUserData()
                FBSDKLoginManager().logOut()
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}
