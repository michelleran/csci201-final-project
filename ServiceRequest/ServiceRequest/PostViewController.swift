//
//  PostViewController.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 11/4/19.
//

import Foundation
import UIKit

class PostViewController: UITableViewController {
    @IBAction func done() {
        // TODO: save request
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
