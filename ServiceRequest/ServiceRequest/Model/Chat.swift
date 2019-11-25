//
//  Chat.swift
//  ServiceRequest
//
//  Created by Rithwik Sivakumar on 11/18/19.
//

import Foundation

class Chat {
    
    var senderID : String = ""
    var receiverID : String = ""
    var requestID : String = ""
    var offerID : String = ""
    var messageList : [String]  = []
    
    init (senderID : String, receiverID : String, requestID : String, offerID : String) {
        
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
    
    /*
    func getMessageList() -> [Message] {
        if let temp = self.messageList { return self.messageList }
        else { return nil }
    }
    
    func addMessage(Message: e)  {
        if let ch = messageList {
            self.messageList.append(contentsOf: e)
        }
        else {
            self.messageList = []
            messageList.append(contentsOf: e)
        }
    }
 
 */
 
    
}
