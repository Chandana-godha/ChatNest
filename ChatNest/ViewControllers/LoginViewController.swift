import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var loginMainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var loginView: UIView!
    @IBOutlet var waringLabels: [UILabel]!
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    @IBOutlet var inputFields: [UITextField]!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var errorFlag = false
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    //MARK: Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for item in self.waringLabels {
            item.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func login(_ sender: Any) {
        
        inputValidation()
        if(errorFlag != true) {
            self.showLoading(state: true)
            for item in self.inputFields {
                item.resignFirstResponder()
            }
            
            
            UserManager.loginUser(withEmail: self.loginEmailField.text!, password: self.loginPasswordField.text!) { [weak weakSelf = self](status) in
                DispatchQueue.main.async {
                    weakSelf?.showLoading(state: false)
                    for item in self.inputFields {
                        item.text = ""
                    }
                    if status == true {
                        print("signed in")
                        
                        let loginvc = UIStoryboard(name: "ChatRooms", bundle: nil).instantiateViewController(withIdentifier: "chatrooms") as! TableViewController
                        let navigationController = UINavigationController(rootViewController: loginvc)
                        self.present(navigationController, animated: true, completion: nil)
                        
                    }
                    else {
                        for item in (weakSelf?.waringLabels)! {
                            item.isHidden = false
                            item.text = "Wrong input parameters, please try again"
                            self.loginView.alpha = 1
                            self.loginView.isUserInteractionEnabled = true
                        }
                    }
                    weakSelf = nil
                }
            }
        }
    }
    
    func showLoading(state: Bool)  {
        if state {
            loginView.alpha = 0.5
            loginView.isUserInteractionEnabled = false
            for item in waringLabels {
                item.isHidden = true
            }
            self.spinner.startAnimating()
        } else {
            self.spinner.stopAnimating()
        }
    }
    
    //To check if email address is valid
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    
    //InputValidation
    func inputValidation()
    {
        let isEmailValid = isValidEmailAddress(emailAddressString:loginEmailField.text!)
        errorFlag = false
        if(self.loginPasswordField.text!.count == 0)
        {
            errorFlag = true
            for item in waringLabels {
                item.isHidden = false
                item.text = "Please enter your password"
                self.loginPasswordField.becomeFirstResponder()
            }
        }
        if(isEmailValid != true)
        {
            errorFlag = true
            for item in waringLabels {
                item.isHidden = false
                item.text = "Email address is not valid"
                self.loginEmailField.becomeFirstResponder()
            }
        }
        if(self.loginEmailField.text!.isEmpty)
        {
            errorFlag = true
            for item in waringLabels {
                item.isHidden = false
                item.text = "Please enter your email id"
                self.loginEmailField.becomeFirstResponder()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
            loginEmailField.text = "anu@gmail.com"
            loginPasswordField.text = "anu123"
        #endif

        self.loginMainView.addSubview(loginView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        loginMainView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       self.loginView.isUserInteractionEnabled = true
       self.loginView.alpha = 1
        
    }
    
    //add method to handle tap event on the view and dismiss keyboard
    @objc func didTapView(gesture: UITapGestureRecognizer)
    {
        self.loginMainView.endEditing(true)
    }
    
    //add observers for UIkeyboard will show and UIkeyboard will hide notification
    func addObservers(){
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil)
        {
            notification in self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil)
        {
            notification in self.keyboardWillHide(notification: notification)
        }
    }
    
    //add method to handle keyboardwillshow
    func keyboardWillShow(notification: Notification)
    {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0,left: 0,bottom: frame.height,right:0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification)
    {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func removeObservers()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    //unwinding to login from profile view
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) {
        
    }
    
}
