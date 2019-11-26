//
//  OffersViewController.swift
//  SegmentedControlTest
//
//  Created by Michelle Ran on 11/26/19.
//  Copyright © 2019 Michelle Ran. All rights reserved.
//

import Foundation
import UIKit

class OffersViewController: UITableViewController {
    // demo to show variable number of rows
    var incoming = 2
    var outgoing = 4
    
    override func viewDidLoad() {
        print("Loading OffersViewController")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) { return "Incoming" }
        return "Outgoing"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) { return incoming }
        return outgoing
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell: IncomingOfferCell = tableView.dequeueReusableCell(withIdentifier: "IncomingOfferCell", for: indexPath) as! IncomingOfferCell
            return cell
        }
        let cell: OutgoingOfferCell = tableView.dequeueReusableCell(withIdentifier: "OutgoingOfferCell", for: indexPath) as! OutgoingOfferCell
        return cell
    }
}
