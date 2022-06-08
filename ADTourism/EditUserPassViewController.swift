//
//  EditUserPassViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 4/18/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class EditUserPassViewController: UIViewController , MainJsonDelegate{

   
    @IBOutlet weak var reenterpasswordview: UIView!
    @IBOutlet weak var newpasswordview: UIView!
    @IBOutlet weak var oldPasswordView: UIView!
    @IBOutlet weak var reenterpasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var reenterpasslbl: UILabel!
    @IBOutlet weak var newuserlbl: UILabel!
    
    @IBOutlet weak var oldUserlbl: UILabel!
    var appDel : AppDelegate! = UIApplication.shared.delegate as! AppDelegate
    var  localisation : Localisation?
    
    func hideKeyPad(){
    self.oldPasswordField.resignFirstResponder()
    self.newPasswordField.resignFirstResponder()
    self.reenterpasswordField.resignFirstResponder()
    }
    @IBAction func saveMethod(_ sender: AnyObject) {
        self.hideKeyPad()
        
        if self.oldPasswordField.text == "" || self.newPasswordField.text == "" || self.reenterpasswordField.text == ""{
        
            SCLAlertView().showError("", subTitle:(localisation?.localizedString(key: "settings.pleasefillallfields"))!, closeButtonTitle:localisation!.localizedString(key: "questions.cancel"))
            
             return
            
            
        
        }
        if self.newPasswordField.text != self.reenterpasswordField.text {
            SCLAlertView().showError("", subTitle:(localisation?.localizedString(key: "settings.bothfieldsareequal"))!, closeButtonTitle:localisation!.localizedString(key: "questions.cancel"))
        return
        }
        self.setupChangePassword()
        
        
        
    }
    func setupChangePassword(){
      // let changePasswordUrl = Constants.baseURL + "changePassword?user_id=" + self.appDel.user.user_id + "&old_password=" + self.oldPasswordField.text! + "&new_password=" + self.newPasswordField.text!
        
        
        let changePasswordUrl = "\(Constants.baseURL)changePassword?user_id=\(self.appDel.user.user_id) &old_password=\(self.oldPasswordField.text!)&new_password=\(self.newPasswordField.text!)"
      
        
         //    let changePasswordUrl = Constants.baseURL + "changePassword"
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(changePasswordUrl, idn: "changepassword")
        
    //    let downloader : DataDownloader = DataDownloader()
      //         downloader.delegate = self
             // downloader.loginPost(Util.encryptPassword(password: passwordText.text!), _username: Util.encryptPassword(password: userText.text!), url: loginUrl, ide: "login")
              
      //  downloader.changePasswordPost(Util.encryptPassword(password: self.oldPasswordField.text!), Util.encryptPassword(password: self.newPasswordField.text!), url: changePasswordUrl, ide: "changepassword", user_id:self.appDel.user.user_id)
        

    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.newpasswordview.layer.cornerRadius = 5.0
        self.newpasswordview.layer.masksToBounds  = true
        self.oldPasswordView.layer.cornerRadius = 5.0
        self.reenterpasswordview.layer.cornerRadius = 5.0
        self.reenterpasswordview.layer.masksToBounds = true
      /////////////////////////////////
        self.oldPasswordField.isSecureTextEntry = true
        self.newPasswordField.isSecureTextEntry = true
        self.reenterpasswordField.isSecureTextEntry = true
        
        
         self.localisation = Localisation()
        savebtn.layer.cornerRadius = 5.0
        savebtn.layer.masksToBounds = true
        if self.appDel.selectedLanguage == 1{
            self.localisation!.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation!.setPreferred("ar", fallback: "en")
        }
        
        self.oldUserlbl.text = self.localisation?.localizedString(key: "settings.oldpassword")
        self.newuserlbl.text = self.localisation?.localizedString(key: "settings.newpassword")
        self.reenterpasslbl.text = self.localisation?.localizedString(key: "settings.reenterpassword")
        self.savebtn.setTitle(self.localisation?.localizedString(key: "settings.savechanges"), for: UIControlState())
        
     
        
        //self.oldPasswordView
        
        
//        "settings.oldpassword" = "Current Password";
//        "settings.newpassword" = "New Password";
//        "settings.reenterpassword" = "Re-enter Password";
//        "settings.savechanges" = "Save Changes";

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func dataDownloaded(_ data: NSMutableData, identity: String) {
        let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        print(str)
        if str!.contains("Incorrect password") {
            SCLAlertView().showError("", subTitle:(localisation?.localizedString(key: "settings.passwordincorrect"))!, closeButtonTitle:localisation!.localizedString(key: "questions.cancel"))
            
        
        }
        if str!.contains("success"){
            SCLAlertView().showInfo("", subTitle:(localisation?.localizedString(key: "settings.passwordupdatedsuccessfully"))!, closeButtonTitle:localisation!.localizedString(key: "questions.cancel"))
            
        }
        
        
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
