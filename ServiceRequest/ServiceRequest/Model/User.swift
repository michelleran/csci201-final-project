//
//  User.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 11/4/19.
//

import Foundation
import MessageKit

class User : SenderType {
    var id: String = ""
    var name: String = ""
    
    var requestsPosted: [String] = []
    var incomingOffers: [String] = []
    var outgoingOffers: [String] = []
    var chats: [String] = []
    var senderId: String
    var displayName: String
    
    init(id: String, name: String, requestsPosted: [String]?, incomingOffers: [String]?, outgoingOffers: [String]?, chats: [String]?) {
        self.id = id
        self.name = name
        self.displayName = name
        self.senderId = id
        if let posted = requestsPosted { self.requestsPosted = posted }
        if let incoming = incomingOffers { self.incomingOffers = incoming }
        if let outgoing = outgoingOffers { self.outgoingOffers = outgoing }
        if let ch = chats { self.chats = ch }
    }
    
    init(id: String, name: String)
    {
        self.id = id
        self.name = name
        self.displayName = name
        self.senderId = id
    }
}
