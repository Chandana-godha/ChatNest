import Foundation
import Firebase

class MessageManager {
    
    func downloadAllMessages(forChatroomID: String, completion: @escaping (Message) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("rooms").child(forChatroomID).child("messages").observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: String]
                    let mid = snapshot.key
                    let content = data["text"] as! String
                    let fromID = data["senderID"] as! String
                    let timestamp = data["timestamp"] as! Double
                    if fromID == currentUserID {
                        let message = Message.init(mId: mid, text: content, timestamp: timestamp, senderName: fromID)
                        completion(message)
                    } else {
                        let message = Message.init(mId: mid, text: content, timestamp: timestamp, senderName: fromID)
                        completion(message)
                    }
                }
            })
        }
    }
}
