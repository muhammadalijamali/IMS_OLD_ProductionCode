//
//  SelectInactiveViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 4/18/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class SelectInactiveViewController: UIViewController, DateSelectedDelegate , MainJsonDelegate {

    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var endDatelblbtn: UIButton!
    @IBOutlet weak var startDatetitlebtn: UIButton!
     var appDel : AppDelegate! = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var endDateView: UIView!
     var localisation : Localisation!
    var startDateStr : String?
    var endDateStr : String?
    
    @IBOutlet weak var startDateView: UIView!
    @IBAction func saveMethod(_ sender: AnyObject) {
        
//        if self.startDateBtn.titleLabel?.text == localisation.localizedString(key: "tasks.startdate") {
//        print("select start date")
//       return
//        }
//        
    
        
//        if endDate == nil && self.appDel.user.inactive_end != "0000-00-00" {
//        self.endDateStr = self.appDel.user.inactive_end
//            
//        }
//        if self.appDel.user.inactive_start == "0000-00-00" || self.appDel.user.inactive_end == "0000-00-00" {
//        return
//            
//        }
        
        
        if startDate !=  nil && endDate != nil {
        if startDate?.compare(self.endDate!) == ComparisonResult.orderedDescending {
        
            let alert = UIAlertController(title: "", message: "Start date should be less than or equal to end date", preferredStyle: UIAlertControllerStyle.alert)
            
           // let alert = UIAlertView(title: "", message: "Start date should be less than end date", delegate: nil, cancelButtonTitle: <#T##String?#>, otherButtonTitles: <#T##String#>, <#T##moreButtonTitles: String...##String#>)
            let cancel = UIAlertAction(title: "Ok", style:UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(cancel)
           self.present(alert, animated: true, completion: nil)
            return
        }
        self.startDateStr = formater.string(from: startDate!)
        self.endDateStr = formater.string(from: endDate!)
            
        self.setupInactiveDate()
        }
    }
    @IBOutlet weak var saveBtn: UIButton!
    @IBAction func endDateMethod(_ sender: AnyObject) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "cnt_startinactive") as! StartInactiveViewController
        
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        vc.del = self
        vc.whichDate = 1
        
        
        // vc.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        //vc.preferredContentSize = CGSizeMake(600, 850)
        // let popoverMenuViewController = vc.popoverPresentationController
        // popoverMenuViewController!.permittedArrowDirections = .Any
        //popoverMenuViewController!.delegate = self
        //popoverMenuViewController!.sourceView = self.view
        //popoverMenuViewController!.sourceRect = CGRectMake(1, 0, 600, 850)
        self.present(vc, animated: true, completion: nil)
    
    }
    @IBOutlet weak var endDateBtn: UIButton!
    var startDate : Date?
    var endDate : Date?
    let formater : DateFormatter = DateFormatter()
    
    
    @IBAction func startDateMethod(_ sender: AnyObject) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "cnt_startinactive") as! StartInactiveViewController
        
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        vc.del = self
        vc.whichDate = 0
        
        
        // vc.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        //vc.preferredContentSize = CGSizeMake(600, 850)
        // let popoverMenuViewController = vc.popoverPresentationController
        // popoverMenuViewController!.permittedArrowDirections = .Any
        //popoverMenuViewController!.delegate = self
        //popoverMenuViewController!.sourceView = self.view
        //popoverMenuViewController!.sourceRect = CGRectMake(1, 0, 600, 850)
        self.present(vc, animated: true, completion: nil)
    }
    @IBOutlet weak var startDateBtn: UIButton!
    @objc func hideKeyPad(){
    self.reasonTextView.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        formater.dateFormat = "YYYY-MM-dd"
        formater.locale = Locale(identifier: "en_US")
        self.startDateView.layer.cornerRadius = 5.0
        self.startDateView.layer.masksToBounds = true
        
        self.endDateView.layer.cornerRadius = 5.0
        self.endDateView.layer.masksToBounds = true
        
        self.saveBtn.layer.cornerRadius = 5.0
        self.saveBtn.layer.masksToBounds = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SelectInactiveViewController.hideKeyPad))
        self.view.addGestureRecognizer(gesture)
        self.reasonTextView.layer.cornerRadius = 5.0
        self.reasonTextView.layer.masksToBounds = true
        
        if appDel.user.inactive_notes != nil {
        self.reasonTextView.text = appDel.user.inactive_notes
        }
        
       // self.reasonTextView.backgroundColor = UIColor(patternImage: UIImage(named: "newtextarea")!)
        
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        
        
        self.startDatetitlebtn.setTitle(localisation.localizedString(key: "tasks.startdate"), for: UIControlState())
        self.endDatelblbtn.setTitle(localisation.localizedString(key: "tasks.enddate"), for: UIControlState())
        self.reasonLbl.text = localisation.localizedString(key: "settings.reason")
        
        self.saveBtn.setTitle(localisation.localizedString(key: "settings.savechanges"), for: UIControlState())
        
        if self.appDel.user.inactive_start != nil && self.appDel.user.inactive_end != nil && self.appDel.user.inactive_start != "0000-00-00" && self.appDel.user.inactive_end != "0000-00-00" {
            //self.fromto.setTitle(self.appDel.user.inactive_start! + " to " + self.appDel.user.inactive_end!, forState: UIControlState.Normal)
            self.startDate = formater.date(from: self.appDel.user.inactive_start!)
          
            self.endDate = formater.date(from: self.appDel.user.inactive_end!)
            print("start date \(self.startDate)")
            print("end date \(self.endDate)")
            
            self.startDateBtn.setTitle(self.appDel.user.inactive_start!, for: UIControlState())
            self.endDateBtn.setTitle(self.appDel.user.inactive_end, for: UIControlState())
        }
        

        
        
        // Do any additional setup after loading the view.
    }
    
    func setupInactiveDate(){
        let loginUrl = Constants.baseURL + "setInspectorInActiveDuration?user_id=" + self.appDel.user.user_id + "&&start_date=\(self.formater.string(from: self.startDate!))&end_date=\(self.formater.string(from: self.endDate!))&inactive_note=\(self.reasonTextView.text)"
        
        
        
        
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "inactive")
        
    
    }
    func dateSelected(_ date: Date, whichDate: Int) {
        

        if whichDate == 0 {
        startDate = date
        
        self.startDateBtn.setTitle(formater.string(from: startDate!), for: UIControlState())
        }
        else if whichDate == 1 {
            endDate = date
            self.endDateBtn.setTitle(formater.string(from: endDate!), for: UIControlState())
           
            
           
            
            
        //endDate = date
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        self.reasonTextView.resignFirstResponder()
        if ((str?.contains("success")) != nil) {
        self.appDel.user.inactive_notes = self.reasonTextView.text
        self.appDel.user.inactive_start = self.formater.string(from: self.startDate!)
        self.appDel.user.inactive_end = self.formater.string(from: self.endDate!)
        }
        print(str)
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
