//
//  LanguageViewController.swift
//  ADTourism
//
//  Created by Administrator on 10/24/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController {
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func englishMethod(_ sender: AnyObject) {
         appDel.selectedLanguage = 1
        self.performSegue(withIdentifier: "sw_login", sender: nil)
        
        
    }
    
    @IBAction func arabicMethod(_ sender: AnyObject) {
        appDel.selectedLanguage = 2
        self.performSegue(withIdentifier: "sw_login", sender: nil)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
       
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
