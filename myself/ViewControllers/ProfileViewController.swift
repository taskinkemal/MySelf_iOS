//
//  ProfileViewController.swift
//  myself
//
//  Created by Kemal Taskin on 25.11.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnLogout.addTarget(self, action: #selector(self.btnLogoutClicked), for: .touchUpInside)
        
        HttpRequest.send(url: "tasks",
                         method: "GET",
                         data: nil,
                         cbSuccess: CallbackSuccess,
                         cbError: CallbackError);
    }
    
    @objc func btnLogoutClicked() {
        
        self.performSegue(withIdentifier: "sgLogout", sender: self)
    }
    
    func CallbackError(statusCode:Int, message: String)
    {
    }
    
    func CallbackSuccess(list:ListWrapper<Task>)
    {
        DispatchQueue.main.async(execute:
            {
                self.ListLoaded(list:list)
        })
    }
    
    func ListLoaded(list:ListWrapper<Task>)
    {
        //self.items.removeAll();
        //self.items += list;
        //self.tableView.reloadData();
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
