//
//  StartInactiveViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 4/18/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol DateSelectedDelegate{
    @objc optional func dateSelected(_ date : Date ,  whichDate : Int)
}
class StartInactiveViewController: UIViewController {
    var whichDate : Int = 1 // 1 start date 2 for end date
    var del : DateSelectedDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func cancelMethod(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var cancelBtn: UIButton!
    @IBAction func startMethod(_ sender: AnyObject) {
          
        del?.dateSelected!(self.datePicker.date, whichDate: whichDate)
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var startBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

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
