//
//  LoginViewController.swift
//  myself
//
//  Created by Kemal Taskin on 25.11.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var lblContinueWithoutAccount: UILabel!
    @IBOutlet weak var lblAppName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblAppName.layer.cornerRadius = 6
        lblAppName.layer.borderWidth = 2
        lblAppName.layer.borderColor = lblAppName.backgroundColor?.cgColor
        lblAppName.tintColor = UIColor.init(displayP3Red: 1, green: 0, blue: 0, alpha: 1)
        
        lblContinueWithoutAccount.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTap))
        lblContinueWithoutAccount.addGestureRecognizer(gestureRecognizer)
        
        // Handle clicks on the button
        btnFacebook.addTarget(self, action: #selector(self.btnFacebookClicked), for: .touchUpInside)

        /*
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
        }
 */
    }
    
    @objc func btnFacebookClicked() {
        /*
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .Failed(let error):
                print(error)
            case .Cancelled:
                print("User cancelled login.")
            case .Success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
            }
        }
 */
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        
        DataStore.SetAccessToken(accessToken: "kemal")
        self.performSegue(withIdentifier: "sgLogin", sender: self)
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
