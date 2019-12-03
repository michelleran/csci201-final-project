//
//  LoginViewController.swift
//  ServiceRequest
//
//  Created by Akhil Arun on 11/16/19.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        if let id = Auth.auth().currentUser?.uid {
            Cloud.getUser(id: id) { user in
                Cloud.currentUser = user
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "logged_in", sender: self)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
        Cloud.login(email: username.text!, password: password.text!) { error in
            if let e = error {
                Util.alert(title: "Error", message: e.localizedDescription ?? "Login failed.", presenter: self)
            } else {
                self.performSegue(withIdentifier: "logged_in", sender: self)
            }
        }
    }
    
}

