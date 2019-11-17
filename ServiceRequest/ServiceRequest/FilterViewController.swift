//
//  FilterViewController.swift
//  ServiceRequest
//
//  Created by Michelle Ran on 11/6/19.
//

import Foundation
import UIKit

class FilterViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - UI
    
    @IBOutlet var tagsField: UITextField!
    @IBOutlet var minPriceField: UITextField!
    @IBOutlet var maxPriceField: UITextField!
    
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
    
    @IBAction func apply() {
        // validate min, max price
        var minPrice: Int = 0
        if let min = minPriceField.text {
            guard let minParsed = Int(min), minParsed >= 0 else {
                Util.alert(title: "Unable to filter", message: "Invalid price.", presenter: self)
                return
            }
            minPrice = minParsed
        }
        var maxPrice: Int = Int.max
        if let max = maxPriceField.text {
            guard let maxParsed = Int(max), maxParsed >= 0 else {
                Util.alert(title: "Unable to filter", message: "Invalid price.", presenter: self)
                return
            }
            maxPrice = maxParsed
        }
        if minPrice > maxPrice {
            Util.alert(title: "Unable to filter", message: "Invalid price range.", presenter: self)
            return
        }
        
        // validate start, end date
        if let start = startDate, let end = endDate, start.compare(end) == .orderedDescending {
            Util.alert(title: "Unable to filter", message: "Invalid date range.", presenter: self)
            return
        }
        
        requestsViewController?.applyFilters(tags: tagsField.text, minPrice: minPrice, maxPrice: maxPrice, startDate: startDate, endDate: endDate)
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
        tagsField.delegate = self
        minPriceField.delegate = self
        maxPriceField.delegate = self
        
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

