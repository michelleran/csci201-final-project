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
    var incomingOffers: [Offer] = []
    var outgoingOffers: [Offer] = []
    
    override func viewDidLoad() {
        Cloud.getIncomingOffers { offer in
            DispatchQueue.main.async {
                self.update(with: offer, to: 0)
            }
        }
        Cloud.getOutgoingOffers { offer in
            DispatchQueue.main.async {
                self.update(with: offer, to: 1)
            }
        }
    }
    
    func update(with: Offer, to: Int) {
        if (to == 1) {
            outgoingOffers.append(with)
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: outgoingOffers.count-1, section: 1)], with: .automatic)
            tableView.endUpdates()
        } else {
            incomingOffers.append(with)
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: incomingOffers.count-1, section: 0)], with: .automatic)
            tableView.endUpdates()
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) { return "Incoming" }
        return "Outgoing"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) { return incomingOffers.count }
        return outgoingOffers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell: IncomingOfferCell = tableView.dequeueReusableCell(withIdentifier: "IncomingOfferCell", for: indexPath) as! IncomingOfferCell
            let offer = incomingOffers[indexPath.row]
            if offer.message.isEmpty { cell.messageLabel.isHidden = true } // TODO: not working?
            else { cell.messageLabel.text = offer.message }
            
            Cloud.getRequest(id: offer.request) { offering in
                DispatchQueue.main.async {
                    cell.requestTitleLabel.text = offering?.title
                }
            }
            Cloud.getUserName(id: offer.provider) { offering in
                DispatchQueue.main.async {
                    cell.providerLabel.text = offering
                }
            }
            
            cell.acceptHandler = {
                Cloud.acceptOffer(offer: offer)
                self.incomingOffers.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            cell.declineHandler = {
                Cloud.deleteOffer(offer: offer)
                self.incomingOffers.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            return cell
        }
        
        let cell: OutgoingOfferCell = tableView.dequeueReusableCell(withIdentifier: "OutgoingOfferCell", for: indexPath) as! OutgoingOfferCell
        let offer = outgoingOffers[indexPath.row]
        if offer.message.isEmpty { cell.messageLabel.isHidden = true }
        else { cell.messageLabel.text = offer.message }
        
        Cloud.getRequest(id: offer.request) { request in
            DispatchQueue.main.async {
                cell.requestTitleLabel.text = request?.title
            }
        }
        Cloud.getUserName(id: offer.requester) { name in
            DispatchQueue.main.async {
                cell.requesterLabel.text = name
            }
        }
        
        cell.withdrawHandler = {
            Cloud.deleteOffer(offer: offer)
            self.outgoingOffers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
}

