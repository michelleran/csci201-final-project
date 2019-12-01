//
//  RequestPostedCell.swift
//  SegmentedControlTest
//
//  Created by Michelle Ran on 11/26/19.
//  Copyright © 2019 Michelle Ran. All rights reserved.
//

import Foundation
import UIKit

class RequestPostedCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    
    var editHandler: (() -> Void) = { }
    @IBAction func edit() {
        self.editHandler()
    }
    
    var deleteHandler: (() -> Void) = { }
    @IBAction func delete() {
        self.deleteHandler()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
