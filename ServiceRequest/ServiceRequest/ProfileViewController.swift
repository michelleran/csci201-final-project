//
//  ProfileViewController.swift
//  ServiceRequest
//
//  Created by Satoshi Nakamura on 11/24/19.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet var username: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if the user is not logged in, then
        if Cloud.currentUser == nil{
            self.presentLoginPage()
            return
        }
        
        // set USERNAME to loggedin user name
        let name = Cloud.currentUser?.name;

        
        // TODO: Update on backend
        
    }
    
    func presentLoginPage(){
        self.dismiss(animated: true, completion: nil)
        
    }

    // TODO: implement edit name
    @IBAction func editUsername(_ sender: UIButton) {
        
    }
    
    @IBAction func logout(_ sender: UIButton) {
        Cloud.currentUser = nil;
        
        // pull up login page
        self.presentLoginPage()
    }
}

class ProfileInEditViewController: UIViewController{
    
    @IBOutlet weak var username: UITextView!

    override func viewDidLoad() {
        
    }
    
    @IBAction func cancelEditing(_ sender: UIButton) {
        
    }
    
    @IBAction func finishedEditing(_ sender: UIButton) {
        // TODO: get name from UI element
        let updated_name = ""
        
        // TODO: update the value on backend
        
        
        // TODO: move back to the profile scene with name as parameter

    }
}
