//
//  ProfileViewController.swift
//  myself
//
//  Created by Kemal Taskin on 25.11.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import UIKit
import FacebookLogin
import GoogleSignIn

class ProfileViewController: UIViewController {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogout.addTarget(self, action: #selector(self.btnLogoutClicked), for: .touchUpInside)
        imgUser.layer.cornerRadius = imgUser.frame.width / 2
        imgUser.layer.masksToBounds = true
        
        lblUserName.layer.borderWidth = 1
        lblUserName.layer.borderColor = UIColor.lightGray.cgColor
        
        btnLogout.layer.borderWidth = 1
        btnLogout.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if (appDelegate.user != nil) {
            
            lblUserName.text = appDelegate.user!.GetFullName()
            let url = URL(string: appDelegate.user!.PictureUrl)
            let data = try? Data(contentsOf: url!)
            imgUser.image = UIImage(data: data!)
        }
        else {
            
            lblUserName.text = "Guest"
        }
    }
    
    @objc func btnLogoutClicked() {
        
        LoginManager().logOut()
        GIDSignIn.sharedInstance().signOut()
        DataStore.SetAccessToken(accessToken: "")
        DataStore.SetGoogleToken(accessToken: "")
        DataStore.SetFacebookToken(accessToken: "")
        
        self.performSegue(withIdentifier: "sgLogout", sender: self)
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

