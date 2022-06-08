//
//  ViewController.swift
//  ADTourism
//
//  Created by Administrator on 8/19/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit
import PKHUD
class ViewController: UIViewController,MainJsonDelegate,VPNManagerDelegate,UITextFieldDelegate {

    @IBOutlet weak var versionlbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var loginMessage: UILabel!
    @IBOutlet weak var password_view: UIView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var loginvIEW: UIView!
    @IBOutlet weak var vpnbtn: UIButton!

    var database = DatabaseManager()

    
    @IBOutlet weak var progreeview: UIProgressView!
    @IBOutlet weak var passwordlbl: UILabel!
    @IBOutlet weak var usernamelbl: UILabel!
    
    let userDefaults : UserDefaults = UserDefaults.standard
    
    var localisation : Localisation!

    var appDel : AppDelegate!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.appDel = UIApplication.shared.delegate! as! AppDelegate
        print("View will apear")
        if self.appDel.userDefault.object(forKey: "vpn_username") != nil {
            vpnbtn.setTitle("VPN Configured,Tap to edit", for:UIControlState())
            vpnbtn.setBackgroundImage(UIImage(), for: UIControlState())
            vpnbtn.backgroundColor = UIColor(red: 100/255, green: 193/255, blue: 244/255, alpha: 1.0)
            vpnbtn.layer.cornerRadius = 3.0
            
        }
        else {
            vpnbtn.setTitle("Setup VPN", for:UIControlState())
            vpnbtn.setBackgroundImage(UIImage(named:"vpn_btn"), for: UIControlState())
            //vpnbtn.backgroundColor = UIColor.grayColor()
            
            print("VPN NOT CONNECTED")
        }
        
    }
    
    func dataChanged() {
        print("View will apear")
        let userdefault = UserDefaults.standard
        
        if userdefault.object(forKey: "vpn_username") != nil {
            vpnbtn.setTitle("VPN Configured,Tap to edit", for:UIControlState())
            vpnbtn.setBackgroundImage(UIImage(), for: UIControlState())
            vpnbtn.backgroundColor = UIColor(red: 100/255, green: 193/255, blue: 244/255, alpha: 1.0)
            vpnbtn.layer.cornerRadius = 3.0
            
        }
        else {
            vpnbtn.setTitle("Setup VPN", for:UIControlState())
            vpnbtn.setBackgroundImage(UIImage(named:"newloginbtn"), for: UIControlState())
            //vpnbtn.backgroundColor = UIColor.grayColor()
            
            print("VPN NOT CONNECTED")
        }
        
    }

    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    @IBAction func setupVPN(_ sender: AnyObject) {
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "cnt_vpn") as! VPNViewController
        popoverVC.del  = self
        
        popoverVC.modalPresentationStyle = .formSheet
        present(popoverVC, animated: true, completion: nil)
        
    }

    @IBAction func configVPN(_ sender: UIButton) {
        
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "cnt_vpn") as! VPNViewController
        popoverVC.del  = self
        
        popoverVC.modalPresentationStyle = .formSheet
        present(popoverVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDel = UIApplication.shared.delegate! as! AppDelegate
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = ""
        UIApplication.shared.statusBarStyle = .lightContent
       // self.userText.becomeFirstResponder()
       
        

        
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }

        if Constants.mode == 0 {
        self.versionlbl.text = "PRO - \(Constants.versionNumber)"
        }
        else if Constants.mode == 1{
            self.versionlbl.text = "UAT - \(Constants.versionNumber)"
            
        }
        else {
            self.versionlbl.text = "QA - \(Constants.versionNumber)"
            
        }
        
        //self.loginMessage.text = localisation.localizedString(key: "login.i_loginmessage")
        self.loginbtn.setTitle(localisation.localizedString(key: "login.loginbtn"), for: UIControlState())
        
        
//        self.userText.attributedPlaceholder = NSAttributedString(string:localisation.localizedString(key: "login.username") + "",
//            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
//        self.passwordText.attributedPlaceholder = NSAttributedString(string:localisation.localizedString(key: "login.password"),
//            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
//
        self.usernamelbl.text = localisation.localizedString(key: "login.username")
        
        self.passwordlbl.text = localisation.localizedString(key: "login.password")
            
            
        self.title = ""
        
        
               self.navigationController?.setNavigationBarHidden(false, animated: true)
       // self.password_view.backgroundColor = UIColor(patternImage: UIImage(named: "password_tab")!)

     //   self.usernameView.backgroundColor = UIColor(patternImage: UIImage(named: "password_tab")!)

       // self.appDel.showIndicator = 1

        
        // Do any additional setup after loading the view, typically from a nib.
        loginvIEW.layer.cornerRadius = 5.0
    }

    @IBAction func loginMethod(_ sender: AnyObject) {
       
        if self.userText.text == "" || self.passwordText.text == "" {
            let message = SCLAlertView()
            message.showError(localisation.localizedString(key: "general.error"), subTitle:localisation.localizedString(key: "login.checkusername"), closeButtonTitle:localisation.localizedString(key: "general.yes"))
            
            message.shouldAutoDismiss = true
            self.activityIndicator.stopAnimating()
            return
        }
        
        if Reachability.connectedToNetwork(){
            self.activityIndicator.startAnimating()
           
      // let loginUrl = Constants.baseURL + "loginInspector?username=" + userText.text! + "&password=" + passwordText.text!
        let loginUrl = Constants.baseURL + "loginInspector"
            print(loginUrl)
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
          
       downloader.loginPost(Util.encryptPassword(password: passwordText.text!), _username: Util.encryptPassword(password: userText.text!), url: loginUrl, ide: "login")
        //downloader.startDownloader(loginUrl, idn: "login")
            
        }
        else {
           // println("No Internet connection")
            if userDefaults.object(forKey: "username") != nil {
          let username = self.userDefaults.object(forKey: "username") as? String
          //let user_id = self.userDefaults.object(forKey: "user_id") as? String
          let password = self.userDefaults.object(forKey: "password") as? String
          //let user_name = self.userDefaults.object(forKey: "inspector_name") as? String
                if self.userText.text == username && password == self.passwordText.text
                {
                let newUser = UserDao()
                   newUser.user_id = self.userDefaults.object(forKey: "user_id") as! String
                    newUser.username = self.userDefaults.object(forKey: "username") as! String
                   newUser.firstname = self.userDefaults.object(forKey: "firstname") as! String
                //    newUser.lastname = self.userDefaults.objectForKey("lastname") as! String
                    newUser.categories = self.userDefaults.object(forKey: "categories") as? String
                    newUser.status = self.userDefaults.object(forKey: "status") as? String
                    newUser.job_title = self.userDefaults.object(forKey: "job_title") as? String
                    newUser.email = self.userDefaults.object(forKey: "email") as? String
                    newUser.shift = self.userDefaults.object(forKey: "shift") as? String
                    newUser.contactno = self.userDefaults.object(forKey: "contactno") as? String
                    newUser.hosName = self.userDefaults.object(forKey: "hosname") as? String
                    newUser.hosMobileNo = self.userDefaults.object(forKey: "hosmobile") as? String
                    newUser.employee_id = self.userDefaults.object(forKey: "employee_id") as? String
                    
                    self.appDel.user = newUser
                    self.performSegue(withIdentifier: "sw_login", sender: nil)

                    
          
                    

                }
            } // end of the if
            else {
                let alert = UIAlertController(title: localisation.localizedString(key: "general.checkinternet"), message: "", preferredStyle: UIAlertControllerStyle.alert)
                let alertAction = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func downloadSubVenues(){
        if Reachability.connectedToNetwork() {
            let downloader  = DataDownloader()
            downloader.delegate = self
            self.appDel.showIndicator = 0
            
            downloader.startDownloader(Constants.baseURL + "getSubVenueListing", idn: "subvenues")
            
        }
    }
    func downloadAllDump(){
        if Reachability.connectedToNetwork() {
            DispatchQueue.main.async {
                self.progreeview.isHidden = false
                self.progreeview.progress = 0.10
            }
            
            let downloader  = DataDownloader()
            downloader.delegate = self
            self.appDel.showIndicator = 0
            
            downloader.startDownloader(Constants.baseURL + "getCompaniesActivityDump", idn: "dump")
            
            
            
        }
        
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
       let dataString = NSString(data: data as Data, encoding:String.Encoding.utf8.rawValue)
   
        if identity == "login" {
       print(dataString)
       
            
  
        let parser : JsonParser = JsonParser()
        let user : UserDao  = parser.parseLoginData(data)
        //print(user.response)
        if user.response == nil {
        print("Response is nil", terminator: "")
//            let alert : UIAlertController = UIAlertController(title: localisation.localizedString(key: "general.error"), message: localisation.localizedString(key: "general.checkinternet"), preferredStyle: UIAlertControllerStyle.Alert)
//            let action1 : UIAlertAction = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.Cancel, handler: nil)
//            alert.addAction(action1)
//            self.presentViewController(alert, animated: true, completion: nil)
//            
            SCLAlertView().showError(localisation.localizedString(key: "general.error"), subTitle:localisation.localizedString(key: "general.checkinternet"), closeButtonTitle:localisation.localizedString(key: "general.yes"))
            self.activityIndicator.stopAnimating()

           // SCLAlertView().addButton(<#T##title: String##String#>, action: <#T##() -> Void#>)
            return
        
        }
        if user.response == "error"{
//            let alert : UIAlertController = UIAlertController(title: localisation.localizedString(key: "general.error"), message: localisation.localizedString(key: "login.checkusername"), preferredStyle: UIAlertControllerStyle.Alert)
//            let action1 : UIAlertAction = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.Cancel, handler: nil)
//            alert.addAction(action1)
//            self.presentViewController(alert, animated: true, completion: nil)
//            
            
            let message = SCLAlertView()
            message.showError(localisation.localizedString(key: "general.error"), subTitle:localisation.localizedString(key: "login.checkusername"), closeButtonTitle:localisation.localizedString(key: "general.yes"))
            
            message.shouldAutoDismiss = true
            self.activityIndicator.stopAnimating()

            
        }
      
            
        else {
            self.appDel.fromLogin = 1
            
            self.appDel.user =  user
            self.userDefaults.set(user.user_id, forKey: "user_id")
            self.userDefaults.set(user.username, forKey: "username")
            self.userDefaults.set(passwordText.text, forKey: "password")
            self.userDefaults.set(user.firstname, forKey: "firstname")
            self.userDefaults.set(user.lastname, forKey: "lastname")
            self.userDefaults.set(user.categories, forKey: "categories")
            self.userDefaults.set(user.status, forKey: "status")
            self.userDefaults.set(user.job_title, forKey: "job_title")
            self.userDefaults.set(user.email, forKey: "email")
            self.userDefaults.set(user.shift, forKey: "shift")
            self.userDefaults.set(user.contactno, forKey: "contactno")
            self.userDefaults.set(user.hosName, forKey: "hosname")
            self.userDefaults.set(user.hosMobileNo, forKey: "hosmobile")
            self.userDefaults.set(user.employee_id, forKey: "employee_id")
            self.userDefaults.set(user.inactive_notes, forKey: "inactive_notes")
            self.userDefaults.set(user.categories, forKey: "categories")
            if user.configDao != nil {
            self.userDefaults.set(user.configDao!, forKey: "config")
            }
            
            //newUser.categories = self.userDefaults.objectForKey("categories") as? String
            
            if self.database.isCompaniesAddedAlready() {
                self.performSegue(withIdentifier: "sw_logintotask", sender: nil)

            }
            else {
                self.downloadAllDump()
            //self.performSegueWithIdentifier("sw_logintotask", sender: nil)
            }

            
        }
            } // end of the login conditions
        else if identity == "subvenues" {
        self.database.deleteSubVeneues()
        let parser : JsonParser = JsonParser()
       // let str = String(data: data, encoding: NSUTF8StringEncoding)
       //  print(str)
        let venueArray = parser.parseSubVenues(data)
        self.database.addSubvenues(venueArray)
         self.performSegue(withIdentifier: "sw_logintotask", sender: nil)
        }
            
        else if identity == "dump" {
             OperationQueue.main.addOperation({
            self.progreeview.progress = 0.5
            
            })
            print(" \n dump downloaded")
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            print(str ?? "")
            let parser = JsonParser()
            DispatchQueue.main.async {
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                PKHUD.sharedHUD.show()
                PKHUD.sharedHUD.dimsBackground = true
            }
            let array = parser.parseCompanies(data)
            let activityCodeArray = parser.parseActivityCodes(data)
            let categoryArray = parser.parseCategories(data)
            let catActArray = parser.parseCatActCodes(data)
            let catCompArray = parser.parseCompanyActCodes(data)
            let mainInspectionList = parser.parseMainInspectionList(data)
            let questionCategories = parser.parseQuestionsCategories(data)
            var questionsArray : NSMutableArray = NSMutableArray()
            
             questionsArray = parser.parseQuestionsForOffline(data)
           
           

            
            //let catCompanyArray = parser.pa
           
            self.database.deleteAllCompanies()
            self.database.deleteAllActivityCodes()
            self.database.deleteAllCatAct()
            self.database.deleteAllCatCompany()
            self.database.deleteAllMainInspectionList()
            self.database.deleteAllQuestion()
            self.database.deleteAllOptions()
            self.database.deleteAllExtraOptions()
            self.database.deleteAllQuestionCategories()
            
         OperationQueue.main.addOperation({
            self.progreeview.progress = 0.6
            })
            
            
            self.database.addCompanies(array)
            OperationQueue.main.addOperation({

            self.progreeview.progress = 0.65
            })
            
                
            self.database.addActivityCode(activityCodeArray)
            self.database.addCatActCodes(catActArray)
            self.database.addInspectionListMain(mainInspectionList)
            self.database.addInspectionList(questionsArray, taskid: "0")
            self.database.addCategories(questionCategories: questionCategories)
            OperationQueue.main.addOperation({

            self.progreeview.progress = 0.70
            })
            
            //self.database.addInspectionList(allQuestions, taskid: "0")
            
            
            //    print(self.database.getActivityCodes())
            self.database.deleteAllCategories()
            //print("adding category \(categoryArray.count)")
            self.database.addCategories(categoryArray)
            self.database.addCatCompanyCodes(catCompArray)
            OperationQueue.main.addOperation({
            self.progreeview.progress = 0.90
            })
            
           // print("All Main List \(self.database.fetchAllInspectionMainListAll())")
           // print("categories \(self.database.getCategories())")
            //PKHUD.sharedHUD.hide(animated: true)
           
            self.activityIndicator.stopAnimating()
             self.downloadSubVenues()
            //self.performSegueWithIdentifier("sw_logintotask", sender: nil)
            
            
            //  print("Act Categiry \(self.database.getCatActCodes())")
            //  print("addCatCompanyCodes \(self.database.getCatCompanyCodes())")
            //self.setupQuestionsDownload()
        }

        
        
        
            
            
            }
    
}

