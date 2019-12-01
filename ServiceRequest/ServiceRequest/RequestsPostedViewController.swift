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
    var requests: [Request] = []
    var requestToEdit: Request?
    
    override func viewDidLoad() {
        // TODO: get posted requests
        /*Cloud.getRequests { requests in // MARK: for testing
            DispatchQueue.main.async {
                self.requests = requests
                self.tableView.reloadData()
            }
        }*/
        Cloud.getRequestsPosted { request in
            DispatchQueue.main.async {
                self.update(with: request)
            }
        }
    }
    
    func update(with: Request) {
        requests.append(with)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: requests.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RequestPostedCell = tableView.dequeueReusableCell(withIdentifier: "RequestPostedCell", for: indexPath) as! RequestPostedCell
        let request = requests[indexPath.row]
        cell.titleLabel.text = request.title
        cell.descLabel.text = request.desc
        cell.editHandler = { self.requestToEdit = request }
        cell.deleteHandler = {
            
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let post = segue.destination as? PostViewController {
            post.prefill = requestToEdit
        }
    }
}
