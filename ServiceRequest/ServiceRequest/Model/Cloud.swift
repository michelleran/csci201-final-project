//
//  Cloud.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 11/4/19.
//

import Foundation
import Firebase

class Cloud {
    static let dateFormat: String = "MM/dd/yy"
    static let dateTimeFormat: String = "MM/dd/yy hh:mm"
    
    static var db: DatabaseReference!
    static var currentUser: User?
    
    static func setup() {
        db = Database.database().reference()
    }
    
    // MARK: - Authentication
    
    static func signup(username: String, email: String, password: String, callback: @escaping (Error?) -> Void) {
        
    }
    
    static func login(email: String, password: String, callback: @escaping (Error?) -> Void) {
        
    }
    
    static func logout() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
        } catch {
            print("Log out failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Users
    
    static func getUser(id: String, callback: @escaping (User) -> Void) {
        db.child("users/" + id).observeSingleEvent(of: .value) { snapshot in
            if let user = snapshotToUser(snapshot: snapshot) {
                callback(user)
            } else {
                print("getUser(\(id)) failed")
            }
        }
    }
    
    // MARK: - Requests
    
    static func getRequests(callback: @escaping ([Request]) -> Void) {
        db.child("requests").queryOrdered(byChild: "timePosted").observeSingleEvent(of: .value) { snapshot in
            var requests: [Request] = []
            for child in snapshot.children {
                guard let data = child as? DataSnapshot else { continue }
                if let request = snapshotToRequest(snapshot: data) {
                    // exclude your own requests
                    if let user = currentUser, user.id == request.poster { continue }
                    requests.append(request)
                }
            }
            // reverse so we have most recent at top
            callback(requests.reversed())
        }
    }
    
    static func getRequest(id: String, callback: @escaping (Request) -> Void) {
        
    }
    
    static func newRequest(request: Request, callback: @escaping (String) -> Void) {
        if let id = db.child("requests").childByAutoId().key {
            let updates: [String: Any] = ["requests/\(id)": request.toDictionary(addTimestamp: true), "users/\(request.poster)/requestsPosted/\(id)": true]
            db.updateChildValues(updates) { (error, ref) in
                if let e = error {
                    print("newRequest failed: " + e.localizedDescription)
                } else { callback(id) }
            }
        } else {
            print("newRequest failed on childByAutoId")
        }
    }
    
    static func alreadyMadeOffer(request: String, callback: @escaping (Bool) -> Void) {
        if let user = currentUser {
            db.child("offers").queryOrdered(byChild: "requestProvider").queryEqual(toValue: request + "+" + user.id).observeSingleEvent(of: .value) { snapshot in
                callback(snapshot.exists())
            }
        } else {
            callback(false)
        }
    }
    
    static func makeOffer(request: Request, message: String?, callback: @escaping (String) -> Void) {
        let currentUserId = currentUser!.id
        if let id = db.child("offers").childByAutoId().key {
            let offer = ["request": request.id, "requester": request.poster, "provider": currentUserId, "requestProvider": "\(request.id)+\(currentUserId)", "message": message]
            let updates: [String: Any] = ["offers/\(id)": offer, "users/\(request.poster)/incomingOffers/\(id)": true, "users/\(currentUserId)/outgoingOffers/\(id)": true]
            db.updateChildValues(updates) { (error, ref) in
                if let e = error {
                    print("makeOffer failed: " + e.localizedDescription)
                } else { callback(id) }
            }
        } else {
            print("makeOffer failed on childByAutoId")
        }
    }
    
    // MARK: - Chat
    
   static func getChats(callback: @escaping ([Chat]) -> Void) {
    
    let user_id = Auth.auth().currentUser!.uid//currentUser!.id
    
   // db.child("users").child(user_id).child("chats").child("testChat4").setValue(true)
    
    
    
    db.child("users").child(user_id).child("chats").observeSingleEvent(of: .value, with: { (snapshot) in
      // Get user value
         var chats: [Chat] = []
        
        
        
        
        let value = snapshot.value as? NSDictionary
        
      
        let keys = value?.allKeys as? [String]
        
       
        
        db.child("chats").observeSingleEvent(of: .value, with: { (snapshot) in
                 // Get user value
            
           // let value = snapshot.value as! [NSDictionary]
            
            for item in snapshot.children {
                
              let key = (item as AnyObject).key as String

                if (keys?.contains(key) ?? false)
                {
                    let details = (item as! DataSnapshot).value as! [String : String]
                    let chat = Chat(senderID: details["sender_id"]! , receiverID: details["receiver_id"]!, requestID: details["request_id"]!, offerID:details["offer_id"]! )
                    
                    chats.append(chat)
                }

            }
            
            print(chats.count)
            callback(chats.reversed())
                   

                 }) { (error) in
                   print(error.localizedDescription)
               }
            

        print("this count")
        print(chats.count)
      

      }) { (error) in
        print(error.localizedDescription)
    }
    
    
    }
    
    static func getChatDetails(chats: [String], callback: @escaping ([Chat]) -> Void) {
        
        
        
        
    }
    
    // MARK: - Networking
    
    private static func get(url: String) {
        
    }
    
    private static func post(url: String) {
        
    }
    
    // MARK: - Helper
    
    /*private static func push(path: String, data: Any, callback: @escaping (Error?, String) -> Void) {
        db.child(path).childByAutoId().setValue(data) { (error, ref) in
            callback(error, ref.key!)
        }
    }*/
    
    private static func exists(path: String, callback: @escaping (Bool) -> Void) {
        db.child(path).observeSingleEvent(of: .value) { snapshot in
            callback(snapshot.exists())
        }
    }
    
    private static func snapshotToUser(snapshot: DataSnapshot) -> User? {
        guard let value = snapshot.value as? NSDictionary else { return nil }
        // name is the only required field
        guard let name = value["name"] as? String else { return nil }
        return User(id: snapshot.key, name: name,
                    requestsPosted: value["requestsPosted"] as? [String],
                    incomingOffers: value["incomingOffers"] as? [String],
                    outgoingOffers: value["outgoingOffers"] as? [String],
                    chats: value["chats"] as? [String])
    }
    
    private static func snapshotToRequest(snapshot: DataSnapshot) -> Request? {
        guard let value = snapshot.value as? NSDictionary else { return nil }
        // get & validate fields
        guard let poster = value["poster"] as? String else { return nil }
        guard let title = value["title"] as? String else { return nil }
        guard let desc = value["desc"] as? String else { return nil }
        guard let tags = value["tags"] as? [String: Bool] else { return nil }
        guard let price = value["price"] as? Int else { return nil }
        // build Request object
        return Request(id: snapshot.key, poster: poster, title: title, desc: desc, tags: tags, startDate: value["startDate"] as? String, endDate: value["endDate"] as? String, price: price)
    }
    
    
    
}
