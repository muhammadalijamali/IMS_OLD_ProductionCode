//
//  ProfileViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 4/18/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController , MainJsonDelegate , UITextFieldDelegate{
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var hosmobile: UILabel!
    @IBOutlet weak var hosname: UILabel!
    @IBOutlet weak var hosdetail: UILabel!
    @IBOutlet weak var employeeidlbl: UILabel!
    @IBOutlet weak var jdetaillbl: UILabel!
    @IBOutlet weak var addresslbl: UILabel!
    @IBOutlet weak var emailAddresslbl: UILabel!
   
    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var personaldetaillbl: UILabel!
    @IBOutlet weak var hosName: UITextField!
    @IBOutlet weak var shiftlbl: UILabel!
    @IBOutlet weak var shiftTextField: UITextField!
    @IBOutlet weak var employeeIdTextField: UITextField!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNameText: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var fullnameText: UITextField!
    @IBOutlet weak var jobdetaillbl: UILabel!
    
    @IBOutlet weak var hosMobile: UITextField!
    @IBOutlet weak var mobilenolbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var profileHeaderView: UIView!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profileLbl: UILabel!
     var localisation : Localisation!
   
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBAction func saveMethod(_ sender: AnyObject) {
    
        if self.usernameTextField.text == "" {
            //let alert = SCLAlertView()
            SCLAlertView().showError(localisation.localizedString(key: "profile.usernameisempty"), subTitle:localisation.localizedString(key: ""), closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
            
            //SCLAlertView().showWarning("", subTitle: localisation.localizedString(key: "profile.usernameisempty"))
            
        return
        }
        setupUpdateProfile()
        
        
        
        
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func setupUpdateProfile(){
        var updateProfile : String  = ""
        
        updateProfile = Constants.baseURL + "updateInspectorProfile?user_id=" + self.appDel.user.user_id + "&full_name=\(self.fullnameText.text!)&email=\(self.emailTextField.text!)&contact_no=\(self.mobileNameText.text!)&username=\(self.usernameTextField.text!)"
        
        
        
        
        
        
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        self.appDel.showIndicator = 1
        
        downloader.startDownloader(updateProfile, idn: "updateprofile")
    
       // var updateProfile : String  = ""
      //          var updateProfileUrl =  Constants.baseURL + "updateInspectorProfile"
               
       //  let downloader : DataDownloader = DataDownloader()
       //  downloader.delegate = self
       // self.appDel.showIndicator = 1
        // downloader.startDownloader(updateProfile, idn: "updateprofile")
        // downloader.updateProfilePost(user_id:self.appDel.user.user_id! , full_name: self.fullnameText.text!, email: self.emailTextField.text!, ide: "updateprofile", contact_no: self.mobileNameText.text!, username: Util.encryptPassword(password:self.usernameTextField.text!), url: updateProfileUrl)

        
        
    }
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "updateprofile" {
         let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
          print(str)
            
            if str!.contains("508") {
                // Email already exists
            //SCLAlertView().showWarning("", subTitle: localisation.localizedString(key: "profile.emailalreadyexists"))
            
                SCLAlertView().showError(localisation.localizedString(key: "profile.emailalreadyexists"), subTitle:localisation.localizedString(key: ""), closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
                
            }
            else if str!.contains("507") {
                //SCLAlertView().showWarning("", subTitle: localisation.localizedString(key: "profile.usernamealreadyexists"))
                SCLAlertView().showError(localisation.localizedString(key: "profile.usernamealreadyexists"), subTitle:localisation.localizedString(key: ""), closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
                
            
            }
        self.userFullName.text = fullnameText.text
    
        
        }
        else if identity == "profile" {
        let parser = JsonParser()
        let user : UserDao = parser.parseProfileData(data)
            
            if user.user_id != nil {
            self.appDel.user = user
            self.setupValues()
            }
        
        }
        
    }
    
    func setUpProfileDownloader(){
        if Reachability.connectedToNetwork() {
            let loginUrl = Constants.baseURL + "getInspectorProfile?user_id=" + self.appDel.user.user_id
            print(loginUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "profile")
            

            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.isNavigationBarHidden = true
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        self.profileHeaderView.bringSubview(toFront: self.jobTitle)
        self.profileHeaderView.bringSubview(toFront: self.userFullName)
        self.profileHeaderView.bringSubview(toFront: self.profilePhoto)
        self.usernameTextField.text = self.appDel.user.username
        self.fullnameText.text = self.appDel.user.firstname
        self.mobileNameText.text = self.appDel.user.contactno
        if self.appDel.user.job_title != nil {
        self.jobTitleTextField.text = self.appDel.user.job_title!
        }
        if self.appDel.user.email != nil {
        self.emailTextField.text = self.appDel.user.email!
        }
        self.shiftTextField.text = self.appDel.user.shift
        self.userFullName.text = self.appDel.user.firstname
        self.jobTitle.text = self.appDel.user.job_title
        self.saveBtn.setTitle(localisation.localizedString(key: "settings.savechanges"), for: UIControlState())
        
        self.personaldetaillbl.text = localisation.localizedString(key: "profile.personaldetail")
        
        self.emailAddresslbl.text = localisation.localizedString(key: "")
       self.jdetaillbl.text = localisation.localizedString(key: "profile.jobdetail")
        
       self.job.text = self.localisation.localizedString(key: "profile.job")
        
        self.employeeidlbl.text = localisation.localizedString(key: "")
        
        
        self.hosmobile.text = localisation.localizedString(key: "company.mobileno")
        
        /*
        userDao.employee_id = dataDict.objectForKey("") as? String
        userDao.hosMobileNo = dataDict.objectForKey("") as? String
        userDao.hosName = dataDict.objectForKey("") as? String
        userDao.job_title = dataDict.objectForKey("") as? String
        userDao.email = dataDict.objectForKey("") as? String
        */
        
        
        self.hosName.text = self.appDel.user.hosName
        self.hosMobile.text = self.appDel.user.hosMobileNo
        self.jobTitle.text = self.appDel.user.job_title
        self.employeeIdTextField.text = self.appDel.user.employee_id
        
        profileLbl.text = localisation.localizedString(key: "profile.profiletitle")
        self.fullnameLbl.text = localisation.localizedString(key: "login.username")
        self.usernameLbl.text = localisation.localizedString(key: "profile.name")
        self.mobilenolbl.text = localisation.localizedString(key: "company.mobileno")
        self.emailAddresslbl.text = localisation.localizedString(key: "finalise.email")
        self.employeeidlbl.text = localisation.localizedString(key: "profile.employeeid")
        self.shiftlbl.text = localisation.localizedString(key: "profile.shift")
        self.hosdetail.text = localisation.localizedString(key: "profile.headofsection")
        
        self.hosname.text = localisation.localizedString(key: "profile.name")
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())

        
        self.setUpProfileDownloader()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    func setupValues(){
        self.profileHeaderView.bringSubview(toFront: self.jobTitle)
        self.profileHeaderView.bringSubview(toFront: self.userFullName)
        self.profileHeaderView.bringSubview(toFront: self.profilePhoto)
        self.usernameTextField.text = self.appDel.user.username
        self.fullnameText.text = self.appDel.user.firstname
        self.mobileNameText.text = self.appDel.user.contactno
        if self.appDel.user.job_title != nil {
            self.jobTitleTextField.text = self.appDel.user.job_title!
        }
        if self.appDel.user.email != nil {
            self.emailTextField.text = self.appDel.user.email!
        }
        self.shiftTextField.text = self.appDel.user.shift
        self.userFullName.text = self.appDel.user.firstname
        self.jobTitle.text = self.appDel.user.job_title
        self.saveBtn.setTitle(localisation.localizedString(key: "profile.saveinfo"), for: UIControlState())
        
        /*
         userDao.employee_id = dataDict.objectForKey("") as? String
         userDao.hosMobileNo = dataDict.objectForKey("") as? String
         userDao.hosName = dataDict.objectForKey("") as? String
         userDao.job_title = dataDict.objectForKey("") as? String
         userDao.email = dataDict.objectForKey("") as? String
         */
        
        
        self.hosName.text = self.appDel.user.hosName
        self.hosMobile.text = self.appDel.user.hosMobileNo
        self.jobTitle.text = self.appDel.user.job_title
        self.employeeIdTextField.text = self.appDel.user.employee_id
        
        profileLbl.text = localisation.localizedString(key: "profile.profiletitle")
    }

    @IBAction func toggleMethod(_ sender: AnyObject) {
    self.revealViewController().revealToggle(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
