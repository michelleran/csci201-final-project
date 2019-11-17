//
//  Request.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 10/31/19.
//

import Foundation

class Request {
    var id: String = ""
    var poster: String = ""
    var title: String = ""
    var desc: String = ""
    var tags: [String] = []
    var startDate, endDate: Date?
    var price: Int
    
    /// Base constructor
    init(id: String, poster: String, title: String, desc: String, tags: [String], startDate: Date? = nil, endDate: Date? = nil, price: Int) {
        self.id = id
        self.poster = poster
        self.title = title
        self.desc = desc
        self.tags = tags
        self.startDate = startDate
        self.endDate = endDate
        self.price = price
    }
    
    /// Posting a new request
    convenience init(title: String, desc: String, tags: String, startDate: Date? = nil, endDate: Date? = nil, price: Int) {
        //self.init(id: "", poster: Cloud.currentUser!.id, title: title, desc: desc, tags: Util.parseTags(tags: tags), startDate: startDate, endDate: endDate, price: price)
        self.init(id: "", poster: Cloud.currentUser!.id, title: title, desc: desc, tags: Util.parseTags(tags: tags), startDate: startDate, endDate: endDate, price: price)
    }
    
    /// Retrieving from database
    convenience init(id: String, poster: String, title: String, desc: String, tags: [String: Bool], startDate: String?, endDate: String?, price: Int) {
        var start, end: Date?
        let formatter = DateFormatter()
        formatter.dateFormat = Cloud.dateFormat
        if let startDateString = startDate {
            start = formatter.date(from: startDateString)
        }
        if let endDateString = endDate {
            end = formatter.date(from: endDateString)
        }
        self.init(id: id, poster: poster, title: title, desc: desc, tags: Array(tags.keys), startDate: start, endDate: end, price: price)
    }
    
    func getTagsString() -> String {
        var str: String = ""
        for tag in tags { str += "#" + tag + " " }
        return str
    }
    
    func getDateRangeString() -> String {
        if (startDate == nil && endDate == nil) { return "Whenever" }
        let formatter = DateFormatter()
        formatter.dateFormat = Cloud.dateFormat
        guard let start = startDate else { return "Before " + formatter.string(from: endDate!) }
        guard let end = endDate else { return "After " + formatter.string(from: startDate!) }
        return formatter.string(from: start) + " to " + formatter.string(from: end)
    }
    
    func toDictionary(addTimestamp: Bool = false) -> NSDictionary {
        var tagsDict: [String: Bool] = [:]
        for tag in tags { tagsDict[tag] = true }
        
        let dict: NSMutableDictionary = ["poster": poster, "title": title, "desc": desc, "tags": tagsDict, "price": price]
        
        let formatter = DateFormatter()
        formatter.dateFormat = Cloud.dateTimeFormat
        if let start = startDate { dict.setValue(formatter.string(from: start), forKey: "startDate") }
        if let end = endDate { dict.setValue(formatter.string(from: end), forKey: "endDate") }
        
        if addTimestamp { dict.setValue(formatter.string(from: Date()), forKey: "timePosted") }
        
        return dict
    }
}
