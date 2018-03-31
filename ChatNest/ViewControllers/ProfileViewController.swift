import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profilePic: RoundedImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    let storageRef = Storage.storage().reference(forURL: "gs://chatnest-e0d5a.appspot.com/")
    let databaseRef = Database.database().reference(fromURL: "https://chatnest-e0d5a.firebaseio.com/")
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func logOut(_ sender: Any) {
        
        UserManager.logOutUser { (status) in
            if status == true {
                print("LOGGED OUT")
                self.performSegue(withIdentifier: "unwindSegueToLogin", sender: self)
                
            }
        }
    }
    @IBAction func update(_ sender: Any) {
        
        updateUsersProfile()
    }
    
    func loadProfileData(){
        //if the user is logged in get the profile data
        if let userID = Auth.auth().currentUser?.uid{
            databaseRef.child("users").child(userID).child("credentials").observe(.value, with: { (snapshot) in
                
                //create a dictionary of users profile data
                let values = snapshot.value as? NSDictionary
                
                //if there is a url image stored in photo
                if let profileImageURL = values?["profilePicLink"] as? String{
                    //using sd_setImage load photo
                    self.profilePic.sd_setImage(with: URL(string: profileImageURL), placeholderImage: UIImage(named: "default profile"))
                }
                
                self.nameTextField.text = values?["name"] as? String
                
            })
            
        }
    }
    
    func updateUsersProfile(){
        //check to see if the user is logged in
        if let userID = Auth.auth().currentUser?.uid{
            guard let newUserName  = self.nameTextField.text else {return}
            
            let newValuesForProfile =
                ["name": newUserName]
            
            //update the firebase database for that user
            self.databaseRef.child("users").child(userID).child("credentials").updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                if error != nil{
                    print(error!)
                    return
                }
                print("Profile Successfully Update")
            })
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(profileView)
        loadProfileData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
