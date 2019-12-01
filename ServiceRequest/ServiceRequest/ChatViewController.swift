//
//  ChatViewController.swift
//  ServiceRequest
//
//  Created by Akhil Arun on 11/29/19.
//

import Foundation
import MessageKit
import UIKit
import InputBarAccessoryView

class ChatViewController : MessagesViewController {
    
    var chatID : String?
    private var messages: [Message] = []
    //private var member:!
  //  private var messageListener: ListenerRegistration?
    let refreshControl = UIRefreshControl()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("herecat")
        
        
      //  member = Member(name:"cat", color: .blue)
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        print(messages.count)
        loadMessages()
        print(messages.count)
        
        self.messagesCollectionView.reloadData()
       self.messagesCollectionView.scrollToBottom()


    }
    

    
    func loadMessages()
    {
        print("attempting to load with")
     
        Cloud.getChatDetails(chatID: chatID!) { (m) in
            DispatchQueue.main.async {
                
                print("inside here")
                print(m.count)
                
              //  self.messages = m
                
                for newM in m
                {

                    var add = true
                    for oldM in self.messages
                    {
                        if (newM.messageId  == oldM.messageId)
                        {
                            add = false
                        }
                        
                    }
                    if (add)
                    {
                         self.messages.append(newM)
                    }
                    
                }
                
                print(self.messages)
                self.messages = self.messages.sorted(by: { $0.sentDate.compare($1.sentDate) == .orderedAscending })
                
                print(self.messages.count)
                print(self.messages)
                
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom()
                
                self.syncMessages()
            }
        }
    }
    
    func syncMessages()
    {
        Cloud.syncChatDetails(chatID: chatID!) { (m) in
            DispatchQueue.main.async {
                for newM in m
                {
                    if (newM.sender.senderId != self.currentSender().senderId)
                    {
                        var add = true
                        for oldM in self.messages
                        {
                            if (newM.messageId  == oldM.messageId)
                            {
                                add = false
                            }
                            
                        }
                        if (add)
                        {
                             self.messages.append(newM)
                        }
                    }
                }
                
              //   self.messages = self.messages.sorted(by: { $0.sentDate.compare($1.sentDate) == .orderedAscending })
                //self.messages = self.messages.sorted(by: { $0.sentDate < $1.sentDate })
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom()
            }
        }
        
    }
    
    func insertMessage(_ message: Message) {
           messages.append(message)
        Cloud.insertMessage(chatID: chatID!, message: message);
           // Reload last section to update header/footer labels and insert a new one
           messagesCollectionView.performBatchUpdates({
               messagesCollectionView.insertSections([messages.count - 1])
               if messages.count >= 2 {
                   messagesCollectionView.reloadSections([messages.count - 2])
               }
           }, completion: { [weak self] _ in
               if self?.isLastSectionVisible() == true {
                   self?.messagesCollectionView.scrollToBottom(animated: true)
               }
           })
       }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
}

extension ChatViewController: MessagesDataSource {
    

    
    func currentSender() -> SenderType {
        let u = Cloud.getCurrentUser();
        
         return Sender(id: u.senderId, displayName: u.displayName);
        
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }

    

}

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 18
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 17
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = getAvatarFor(sender: message.sender)
        avatarView.set(avatar: avatar)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
           return isFromCurrentSender(message: message) ? .white : .darkText
       }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        //print(isFromCurrentSender(message: message))
        return isFromCurrentSender(message: message) ? UIColor.systemBlue : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
    
    
    func getAvatarFor(sender: SenderType) -> Avatar {
        let firstName = sender.displayName.components(separatedBy: " ").first
        let lastName = sender.displayName.components(separatedBy: " ").first
        let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
        switch sender.senderId {
        case "000001":
            return Avatar(image: #imageLiteral(resourceName: "Nathan-Tannar"), initials: initials)
        case "000002":
            return Avatar(image: #imageLiteral(resourceName: "Steven-Deutsch"), initials: initials)
        case "000003":
            return Avatar(image: #imageLiteral(resourceName: "Wu-Zhong"), initials: initials)
        case "000000":
            return Avatar(image: nil, initials: "SS")
        default:
            return Avatar(image: nil, initials: initials)
        }
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()

        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        
        print("inserting messages now")
        for component in data {
            if let str = component as? String {
                
                let u = Cloud.getCurrentUser();
                let size = messages.count
                let message = Message(text: str, user: u, messageId: UUID().uuidString, date: Date())
                self.insertMessage(message)
               
            } 
        }
    }

    
}


/*
extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: member.name, displayName: member.name)
    }
    
  func numberOfSections(
    in messagesCollectionView: MessagesCollectionView) -> Int {
    return messages.count
  }
  

  
  func messageForItem(
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> MessageType {
    
    return messages[indexPath.section]
  }
  
  func messageTopLabelHeight(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    
    return 12
  }
  
  func messageTopLabelAttributedText(
    for message: MessageType,
    at indexPath: IndexPath) -> NSAttributedString? {
    
    return NSAttributedString(
      string: message.sender.displayName,
      attributes: [.font: UIFont.systemFont(ofSize: 12)])
  }
}


extension ChatViewController: MessagesLayoutDelegate {
  func heightForLocation(message: MessageType,
    at indexPath: IndexPath,
    with maxWidth: CGFloat,
    in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    
    return 0
  }
}


extension ChatViewController: MessagesDisplayDelegate {
  func configureAvatarView(
    _ avatarView: AvatarView,
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) {
    
    let message = messages[indexPath.section]
    let color = message.member.color
    avatarView.backgroundColor = color
  }
}

extension ChatViewController: MessageInputBarDelegate {
  func messageInputBar(
    _ inputBar: MessageInputBar,
    didPressSendButtonWith text: String) {
    
    print("trying to send message")
    
    let newMessage = Message(
      member: member,
      text: text,
      messageId: UUID().uuidString)
      
    messages.append(newMessage)
    inputBar.inputTextView.text = ""
    messagesCollectionView.reloadData()
    messagesCollectionView.scrollToBottom(animated: true)
  }
}

*/

