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
    
    init(id: String, name: String, requestsPosted: [String: Bool]?, incomingOffers: [String: Bool]?, outgoingOffers: [String: Bool]?, chats: [String: Bool]?) {
        self.id = id
        self.name = name
        self.displayName = name
        self.senderId = id
        if let posted = requestsPosted { self.requestsPosted = Array(posted.keys) }
        if let incoming = incomingOffers { self.incomingOffers = Array(incoming.keys) }
        if let outgoing = outgoingOffers { self.outgoingOffers = Array(outgoing.keys) }
        if let ch = chats { self.chats = Array(ch.keys) }
    }
    
    init(id: String, name: String)
    {
        self.id = id
        self.name = name
        self.displayName = name
        self.senderId = id
    }
}
