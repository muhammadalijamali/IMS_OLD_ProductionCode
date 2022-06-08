//
//  ChatViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 10/31/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MainJsonDelegate,UITextFieldDelegate,UserSelectedDelegate {

    @IBAction func chatUserMethod(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "sw_showchatusers", sender: nil)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBOutlet weak var chatuserbtn: UIButton!
    @IBOutlet weak var chatTitle: UILabel!
        @IBOutlet weak var topbar: UIView!
    @IBOutlet weak var tabletopcons: NSLayoutConstraint!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var previouslbl: UILabel!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var chattable: UITableView!
    let userDefaults : UserDefaults = UserDefaults.standard

    var chatUser : ChatUsers?
    var localisation : Localisation?
    
    var start : Int = 0
    var limit : Int = 50
    var increment = 50
    var total : Int = 0
    var refreshControl = UIRefreshControl()
    
    var chatdownloadTimer : Timer?
    var shouldScrollDown : Int = 1
    
    
    var totalMessage: NSMutableArray = NSMutableArray()
    let del : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var chatTextField: UITextField!
    
    
    @IBAction func toggleMethod(_ sender: AnyObject) {
 self.revealViewController().revealToggle(animated: true)
        
    }
    func userSelected(_ user: ChatUsers) {
        self.chatUser = user
        //self.tit
           start  = 0
         limit  = 50
        increment = 50
        total  = 0
        self.totalMessage = NSMutableArray()
        self.chatuserbtn.isHidden = true
        self.userDefaults.setValue(self.chatUser?.user_name!, forKey: "chat_username")
        self.userDefaults.setValue(self.chatUser!.user_id!, forKey: "chat_userid")
        self.userDefaults.setValue(self.chatUser!.type!, forKey: "chat_type")
        self.userDefaults.synchronize()
        
       
        self.chatTitle.text =  self.chatUser!.type! + " - " + self.chatUser!.user_name!
        
        self.setupChatDownloader()
    }
    
    
    @IBAction func showAllUsers(_ sender: UIButton) {
    //cnt_chatusers
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        if segue.identifier! == "sw_showchatusers" {
        
            let controller = segue.destination as! UsersViewController
            controller.del = self
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func setupChatDownloader(){
        if Reachability.connectedToNetwork() {
            if self.chatUser != nil {
            self.del.showIndicator = 0
        let loginUrl = "\(Constants.baseURL)getChatHistory?inspectorID=\(self.del.user.user_id!)&start=\(self.start)&limit=\(self.limit)&userID=\(self.chatUser!.user_id!)&type=\(self.chatUser!.type!)"
            
        
        print(loginUrl)
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "chat")
            }
            else {
                let alert = SCLAlertView()
                alert.checkCircleIconImage(UIImage(named:"users"), defaultImage: UIImage(named:"users")!)
                alert.showCloseButton = false
                alert.addButton("Dismiss", action: {
                
                })
                self.refreshControl.endRefreshing()
                
                
                
                alert.showError("", subTitle: self.localisation!.localizedString(key: "chat.selectuser"))
                
                    
                //SCLAlertView().showError("", subTitle: "Select user to start chat")
            
                
            }
        }
        
        
        
    }
       /*
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    print(textField.text)
        if textField.text != "" {
        //self.sendBtn.setImage(UIImage(named:"chat_sendac"), forState: UIControlState.Normal)
            
        self.sendBtn.setBackgroundImage(UIImage(named:"chat_sendac"), forState: UIControlState.Normal)
        }
        else {
           
            self.sendBtn.setBackgroundImage(UIImage(named:"chat_sendin"), forState: UIControlState.Normal)
            
        }
    return true
    }
 */
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        
        if identity == "chat" {
            
        let jsonParser = JsonParser()
             self.totalMessage = jsonParser.parseChat(data)
           
                if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
                }
            
            if totalMessage.count == 0 {
                self.previouslbl.isHidden = false
                self.previouslbl.text = "No previous conversation found"
                 self.chattable.reloadData()
            return
            }
            else {
                self.previouslbl.isHidden = true
            }
             self.chattable.reloadData()
            if shouldScrollDown == 1 {
            let indexPath = IndexPath(row: totalMessage.count - 1, section: 0)
            self.chattable.scrollToRow(at: indexPath, at: .bottom, animated: false)
            self.chattable.layoutIfNeeded()
            }
            
            /*
            if self.shouldScrollDown == 1 {
            
                self.totalMessage = jsonParser.parseChat(data)
                
                
                
                if totalMessage.count == 0 {
                    self.previouslbl.hidden = false
                }
                else {
                    self.previouslbl.hidden = true
                }
                let str = String(data: data, encoding: NSUTF8StringEncoding)
                print(str)
                self.chattable.reloadData()
                
                
            }
            else {
            
            
            self.totalMessage.addObjectsFromArray(jsonParser.parseChat(data) as [AnyObject])
            if totalMessage.count == 0 {
            self.previouslbl.hidden = false
            }
            else {
            self.previouslbl.hidden = true
            }
            let str = String(data: data, encoding: NSUTF8StringEncoding)
            print(str)
            self.chattable.reloadData()
            if self.shouldScrollDown == 1 {
            print("Scroll Down == 1")
            let indexPath = NSIndexPath(forRow: totalMessage.count - 1, inSection: 0)
            self.chattable.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
            self.chattable.layoutIfNeeded()
                }
            }
 */
            
            
        }
        else if identity == "send"{
           // let str = String(data: data, encoding: NSUTF8StringEncoding)
            //print(str)
            self.chatTextField.text = ""
        self.setupChatDownloader()
        }
        
    }
    func sendMessage(){
        print("self.del.chatuser \(self.del.chatUser?.user_name)")
        if Reachability.connectedToNetwork() {
            if self.del.chatUser != nil {
            let loginUrl = Constants.baseURL + "sendMessageToAdmin"
            
            print(loginUrl)
            
            self.shouldScrollDown = 1
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            //downloader.startDownloader(loginUrl, idn: "send")
            downloader.sendPostMessage("send", url: URL(string: loginUrl)!, message: self.chatTextField.text!)
            }
            else {
                SCLAlertView().showError("Select User", subTitle:"Please select user to start chat!", closeButtonTitle:"Dismiss")
                self.chatTextField.resignFirstResponder()
                
            }
        }
        
        

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalMessage.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = self.totalMessage.object(at: indexPath.row) as! ChatDao
        if chat.total_records != nil {
        self.total = Int(chat.total_records!)!
        }
        if chat.senderID == self.del.user.user_id {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_mychat") as! MyChatTableViewCell
            cell.mychatlbl.text = ""
            cell.mydateTimelbl.text = ""
            //cell.yourchatlbl.text = ""
            //cell.yourDatetimelbl.text = ""
            
            cell.mychatlbl.text = chat.message
            cell.coloredBackground.layer.cornerRadius = 4.0
            cell.mydateTimelbl.text = chat.messageDateTime
            
            return cell
            
        }
        else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_yourchat") as! MyChatTableViewCell
            //cell.mychatlbl.text = ""
            //cell.mydateTimelbl.text = ""
            cell.yourchatlbl.text = ""
            cell.yourDatetimelbl.text = ""
            
            
            cell.yourchatlbl.text = "\(chat.senderName!):\(chat.message!)"
            cell.coloredBackground.layer.cornerRadius = 4.0
            cell.yourDatetimelbl.text = chat.messageDateTime
            
        return cell
        }
        
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       /*
        if indexPath.row == 0 {
            print("Total \(total) Array\(self.totalMessage.count)")
            if total > self.totalMessage.count {
             self.start = self.limit
             self.limit = self.limit + self.increment
             self.setupChatDownloader()
                print("000000000")
            }
            
        }
        else if indexPath.row == self.totalMessage.count - 1        {
            self.start = 0
            self.limit = 50
            self.totalMessage = NSMutableArray()
          
            self.setupChatDownloader()
          

        }
 */
        /*
        print(indexPath.row)
        
        if indexPath.row >= self.totalMessage.count - 4   {
        self.shouldScrollDown = 1
        }
       */
        
    }
    
    @objc func keybaordDidShow(_ notification: Notification){
       
        if UIDevice.current.userInterfaceIdiom == .pad {
    self.bottomConst.constant = 330
    self.tabletopcons.constant = -250
        }
        else {
            self.bottomConst.constant = 240
            self.tabletopcons.constant = -200
            
            
        }
     self.view.layoutIfNeeded()
     self.view.setNeedsLayout()
    }
    @objc func keybaordDidHide(_ notification: Notification){
      if UIDevice.current.userInterfaceIdiom == .pad {
        self.bottomConst.constant = 0
        self.tabletopcons.constant = 55
        }
      else {
        self.bottomConst.constant = 0
        self.tabletopcons.constant = 8
        
        }
        self.view.layoutIfNeeded()
    }
    
    
    @IBAction func sendMethod(_ sender: UIButton) {
        if chatTextField.text != "" {
        self.sendMessage()
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear")
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if self.chatdownloadTimer != nil {
        self.chatdownloadTimer?.invalidate()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chattable.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
        self.chatTextField.delegate = self
        self.localisation = Localisation()
        if self.del.selectedLanguage == 1{
            self.localisation!.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation!.setPreferred("ar", fallback: "en")
        }
        /*
        totalMessage.addObject("")
        totalMessage.addObject("")
        totalMessage.addObject("")
        totalMessage.addObject("")
        */
        
    //    NotificationCenter.default.addObserver(self, selector: #selector(keybaordDidShow), name: .UIKeyboardWillShow, object: nil)
        
        //NotificationCenter.default.addObserver(self, selector:#selector(keybaordDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
     //    NotificationCenter.default.addObserver(self, selector:#selector(keybaordDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(YourClassName.methodOfReceivedNotification(_:)), name:"NotificationIdentifier", object: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.bringSubview(toFront: self.topbar)
        //self.setupChatDownloader()
        self.chatTitle.text = localisation?.localizedString(key: "chat.chat")
        
        
        if userDefaults.value(forKey: "chat_username") != nil {
        let chat = ChatUsers()
            chat.user_id = userDefaults.object(forKey: "chat_userid") as? String
            
            chat.user_name = userDefaults.object(forKey: "chat_username") as? String
            chat.type = userDefaults.object(forKey: "chat_type") as? String
            self.chatUser = chat
            self.chatTitle.text = chat.type! + " - " + chat.user_name!
            self.del.chatUser = chat
            
        }
        if self.chatUser == nil {
        self.chatuserbtn.isHidden = false
        self.previouslbl.text = self.localisation?.localizedString(key: "chat.selectuser")
            
            
        }
        else {
            self.chatuserbtn.isHidden = true
            //self.previouslbl.text = "No previous conversation found"
            self.previouslbl.isHidden = true
            
        }
        self.chatdownloadTimer = Timer.scheduledTimer(timeInterval: 02, target: self, selector: #selector(ChatViewController.chatDownloadTimer), userInfo: nil, repeats: true)
        
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        
        
        _ = notificationCenter.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.chatTextField, queue: mainQueue) { _ in
            if self.chatTextField.text != "" {
                //self.sendBtn.setImage(UIImage(named:"chat_sendac"), forState: UIControlState.Normal)
                
                self.sendBtn.setImage(UIImage(named:"chat_sendac"), for: UIControlState())
            }
            else {
                
                self.sendBtn.setImage(UIImage(named:"chat_sendin"), for: UIControlState())
                
            }
            

            
        }
        
        refreshControl = UIRefreshControl()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to load more")
        refreshControl.addTarget(self, action: #selector(ChatViewController.refresh(_:)), for: UIControlEvents.valueChanged)
//        if #available(iOS 11.0, *) {
//            // use UIStackView
//        chattable.refreshControl = refreshControl
//        } else {
//            // show sad face emoji
//            self.chattable.addSubview(refreshControl) // not required when using UITableViewController
//            
//        }
        
        
        if #available(iOS 10.0, *) {
            chattable.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            self.chattable.addSubview(refreshControl)
        }

    
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keybaordDidShow(Notification(name: .UIKeyboardWillShow))
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.keybaordDidHide(Notification(name: .UIKeyboardWillHide))
    }
    @objc func chatDownloadTimer(){
        if Reachability.connectedToNetwork() && self.chatUser != nil {
            self.del.showIndicator = 0
            self.shouldScrollDown = 0
            let loginUrl = "\(Constants.baseURL)getChatHistory?inspectorID=\(self.del.user.user_id!)&start=\(self.start)&limit=\(self.limit)&userID=\(self.chatUser!.user_id!)&type=\(self.chatUser!.type!)"

            
            
            print(loginUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "chat")
            
        }
        
        

        
    }
    @objc func refresh(_ sender : UIRefreshControl){
    print("refresh called")
        self.start = 0
        self.limit = self.limit + self.increment
        self.shouldScrollDown = 0
        
        self.setupChatDownloader()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
