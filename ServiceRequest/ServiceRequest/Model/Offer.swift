//
//  Offer.swift
//  ServiceRequest
//
//  Created by Rithwik Sivakumar on 11/18/19.
//

import Foundation

class Offer {
    var id: String = ""
    var requester: String = ""
    var provider: String = ""
    var request: String = ""
    var message: String = ""
    
    init(id: String, requester: String, provider: String, request: String, message: String?) {
        self.id = id
        self.requester = requester
        self.provider = provider
        self.request = request
        if let msg = message { self.message = msg }
    }
}
