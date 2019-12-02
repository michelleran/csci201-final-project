//
//  OutgoingOfferCell.swift
//  SegmentedControlTest
//
//  Created by Michelle Ran on 11/26/19.
//  Copyright © 2019 Michelle Ran. All rights reserved.
//

import Foundation
import UIKit

class OutgoingOfferCell: UITableViewCell {
    @IBOutlet weak var requestTitleLabel: UILabel!
    @IBOutlet weak var requesterLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
