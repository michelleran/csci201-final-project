//
//  PostViewController.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 11/4/19.
//

import Foundation
import UIKit

class PostViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - UI
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var descField: UITextView!
    @IBOutlet var tagsField: UITextField!
    @IBOutlet var priceField: UITextField!
    
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    
    @IBAction func selectStartDate() {
        DatePickerDialog(buttonColor: self.view.tintColor).show("Select a start date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: startDate ?? Date(), minimumDate: Date(), maximumDate: endDate, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.startDate = dt
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yy"
                self.startDateLabel.text = formatter.string(from: dt)
            }
        }
    }
    
    @IBAction func selectEndDate() {
        DatePickerDialog(buttonColor: self.view.tintColor).show("Select an end date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: endDate ?? Date(), minimumDate: startDate ?? Date(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.endDate = dt
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yy"
                self.endDateLabel.text = formatter.string(from: dt)
            }
        }
    }
    
    @IBAction func done() {
        // validate required fields
        guard let title = titleField.text, !title.isEmpty else {
            Util.alert(title: "Unable to submit", message: "Please provide a title.", presenter: self)
            return
        }
        guard let desc = descField.text, !desc.isEmpty else {
            Util.alert(title: "Unable to submit", message: "Please provide a description.", presenter: self)
            return
        }
        guard let tags = tagsField.text, !tags.isEmpty else {
            Util.alert(title: "Unable to submit", message: "Please add at least one tag.", presenter: self)
            return
        }
        guard let price = Int(priceField.text ?? ""), price >= 0 else {
            Util.alert(title: "Unable to submit", message: "Invalid price.", presenter: self)
            return
        }
        
        // validate start, end date
        if let end = endDate {
            if end.compare(Date()) == .orderedAscending {
                Util.alert(title: "Unable to submit", message: "Invalid end date.", presenter: self)
                return
            }
            if let start = startDate, start.compare(end) == .orderedDescending {
                Util.alert(title: "Unable to submit", message: "Invalid date range.", presenter: self)
                return
            }
        }
        
        let request: Request = Request(title: title, desc: desc, tags: tags, startDate: startDate, endDate: endDate, price: price)
        // save changes
        if let pre = prefill {
            // editing existing request
            Cloud.updateRequest(id: pre.id, request: request) { _ in }
        } else {
            // posting a new request
            Cloud.newRequest(request: request) { _ in }
        }
        
        // return to previous page
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Instance variables
    
    var prefill: Request?
    var startDate: Date?
    var endDate: Date?
    
    //var requestsViewController: RequestsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        tagsField.delegate = self
        priceField.delegate = self
        
        if let pre = prefill {
            // in edit mode
            titleField.text = pre.title
            descField.text = pre.desc
            tagsField.text = pre.tags.joined(separator: ", ")
            priceField.text = String(pre.price)
            // set date labels, if appropriate
            if let start = pre.startDate {
                startDate = start
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yy"
                self.startDateLabel.text = formatter.string(from: start)
            }
            if let end = pre.endDate {
                endDate = end
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yy"
                self.endDateLabel.text = formatter.string(from: end)
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
