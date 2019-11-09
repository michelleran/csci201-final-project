//
//  Cloud.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 11/4/19.
//

import Foundation
import Firebase

class Cloud {
    static var db: DatabaseReference!
    static var currentUser: User?
    
    static func setup() {
        db = Database.database().reference()
    }
    
    // MARK: - Authentication
    
    static func signup(username: String, email: String, password: String, completion: (Error?) -> ()) {
        
    }
    
    static func login() {
        
    }
    
    static func logout() {
        currentUser = nil;
    }
    
    // MARK: - Requests
    
    // MARK: - Chat
    
    // MARK: - Helper
    
    private static func get(url: String) {
        
    }
    
    private static func post(url: String) {
        
    }
}
