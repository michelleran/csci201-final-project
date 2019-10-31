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
    @IBOutlet var descLabel: UILabel!
    
    var interestedHandler: ((UIButton) -> ())?
    
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
