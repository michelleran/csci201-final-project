//
//  Cloud.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 11/4/19.
//

import Foundation
import Firebase
import Kanna

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
        guard let url = URL(string: "http://35.215.113.104:8080/Register201Project/register.jsp?email=\(email)&password=\(password)&displayname=\(username)") else { return }
        UIApplication.shared.open(url, options: [:]) { success in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) { // TODO: maybe longer
                login(email: email, password: password) { error in
                    if let id = Auth.auth().currentUser?.uid {
                        if currentUser == nil {
                            // new user
                            db.child("users/\(id)/name").setValue(username)
                            //currentUser = User(id: id, name: username, requestsPosted: [:], incomingOffers: [:], outgoingOffers: [:], chats: [:])
                            currentUser = User(id: id, name: username)
                        }
                        callback(nil)
                    } else {
                        callback(error)
                    }
                }
            }
        }
    }
    
    static func login(email: String, password: String, callback: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let user = result?.user {
                // get auxiliary data
                getUser(id: user.uid) { user in
                    currentUser = user
                }
            }
            callback(error)
        }
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
        return currentUser!
    }
    
    static func changeUsername(newName: String) {
        guard let id = currentUser?.id else { return }
        db.child("users/\(id)/name").setValue(newName)
        Cloud.currentUser?.name = newName
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
    
    static func getRequest(id: String, callback: @escaping (Request?) -> Void) {
        db.child("requests/\(id)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                callback(nil)
                return
            }
            callback(dictToRequest(id: id, dict: value))
        }
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
    
    static func getRequestsPosted(callback: @escaping (Request) -> Void) {
        guard let ids = currentUser?.requestsPosted else { return }
        print(ids)
        for id in ids {
            getRequest(id: id) { request in
                if let req = request { callback(req) }
            }
        }
    }
    
    // MARK: - Offers
    
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
        guard let currentUserId = currentUser?.id else { return }
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
    
    static func acceptOffer(offer: Offer) {
        createChat(offer: offer)
        deleteOffer(offer: offer)
    }
    
    static func deleteOffer(offer: Offer) {
        let updates: [String: Any] = [
            "users/\(offer.provider)/outgoingOffers/\(offer.id)": NSNull(),
            "users/\(offer.request)/incomingOffers/\(offer.id)": NSNull(),
            "offers/\(offer.id)": NSNull()
        ]
        db.updateChildValues(updates) { (error, ref) in
            if let e = error {
                print("deleteOffer: " + e.localizedDescription)
            }
        }
    }
    
    // MARK: - Chat
    
    static func createChat(offer: Offer) -> String
    {
        let newChatID = UUID().uuidString
        let updates: [String: Any] = [
            "chats/\(newChatID)": [
                "offer_id": offer.id,
                "request_id": offer.request,
                "receiver_id": offer.requester,
                "sender_id": offer.provider
            ],
            "users/\(offer.requester)/chats/\(newChatID)": true,
            "users/\(offer.provider)/chats/\(newChatID)": true
        ]
        db.updateChildValues(updates)
        return newChatID
    }
    
    static func getChats(callback: @escaping ([Chat]) -> Void) {
        guard let user_id = currentUser?.id else { return }
        db.child("users/\(user_id)/chats").observeSingleEvent(of: .value, with: { (snapshot) in
            var chats: [Chat] = []
            let value = snapshot.value as? NSDictionary
            let keys = value?.allKeys as? [String]
            
            db.child("chats").observeSingleEvent(of: .value, with: { (snapshot) in
                // let value = snapshot.value as! [NSDictionary]
                for item in snapshot.children {
                    let key = (item as AnyObject).key as String
                    if (keys?.contains(key) ?? false) {
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
    
    static func insertMessage(chatID: String, message: Message)
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
       let formdate = formatter.string(from: message.sentDate)
        
        let key = db.child("chats").child(chatID).child("messages").child(message.messageId)
        
        let body = ["text": message.text,
                    "senderID": message.user.id,
                    "displayName": message.user.displayName,
                    "date": formdate]
        
        
        print("/chats/\(key)")
        let childUpdates = ["/chats/\(chatID)/messages/\(message.messageId)": body]
        
        db.updateChildValues(childUpdates)
        
        
    }
    
    static func getChatDetails(chatID : String, callback: @escaping ([Message]) -> Void) {
        db.child("chats").child(chatID).child("messages").observeSingleEvent(of: .value) { (snapshot) in
            var messages : [Message] = []
            let formatter = DateFormatter()
          //  formatter.dateFormat = dateTimeFormat
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            for item in snapshot.children {
                let key = (item as AnyObject).key as String
               // print (key)
                    
                   
                let details = (item as! DataSnapshot).value as! [String : String]
                print(details)
                let message = Message(text: details["text"]! , user: User(id:  details["senderID"]!, name: details["displayName"]!),  messageId: key, date: formatter.date(from: details["date"]!)!)

                messages.append(message)
                
            }
            print(messages.count)
            print(messages)
            callback(messages)
        }
    }
    
    static func syncChatDetails(chatID : String, callback: @escaping ([Message]) -> Void) {
        db.child("chats").child(chatID).child("messages").observe(.childAdded) { (snapshot) in
            var messages : [Message] = []
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            //print(snapshot)

           
            let details =  snapshot.value as! [String : String]
            let message = Message(text: details["text"]! , user: User(id:  details["senderID"]!, name: details["displayName"]!),  messageId: snapshot.key, date: formatter.date(from: details["date"]!)!)
            
            messages.append(message)
                
            
            
            
            /*
            for item in (snapshot.value as? [[String :Any]])! {
                           
                     let key = (item as AnyObject).key as String
                
                print (key)

                        if (key.contains("m"))
                       {
                        print("hello")
                           let details = item[key] as! [String : String]
                        let message = Message(text: details["text"]! , user: User(id:  details["senderID"]!, name: details["displayName"]!),  messageId: key, date: formatter.date(from: details["date"]!)!)
                        
                        messages.append(message)
                          
                       }
                
            }
 
 */
            
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

    /*private static func getHTML(urlString: String) -> HTMLDocument? {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        if let html = try? String(contentsOf: url), let doc = try? HTML(html: html, encoding: .utf8) {
            return doc
        } else {
            print("Unable to convert to HTMLDocument")
            return nil
        }
    }*/
    
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
                    requestsPosted: value["requestsPosted"] as? [String: Bool],
                    incomingOffers: value["incomingOffers"] as? [String: Bool],
                    outgoingOffers: value["outgoingOffers"] as? [String: Bool],
                    chats: value["chats"] as? [String: Bool])
    }
    
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
    static func getRequestTitle(id:String, callback: @escaping (String) -> Void) {
        db.child("requests").child(id).observeSingleEvent(of: .value) { (snapshot) in
            let val = snapshot.value as? [String : Any]
            callback(val!["title"] as! String)
        }
    }
}


