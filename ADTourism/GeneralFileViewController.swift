//
//  GeneralFileViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 9/20/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class GeneralFileViewController: UIViewController {
    var loadurl : URL?
    @IBAction func exitMethod(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if loadurl != nil {
        self.webview.loadRequest(URLRequest(url:loadurl!))
            
        }
        
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
