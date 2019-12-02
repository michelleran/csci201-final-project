//
//  IncomingOfferCell.swift
//  SegmentedControlTest
//
//  Created by Michelle Ran on 11/26/19.
//  Copyright © 2019 Michelle Ran. All rights reserved.
//

import Foundation
import UIKit

class IncomingOfferCell: UITableViewCell {
    @IBOutlet weak var requestTitleLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var acceptHandler: (() -> Void) = { }
    @IBAction func accept() {
        self.acceptHandler()
    }
    
    var declineHandler: (() -> Void) = { }
    @IBAction func decline() {
        self.declineHandler()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
