class Message {
    var mId: String
    var text: String
    var timestamp: Double
    var date: String
    var senderName: String
    
    init(mId: String, text: String, timestamp: Double, date: String, senderName: String) {
        self.mId = mId
        self.text = text
        self.timestamp = timestamp
        self.date = date
        self.senderName = senderName
    }
}
