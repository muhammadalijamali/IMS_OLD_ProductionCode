//
//  ShowImageViewController.swift
//  ADTourism
//
//  Created by Administrator on 10/3/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var displayImage: UIImageView!
        var localisation : Localisation!
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func cancelMethod(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        displayImage.image = appDel.imageToShow
        self.localisation = Localisation()
        
        
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }

        self.cancelBtn.setTitle(localisation.localizedString(key: "questions.cancel"), for: UIControlState())
        
        // Do any additional setup after loading the view.
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
