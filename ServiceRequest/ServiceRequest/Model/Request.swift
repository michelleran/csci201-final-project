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
    var startDate: Date?
    var endDate: Date?
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
        var tagsArray: [String] = tags.components(separatedBy: ",")
        for i in 0..<tagsArray.count {
            tagsArray[i] = tagsArray[i].trimmingCharacters(in: .whitespacesAndNewlines)
        }
        self.init(id: "", poster: Cloud.currentUser!.id, title: title, desc: desc, tags: tagsArray, startDate: startDate, endDate: endDate, price: price)
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
        for tag in tags {
            str += "#" + tag + " "
        }
        return str
    }
    
    func getDateRangeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Cloud.dateFormat
        var str: String = ""
        if let start = startDate {
            str += formatter.string(from: start)
        } else {
            str += "N/A"
        }
        str += " - "
        if let end = endDate {
            str += formatter.string(from: end)
        } else {
            str += "N/A"
        }
        return str
    }
}
