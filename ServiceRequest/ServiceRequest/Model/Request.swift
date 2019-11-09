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
    var tags: [String] = []
    var startDate: Date?
    var endDate: Date?
    var price: Int
    
    init(id: String, title: String, desc: String, tags: [String], startDate: Date? = nil, endDate: Date? = nil, price: Int) {
        self.id = id
        self.title = title
        self.desc = desc
        self.tags = tags
        self.startDate = startDate
        self.endDate = endDate
        self.price = price
    }
    
    convenience init(id: String, title: String, desc: String, tags: String, startDate: Date? = nil, endDate: Date? = nil, price: Int) {
        var tagsArray: [String] = tags.components(separatedBy: ",")
        for i in 0..<tagsArray.count {
            tagsArray[i] = tagsArray[i].trimmingCharacters(in: .whitespacesAndNewlines)
        }
        self.init(id: id, title: title, desc: desc, tags: tagsArray, startDate: startDate, endDate: endDate, price: price)
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
        formatter.dateFormat = "MM/dd/yy"
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
