//
//  Request.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 10/31/19.
//

import Foundation

class Request {
    var id: String = ""
    var title: String = ""
    var desc: String = ""
    
    // TODO: other fields
    
    init(id: String, title: String, desc: String) {
        self.id = id
        self.title = title
        self.desc = desc
    }
}
