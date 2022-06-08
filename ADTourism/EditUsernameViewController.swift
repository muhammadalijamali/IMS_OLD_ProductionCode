//
//  EditUsernameViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 4/18/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class EditUsernameViewController: UIViewController ,MainJsonDelegate , UITextFieldDelegate {
    let appdel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernamelbl: UILabel!
    var localisation : Localisation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localisation = Localisation()

        if self.appdel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
       // self.usernameTextField.becomeFirstResponder()
       self.navigationController?.isNavigationBarHidden = false
        self.outerView.layer.cornerRadius = 6.0
        
        self.usernameTextField.text = self.appdel.user.username
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.setupchangeUsername()
    return true
    }
    
    
    func setupchangeUsername(){
        
        var updateProfile : String  = ""
        updateProfile = Constants.baseURL + "updateInspectorProfile?user_id=" + self.appdel.user.user_id! + "&full_name=\(self.appdel.user.firstname!)&email=\(self.appdel.user.email!)&contact_no=\(self.appdel.user.contactno!)&username=\(self.usernameTextField.text!)"
        
        
        
        
        
        
        //var updateProfile : String  = ""
          //     var updateProfileUrl =  Constants.baseURL + "updateInspectorProfile"
              
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(updateProfile, idn: "updateprofile")
        //downloader.updateProfilePost(user_id:self.appdel.user.user_id! , full_name: self.appdel.user.firstname!, email: self.appdel.user.email!, ide: "updateprofile", contact_no: self.appdel.user.contactno!, username: Util.encryptPassword(password:self.usernameTextField.text!), url: updateProfileUrl)

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false

    }
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        if identity == "updateprofile" {
           
            if str!.contains("507") {
                SCLAlertView().showError(localisation.localizedString(key: "profile.usernamealreadyexists"), subTitle:localisation.localizedString(key: ""), closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
                
                
                
            }
        
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
