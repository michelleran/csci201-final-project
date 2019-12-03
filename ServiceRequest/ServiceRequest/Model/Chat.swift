//
//  Chat.swift
//  ServiceRequest
//
//  Created by Rithwik Sivakumar on 11/18/19.
//

import Foundation

class Chat {
    
    var chatID : String = ""
    var senderID : String = ""
    var receiverID : String = ""
    var requestID : String = ""
    var offerID : String = ""
    var messageList : [String]  = []
    
    init (chatID : String, senderID : String, receiverID : String, requestID : String, offerID : String) {
        
        self.chatID = chatID
        self.senderID = senderID
        self.receiverID = receiverID
        self.requestID = requestID
        self.offerID = offerID
       
    }
    
    func getSenderID() -> String {
        return self.senderID
    }
    
    func getReceiverID() -> String {
        return self.receiverID
    }
    
    func getRequestID() -> String {
        return self.requestID
    }
    
    func getOfferID() -> String {
        return self.offerID
    }
    
}
