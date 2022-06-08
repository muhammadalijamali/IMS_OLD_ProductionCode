//
//  PermitSearchViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 9/8/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class PermitSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MainJsonDelegate,DateSelectorDelegate,QRCodeDelegate,SessionPermitsDataDelegate ,UITextFieldDelegate,SearchSubVenueDelegate,UIPopoverPresentationControllerDelegate,UIAdaptivePresentationControllerDelegate,ABCSelectedDelegate{
    
    
    @IBOutlet weak var expiredSwitch: UISwitch!
    @IBOutlet weak var expiredlbl: UILabel!
   
    @IBOutlet weak var digitBtn: UIButton!

    var selectedCharacters : String? = ""
    var database = DatabaseManager()
    
    func codeSelected(_ code: String) {
        if code == "Select Code" {
            self.selectedCharacters = ""
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                self.digitBtn.setTitle(localisation.localizedString(key: "permit.selectCode"), for: UIControlState())
                
            }
            else {
                self.digitBtn.setTitle(localisation.localizedString(key: "permit.Code"), for: UIControlState())
                
            }
            }
        else {
        self.selectedCharacters = code
            self.digitBtn.setTitle(self.selectedCharacters, for: UIControlState())
        }
        
    }
    
    
    @IBAction func digitDropdown(_ sender: UIButton) {
        
        
//        let alert : UIAlertController = UIAlertController(title: "Select Code", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//        for a in 0  ..< self.atozArray.count {
//
//            let action1 : UIAlertAction = UIAlertAction(title:atozArray.objectAtIndex(a) as? String, style: UIAlertActionStyle.Default, handler: {
//           
//                self.selectedCharacters = self.atozArray.objectAtIndex(a) as? String
//                self.digitBtn.setTitle(self.selectedCharacters, forState: UIControlState.Normal)
//                
//            })
//            
//            alert.addAction(action1)
//        
//        }
//        let action1 : UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
//        alert.addAction(action1)
//        
//        self.presentViewController(alert, animated: true, completion: nil)
        
//        
//        let alert = SCLAlertView()
//        
//        
//        alert.showCloseButton = false
//      
//        for a in 0  ..< self.atozArray.count {
//      
//            alert.addButton(self.atozArray.objectAtIndex(a) as! String, action: {
//            
//    
//    })
//        }
//        alert.showInfo("Select I dont know what", subTitle: "")
        
        
        
        let popController = storyboard!.instantiateViewController(withIdentifier: "cnt_atoz") as! ABCViewController
        //popController.licenseNo = self.licenseNoTextField.text
        popController.del = self
        
            popController.view.backgroundColor = UIColor().withAlphaComponent(1.0)
        popController.del = self
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender // button
        popController.popoverPresentationController?.sourceRect = sender.bounds
        self.present(popController, animated: true, completion: nil)
        

        
    }
    
    
    
    @IBAction func subVenueMethod(_ sender: UIButton) {
        if self.licenseNoTextField.text != "" {
        let popController = storyboard!.instantiateViewController(withIdentifier: "cnt_searchsubvenue") as! SearchSubvenueController
          popController.licenseNo = self.licenseNoTextField.text
          popController.del = self
        
       // vc.modalPresentationStyle = UIModalPresentationStyle.FormSheet
       // self.presentViewController(vc, animated: true, completion: nil)
          
           // var nav = UINavigationController(rootViewController: vc)
            //nav.modalPresentationStyle = UIModalPresentationStyle.Popover
            //var popover = nav.popoverPresentationController! as UIPopoverPresentationController
           // popover.delegate = self
           // popover.popoverContentSize = CGSizeMake(1000, 300)
           // popover.sourceView = self.view
           // popover.sourceRect = CGRectMake(100,100,0,0)
            
           // self.presentViewController(nav, animated: true, completion: nil)
        
        
            //let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("cnt_searchsubvenue") as! CategoryViewController
            popController.view.backgroundColor = UIColor().withAlphaComponent(1.0)
            popController.del = self
            // set the presentation style
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = sender // button
            popController.popoverPresentationController?.sourceRect = sender.bounds
            self.present(popController, animated: true, completion: nil)

        
        }
        
        
    }
    @IBAction func expiredSwitchAction(_ sender: UISwitch) {
   self.searchMethod(sender)
    }
    
   
    func subVenueSearched(_ subvenue: SubVenueDao) {
        self.subvenueBtn.setTitle(subvenue.subVenue, for: UIControlState())
        self.selectedSubvenueString = subvenue.subVenue!
        self.setupPermitDownloader()
    }
    func downloadSubVenues(){
    
        
        let loginUrl = Constants.baseURL + "getSubVenueListing"
        print(loginUrl)
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "subvenues")
        
        
        

        
    }
    
    @IBOutlet weak var subvenueBtn: UIButton!
    
    @IBOutlet weak var syncBtn: UIButton!
    var rotateTimer: Timer?
    var syncDone : Bool = false
    var allSubvenues : NSMutableArray = NSMutableArray()
    var selectedSubvenueString : String = ""
    
    
    @IBOutlet weak var extendedOuterView: UIView!
    
    @IBOutlet weak var driverNoTextField: MarginTextField!
    @IBOutlet weak var plateNoSearchField: MarginTextField!
    
    func allRequestedDataDownloaded(_ data: Data, identity: String) {
        let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print(str)
        syncDone = true
        
        
        let parser = JsonParser()
        let allpermits = parser.perseAllPermits(NSMutableData(data: data))
        let database = DatabaseManager()
        database.deleteDrivers()
        database.deleteOfflinePermits()
        database.deleteVehicles(allpermits)
       // database.addAllPermits(allpermits)
        print("All permits added")
       
        print("Sync done")
        
        downloadAllDump()
        
        //        for p in 0 ..< allpermits.count {
        //        let p1 = allpermits.objectAtIndex(p) as? MainPermitDao
        //           print("Permit id \(p1!.permitID) has \(p1?.drivers.count) drivers has \(p1?.vehicles.count) has vehcils")
        //
        //        }
    }
    
    
    func downloadAllDump(){
        if Reachability.connectedToNetwork() {
            
            let downloader  = DataDownloader()
            downloader.delegate = self
            self.appDel.showIndicator = 1
            
            downloader.startDownloader(Constants.baseURL + "getCompaniesActivityDump", idn: "dump")
            
            
            
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
        if (textField == self.licenseNoTextField || self.companyNameTextField == textField) && self.licenseNoTextField.text != "" {
        
            self.subvenueBtn.isEnabled = true
            
        }
        
        self.searchMethod(textField)
        return true
        
    }
    func setupOfflinePermits(){
        if Reachability.connectedToNetwork() {
            self.rotate()
            // self.rotateTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "rotate", userInfo: nil, repeats: true)
            
            
            let session = AllPermitSessionDownloader()
            session.del = self
            let loginUrl = Constants.baseURL + "getPermitsInfo"
            
            print(loginUrl)
            
            session.setupDataDownloader(loginUrl, identity: "allpermits")
        }
        else {
            SCLAlertView().showInfo("", subTitle: localisation.localizedString(key: "general.checkinternet"))
            
            
        }// end of the else
        
        
        
    }
    func rotate(){
        print("ROTATE")
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: { () ->  Void in
            self.syncBtn.transform = self.syncBtn.transform.rotated(by: CGFloat(M_PI_2))
        }) { (finished) -> Void in
            if self.syncDone == false {
                self.rotate()
            }
        } }
    
    @IBAction func syncMethod(_ sender: UIButton) {
        self.setupOfflinePermits()
    }
    @IBOutlet weak var noRecordslbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func cancelMethod(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var subVenueTextField: MarginTextField!
    
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var permitTable: UITableView!
    @IBOutlet weak var alternameNoTextField: MarginTextField!
    @IBOutlet weak var permitNoTextField: MarginTextField!
    @IBOutlet weak var startDateBtn: ADButton!
    var permitsArray : NSMutableArray = NSMutableArray()
    var firstDate : Date?
    var secondDate : Date?
    var whichDate : Int = 0 // 0 first date 1 second data
    var reportType : String = "report"
    let formater : DateFormatter = DateFormatter()
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var localisation : Localisation!
    var MAX_FIELD_LENGTH : Int = 4
    var permitType : String = "All"
    var companyArray : NSMutableArray = NSMutableArray()
    var searchType : Int = 0 // 0 for permits  1 for companies
    var companiesArray : NSMutableArray = NSMutableArray()
    
    
    
    
    @IBOutlet weak var licenseNoTextField: MarginTextField!
    
    func codeDetected(_ code: String) {
        self.permitNoTextField.text = code
        self.searchMethod(self.view)
    }
    
    @IBOutlet weak var companyNameTextField: MarginTextField!
    @IBAction func startDateMethod(_ sender: ADButton) {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let menuViewController: DateSelectorViewController = storyboard.instantiateViewController(withIdentifier: "cnt_date") as! DateSelectorViewController
        menuViewController.delegate = self
        menuViewController.button = sender
        self.whichDate = 0
        self.appDel.calenderHisyoty = 1
        
        
        
        menuViewController.modalPresentationStyle = .popover
        //menuViewController.preferredContentSize = CGSizeMake(50, 100)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .any
        // popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = (sender as? UIButton)
        
        //        popoverMenuViewController?.sourceRect = CGRect(
        //            x: location.x,
        //            y: location.y,
        //            width: 1,
        //            height: 1)
        present(
            menuViewController,
            animated: true,
            completion: nil)
        
    }
    
    @IBOutlet weak var endDateBtn: UIButton!
    
    
    @IBAction func startScanning(_ sender: AnyObject) {
        self.openScanner()
    }
    @IBAction func clearMethod(_ sender: AnyObject) {
        self.permitsArray = NSMutableArray()
        
        self.companyNameTextField.text = ""
        self.licenseNoTextField.text = ""
        //self.alternameNoTextField.text = ""
        self.permitNoTextField.text = ""
        //self.subVenueTextField.text = ""
        self.driverNoTextField.text = ""
        self.permitNoTextField.text = ""
        self.plateNoSearchField.text = ""
        self.subvenueBtn.isEnabled = false
        self.selectedSubvenueString = ""
        self.selectedCharacters = ""
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.digitBtn.setTitle("Select Code", for: UIControlState())
            
        }
        else {
            self.digitBtn.setTitle("Code", for: UIControlState())
            
        }

        
        
        
//        if self.permitType == "Safari" && Reachability.connectedToNetwork() {
//            
//            self.permitTable.moveDownView()
//            self.extendedOuterView.makeHidden()
//            self.permitType = "All"
//            
//            self.locationBtn.setTitle("All", forState: UIControlState.Normal)
//            
//            
//        }
        
        
        // self.startDateBtn.setTitle("", forState: UIControlState.Normal)
        // self.endDateBtn.setTitle("", forState: UIControlState.Normal)
        
        self.firstDate = nil
        self.secondDate = nil
        self.noRecordslbl.isHidden = true
        self.searchType = 0
        self.companiesArray = NSMutableArray()
        self.permitTable.reloadData()
        
        /*
         "permit.alternatenumber" = "Alternate Number";
         "permit.permitnumber" = "Permit Id";
         "permit.location" = "Location";
         
         */
        
        //self.alternameNoTextField.placeholder = localisation.localizedString(key: "permit.alternatenumber")
        self.subvenueBtn.setTitle(localisation.localizedString(key:"permit.subvenue"), for: UIControlState())

        self.permitNoTextField.placeholder = localisation.localizedString(key: "permit.permitnumber")
        //.placeholder = localisation.localizedString(key: "permit.permitnumber")
        //self.locationBtn.setTitle(localisation.localizedString(key:"history.selecttype"), forState: UIControlState.Normal)
        self.companyNameTextField.placeholder = localisation.localizedString(key: "company.companyname")
        self.licenseNoTextField.placeholder = localisation.localizedString(key: "company.licenseno")
        self.startDateBtn.setTitle(localisation.localizedString(key: "company.issueDate"), for: UIControlState())
        self.endDateBtn.setTitle(localisation.localizedString(key: "company.expirtydate"), for: UIControlState())
        //self.searchBtn.setTitle(localisation.localizedString(key: "tasks.search"), forState: UIControlState.Normal)
        self.startDateBtn.setTitle(self.getDateByDays(-365) + ":" + localisation.localizedString(key: "company.issueDate")   , for: UIControlState())
        self.endDateBtn.setTitle(self.getDateByDays(365) + ":" + localisation.localizedString(key: "company.expirtydate"), for: UIControlState())
        
        self.setexpiry1Year()
        self.setissue1YearOld()
        
       // self.searchBtn.setTitle(localisation.localizedString(key: "tasks.search"), forState: UIControlState.Normal)
        
        
        
    }
    @IBOutlet weak var searchBtn: UIButton!
    
    @objc func openCreateInspection(_ sender : PermitBtn){
       
        if self.driverNoTextField.text != "" {
            self.appDel.searchedCar = ""
            
            self.appDel.searchedDriver = self.driverNoTextField.text
        }
            
        else if self.plateNoSearchField.text != "" {
            self.appDel.searchedDriver = ""
            self.appDel.searchedCar = self.plateNoSearchField.text
        }

        
        let cnt = self.storyboard?.instantiateViewController(withIdentifier: "cnt_addInspection") as! SearchViewController
        cnt.searchType = 1
        cnt.searchText = sender.license_No!
        self.navigationController?.pushViewController(cnt, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sw_searchsubvenue" {
            let popoverViewController = segue.destination
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }

    func searchByNumberPlate(){
    let databaseManager = DatabaseManager()
    let allPlate = databaseManager.searchVehiclesWithPlateNo(self.plateNoSearchField.text!)
        for a in allPlate   {
            if let a1 = a as? VehicleInfo {
            print(a1.plateNo)
              a1.plateNo? = (a1.plateNo?.replacingOccurrences(of: " ", with: ""))!
            a1.plateNo? = (a1.plateNo?.replacingOccurrences(of: "-", with: ""))!
                print(a1.plateNo)
            }
            else {
            print("Not Vehcile")
            }
        }
    
    }
    
    @IBAction func searchMethod(_ sender: AnyObject) {
       
        
        
        let missingData = SCLAlertView()
        self.permitNoTextField.resignFirstResponder()
        self.licenseNoTextField.resignFirstResponder()
        //self.subVenueTextField.resignFirstResponder()
        self.companyNameTextField.resignFirstResponder()
        if   self.permitType == "Safari"  || self.permitType == "Camp" {
            
            if self.licenseNoTextField.text == ""  && self.permitNoTextField.text == "" && self.driverNoTextField.text == "" && self.plateNoSearchField.text == "" {
                missingData.showError("Missing Data", subTitle: "Provide Permit Id/Select Company/License No./Plate No./Driver No. to search")
                
                
                
                return
                
            }
            
             searchByNumberPlate()
            
           
            
            let databaseManager = DatabaseManager()
            
            let tempArray:NSMutableArray  = databaseManager.searchPermitsWithPlateNoAndLicenseNo(Util.getEnglishNo(self.plateNoSearchField.text!),license_no: Util.getEnglishNo(self.driverNoTextField.text!),lic_no: Util.getEnglishNo(licenseNoTextField.text!),permitId: Util.getEnglishNo(permitNoTextField.text!),type: self.permitType, code: self.selectedCharacters)
            
            self.permitsArray = NSMutableArray()
            print("Temp array \(tempArray.count)")
            for permit in tempArray {
                //  print("issue date :\((permit as! MainPermitDao).issuedDate!) expiry Date \((permit as! MainPermitDao).expiryDate!)")
                let dateformat = DateFormatter()
                dateformat.dateFormat = "dd/MM/yyyy"
                
                //print("issue date :\(dateformat.dateFromString((permit as! MainPermitDao).issuedDate!)) expiry Date \((permit as! MainPermitDao).expiryDate!)")
                if (permit as! MainPermitDao).startDate != nil && (permit as! MainPermitDao).expiryDate != nil {
                    let permitIssueDate = dateformat.date(from: (permit as! MainPermitDao).startDate!)
                    let permitExpiryDate = dateformat.date(from: (permit as! MainPermitDao).expiryDate!)
                    if permitIssueDate != nil && permitExpiryDate != nil {
                        if self.firstDate!.isLessThanDate(permitIssueDate!) && (self.secondDate?.isGreaterThanDate(permitExpiryDate!))! {
                            print("date is within range")
                            if self.expiredSwitch.isOn {
                            
                            self.permitsArray.add(permit)
                            }
                            else {
                                if (permitExpiryDate!.isLessThanDate(Date()) ) {
                                print("permit is expired")
                                }
                                else {
                                    self.permitsArray.add(permit)
                                    
                                }
                            }
                        }
                        else {
                            print("date is not within range outside if \(self.firstDate!)")

                            if permitIssueDate!.isLessThanDate(Date(timeIntervalSince1970: 1000))  {
                            
                               // print(permit as! MainPermitDao).issuedDate
                            print("date is not within range \(permitIssueDate) ")
                                self.permitsArray.add(permit)

                            }
                        }
                    }
                    else {
                        self.permitsArray.add(permit)
                        
                    }
                    
                }
                else {
                    self.permitsArray.add(permit)
                    
                }
                //print("issue date :\(dateformat.stringFromDate(dat!)) expiry Date \((permit as! MainPermitDao).expiryDate!)")
                
                
                //print("searched issue date :\(self.fir)searched expiry Date \((permit as! MainPermitDao).expiryDate!)")
                
                
            }// end of the for loop
            if self.permitsArray.count == 0 {
                self.noRecordslbl.isHidden = false
            }
            else {
                self.noRecordslbl.isHidden = true
                
            }
            
            //print("Permit Count \(self.permitsArray.count)")
            
            self.hideAllKeyPads()
            self.permitTable.reloadData()
            return
            
        }
        
        
        
        
        
        if self.licenseNoTextField.text == ""  && self.permitNoTextField.text == "" {
            missingData.showError("Missing Data", subTitle: "Provide Permit Id/Select Company/License No. to search")
            
            
            
            return
            
        }
        
        if (self.licenseNoTextField.text! as NSString).length < self.MAX_FIELD_LENGTH  && (self.companyNameTextField.text == "" && self.permitNoTextField.text == "")  {
            
            missingData.showError(self.localisation.localizedString(key: "permit.datalength"), subTitle:  self.localisation.localizedString(key: "permit.lenghtmessage"))
            
            return
            
        }
            
        else if (self.companyNameTextField.text! as NSString).length < self.MAX_FIELD_LENGTH && (self.licenseNoTextField.text == "" && self.permitNoTextField.text == "")  {
            missingData.showError(self.localisation.localizedString(key: "permit.datalength"), subTitle:  self.localisation.localizedString(key: "permit.lenghtmessage"))
            return
            
        }
        else if (self.licenseNoTextField.text == "" && self.companyNameTextField.text == "" && self.permitNoTextField.text == ""){
            missingData.showError(self.localisation.localizedString(key: "permit.datalength"), subTitle:  self.localisation.localizedString(key: "permit.lenghtmessage"))
            return
            
            
        }
        else if (self.permitNoTextField.text! as NSString).length < self.MAX_FIELD_LENGTH && (self.licenseNoTextField.text == "" && self.companyNameTextField.text == ""){
            missingData.showError(self.localisation.localizedString(key: "permit.datalength"), subTitle:  self.localisation.localizedString(key: "permit.lenghtmessage"))
            return
            
            
        }
        
        
        self.setupPermitDownloader()
    }
    
    
    func hideAllKeyPads(){
    self.licenseNoTextField.resignFirstResponder()
    self.companyNameTextField.resignFirstResponder()
    self.permitNoTextField.resignFirstResponder()
    //self.subVenueTextField.resignFirstResponder()
    self.driverNoTextField.resignFirstResponder()
    self.plateNoSearchField.resignFirstResponder()
        
    }
    
    
    
    @IBAction func categoryMethod(_ sender: UIButton) {
        let alert = SCLAlertView()
        
        
        alert.showCloseButton = false
        
        alert.addButton("All", action: {
           
            if self.permitType == "Safari" || self.permitType == "Camp" {
                self.permitTable.moveDownView()
            }
            
            self.extendedOuterView.makeHidden()
            self.permitType = "All"
            
            self.locationBtn.setTitle("All", for: UIControlState())
            
        })
        
        
        alert.addButton("Event", action: {
           
            if self.permitType == "Safari"  || self.permitType == "Camp"{
                self.permitTable.moveDownView()
            }
            self.permitType = "Multiple Times"
            self.extendedOuterView.makeHidden()
            
            self.locationBtn.setTitle("Event", for: UIControlState())
            
        })
        
        
        
        alert.addButton("Activity", action: {
           
            if self.permitType == "Safari" || self.permitType == "Camp" {
                self.permitTable.moveDownView()
            }
            self.permitType = "Activity"
            self.extendedOuterView.makeHidden()
            self.locationBtn.setTitle("Activity", for: UIControlState())
            
        })
        
//        alert.addButton("Camp", action: {
//           
//            if self.permitType == "Safari" || self.permitType == "Camp" {
//                //self.permitTable.moveDownView()
//            }
//            else {
//                self.extendedOuterView.makeVisible()
//                self.permitTable.moveUpView()
//            }
//            self.permitType = "Camp"
//            //   self.extendedOuterView.makeHidden()
//            self.locationBtn.setTitle("Camp", forState: UIControlState.Normal)
//            
//        })
        
        alert.addButton("Safari & Camps", action: {
           
            if self.permitType == "Safari" || self.permitType == "Camp" {
                
            }
            else {
                self.extendedOuterView.makeVisible()
                self.permitTable.moveUpView()
                
            }
            self.permitType = "Safari"
            self.locationBtn.setTitle("Safari & Camps", for: UIControlState())
            
            
            
        })
        
        alert.addButton("Holiday Home", action: {
           
            self.extendedOuterView.makeHidden()
            if self.permitType == "Safari" || self.permitType == "Camp"{
                self.permitTable.moveDownView()
            }
            self.permitType = "HolidayHome"
            self.locationBtn.setTitle("Holiday Home", for: UIControlState())
            
        })
        
        
        
        
        alert.addButton("",tag:250 , action: {
           
            
        })
        
        
        alert.showInfo(localisation.localizedString(key: "history.selecttype"), subTitle: "")
        
        
        
        
        
    }
    @IBAction func endDateMethod(_ sender: ADButton) {
        
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let menuViewController: DateSelectorViewController = storyboard.instantiateViewController(withIdentifier: "cnt_date") as! DateSelectorViewController
        menuViewController.delegate = self
        menuViewController.button = sender
        self.whichDate = 1
        self.appDel.calenderHisyoty = 2
        
        
        
        
        menuViewController.modalPresentationStyle = .popover
        //menuViewController.preferredContentSize = CGSizeMake(50, 100)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .any
        // popoverMenuViewController?.delegate = self
        
        popoverMenuViewController?.sourceView = (sender as UIButton)
        
        
        present(
            menuViewController,
            animated: true,
            completion: nil)
        
        
    }
    
    func openScanner(){
        let cnt = storyboard?.instantiateViewController(withIdentifier: "cnt_sqcodescan") as! QRCodeViewController
        cnt.del = self
        self.present(cnt, animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController? .setNavigationBarHidden(true, animated:true)

    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController? .setNavigationBarHidden(true, animated:true)
        self.title = ""
        self.appDel.selectedDrivers = NSMutableArray()
        self.appDel.selectedVehicles = NSMutableArray()
        
        self.appDel.offlinePermit = nil
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationIte
        self.permitsArray = NSMutableArray()
        
        self.navigationController? .setNavigationBarHidden(true, animated:true)
        
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        
        // =  localisation.localizedString(key: "permit.permit")
        
        
        self.appDel.searchedDriver = ""
        self.appDel.searchedCar = ""
        
        // formater.dateFormat = "YYYY-MM-dd"
        formater.dateFormat = "dd/MM/YYY"
        //"permit.driverno" = "رقم تصريح سائق";
        //"permit.plateno" = "رقم المركبة";
        self.driverNoTextField.placeholder =  localisation.localizedString(key: "permit.driverno")
        self.plateNoSearchField.placeholder = localisation.localizedString(key: "permit.plateno")
        self.expiredlbl.text = localisation.localizedString(key: "permit.expired")
        
        
        // self.alternameNoTextField.placeholder = localisation.localizedString(key: "permit.alternatenumber")
        self.permitNoTextField.placeholder = localisation.localizedString(key: "permit.permitnumber")
       // self.per.placeholder = localisation.localizedString(key: "permit.subvenue")
        self.subvenueBtn.setTitle(localisation.localizedString(key:"permit.subvenue"), for: UIControlState())
        
        //.placeholder = localisation.localizedString(key: "permit.permitnumber")
        //self.locationBtn.setTitle(localisation.localizedString(key:"history.selecttype"), forState: UIControlState.Normal)
        self.locationBtn.setTitle("Type : All", for: UIControlState())
        
        self.companyNameTextField.placeholder = localisation.localizedString(key: "company.companyname")
        self.licenseNoTextField.placeholder = localisation.localizedString(key: "company.licenseno")
        //self.startDateBtn.setTitle(localisation.localizedString(key: "company.issueDate"), forState: UIControlState.Normal)
        //self.endDateBtn.setTitle(localisation.localizedString(key: "company.expirtydate"), forState: UIControlState.Normal)
        
        self.startDateBtn.setTitle(self.getDateByDays(-365) + ":" + localisation.localizedString(key: "company.issueDate")   , for: UIControlState())
        self.endDateBtn.setTitle(self.getDateByDays(365) + ":" + localisation.localizedString(key: "company.expirtydate"), for: UIControlState())
       // self.searchBtn.setTitle(localisation.localizedString(key: "tasks.search"), forState: UIControlState.Normal)
        
        
       // self.cancelBtn.setTitle(localisation.localizedString(key: "searchcompany.clear"), forState: UIControlState.Normal)
        self.noRecordslbl.text = localisation.localizedString(key: "general.norecordsfound")
        self.setexpiry1Year()
        self.setissue1YearOld()
        
        
        
        
        //        if let placeholder = alternameNoTextField.placeholder {
        //      //  self.alternameNoTextField.attributedPlaceholder = NSAttributedString(string:placeholder, attributes: [NSForegroundColorAttributeName: UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)])
        //
        //        }
        
        if let placeholder = licenseNoTextField.placeholder {
            self.licenseNoTextField.attributedPlaceholder = NSAttributedString(string:placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)])
            
        }
        
        if let placeholder = permitNoTextField.placeholder {
            self.permitNoTextField.attributedPlaceholder = NSAttributedString(string:placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)])
            
        }
        
        if let placeholder = companyNameTextField.placeholder {
            self.companyNameTextField.attributedPlaceholder = NSAttributedString(string:placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)])
            
        }
        
        
        
        if Reachability.connectedToNetwork() {
            
        }
        else {
            
            SCLAlertView().showInfo("No Internet available", subTitle: localisation.localizedString(key: "Only safari/Camps permits are available offline"))
            self.permitType = "Safari"
            self.locationBtn.setTitle("Safari & Camps", for: UIControlState())
            
            self.permitTable.moveUpView()
            self.extendedOuterView.makeVisible()
            self.hideAllKeyPads()
            //self.permitTable.backgroundColor = UIColor.redColor()
            
        }
        
        
        
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        
        
        let observer = notificationCenter.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.companyNameTextField, queue: mainQueue) { _ in
            
            
            
            
            
            //self.setupSearchDownloader(self.searchTextField.text!, licenseNo: self.licenseNoSearch.text!)
            // if Reachability.connectedToNetwork() {
            self.searchType = 1
            self.appDel.showIndicator = 0
            
            
            self.setupSearchDownloader(self.companyNameTextField.text!)
            // }
            
        }
        
        let observer_licenseNo = notificationCenter.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.licenseNoTextField, queue: mainQueue) { _ in
            
            
            self.searchType = 1
            self.appDel.showIndicator = 0
            
            
            self.setupSearchDownloader(self.companyNameTextField.text!)
            
//            if Reachability.connectedToNetwork() {
//
//            }
//            else {
//                self.searchType = 1
//                let database = DatabaseManager()
//                self.companiesArray = database.fetchAllCompaniesByLicenseNoAndCompanyName(self.licenseNoTextField.text!,company_name:"")
//                print(self.companyArray.count)
//
//                self.permitTable.reloadData()
//            }
            
        }
        
        
        
        
         if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.digitBtn.setTitle(localisation.localizedString(key: "permit.selectCode"), for: UIControlState())
            
        }
        else {
            self.digitBtn.setTitle(localisation.localizedString(key: "permit.Code"), for: UIControlState())
            
        }

        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func setupSearchDownloader(_ companyName : String){
        
        if Reachability.connectedToNetwork() {
            let database = DatabaseManager()
             let tempArray = database.fetchAllCompaniesByLicenseNoAndCompanyName(self.licenseNoTextField.text!,company_name: companyName)
            if tempArray.count > 0 {
               self.companiesArray = tempArray
                self.permitTable.reloadData()
            return
            }
            else {
            
            
            
            let searchUrl = Constants.baseURL + "searchCompanies?company_name=" + companyName + "&license_no="
             self.appDel.showIndicator = 0
            
            print(searchUrl)
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(searchUrl, idn: "searchCompany")
            }
        } // END OF THE IF
        else {
            let database = DatabaseManager()
            self.companiesArray = database.fetchAllCompaniesByLicenseNoAndCompanyName(self.licenseNoTextField.text!,company_name: companyName)
            // print("Total Count \(self.companiesArray)")
            //  self.companyArray = database.fetchAllCompanies(companyName)
            // print("Searching for \(companyName)")
            self.permitTable.reloadData()
            
            
            
        } // end of the i
       // self.hideAllKeyPads()
        
    }
    func setupPermitDownloaderWithDates(){
        if Reachability.connectedToNetwork() {
            
            if self.firstDate != nil && self.secondDate != nil {
                let versionUrl = Constants.baseURL + "getePermitForEstablishments?permit_no=&license_no=&permit_type=\(self.permitType)&establishment_name=&address=&alternative_no=&issue_date=\(self.formater.string(from: self.firstDate!))&expire_date=\(self.formater.string(from: self.secondDate!))"
                
                
                print(versionUrl)
                
                let downloader : DataDownloader = DataDownloader()
                downloader.delegate = self
                downloader.startDownloader(versionUrl, idn: "permits")
            }
        }
        
    }
    func setupPermitDownloader(){
        
        if Reachability.connectedToNetwork() {
            var expired : String = "No"
            if self.expiredSwitch.isOn {
            expired = "Yes"
            }
            else {
                expired = "No"
                
            }
            
            if self.firstDate != nil  && self.secondDate != nil {
                let versionUrl = Constants.baseURL + "getePermitForEstablishments?permit_no=\(self.permitNoTextField.text!)&license_no=\(self.licenseNoTextField.text!)&permit_type=\(self.permitType)&establishment_name=\(self.companyNameTextField.text!)&address=&alternative_no=&issue_date=\(self.formater.string(from: self.firstDate!))&SubVenue=\(self.selectedSubvenueString)&expire_date=\(self.formater.string(from: self.secondDate!))&IncludeExpired=\(expired)"
                
                self.searchType = 0
                self.companyArray = NSMutableArray()
                
                
                print(versionUrl)
                
                let downloader : DataDownloader = DataDownloader()
                downloader.delegate = self
                self.appDel.showIndicator = 1
                downloader.startDownloader(versionUrl, idn: "permits")
                
            }
            else {
                if self.permitNoTextField.text == "" && self.licenseNoTextField.text == "" && self.companyNameTextField.text == "" {
                    let alert = SCLAlertView()
                    alert.showCloseButton = false
                    alert.addButton("Dismiss", action: {
                       
                        
                    })
                    alert.showError("Missing Data!", subTitle: "Provide some data to search")
                    return
                }
                
                
                let versionUrl = Constants.baseURL + "getePermitForEstablishments?permit_no=\(self.permitNoTextField.text!)&license_no=\(self.licenseNoTextField.text!)&permit_type=\(self.permitType)&establishment_name=\(self.companyNameTextField.text!)&address=&SubVenue=\(self.subVenueTextField.text!)&alternative_no=&issue_date=&expire_date=&IncludeExpired=\(expired)"
                
                
                
                
                
                
                print(versionUrl)
                
                let downloader : DataDownloader = DataDownloader()
                downloader.delegate = self
                downloader.startDownloader(versionUrl, idn: "permits")
                
                
                
                
            }
        }
        else{
            let database = DatabaseManager()
            database.countAllPermits()
            database.countAllDrivers()
            database.countAllVehicles()
            
            let array = database.fetchAllPermitsByPermitId(self.permitNoTextField!.text!)
            self.permitsArray = NSMutableArray()
            self.permitsArray = array
            self.permitTable.reloadData()
            
            if self.permitsArray.count > 0  {
                self.noRecordslbl.isHidden = true
            }
            else {
                self.noRecordslbl.isHidden = false
                
            }
            //print("total search \(array.count)")
            
            
        }
        
        
    }
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        //let str = String(data: data, encoding: NSUTF8StringEncoding)
        //print("\(identity) : \(str)")
        
        if identity == "permits" {
            let parser = JsonParser()
            self.permitsArray = parser.parsePermits(data)
            if self.permitsArray.count > 0 {
                self.noRecordslbl.isHidden = true
            }
            else {
                self.noRecordslbl.isHidden = false
                self.view.bringSubview(toFront: self.noRecordslbl)
            }
            
            self.permitTable.reloadData()
            
        } // end if the identity
        if identity == "searchCompany" {
            let parser = JsonParser()
            self.noRecordslbl.isHidden = true
            self.companiesArray = parser.parseSearchdCompanies(data)
            self.permitTable.reloadData()
            
        }
        if identity == "subvenues" {
            let parser = JsonParser()
            self.allSubvenues = parser.parseSubVenues(data)
            
            for sub in self.allSubvenues {
                if let sub1 = sub as? SubVenueDao {
                
                }// end of the if
            }
            
            

            
        
        }
        else if identity == "dump" {
           
            print(" \n dump downloaded")
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            print(str ?? "")
            let parser = JsonParser()
           
            let array = parser.parseCompanies(data)
            let activityCodeArray = parser.parseActivityCodes(data)
            let categoryArray = parser.parseCategories(data)
            let catActArray = parser.parseCatActCodes(data)
            let catCompArray = parser.parseCompanyActCodes(data)
            let mainInspectionList = parser.parseMainInspectionList(data)
            let questionCategories = parser.parseQuestionsCategories(data)
            var questionsArray : NSMutableArray = NSMutableArray()
            
            questionsArray = parser.parseQuestionsForOffline(data)

            
            //let catCompanyArray = parser.pa
            
            self.database.deleteAllCompanies()
            self.database.deleteAllActivityCodes()
            self.database.deleteAllCatAct()
            self.database.deleteAllCatCompany()
            self.database.deleteAllMainInspectionList()
            self.database.deleteAllQuestion()
            self.database.deleteAllOptions()
            self.database.deleteAllExtraOptions()
            self.database.deleteAllQuestionCategories()

            self.database.addCompanies(array)
        
            self.database.addActivityCode(activityCodeArray)
            self.database.addCatActCodes(catActArray)
            self.database.addInspectionListMain(mainInspectionList)
            self.database.addInspectionList(questionsArray, taskid: "0")
            self.database.addCategories(questionCategories: questionCategories)
           
            self.database.deleteAllCategories()
            //print("adding category \(categoryArray.count)")
            self.database.addCategories(categoryArray)
            self.database.addCatCompanyCodes(catCompArray)
          self.syncDone = true
            
        }
        
        
        
        
        
        
    }
    
    
    
    @IBAction func toggleMenu(_ sender: AnyObject) {
        self.revealViewController().revealToggle(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TABLEVIEW DELETEGATE AND DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchType == 0 {
            if self.permitsArray.count > 0{
            self.noRecordslbl.isHidden = true
            }
            return  self.permitsArray.count
        }
        else{
            if self.companiesArray.count > 0 {
                self.noRecordslbl.isHidden = true
            }
            return self.companiesArray.count
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView(frame:CGRect(x: 0, y: 0, width: 50, height: tableView.frame.width))
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        return view
        
    
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.plateNoSearchField {
        let aSet = CharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
        }
        else {
        return true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchType == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_permit") as! PermitCells
            if indexPath.row % 2 == 0 {
                cell.contentView.backgroundColor =  UIColor.white
            }
            else {
                cell.contentView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
            }
            
            
            cell.licenseNolbl.text = localisation.localizedString(key: "searchcompany.licenseno")
            cell.permitTylelbl.text = localisation.localizedString(key: "permit.subvenue")
            cell.startDatelbl.text =  localisation.localizedString(key: "company.issueDate")
            cell.expiryDatelbl.text = localisation.localizedString(key: "company.expirtydate")
            cell.permitNolbl.text = localisation.localizedString(key: "permit.permitno")
            
            cell.createInspectionBtn.addTarget(self, action: #selector(PermitSearchViewController.openCreateInspection(_:)), for: UIControlEvents.touchUpInside)
            
            
            //        "company.issueDate" = "Issue Date";
            //        "company.expirtydate" = "Expiry Date";
            //
            
            //cell.companyName.setTitle(dao.company_name, forState: UIControlState.Normal)
            print("Permit Type : \(self.permitType)")
            if Reachability.connectedToNetwork() && self.permitType != "Safari" && self.permitType != "Camp" {
                
                let dao = self.permitsArray.object(at: indexPath.row) as! PermitDao
                
                if self.appDel.selectedLanguage == 1 && dao.company_name != nil {
                    cell.companyName.setTitle(dao.company_name, for: UIControlState())
                    
                }
                else  if  self.appDel.selectedLanguage == 2 && dao.company_name_arabic != nil {
                    
                    cell.companyName.setTitle(dao.company_name_arabic, for: UIControlState())
                    print(dao.company_name_arabic)
                    
                }
                else {
                    cell.companyName.setTitle(dao.company_name, for: UIControlState())
                    
                }
                let dateformat = DateFormatter()
                dateformat.dateFormat = "MM/dd/yyyy"
         //       print("Date ss \(dateformat.dateFromString(dao.expire_date!))")
//                var date = dateformat.dateFromString(dao.expire_date!)
//                if date == nil {
//                dateformat.dateFormat = "MM/DD/yyyy hh:mm:ss a"
//                }
                if dao.expire_date != nil {
                    if dateformat.date(from: dao.expire_date!) != nil {
                if (dateformat.date(from: dao.expire_date!)!.isLessThanDate(Date()) )
                {
                    cell.contentView.backgroundColor = UIColor(red: 255/255, green: 231/255, blue: 229/255, alpha: 1.0)
                    
                
                }
                }
                }

                
                cell.startDateVal.text = dao.issue_date
                cell.expiryDateVal.text = dao.expire_date
                cell.permitNoVal.text = dao.permitID
                //cell.permitTypeVal.text = dao.permit_type
                cell.permitTypeVal.text = dao.sub_venue
                cell.licenseNoVal.text = dao.license_info
                cell.createInspectionBtn.license_No = dao.license_info
            }
            else {
                let dao = self.permitsArray.object(at: indexPath.row) as! MainPermitDao
                cell.startDateVal.text = dao.startDate
                cell.expiryDateVal.text = dao.expiryDate
                cell.permitNoVal.text = dao.permitID
                let dateformat = DateFormatter()
                
                dateformat.dateFormat = "dd/MM/yyyy"
                
                
                if dao.expiryDate != nil {
                    if dateformat.date(from: dao.expiryDate!) != nil {
                        if (dateformat.date(from: dao.expiryDate!)!.isLessThanDate(Date()) )
                        {
                    cell.contentView.backgroundColor = UIColor(red: 255/255, green: 231/255, blue: 229/255, alpha: 1.0)
                    
                    
                }
                    }
                }
                
                
                //cell.permitTypeVal.text = dao.permit_type
                //cell.permitTypeVal.text = dao.subVenue
                cell.permitTypeVal.text = ""
                
                cell.createInspectionBtn.tag = indexPath.row
                
                
                cell.createInspectionBtn.license_No = dao.businessLicense
                cell.licenseNoVal.text = dao.businessLicense
                cell.companyName.setTitle(dao.organizerName, for: UIControlState())
            }
            
            
            return cell
        }
        else {
            let cell : SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_searchCompany") as! SearchTableViewCell
            let dao = self.companiesArray.object(at: indexPath.row) as! CompanyDao
            if dao.company_name != nil {
                cell.companyNameLbl.text = dao.company_name!
            }
            if dao.license_info != nil {
                cell.licenseNumberLbl.text = dao.license_info!
            }
            
            if dao.company_name_arabic != nil {
                cell.company_name_ar.text = dao.company_name_arabic!
            }
            cell.licensenolbl.text = localisation.localizedString(key: "searchcompany.licenseno")
            if indexPath.row % 2 == 0 {
                cell.contentView.backgroundColor =  UIColor.white
            }
            else {
                cell.contentView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
            }
            
            
            
            return cell
            
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.appDel.selectedDrivers = NSMutableArray()
       self.appDel.selectedVehicles = NSMutableArray()
       self.companyNameTextField.resignFirstResponder()
       self.licenseNoTextField.resignFirstResponder()
        
        
        
        if self.driverNoTextField.text != "" {
            self.appDel.searchedCar = ""
            
            self.appDel.searchedDriver = self.driverNoTextField.text
        }
            
        else if self.plateNoSearchField.text != "" {
            self.appDel.searchedDriver = ""
            self.appDel.searchedCar = self.plateNoSearchField.text
            self.appDel.selectedCode = self.selectedCharacters
            
        }
        
        if Reachability.connectedToNetwork() && self.permitType != "Safari" &&  self.permitType != "Camp"{
            if self.searchType == 1 {
                let company = self.companiesArray.object(at: indexPath.row) as! CompanyDao
                self.licenseNoTextField.text = company.license_info
                self.companyNameTextField.text = ""
                self.subvenueBtn.isEnabled = true
                self.companyNameTextField.resignFirstResponder()
                self.companiesArray = NSMutableArray()
                
                self.setupPermitDownloader()
            }
            else {
                let permit = self.permitsArray.object(at: indexPath.row) as! PermitDao
                permit.fromSearch = 1
                self.appDel.selectedPermit = permit
                self.performSegue(withIdentifier: "sw_openpdf", sender: nil)
            }
        }// end of if internet available
        else {
            //self.performSelector("sw_sw_offlinepermit", withObject: nil)
            if self.searchType == 1 {
                let company = self.companiesArray.object(at: indexPath.row) as! CompanyDao
                let database = DatabaseManager()
                self.licenseNoTextField.text = company.license_info
                self.companyNameTextField.text = company.company_name
                
                self.searchType = 0
                self.permitsArray = database.fetchAllPermitsByLicenseNo(self.licenseNoTextField.text!)
                self.permitTable.reloadData()
            }
            else {
                let permit = self.permitsArray.object(at: indexPath.row) as! MainPermitDao
                permit.searchedCar = Util.getEnglishNo(self.plateNoSearchField.text!)
                permit.seachedDrLicense = Util.getEnglishNo(self.driverNoTextField.text!)
                
                self.appDel.offlinePermit = permit
                
                
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "sw_offlinepermit", sender: nil)
                }
            }
            
        }// end of the else
        
    }// end of the fuction
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  95
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func dateDeletced(_ date: Date, button: ADButton) {
        
        formater.locale = Locale(identifier: "en_US")
        
        
        if self.whichDate == 0 {
            self.firstDate = date
            self.startDateBtn.setTitle(formater.string(from: self.firstDate!), for: UIControlState())
            
            //   self.firstText.text = formater.stringFromDate(date)
            if self.firstDate != nil && self.secondDate != nil {
                //  self.setupPermitDownloaderWithDates()
                // self.setupDownloaderWithDate(self.reportType, startDate: formater.stringFromDate(self.firstDate!), endDate: formater.stringFromDate(self.secondDate!))
                
                
            } // end of the if
        }
        else {
            //    self.secondText.text = formater.stringFromDate(date)
            self.endDateBtn.setTitle(formater.string(from: date), for:UIControlState())
            self.secondDate = date
            
            if self.firstDate != nil {
                // self.setupPermitDownloaderWithDates()
                //self.setupDownloaderWithDate(self.reportType, startDate: formater.stringFromDate(self.firstDate!), endDate: formater.stringFromDate(self.secondDate!))
                
            }
            //  self.setupDownloaderWithDate(self.ty, startDate: <#String#>, endDate: <#String#>)
        }
    }
    
    
    
}
extension PermitSearchViewController {
    func getDateByDays(_ days : Int)-> String{
        let today: Date = Date()
        
        let daysToAdd:Int = days
        
        // Set up date components
        var dateComponents: DateComponents = DateComponents()
        dateComponents.day = daysToAdd
        
        // Create a calendar
        var gregorianCalendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let yesterDayDate: Date = (gregorianCalendar as NSCalendar).date(byAdding: dateComponents, to: today, options:NSCalendar.Options(rawValue: 0))!
        return formater.string(from: yesterDayDate)
        
        
        
    }
    func setexpiry1Year(){
        var dateComponents: DateComponents = DateComponents()
        dateComponents.day = 365
        // Create a calendar
        let today: Date = Date()
        
        let gregorianCalendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let yesterDayDate: Date = (gregorianCalendar as NSCalendar).date(byAdding: dateComponents, to: today, options:NSCalendar.Options(rawValue: 0))!
        self.secondDate = yesterDayDate
        
    }
    
    func setissue1YearOld(){
        var dateComponents: DateComponents = DateComponents()
        dateComponents.day = -365
        // Create a calendar
        let today: Date = Date()
        
        let gregorianCalendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let yesterDayDate: Date = (gregorianCalendar as NSCalendar).date(byAdding: dateComponents, to: today, options:NSCalendar.Options(rawValue: 0))!
        self.firstDate =  yesterDayDate
        
    }
    
}
extension UIView {
    func makeHidden() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 1.0, delay: 0.2, options:
            UIViewAnimationOptions.curveEaseOut, animations: {
                self.alpha = 0
                
            }, completion: { finished in
                self.isHidden = true
        })
    }// end of the fade in
    
    func makeVisible() {
        UIView.animate(withDuration: 1.0, delay: 0.2, options:
            UIViewAnimationOptions.curveEaseOut, animations: {
                self.isHidden = false
                self.alpha = 1.0
            }, completion: { finished in
                
                
        })
        
        
        
        
    }
    func moveUpView()
    {
        
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 5.0, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + 45, width: self.frame.width, height: self.frame.height)
            
            }, completion: { finished in
                
                
        })
        
    }
    
    func moveDownView()
    {
        
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 5.0, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - 45, width: self.frame.width, height: self.frame.height)
            
            }, completion: { finished in
                
                
        })
        
    }
    
    
}
extension Date {
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending || self.compare(dateToCompare) == ComparisonResult.orderedSame{
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending || self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
}
