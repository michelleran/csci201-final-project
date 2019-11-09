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
        if (titleField.text ?? "").isEmpty || descField.text.isEmpty || (tagsField.text ?? "").isEmpty || (priceField.text ?? "").isEmpty
        {
            let alertController = UIAlertController(title: "Unable to post", message:
                "Please fill out all required fields.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        // TODO: save request to Firebase (and get generated id)
        requestsViewController?.update(with: Request(id: "something", title: titleField.text!, desc: descField.text, tags: tagsField.text!, startDate: startDate, endDate: endDate, price: Int(priceField.text!) ?? 0))
        
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
