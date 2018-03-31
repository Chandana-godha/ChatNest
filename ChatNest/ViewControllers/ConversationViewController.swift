import UIKit
import Firebase

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var msgTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var totalChatView: UIView!
    var selectedUser: User?
    let sname  = " "
    var room: Room? {
        didSet {
            let roomsRef: DatabaseReference = Database.database().reference().child("rooms")
            let roomRef = roomsRef.child(room!.id)
            messageRef = roomRef.child("messages")
            observeMessages()
            title = room?.name
        }
    }
    
    let databaseRef = Database.database().reference(fromURL: "https://chatnest-e0d5a.firebaseio.com/")
    var roomRef : DatabaseReference?
    let userId = Auth.auth().currentUser?.uid
    let userName = Auth.auth().currentUser?.displayName
    
    private var messages : [Message] = []
    private var messageRef: DatabaseReference?
    private var messagesRefHandle: DatabaseHandle?
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //To eliminate the seperators of the UITableView
        self.chatTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        NSLog("Finished loading")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        msgTextField.resignFirstResponder()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
        cell.message.text = messages[indexPath.row].text
        cell.senderNameLabel.text = messages[indexPath.row].senderName 
        return cell
        
    }
   
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        msgTextField.resignFirstResponder()
        return true
    }
    
    // to send a message
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.msgTextField.resignFirstResponder()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        NSLog("Message added")
        let messages = msgTextField.text
        let newMessageRef = messageRef!.childByAutoId()
        if let userID = Auth.auth().currentUser?.uid{
            databaseRef.child("users").child(userID).child("credentials").observe(.value, with: { (snapshot) in
                
                //create a dictionary of users profile data
                let values = snapshot.value as? NSDictionary
                
                let senderName = values?["name"] as? String
        let messageItem = [
            "text" : messages as Any,
            "timestamp" : ServerValue.timestamp(),
            "date": String(),
            "senderName": senderName
            ] as [String : Any]
        
        newMessageRef.setValue(messageItem)
        self.msgTextField.text = ""
        
    }
            )}
    }
    
    
    
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            totalChatView.frame.origin.y -= keyboardSize.height
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            totalChatView.frame.origin.y = 0
            
        }
    }
    
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.chatTableView.contentInset.bottom = height
            self.chatTableView.scrollIndicatorInsets.bottom = height
            if self.messages.count > 0 {
                self.chatTableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    
    private func observeMessages() {
        // We can use the observe method to listen for new
        // messages being written to the Firebase DB
        
        NSLog("observe messages function entry")
        
        messagesRefHandle = messageRef!.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! NSDictionary
            let id = snapshot.key
            if let text = messageData["text"] as! String!, let senderName = messageData["senderName"] as! String!, let timestamp = messageData["timestamp"] as! Double!, let date = messageData["date"] as! String!, text.count > 0 {
                let converted = NSDate(timeIntervalSince1970: timestamp / 1000)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = NSTimeZone.local
                dateFormatter.dateFormat = "hh:mm"
                let date = dateFormatter.string(from: converted as Date)
                NSLog("\(date)")
                NSLog("\(senderName)")
                self.messages.append(Message(mId: id, text: text, timestamp: timestamp, date: date, senderName: senderName))
                self.chatTableView.reloadData()
            }
            else {
                print("Error! Couldn't load messages")
            }
            
        })
        
    }
    
}
