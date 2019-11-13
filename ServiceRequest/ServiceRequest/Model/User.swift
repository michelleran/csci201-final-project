//
//  User.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 11/4/19.
//

import Foundation

class User {
    var id: String = ""
    var name: String = ""
    
    var requestsPosted: [String] = []
    var incomingOffers: [String] = []
    var outgoingOffers: [String] = []
    var chats: [String] = []
    
    init(id: String, name: String, requestsPosted: [String]?, incomingOffers: [String]?, outgoingOffers: [String]?, chats: [String]?) {
        self.id = id
        self.name = name
        if let posted = requestsPosted { self.requestsPosted = posted }
        if let incoming = incomingOffers { self.incomingOffers = incoming }
        if let outgoing = outgoingOffers { self.outgoingOffers = outgoing }
        if let ch = chats { self.chats = ch }
    }
}
