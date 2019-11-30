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
    
    static func getCurrentUser() -> User {
        return currentUser!;
    }
    
    
    
    // MARK: - Requests
    
    static func getRequests(callback: @escaping ([Request]) -> Void) {
        let url = "http://35.215.113.104:8080/CSCI201FinalProject/GetRequest?userID=" + (currentUser?.id ?? "")
        get(url: url) { data in
            guard let root = data as? [String: Any], let children = root["root"] as? [String: [String: Any]] else {
                print("Get requests failed: data not in valid format")
                return
            }
            var requests = Heap<Request>(array: []) { (r1, r2) in
                return r1.timePosted < r2.timePosted
            }
            for (id, value) in children {
                if let request = dictToRequest(id: id, dict: value) {
                    requests.insert(request)
                }
            }
            callback(requests.sorted())
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
    
    static func updateRequest(id: String, request: Request, callback: @escaping (Bool) -> Void) {
        let updates = request.toDictionary(addTimestamp: false) as! [String: Any]
        db.child("requests").child(id).updateChildValues(updates) { (error, ref) in
            if let e = error {
                print("updateRequest failed: " + e.localizedDescription)
                callback(false)
            } else { callback(true) }
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
    
    static func createChat(offerID: String, requestID: String)
    {
        let newChatID = UUID().uuidString
        
        db.child("chats").child(newChatID).child("offer_id").setValue(offerID)
        db.child("chats").child(newChatID).child("request_id").setValue(requestID)
        
        db.child("offers").child(offerID).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? [String:String]
            
            db.child("chats").child(newChatID).child("receiver_id").setValue(value!["requester"])
            db.child("chats").child(newChatID).child("sender_id").setValue(value!["provider"])
            
            db.child("users").child(value!["requester"]!).child("chats").setValue([newChatID : true])
            db.child("users").child(value!["provider"]!).child("chats").setValue([newChatID : true])
            
        }
        
        
    }
    
   static func getChats(callback: @escaping ([Chat]) -> Void) {
    
    let user_id = Auth.auth().currentUser!.uid//currentUser!.id
    
    db.child("users").child(user_id).child("chats").child("testchat").setValue(true)
    
    
    
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
                    let details = (item as! DataSnapshot).value as! [String : Any]
                    let chat = Chat(chatID: key, senderID: details["sender_id"]! as! String , receiverID: details["receiver_id"]! as! String, requestID: details["request_id"]! as! String, offerID:details["offer_id"]! as! String )
                    
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
    
    static func insertMessage(chatID: String, message : Message)
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        db.child("chats").child(chatID).child(message.messageId).child("text").setValue(message.text)
        db.child("chats").child(chatID).child(message.messageId).child("senderID").setValue(message.user.id)
        db.child("chats").child(chatID).child(message.messageId).child("displayName").setValue(message.user.displayName)
        
        let formdate = formatter.string(from: message.sentDate)
        db.child("chats").child(chatID).child(message.messageId).child("date").setValue(formdate)
        
        
    }
    
    static func getChatDetails(chatID : String, callback: @escaping ([Message]) -> Void) {
        
        db.child("chats").child(chatID).observeSingleEvent(of: .value) { (snapshot) in
            var messages : [Message] = []
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            
             for item in snapshot.children {
                           
                     let key = (item as AnyObject).key as String
                
                print (key)

                        if (key.contains("m"))
                       {
                        print("hello")
                           let details = (item as! DataSnapshot).value as! [String : String]
                        let message = Message(text: details["text"]! , user: User(id:  details["senderID"]!, name: details["displayName"]!),  messageId: key, date: formatter.date(from: details["date"]!)!)
                        
                        messages.append(message)
                          
                       }
                
            }
            
            print(messages.count)
            
            callback(messages)

        }
            
        
        
    }
    
    // MARK: - Networking
    
    private static func get(url: String, callback: @escaping (Any) -> Void) {
        guard let u = URL(string: url) else {
            print("Get failed: invalid url")
            return
        }
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: URLRequest(url: u)) { (data, response, error) in
            if let e = error {
                print("Get failed: \(e.localizedDescription)")
                return
            }
            guard let d = data else {
                print("Get failed: no data")
                return
            }
            do {
                let deserialized = try JSONSerialization.jsonObject(with: d, options: [])
                callback(deserialized)
            } catch {
                print("Get failed: could not deserialize")
            }
        }
        task.resume()
    }
    
    private static func post(url: String) {
        
    }
    
    // MARK: - Helper
    
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
    
    /*private static func snapshotToRequest(snapshot: DataSnapshot) -> Request? {
        guard let value = snapshot.value as? NSDictionary else { return nil }
        // get & validate fields
        guard let poster = value["poster"] as? String else { return nil }
        guard let title = value["title"] as? String else { return nil }
        guard let desc = value["desc"] as? String else { return nil }
        guard let tags = value["tags"] as? [String: Bool] else { return nil }
        guard let price = value["price"] as? Int else { return nil }
        // build Request object
        let request = Request(id: snapshot.key, poster: poster, title: title, desc: desc, tags: tags, startDate: value["startDate"] as? String, endDate: value["endDate"] as? String, price: price)
        request.timePosted = value["timePosted"] as? String ?? ""
        return request
    }*/
    
    private static func dictToRequest(id: String, dict: [String: Any]) -> Request? {
        guard let poster = dict["poster"] as? String else { return nil }
        guard let title = dict["title"] as? String else { return nil }
        guard let desc = dict["desc"] as? String else { return nil }
        guard let tags = dict["tags"] as? [String: Bool] else { return nil }
        guard let price = dict["price"] as? Int else { return nil }
        let request = Request(id: id, poster: poster, title: title, desc: desc, tags: tags, startDate: dict["startDate"] as? String, endDate: dict["endDate"] as? String, price: price)
        request.timePosted = dict["timePosted"] as? String ?? ""
        return request
    }
    
    
    static func getUserName(id: String, callback: @escaping (String) -> Void)
    {
        db.child("users").child(id).observeSingleEvent(of: .value) { (snapshot) in
            let u = snapshotToUser(snapshot: snapshot)
            
            callback((u?.displayName)!)
            
        }
    }
    
    //change to implement using getRequest eventually....
    static func getRequestTitle(id:String, callback: @escaping (String) -> Void)
    {
        db.child("requests").child(id).observeSingleEvent(of: .value) { (snapshot) in
            let val = snapshot.value as? [String : Any]

            callback(val!["title"] as! String)
            
        }
    }

    
    
    
    
}


