//
//  ChatsViewController.swift
//  ServiceRequest
//
//  Created by Akhil Arun on 11/24/19.
//

import Foundation
import UIKit

class ChatsViewController: UITableViewController {
    
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
        Cloud.getChats { chats in
            self.chats = chats
            print("after method")
            print(chats.count)
            self.tableView.reloadData()
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatCell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        // get chat object
        let chat: Chat
       
        chat = chats[indexPath.row]
        // populate cell
        cell.other_user.text = chat.senderID
        cell.offer.text = chat.offerID

        return cell
    }






}

