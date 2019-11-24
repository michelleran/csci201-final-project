//
//  Offer.swift
//  ServiceRequest
//
//  Created by Rithwik Sivakumar on 11/18/19.
//

import Foundation

class Offer {
    
    var offerID : String = ""
    var requestID : String = ""
    var providerID : String = ""
    var chat : Chat = nil
    var message : String
    
    init (offerID : String, requestID : String, providerID : String, chat : Chat, message : String) {
        self.offerID = offerID
        self.requestID = requestID
        self.providerID = providerID
        self.chat = chat
        self.message = message
    }
    
    func getOfferID () -> String {
        return self.offerID
    }
    
    func getRequestID () -> String {
        return self.requestID
    }
    
    func getProviderID () -> String {
        return self.providerID
    }
    
    func getChat () -> Chat {
        return self.chat
    }
    
    func getMessage () -> String {
        return self.message
    }
    
}
