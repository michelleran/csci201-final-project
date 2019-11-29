//
//  RequestsPostedViewController.swift
//  SegmentedControlTest
//
//  Created by Michelle Ran on 11/26/19.
//  Copyright © 2019 Michelle Ran. All rights reserved.
//

import Foundation
import UIKit

class RequestsPostedViewController: UITableViewController {
    var requests = 3 // demo to show variable number of rows
    
    var requestToEdit: Request?
    
    override func viewDidLoad() {
        print("Loading RequestsPostedViewController")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RequestPostedCell = tableView.dequeueReusableCell(withIdentifier: "RequestPostedCell", for: indexPath) as! RequestPostedCell
        cell.editHandler = {
            // set requestToEdit
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let post = segue.destination as? PostViewController {
            post.prefill = requestToEdit
        }
    }
}
