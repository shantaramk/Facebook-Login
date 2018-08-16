//
//  ViewController.swift
//  FacebookLogin
//
//  Created by Shantaram Kokate on 8/16/18.
//  Copyright © 2018 Shantaram Kokate. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin
class ViewController: UIViewController,FBSDKLoginButtonDelegate {

    var dict : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //creating button
        let loginButton = FBSDKLoginButton(type: .roundedRect)
        let parameters = ["public_profile","email"]
        loginButton.readPermissions = parameters
        loginButton.center = view.center
        loginButton.delegate = self
       // loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchDragInside)
        //adding it to view
        view.addSubview(loginButton)
        //if the user is already logged in
        if (FBSDKAccessToken.current()) != nil{
            getFBUserData()
        }
        
    }
    
    //when login button clicked
    @objc func loginButtonClicked() {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (loginResult, error) in
            if (error == nil) {
                let fbloginresult : FBSDKLoginManagerLoginResult = loginResult!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        loginManager.logOut()
                    }
                    
                }
                
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            //    let parameters = ["fields": "first_name, email, last_name, picture"]
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
    // MARK: - Facebook login delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (error == nil) {
            if (FBSDKAccessToken.current()) != nil{
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

