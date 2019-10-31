//
//  RequestsViewController.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 10/31/19.
//

import Foundation
import UIKit

class RequestsViewController: UITableViewController {
    var requests: [Request] = [
        Request(id: "id1", title: "Lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor", desc: "Desc 1"),
        Request(id: "id2", title: "Request 2", desc: "Lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.rowHeight = UITableView.automaticDimension
        update(with: Request(id: "id3", title: "Request 3", desc: "Desc 3"))
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
        let cell: RequestCell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell
        let request = requests[indexPath.row]
        cell.titleLabel.text = request.title
        cell.descLabel.text = request.desc
        cell.interestedHandler = { (sender: UIButton) in
            self.handleInterested(id: request.id)
            sender.isEnabled = false
        }
        return cell
    }
    
    func handleInterested(id: String) {
        print(id)
    }
}
