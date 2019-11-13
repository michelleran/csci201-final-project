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
        DatePickerDialog(buttonColor: self.view.tintColor).show("Select a start date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: startDate ?? Date(), datePickerMode: .date) {
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
        DatePickerDialog(buttonColor: self.view.tintColor).show("Select an end date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: endDate ?? Date(), datePickerMode: .date) {
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
        // validate input
        guard let title = titleField.text, !title.isEmpty else {
            Util.alert(title: "Unable to post", message: "Please provide a title.", presenter: self)
            return
        }
        guard let desc = descField.text, !desc.isEmpty else {
            Util.alert(title: "Unable to post", message: "Please provide a description.", presenter: self)
            return
        }
        guard let tags = tagsField.text, !tags.isEmpty else {
            Util.alert(title: "Unable to post", message: "Please add at least one tag.", presenter: self)
            return
        }
        guard let price = Int(priceField.text ?? ""), price >= 0 else {
            Util.alert(title: "Unable to post", message: "Invalid price.", presenter: self)
            return
        }
        
        // write to cloud
        let request: Request = Request(title: title, desc: desc, tags: tags, startDate: startDate, endDate: endDate, price: price)
        Cloud.newRequest(request: request) { _ in
            self.requestsViewController?.update(with: request)
        }
        
        // return to Requests
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Instance variables
    
    var startDate: Date?
    var endDate: Date?
    
    var requestsViewController: RequestsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        tagsField.delegate = self
        priceField.delegate = self
        
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
