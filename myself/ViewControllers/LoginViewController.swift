//
//  LoginViewController.swift
//  myself
//
//  Created by Kemal Taskin on 25.11.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var lblContinueWithoutAccount: UILabel!
    @IBOutlet weak var lblAppName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = "746874009854-n4hu1lq2d28gf3dhs0v8mbbtie5n4ha2.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")

        
        lblAppName.layer.cornerRadius = 6
        lblAppName.layer.borderWidth = 2
        lblAppName.layer.borderColor = lblAppName.backgroundColor?.cgColor
        lblAppName.tintColor = UIColor.init(displayP3Red: 1, green: 0, blue: 0, alpha: 1)
        
        lblContinueWithoutAccount.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTap))
        lblContinueWithoutAccount.addGestureRecognizer(gestureRecognizer)
        
        // Handle clicks on the button
        btnFacebook.addTarget(self, action: #selector(self.btnFacebookClicked), for: .touchUpInside)
        btnGoogle.addTarget(self, action: #selector(self.btnGoogleClicked), for: .touchUpInside)

        if let accessToken = DataStore.GetFacebookToken() {
            // User is logged in, use 'accessToken' here.
            self.GetFacebookUser(facebookToken: accessToken)
        }
        
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
            self.GetFacebookUser(facebookToken: accessToken.authenticationToken)
        }
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            
            if (signIn.currentUser != nil) {
                
                //let userId = signIn.currentUser.userID                  // For client-side use only!
                let idToken = signIn.currentUser.authentication.idToken // Safe to send to the server
                //let fullName = signIn.currentUser.profile.name
                let givenName = signIn.currentUser.profile.givenName
                let familyName = signIn.currentUser.profile.familyName
                let email = signIn.currentUser.profile.email
                let pictureUrl = signIn.currentUser.profile.imageURL(withDimension: 200)?.absoluteString
                
                let tokenRequest = TokenRequest(Email: email!, FirstName: givenName!, LastName: familyName!, PictureUrl: pictureUrl!,
                                                FacebookToken: "", GoogleToken: idToken!, DeviceID: "")
                
                self.SetUser(email: email!, firstName: givenName!, lastName: familyName!, pictureUrl: pictureUrl!)
                
                HttpRequest.send(url: "token/Google",
                                 method: "POST",
                                 data: tokenRequest,
                                 cbSuccess: self.CallbackSuccess,
                                 cbError: self.CallbackError);
            }
            
        } else {
            print("\(String(describing: error))")
        }
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                     withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            //let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            //let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let pictureUrl = user.profile.imageURL(withDimension: 200)?.absoluteString
            
            DataStore.SetGoogleToken(accessToken: idToken!)
            
            let tokenRequest = TokenRequest(Email: email!, FirstName: givenName!, LastName: familyName!, PictureUrl: pictureUrl!,
                                            FacebookToken: "", GoogleToken: idToken!, DeviceID: "")
            
            self.SetUser(email: email!, firstName: givenName!, lastName: familyName!, pictureUrl: pictureUrl!)
            
            HttpRequest.send(url: "token/Google",
                             method: "POST",
                             data: tokenRequest,
                             cbSuccess: self.CallbackSuccess,
                             cbError: self.CallbackError);
            
        } else {
            print("\(String(describing: error))")
        }
    }
    
    @objc func btnGoogleClicked() {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func btnFacebookClicked() {

        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ReadPermission.publicProfile, ReadPermission.email, ReadPermission.userBirthday], viewController : self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login")
            case .success( _, _, let accessToken):
                print("Logged in")
                DataStore.SetFacebookToken(accessToken: accessToken.authenticationToken)
                self.GetFacebookUser(facebookToken: accessToken.authenticationToken)
            }
        }
    }
    
    func GetFacebookUser(facebookToken: String) {
        
        let accessToken = AccessToken(authenticationToken: facebookToken)
        let request = GraphRequest.init(graphPath: "me", parameters: ["fields":"first_name,last_name,email, picture.type(large)"], accessToken: accessToken, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
        
        request.start({ (response, requestResult) in
            switch requestResult{
            case .success(let response):
                let email = response.dictionaryValue!["email"] as! String
                let firstName = response.dictionaryValue!["first_name"] as! String
                let lastName = response.dictionaryValue!["last_name"] as! String
                let pictureUrl = ((response.dictionaryValue!["picture"] as! [String: Any])["data"] as! [String: Any])["url"] as! String
                
                let tokenRequest = TokenRequest(Email: email, FirstName: firstName, LastName: lastName, PictureUrl: pictureUrl,
                                                FacebookToken: facebookToken, GoogleToken: "", DeviceID: "")
                
                self.SetUser(email: email, firstName: firstName, lastName: lastName, pictureUrl: pictureUrl)
                
                HttpRequest.send(url: "token/Facebook",
                                 method: "POST",
                                 data: tokenRequest,
                                 cbSuccess: self.CallbackSuccess,
                                 cbError: self.CallbackError);
                
            case .failed(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        
        DataStore.SetAccessToken(accessToken: "")
        self.performSegue(withIdentifier: "sgLogin", sender: self)
    }
    
    func SetUser(email: String, firstName: String, lastName: String, pictureUrl: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user = User(Email: email, FirstName: firstName, LastName: lastName, PictureUrl: pictureUrl)
    }
    
    func CallbackError(statusCode:Int, message: String)
    {
    }
    
    func CallbackSuccess(token: AuthToken)
    {
        DispatchQueue.main.async(execute:
        {
                DataStore.SetAccessToken(accessToken: token.Token!)
                self.performSegue(withIdentifier: "sgLogin", sender: self)
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
