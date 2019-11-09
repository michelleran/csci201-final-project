//
//  RequestCell.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 10/31/19.
//

import Foundation
import UIKit

class RequestCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tagsLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var dateRangeLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    var interestedHandler: ((UIButton) -> Void)?
    
    @IBAction func interested(sender: UIButton) {
        self.interestedHandler?(sender)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
