//
//  DateSelectorViewController.swift
//  ADTourism
//
//  Created by Administrator on 9/17/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol DateSelectorDelegate
{
    func dateDeletced(_ date : Date, button : ADButton)
}

class DateSelectorViewController: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate : DateSelectorDelegate!
    var button : ADButton!
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var localisation  = Localisation()
    
    
    @IBAction func selectMethod(_ sender: AnyObject) {
        delegate.dateDeletced(datePicker.date , button: button)
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancelMethod(_ sender: AnyObject) {
     self.dismiss(animated: true, completion: nil)
    }
    @IBAction func closeMethod(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dateSelected(){
    delegate.dateDeletced(datePicker.date , button: button)
    self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // datePicker.addTarget(self, action: "dateSelected", forControlEvents: UIControlEvents.ValueChanged)
        if self.appDel.calenderHisyoty == 1 {
        }
        else if self.appDel.calenderHisyoty == 2 {
            let today = Date()
            let tomorrow = (Calendar.current as NSCalendar)
                .date(
                    byAdding: .day,
                    value: 1,
                    to: today, 
                    options: []
            )
            datePicker.minimumDate = tomorrow
        }
        else {
        //datePicker.minimumDate = NSDate()
        }
        datePicker.date = Date()
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
           
        self.selectDateBtn.setTitle(localisation.localizedString(key: "history.select"), for: UIControlState())
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
