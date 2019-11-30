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
        
        let currentU = Cloud.getCurrentUser()
        
        if (chat.senderID == currentU.id)
        {
            Cloud.getUserName(id: chat.receiverID) { (name) in
                cell.other_user.text = name
            }
            
        }
        else
        {
            Cloud.getUserName(id: chat.senderID) { (name) in
                           cell.other_user.text = name
                       }
        }
        
        Cloud.getRequestTitle(id: chat.requestID) { (title) in
            cell.offer.text = title
        }
        

        return cell
    }
    
    var newChatID : String?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("gooing nn")
        newChatID = chats[indexPath.row].chatID
        
        print(newChatID)
        
        self.performSegue(withIdentifier: "chatDetail", sender: self)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.destination is ChatViewController
         {
               let vc = segue.destination as! ChatViewController
               vc.chatID = newChatID
            print("new chat")
            print(vc.chatID)
                   
        }
    }
    






}

