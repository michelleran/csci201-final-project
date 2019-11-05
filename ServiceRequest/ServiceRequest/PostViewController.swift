//
//  PostViewController.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 11/4/19.
//

import Foundation
import UIKit

class PostViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet var titleField: UITextField!
    @IBOutlet var descField: UITextView!
    @IBOutlet var priceField: UITextField!
    // TODO: others
    
    var requestsViewController: RequestsViewController?
    
    @IBAction func done() {
        // validate input
        if (titleField.text ?? "").isEmpty || descField.text.isEmpty || (priceField.text ?? "").isEmpty
        {
            let alertController = UIAlertController(title: "Unable to post", message:
                "Please fill out all required fields.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        requestsViewController?.update(with: Request(id: "something", title: titleField.text!, desc: descField.text))
        
        // TODO: save request to Firebase
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        //descField.delegate = self
        priceField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
