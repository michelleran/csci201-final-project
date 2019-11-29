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
    @IBOutlet var edit_or_finish: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    var beforeEdit = ""

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

    // If its in editing, then finish editing
    @IBAction func editOrFinishEditingUsername(_ sender: UIButton) {
        if (edit_or_finish.titleLabel!.text == "Edit"){
            username.isEditable = true
            edit_or_finish.titleLabel!.text = "Finish"
            beforeEdit = username.text
            cancelBtn.isHidden = false
            
            // TODO: show cursur and keyboard
        }else {
            // Finished editing username
            
            username.isEditable = false
            edit_or_finish.titleLabel!.text = "Edit"
            cancelBtn.isHidden = true
            
            // TODO: update the name on backend
            
        }
    }

    
    @IBAction func logout(_ sender: UIButton) {
        Cloud.logout()
        // pull up login page
        self.presentLoginPage()
    }
    
    @IBAction func cancelEditing(_ sender: UIButton){
        cancelBtn.isHidden = true
        
        username.text = beforeEdit
        edit_or_finish.titleLabel!.text = "Edit"
    }

}

//class ProfileInEditViewController: UIViewController{
//
//    @IBOutlet weak var username: UITextView!
//
//    override func viewDidLoad() {
//
//    }
//
//    @IBAction func cancelEditing(_ sender: UIButton) {
//
//    }
//
//    @IBAction func finishedEditing(_ sender: UIButton) {
//        // TODO: get name from UI element
//        let updated_name = ""
//
//        // TODO: update the value on backend
//
//
//        // TODO: move back to the profile scene with name as parameter
//
//    }
//}
