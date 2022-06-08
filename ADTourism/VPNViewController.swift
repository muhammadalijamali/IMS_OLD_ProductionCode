//
//  VPNViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 10/6/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol VPNManagerDelegate{
    @objc optional func dataChanged()
    
}

class VPNViewController: UIViewController {
      


    @IBOutlet weak var vpnUsernamelbl: UILabel!
    
    @IBOutlet weak var usernameTextField: MarginTextField!
    
    @IBOutlet weak var passwordlbl: UILabel!
    
    @IBOutlet weak var passwordTextField: MarginTextField!
    
    @IBOutlet weak var vpnSettingsTitlelbl: UILabel!
    
    @IBOutlet weak var serverIPLbl: UILabel!
    
    @IBOutlet weak var serverIPTextField: MarginTextField!
    
    @IBOutlet weak var grouplbl: UILabel!
    
    @IBOutlet weak var groupTextField: MarginTextField!
    
    @IBOutlet weak var sharedlbl: UILabel!
    var del : VPNManagerDelegate?
    
    
    @IBOutlet weak var sharedTextField: MarginTextField!
    var userDefault : UserDefaults = UserDefaults.standard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        serverIPTextField.resignFirstResponder()
        groupTextField.resignFirstResponder()
        sharedTextField.resignFirstResponder()
    }
    
    @IBAction func resetMethod(_ sender: UIButton) {
    let alert = SCLAlertView()
        alert.showCloseButton = false
        alert.addButton("Reset", action:{
            self.vpnManager.deleteVPN()
            self.userDefault.removeObject(forKey: "vpn_username")
            self.userDefault.removeObject(forKey: "vpn_password")
            self.userDefault.removeSuite(named: "vpn_group")
            self.userDefault.removeSuite(named: "vpn_sharedsecret")
            self.userDefault.removeSuite(named: "vpn_server")
            
            
            self.vpnManager.timer?.invalidate()
            
            self.userDefault.synchronize()
           self.usernameTextField.text = ""
           self.passwordTextField.text = ""
            self.del?.dataChanged!()
            

            })
        alert.addButton("Dismiss", action: {
       
        })
        
    alert.showInfo("Reset VPN", subTitle: "Resetting VPN will remove stored VPN configuration")
    }
    
    let vpnManager = VPNManager()
    
    
    @IBAction func showHidePassword(_ sender: UIButton) {
        if sender.tag == 0 {
        self.passwordTextField.isSecureTextEntry = false
        sender.setTitle("Hide", for: UIControlState())
        sender.tag = 1
            
        }
        else {
            self.passwordTextField.isSecureTextEntry = true
            sender.setTitle("Show", for: UIControlState())
            sender.tag = 0
        }
    }
    
    
    @IBAction func showHideSecret(_ sender: UIButton) {
        if sender.tag == 0 {
            self.sharedTextField.isSecureTextEntry = false
            sender.setTitle("Hide", for: UIControlState())
            sender.tag = 1
            
        }
        else {
            self.sharedTextField.isSecureTextEntry = true
            sender.setTitle("Show", for: UIControlState())
            sender.tag = 0
        }

    
    }
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBAction func saveVPN(_ sender: AnyObject) {
        KeychainMethods.deleteAllKeychain()
        if self.serverIPTextField.text == "" {
            SCLAlertView().showInfo("Enter VPN Server", subTitle: "")
        return
        }
        if self.sharedTextField.text == "" {
            SCLAlertView().showInfo("Enter Shared secret", subTitle: "")
        return
        }
        if self.groupTextField.text == "" {
            SCLAlertView().showInfo("Enter Group", subTitle: "")
        return
        }
        
        if self.usernameTextField.text == ""{
             SCLAlertView().showInfo("Enter Username", subTitle: "")
        return
        }
        if self.passwordTextField.text == "" {
             SCLAlertView().showInfo("Enter Password", subTitle: "")
        return
        }
        
        print(self.passwordTextField.text!)
        print(self.usernameTextField.text!)
        
        let vpn = VPNDao()
        vpn.VPN_USER = self.usernameTextField.text!
        vpn.VPN_PASSWORD = self.passwordTextField.text!
        vpn.SERVER_IDENTIFIER = self.groupTextField.text!
        vpn.LOCAL_IDENTIFIER = self.groupTextField.text!
        vpn.VPN_SERVER = self.serverIPTextField.text!
        vpn.SHARED_SECRET = self.sharedTextField.text!
        self.userDefault.setValue(self.usernameTextField.text!, forKey: "vpn_username")
        self.userDefault.setValue(self.passwordTextField.text!, forKey: "vpn_password")
        self.userDefault.setValue(self.groupTextField.text!, forKey: "vpn_group")
        self.userDefault.setValue(self.sharedTextField.text!, forKey: "vpn_sharedsecret")
        self.userDefault.setValue(self.serverIPTextField.text!, forKey: "vpn_server")
        self.userDefault.synchronize()
        self.vpnManager.setupVPN(vpn)
        self.vpnManager.startVPNTimer(vpn)
        self.exitPopup(self)
        self.del?.dataChanged!()

        //self.vpnManager.startVPNTimer(vpn)
//        if  self.vpnManager.setupVPN(vpn) {
//        
//        }
        
            
    }
    
    
    
        
    
    @IBOutlet weak var resetBtn: UIButton!
    
    @IBAction func exitPopup(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
        
    }
    
        
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetBtn.isHidden = false
        
        if self.userDefault.object(forKey: "vpn_username") != nil {
        self.usernameTextField.text = self.userDefault.object(forKey: "vpn_username") as? String
        self.resetBtn.isHidden = false
            
        }
        if self.userDefault.object(forKey: "vpn_password") != nil {
        self.passwordTextField.text = self.userDefault.object(forKey: "vpn_password") as? String
            
        }
        if self.userDefault.object(forKey: "vpn_group") != nil {
            self.groupTextField.text = self.userDefault.object(forKey: "vpn_group") as? String

        }
       
        if self.userDefault.object(forKey: "vpn_sharedsecret") != nil {
        self.sharedTextField.text = self.userDefault.object(forKey: "vpn_sharedsecret") as? String
        }
        
        if self.userDefault.object(forKey: "vpn_server") != nil {
            self.serverIPTextField.text = self.userDefault.object(forKey: "vpn_server") as? String
        }
        
        
       
        
        
        self.resetBtn.layer.cornerRadius = 3.0
        self.saveBtn.layer.cornerRadius = 3.0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
