//
//  SettingsViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 4/18/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController , MainJsonDelegate {
    var localisation : Localisation!
    var appDel : AppDelegate! = UIApplication.shared.delegate as! AppDelegate
    var userDefault : UserDefaults = UserDefaults.standard
    let databaseManager = DatabaseManager()
    
    @IBOutlet weak var uatlbl: UILabel!
    @IBOutlet weak var fromto: UIButton!
    @IBOutlet weak var settingsTitle: UILabel!
    @IBOutlet weak var usernamelbl: UILabel!
    
    @IBOutlet weak var versionlbl: UILabel!
    
    @IBOutlet weak var logout: UIView!
    @IBOutlet weak var inactiveduration: UILabel!
    @IBOutlet weak var languagelbl: UILabel!
    @IBOutlet weak var passwordlbl: UILabel!
    @IBAction func langMethod(_ sender: AnyObject) {
       // SCLAlertView().showError(localisation.localizedString(key: "tasks.youareinactive"), subTitle:localisation.localizedString(key: "tasks.inactiveMessage"), closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
        
        
        
        let alert = SCLAlertView()
        alert.showCloseButton = false
            alert.addButton("العربية", action: {
       
                self.appDel.selectedLanguage = 2
                self.userDefault.set(2, forKey: "lang")
                self.langBtn.setTitle("العربية", for: UIControlState())
                self.setupLang()
                self.setupLang("arabic")

            })
        
        alert.addButton("English", action: {
       
            self.appDel.selectedLanguage = 1
            self.userDefault.set(1, forKey: "lang")
            self.langBtn.setTitle("English", for: UIControlState())
            self.setupLang()
            self.setupLang("english")

        })
        alert.addButton(localisation.localizedString(key:"questions.cancel"), action: {
       
        })
        
        self.userDefault.synchronize()
        alert.showInfo(localisation.localizedString(key:"settings.selectlangugae"), subTitle: "")
        
        
    }
    
    func setupLang(_ lang : String) {
        let langurl = Constants.baseURL + "updateLanguageSetting?inspector_id=" + self.appDel.user.user_id + "&selected_lang=" + lang
        print(langurl)
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(langurl, idn: "updatelang")
        
        
        
    }// end of the setup lang
    
    @IBOutlet weak var langBtn: UIButton!
    @IBAction func logoutMethod(_ sender: AnyObject) {
      self.appDel.userDefaults.removeObject(forKey: "username")
        self.appDel.userDefaults.removeObject(forKey: "lang")
        self.appDel.userDefaults.synchronize()
        self.databaseManager.deleteAllTasks()
        let cnt = self.storyboard?.instantiateViewController(withIdentifier: "cnt_startnav") as! UINavigationController
      self.present(cnt, animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.isNavigationBarHidden = true
    }
    var del : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func setupVpn(_ sender: UIButton) {
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "cnt_vpn") as! VPNViewController
        
        popoverVC.modalPresentationStyle = .formSheet
        present(popoverVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var passwordBtn: UIButton!
    @IBAction func usernameMethod(_ sender: AnyObject) {
    self.performSegue(withIdentifier: "sw_settingstoeditname", sender: nil)
    }
    @IBOutlet weak var usernameView: UIView!
    @IBAction func passwordMethod(_ sender: AnyObject) {
    self.performSegue(withIdentifier: "sw_settinstochangepassword", sender: nil)
        
    }
    
    @IBAction func durationMethod(_ sender: AnyObject) {
    self.performSegue(withIdentifier: "sw_settingstoduration", sender: nil)
        
    }
    
    @IBOutlet weak var usernameBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        if Constants.mode == 1 {
            //self.uatlbl.hidden = false
            self.uatlbl.text = "UAT"
            
        }
        else if Constants.mode == 0{
            self.uatlbl.text = "PRO"
            
            
        }
        else {
            self.uatlbl.text = "QA"
            
            
        }

        
     self.usernameView.layer.cornerRadius = 6.0
     self.usernameView.layer.masksToBounds = true
        
        self.languageView.layer.cornerRadius = 6.0
        self.languageView.layer.masksToBounds = true
        
        self.logoutView.layer.cornerRadius = 6.0
        self.logoutView.layer.masksToBounds = true
        self.usernameBtn.setTitle(del.user.username, for: UIControlState())
        self.passwordBtn.setTitle("**********", for: UIControlState())
        self.setupLang()
        
        if self.appDel.user.inactive_start != nil && self.appDel.user.inactive_end != nil && self.appDel.user.inactive_start != "0000-00-00" && self.appDel.user.inactive_end != "0000-00-00" {
        self.fromto.setTitle(self.appDel.user.inactive_start! + " to " + self.appDel.user.inactive_end!, for: UIControlState())
            
        }
        
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
//    
        
   

        self.setupLang()
        
        // Do any additional setup after loading the view.
    }
    func setupLang(){
        self.localisation = Localisation()
        if self.del.selectedLanguage == 1{
            self.langBtn.setTitle("English", for: UIControlState())
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            self.langBtn.setTitle("العربية", for: UIControlState())
            
        }
        self.usernamelbl.text = localisation.localizedString(key:
            "settings.username")
        self.passwordlbl.text = localisation.localizedString(key:
            "settings.password")
        self.languagelbl.text = localisation.localizedString(key: "settings.language")
    
        self.inactiveduration.text = localisation.localizedString(key: "settings.inactiveduration")
        self.versionlbl.text = localisation.localizedString(key: "settings.applicationno")
        self.logoutBtn.setTitle(localisation.localizedString(key: "settings.logout"), for: UIControlState())
        self.settingsTitle.text = localisation.localizedString(key: "settings.title")

    }

    @IBAction func toggleMethod(_ sender: AnyObject) {
    self.revealViewController().revealToggle(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        print("language updated \(identity)")
        
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
