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
    
    static func signup(username: String, email: String, password: String, callback: (Error?) -> Void) {
        
    }
    
    static func login() {
        
    }
    
    static func logout() {
        currentUser = nil;
    }
    
    // MARK: - Requests
    
    static func getRequests(callback: @escaping ([Request]) -> Void) {
        // TODO: don't know if ordering is correct
        db.child("requests").queryOrdered(byChild: "timePosted").observeSingleEvent(of: .value) { snapshot in
            var requests: [Request] = []
            for child in snapshot.children {
                guard let data = child as? DataSnapshot else { continue }
                guard let value = data.value as? NSDictionary else { continue }
                
                // get & validate fields
                guard let poster = value["poster"] as? String else { continue }
                guard let title = value["title"] as? String else { continue }
                guard let desc = value["description"] as? String else { continue }
                guard let tags = value["tags"] as? [String: Bool] else { continue }
                guard let price = value["price"] as? Int else { continue }
                
                // build Request object
                let request: Request = Request(id: data.key, poster: poster, title: title, desc: desc, tags: tags, startDate: value["startDate"] as? String, endDate: value["endDate"] as? String, price: price)
                requests.append(request)
            }
            callback(requests)
        }
    }
    
    static func newRequest(request: Request, callback: (String?) -> Void) {
        
    }
    
    static func makeOffer(id: String, message: String?, callback: (String?) -> Void) {
        
    }
    
    // MARK: - Chat
    
    // MARK: - Helper
    
    private static func get(url: String) {
        
    }
    
    private static func post(url: String) {
        
    }
}
