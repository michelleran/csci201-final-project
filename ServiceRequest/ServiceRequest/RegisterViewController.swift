//
//  RegisterViewController.swift
//  ServiceRequest
//
//  Created by Akhil Arun on 11/16/19.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirm_pass: UITextField!
    
    @IBOutlet var name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func register(_ sender: Any) {
        
        if password.text != confirm_pass.text {
            let alertController = UIAlertController(title: "Passwords Must Match", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if name.text == ""
        {
            let alertController = UIAlertController(title: "Invalid Name", message: "Please enter your name", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            
            Auth.auth().createUser(withEmail: username.text!, password: password.text!){ (user, error) in
                if error == nil {
                    var ref: DatabaseReference!
                    
                    print("adding item to db")
                    ref = Database.database().reference()
                    //userEmail.inde
                    
                    let user_id = Auth.auth().currentUser?.uid
                    
                    let display_name: String = self.name.text!
                    
                    
                    ref.child("users").child(user_id!).updateChildValues(["name": display_name])

                    self.performSegue(withIdentifier: "registered", sender: self)
                }
                else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
}
