//
//  PoolFilterViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 6/9/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class PoolFilterViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate , MainJsonDelegate {

    
    @IBOutlet weak var addressSearchBtn: UIButton!
    @IBOutlet weak var outerAddressView: UIView!
    @IBOutlet weak var licenseOuterView: UIView!
    @IBOutlet weak var areaPriorityBtn: UIButton!
    
    @IBAction func showAreaPriority(_ sender: AnyObject) {
        self.keyPad()
        let alert = SCLAlertView()
        alert.showCloseButton = false
        //  alert.showCircularIcon = false
        
        let high = alert.addButton(self.localisation!.localizedString(key: "tasks.high"),tag: 150 , action: {
           
            self.urgency = 3 // NON DTCM
            self.appDel.selectedUrgency = self.urgency
            
            //self.typeLbl.text = self.localisation.localizedString(key: "tasks.high")
            self.areaPriorityBtn.setTitle(self.localisation!.localizedString(key: "tasks.high"), for: UIControlState())
            self.areaPriorityBtn.layer.borderColor = self.HIGHCOLOR.cgColor
            self.areaPriorityBtn.layer.borderWidth = 1.0
            //self.areaPriorityBtn.?.textColor = UIColor.blackColor()
            self.areaPriorityBtn.setTitleColor(UIColor.black, for: UIControlState())
            
            
        } )
        
        high.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
        
        let mediumColor = UIColor(red:246/255 , green: 142/255, blue: 90/255, alpha: 1.0)
        
        alert.addButton(self.localisation!.localizedString(key: "tasks.medium"),tag : 100, action: {
           
            self.urgency = 2 // NON DTCM
            self.appDel.selectedUrgency = self.urgency
            
            //self.priorityBtn.text = self.localisation.localizedString(key: "tasks.medium")
            self.areaPriorityBtn.layer.borderColor = self.MEDIUMCOLOR.cgColor
            self.areaPriorityBtn.layer.borderWidth = 1.0
            self.areaPriorityBtn.setTitleColor(UIColor.black, for: UIControlState())
            
            self.areaPriorityBtn.setTitle(self.localisation!.localizedString(key: "tasks.medium"), for: UIControlState())
            
            
        } )
        
        
        
        
        let low = alert.addButton(self.localisation!.localizedString(key: "tasks.low"),tag: 50 ,action: {
           
            self.urgency =  1 // DTCM
            self.appDel.selectedUrgency = self.urgency
            
            //self.typeLbl.text = self.localisation.localizedString(key: "tasks.low")
            self.areaPriorityBtn.layer.borderColor = self.LOWCOLOR.cgColor
            self.areaPriorityBtn.layer.borderWidth = 1.0
            self.areaPriorityBtn.setTitleColor(UIColor.black, for: UIControlState())
            
            self.areaPriorityBtn.setTitle(self.localisation!.localizedString(key: "tasks.low"), for: UIControlState())
            
        } )
        
        low.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
        
        
        
        
        
        // alert.ad
        
        alert.addButton(localisation!.localizedString(key: "questions.cancel"),tag:250 , action: {
           
            
        })
        
        alert.showInfo(localisation!.localizedString(key: "tasks.priority"), subTitle: "")

    }
    @IBOutlet weak var priorityBtn: UIButton!
    let LOWCOLOR : UIColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
    let MEDIUMCOLOR : UIColor =  UIColor(red:246/255 , green: 142/255, blue: 90/255, alpha: 1.0)
    let HIGHCOLOR : UIColor =  UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
    
    
    @IBOutlet weak var searchBtn: UIButton!
     var urgency : Int = 0
    @IBAction func licenseSearch(_ sender: AnyObject) {
        if self.detailLicenseSearch.text != "" {
        self.appDel.selectedPoolOption =  self.SEARCH_BY_LICENSE
        self.appDel.selectedLicense = self.detailLicenseSearch.text!
       // self.navigationController?.popViewControllerAnimated(true)
        self.performSegue(withIdentifier: "sw_poollisting", sender: nil)
            
        }// end of the if
        
    }
    
    
    
    
    @IBAction func showPriority(_ sender: AnyObject) {
        self.keyPad()
        let alert = SCLAlertView()
        alert.showCloseButton = false
        //  alert.showCircularIcon = false
        
        let high = alert.addButton(self.localisation!.localizedString(key: "tasks.high"),tag: 150 , action: {
           
            self.urgency = 3 // NON DTCM
            self.appDel.selectedUrgency = self.urgency
            
            //self.typeLbl.text = self.localisation.localizedString(key: "tasks.high")
            self.priorityBtn.setTitle(self.localisation!.localizedString(key: "tasks.high"), for: UIControlState())
            self.priorityBtn.layer.borderColor = self.HIGHCOLOR.cgColor
            self.priorityBtn.layer.borderWidth = 1.0
            //self.priorityBtn.titleLabel?.textColor = UIColor.blackColor()
            self.priorityBtn.setTitleColor(UIColor.black, for: UIControlState())
            
            
        } )
        
        high.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
        
        let mediumColor = UIColor(red:246/255 , green: 142/255, blue: 90/255, alpha: 1.0)
        
        alert.addButton(self.localisation!.localizedString(key: "tasks.medium"),tag : 100, action: {
           
            self.urgency = 2 // NON DTCM
            self.appDel.selectedUrgency = self.urgency
            
            //self.priorityBtn.text = self.localisation.localizedString(key: "tasks.medium")
            self.priorityBtn.layer.borderColor = self.MEDIUMCOLOR.cgColor
            self.priorityBtn.layer.borderWidth = 1.0
           // self.priorityBtn.titleLabel?.textColor = UIColor.blackColor()
            
            self.priorityBtn.setTitle(self.localisation!.localizedString(key: "tasks.medium"), for: UIControlState())
            self.priorityBtn.setTitleColor(UIColor.black, for: UIControlState())
            
            
        } )
        
        
        
        
        let low = alert.addButton(self.localisation!.localizedString(key: "tasks.low"),tag: 50 ,action: {
           
            self.urgency =  1 // DTCM
            self.appDel.selectedUrgency = self.urgency
            
            //self.typeLbl.text = self.localisation.localizedString(key: "tasks.low")
            self.priorityBtn.layer.borderColor = self.LOWCOLOR.cgColor
            self.priorityBtn.layer.borderWidth = 1.0
            //self.priorityBtn.titleLabel?.textColor = UIColor.blackColor()
            
            self.priorityBtn.setTitle(self.localisation!.localizedString(key: "tasks.low"), for: UIControlState())
            
        } )
        
        low.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
        
        
        
        
        
        // alert.ad
        
        alert.addButton(localisation!.localizedString(key: "questions.cancel"),tag:250 , action: {
           
            
        })
        
        alert.showInfo(localisation!.localizedString(key: "tasks.priority"), subTitle: "")
    
    }
    @IBOutlet weak var addressLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var licenseLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuleftConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityCodesTableView: UITableView!
    @IBOutlet weak var activityCodesTextField: BiggerMarginTextField!
    let ANIMATION_DURATION : Double =  1.0
    let SEARCH_BY_ACTIVITYCODE : Int =  2
    let SEARCH_BY_LICENSE : Int = 3
    let SEARCH_BY_ADDRESS : Int = 4
    
    
    

    @IBAction func searchLicenseNo(_ sender: AnyObject) {
        if self.detailLicenseText.text != nil && self.detailLicenseText.text != "" {
           self.appDel.selectedPoolOption = self.SEARCH_BY_ADDRESS
         self.appDel.selectedAddress = self.detailLicenseText.text!
         self.detailLicenseText.resignFirstResponder()
            self.performSegue(withIdentifier: "sw_poollisting", sender: nil)
            
        }
    }
    @IBOutlet weak var detailLicenseText: UITextField!
    
    
    
    
    @IBAction func hideAddresss(_ sender: AnyObject) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.menuleftConstraint.constant = 100
            
        }
        else {
            self.menuleftConstraint.constant = 0
            
        }
        
        self.menuView.isHidden = false
        
        self.addressLeftConstraint.constant = -800
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5,
                                   options: [], animations: {
                                    
                                    //  self.menuView.center.x =  1100
                                    self.view.layoutIfNeeded()
            },completion: {
                (value: Bool) in
                self.licenseSearchView.isHidden = true
                self.addressView.isHidden = true
                self.categoryView.isHidden = true
                
                
        })
        

    
//    self.addressView.hidden = true
//    self.licenseSearchView.hidden = true
//      
        
        
        
        
    }

    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressBtn: UIButton!
    
    @IBOutlet weak var detailAddresslbl: UILabel!
    
    @IBOutlet weak var detailAddressDesc: UILabel!
    
    
    
    @IBAction func showAddress(_ sender: AnyObject) {
        self.addressView.isHidden = false
        self.menuView.isHidden = true
        self.areaPriorityBtn.layer.borderColor = UIColor.clear.cgColor
        self.detailLicenseText.text = ""
        self.urgency = 0
        self.areaPriorityBtn.setTitle(localisation!.localizedString(key: "tasks.priority"), for: UIControlState())
        
        
        
        self.menuleftConstraint.constant = -800
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.addressLeftConstraint.constant = 100
            
        }
        else {
            self.addressLeftConstraint.constant = 2
            
        }
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0.0,
                                                                      usingSpringWithDamping: 0.5,
                                           initialSpringVelocity: 0.5,
                                           options: [], animations: {
        
                                          //  self.menuView.center.x =  1100
                                            self.view.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
                self.licenseSearchView.isHidden = true
             
                self.categoryView.isHidden = true
                
        })
        
        
        
    }
    
    @IBOutlet weak var filterbg: UIImageView!
    
    
    
   
    
    @IBAction func poolCloseMethod(_ sender: AnyObject) {
        
print("Pool close is called")
        
    // self.categoryView.center.x =  -700
    // self.menuView.center.x =  400
        self.menuView.isHidden = false
        if UIDevice.current.userInterfaceIdiom == .pad {
        self.menuleftConstraint.constant = 100
        }
        else {
            self.menuleftConstraint.constant = 0
            
        }
        self.categoryLeftConstraint.constant = -600
        self.activityCodesTextField.resignFirstResponder()
       
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5,
                                   options: [], animations: {
                                    
                                    //      self.categoryView.center.x =  400
                                    self.view.layoutIfNeeded()
                                    
            }, completion: {
                (value: Bool) in
                self.licenseSearchView.isHidden = true
                self.addressView.isHidden = true
                self.categoryView.isHidden = true
                // self.categoryView.hidden = true
                //self.menuView.hidden = true
        })
        

    
    }
    
    
    
    // MARK:- License Connection
    
    @IBOutlet weak var detailLicenseSearch: UITextField!
    
    
    @IBOutlet weak var detailLicenseTitle: UILabel!
    
    @IBOutlet weak var detailLicenseDesc: UILabel!
    
    @IBAction func click(_ sender: AnyObject) {
   
    }
    
    
    
    @IBAction func hideLicenseInfo(_ sender: AnyObject) {
   
    
    }
    
   
    
    @IBAction func hideLicesne(_ sender: AnyObject) {
    

        if UIDevice.current.userInterfaceIdiom == .pad {
            self.menuleftConstraint.constant = 100
            
        }
        else {
      
            self.menuleftConstraint.constant = 0
            
        }
        self.menuView.isHidden = false
       
        
        self.licenseLeftConstraint.constant = -800
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5,
                                   options: [], animations: {
                                    
                                    
                                    self.view.layoutIfNeeded()
                                    
            }, completion: {
                (value: Bool) in
                self.licenseSearchView.isHidden = true
                 self.addressView.isHidden = true
                self.categoryView.isHidden = true
                self.menuView.isHidden = false
        })

        
        
        

        
    }
    
    @IBOutlet weak var licenseBtn: UIButton!
    
    @IBAction func showLicense(_ sender: AnyObject) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.licenseLeftConstraint.constant = 100
            
        }
        else {
            self.licenseLeftConstraint.constant = -05
            
        }
          self.menuleftConstraint.constant = -800
        self.licenseSearchView.isHidden = false
        self.addressView.isHidden = true
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5,
                                   options: [], animations: {
                                    
                                    
                                    self.view.layoutIfNeeded()
                                    
            }, completion: {
            (value: Bool) in
             self.menuView.isHidden = true
             
            })
        


    
    }
    
    @IBOutlet weak var licenseSearchView: UIView!
    @IBOutlet weak var poolCloseBtn: UIButton!
    
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var activityCodeDesc: UILabel!
    @IBOutlet weak var activityCodelbl: UILabel!
    
    @IBOutlet weak var detailActivityCodelbl: UILabel!
    @IBOutlet weak var detailActivityCodeDesc: UILabel!
    var activityCodeArray : NSMutableArray = NSMutableArray()
    
    
    @IBOutlet weak var addressdesc: UILabel!
    @IBOutlet weak var addresslbl: UILabel!
    @IBOutlet weak var licensedesc: UILabel!
    @IBOutlet weak var licenseNolbl: UILabel!
    @IBOutlet weak var addressDesc: UILabel!
       @IBOutlet weak var mapDesc: UILabel!
    @IBOutlet weak var mapTitle: UILabel!
    @IBOutlet weak var mapBtn: UIButton!
    var localisation : Localisation?
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func closeFilter(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
    }
    
    func searchByActivityCode(){
        if Reachability.connectedToNetwork() {
            if self.activityCodesTextField.text != nil || self.activityCodesTextField.text != "" {
            
            var searchStr : NSString = self.activityCodesTextField.text! as NSString
            
            searchStr  = searchStr.replacingOccurrences(of: "١", with: "1") as NSString
            searchStr = searchStr.replacingOccurrences(of: "٢", with: "2") as NSString
            searchStr = searchStr.replacingOccurrences(of: "٣", with: "3") as NSString
            searchStr = searchStr.replacingOccurrences(of: "٤", with: "4") as NSString
            searchStr = searchStr.replacingOccurrences(of: "٥", with: "5") as NSString
            searchStr = searchStr.replacingOccurrences(of: "٦", with: "6") as NSString
            searchStr = searchStr.replacingOccurrences(of: "٧", with: "7") as NSString
            searchStr = searchStr.replacingOccurrences(of: "٨", with: "8") as NSString
            searchStr = searchStr.replacingOccurrences(of: "٩", with: "9") as NSString
            searchStr = searchStr.replacingOccurrences(of: "٠", with: "0") as NSString
            

            
            let loginUrl = Constants.baseURL + "searchActivityCodeInPool?query=" + (searchStr as String) + "&priority=\(self.urgency)&inspectorID=\(self.appDel.user.user_id!)"
                
            print(loginUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "activityCodes")

            }
        } // end of the connectedToNetwork
        
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "activityCodes" {
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            print(str)
            let parser = JsonParser()
        self.activityCodeArray = parser.parsePoolActivityCodes(data)
           print("Total Count \(self.activityCodeArray.count)")
            self.activityCodesTableView.reloadData()
        } // end of the identity
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("View Will appear called")
        self.categoryView.isHidden = true
        self.licenseSearchView.isHidden = true
        self.addressView.isHidden = true
        self.menuView.isHidden = false
        if UIDevice.current.userInterfaceIdiom == .pad {
        self.menuleftConstraint.constant = 100
            
        }
        else {
        self.menuleftConstraint.constant = 0
        }
        
        
    }
    func keyPad(){
    self.detailLicenseText.resignFirstResponder()
    self.detailLicenseSearch.resignFirstResponder()
    self.activityCodesTextField.resignFirstResponder()
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation!.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation!.setPreferred("ar", fallback: "en")
        }
  
        self.outerAddressView.layer.cornerRadius = 3.0
        
        self.licenseOuterView.layer.cornerRadius = 3.0
    self.view.sendSubview(toBack: self.filterbg)
        self.appDel.selectedUrgency = 0
        
        // Do any additional setup after loading the view.
//        "tasks.name/license" = "Name/License number";
//        "tasks.name/licenseDesc" = "Name/License number";
//        "tasks.address/region desc" = "Filter tasks by Name/License";

       self.priorityBtn.setTitle(localisation!.localizedString(key: "tasks.priority"), for: UIControlState())
        
        self.areaPriorityBtn.setTitle(localisation!.localizedString(key: "tasks.priority"), for: UIControlState())
        
        self.licenseNolbl.text = self.localisation?.localizedString(key: "tasks.name/license")
   self.licensedesc.text = self.localisation?.localizedString(key: "tasks.name/licenseDesc")
   self.addresslbl.text = self.localisation?.localizedString(key: "tasks.address/region title")
   self.addressdesc.text = self.localisation?.localizedString(key: "tasks.address/region desc")
    //self.detailLicenseText.placeholder = self.localisation?.localizedString(key: "tasks.address/region desc")
        
   self.mapTitle.text = self.localisation?.localizedString(key: "tasks.map")
   self.mapDesc.text = self.localisation?.localizedString(key: "tasks.filtertasksbymap")
   self.activityCodeDesc.text = self.localisation?.localizedString(key: "tasks.activitycodedesc")
    self.activityCodelbl.text = self.localisation?.localizedString(key: "tasks.activtiycode")
     self.activityCodesTextField.placeholder = self.localisation?.localizedString(key: "tasks.activtiycode")
      //  self..text = self.localisation?.localizedString(key: "tasks.activtiycode")
        
        self.detailAddresslbl.text = self.localisation?.localizedString(key: "tasks.address/region title")
        self.detailAddressDesc.text = self.localisation?.localizedString(key: "tasks.address/region desc")
 
        
        self.detailActivityCodeDesc.text = self.localisation?.localizedString(key: "tasks.activitycodedesc")
        self.detailActivityCodelbl.text = self.localisation?.localizedString(key: "tasks.activtiycode")

        self.detailLicenseTitle.text = self.localisation?.localizedString(key: "tasks.name/license")

        self.detailLicenseDesc.text = self.localisation?.localizedString(key: "tasks.name/licenseDesc")
        self.addressSearchBtn.setTitle(localisation?.localizedString(key: "tasks.search"), for: UIControlState())
        
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        
        _ = notificationCenter.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.activityCodesTextField, queue: mainQueue) { _ in
            // print("observer " + self.searchTextField.text!)
            
            //self.searchTasks()
            self.appDel.showIndicator = 0
            //let timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "lazyTasksDownloader", userInfo: nil, repeats: true)
            self.searchByActivityCode()
            
            
            //self.dataTable.reloadData()
        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showActivityCode(_ sender: AnyObject) {
      //  let vc = storyboard!.instantiateViewControllerWithIdentifier("cnt_activitycodesearch") as! ActivityCodeViewController
        //vc.finishDel = self
        //vc.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        //self.presentViewController(vc, animated: true, completion: nil)
      //  self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.categoryLeftConstraint.constant = 100
            
        }
        else {
            self.categoryLeftConstraint.constant = 02
            
        }
        self.menuleftConstraint.constant = -800
        self.categoryView.isHidden = false
        self.appDel.selectedUrgency = 0
        self.priorityBtn.setTitle(localisation!.localizedString(key: "tasks.priority"), for: UIControlState())
        self.urgency = 0
        self.priorityBtn.layer.borderColor = UIColor.clear.cgColor
        self.activityCodesTextField.text = ""
        self.activityCodeArray = NSMutableArray()
        self.activityCodesTableView.reloadData()
        

//        UIView.animateWithDuration(1.5, delay: 0,
//                                   usingSpringWithDamping: 0.5,
//                                   initialSpringVelocity: 0.5,
//                                   options: [], animations: {
//                                   
//                              //      self.categoryView.center.x =  400
//                                    
//            }, completion: nil)

        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5,
                                   options: [], animations: {
                                    
                              //      self.categoryView.center.x =  400
        self.view.layoutIfNeeded()

            }, completion: {
                (value: Bool) in
                self.licenseSearchView.isHidden = true
               self.addressView.isHidden = true
               // self.categoryView.hidden = true
                self.menuView.isHidden = true
        })
        

        
        
//        self.categoryView.center.x =  400
//        self.categoryView.center.x =  400
//        self.activityCodesTextField.becomeFirstResponder()
//        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

 // MARK:- ActivityCode tableview delegates and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityCodeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_searchactivitycode")
        let activityCode = self.activityCodeArray.object(at: indexPath.row) as! ActivityCodeDao
        let cellLabel : UILabel = cell!.contentView.viewWithTag(100) as! UILabel
        if self.appDel.selectedLanguage == 1{
            cellLabel.text = "\(activityCode.activity_name!) (\(activityCode.activity_code!))"
        }
       
        else {
            cellLabel.text = "\(activityCode.activity_name_arabic!) (\(activityCode.activity_code!))"
            
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.appDel.selectedActivityCode = self.activityCodeArray.object(at: indexPath.row) as? ActivityCodeDao
    self.appDel.selectedPoolOption = 2
    self.activityCodesTextField.resignFirstResponder()
    //self.navigationController?.popViewControllerAnimated(true)
        self.performSegue(withIdentifier: "sw_poollisting", sender: nil)
        
    }
   // MARK:- TextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
        if textField.text != "" {
            
         self.searchByActivityCode()
        }
        return true
    }
    
    
    
}
