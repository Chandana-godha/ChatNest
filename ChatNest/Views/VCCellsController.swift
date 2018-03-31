import Foundation
import UIKit

class VCCellsController: UITableViewCell{
    
}
class SenderCell: UITableViewCell {
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var senderNameLabel: UILabel!
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
    }
}

class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var message: UITextView!
    
    func clearCellData()  {
        self.message.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
    }
}

