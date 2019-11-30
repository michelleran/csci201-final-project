//
//  PendingViewController.swift
//  SegmentedControlTest
//
//  Created by Michelle Ran on 11/26/19.
//  Copyright © 2019 Michelle Ran. All rights reserved.
//

import Foundation
import UIKit

class PendingViewController: UIViewController {
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var requestsView: UIView!
    @IBOutlet var offersView: UIView!
    
    @IBAction func toggle() {
        if (segmentedControl.selectedSegmentIndex == 0) {
            // requests
            offersView.isHidden = true
            requestsView.isHidden = false
        } else {
            // offers
            requestsView.isHidden = true
            offersView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        offersView.isHidden = true
        requestsView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Cloud.currentUser == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
