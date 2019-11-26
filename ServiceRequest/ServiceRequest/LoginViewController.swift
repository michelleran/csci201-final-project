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

    @IBOutlet var username: UITextField! // TODO: this might be confusing, rename to email?
    @IBOutlet var password: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        if let id = Auth.auth().currentUser?.uid {
            Cloud.getUser(id: id) { user in
                Cloud.currentUser = user
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "logged_in", sender: self)
                }
            }
            /*if let storyboard = self.storyboard {
                let vc = storyboard.instantiateViewController(withIdentifier: "logged_in_main")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }*/
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
        // TODO: validation
        // TODO: move to Cloud
        Auth.auth().signIn(withEmail: username.text!, password: password.text!) { (result, error) in
            if let user = result?.user {
                // get auxiliary data
                Cloud.getUser(id: user.uid) { user in
                    Cloud.currentUser = user
                }
                self.performSegue(withIdentifier: "logged_in", sender: self)
            } else {
                Util.alert(title: "Error", message: error?.localizedDescription ?? "Login failed.", presenter: self)
            }
        }
    }
    
}

