# Facebook-Login
How to use facebook login interator 

1.

FacebookLoginInteractor.shared.clearSession()

2.

@IBAction func signInWithFacebookButtonClick(_ sender: Any) {
         pushToFacebookView()
 }
 
    
3. 

// MARK: - Facebook Login

extension LoginViewController: FacebookLoginDelegate {
    func didLogInWithUserInformation(facebookId: String, accessToken: String) {
        //call Facebook Login API
    }
    
    func pushToFacebookView() {
        let facebookLogin = FacebookLoginInteractor.shared
        facebookLogin.delegate = self
        facebookLogin.view = self
        facebookLogin.pushToFacebookView()
    }
}
