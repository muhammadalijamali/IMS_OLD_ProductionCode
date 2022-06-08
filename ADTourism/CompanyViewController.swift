//
//  CompanyViewController.swift
//  ADTourism
//
//  Created by Administrator on 8/30/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit
import MapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



 class CompanyViewController: UIViewController  , MKMapViewDelegate , MainJsonDelegate , UITableViewDataSource , UITableViewDelegate , CLLocationManagerDelegate , UITextFieldDelegate , UITextViewDelegate,UIPopoverPresentationControllerDelegate,UIAdaptivePresentationControllerDelegate ,AreasDelegate {
    
    @IBOutlet weak var companyName_ar: UILabel!
    @IBOutlet weak var companyNameLbl_en: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    @IBOutlet weak var fourstar: UIImageView!
    @IBOutlet weak var thirdstar: UIImageView!
    @IBOutlet weak var firststar_1: UIImageView!
    
    @IBOutlet weak var fifthstar: UIImageView!
    @IBOutlet weak var secondstart: UIImageView!
    @IBOutlet weak var star_view: UIView!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var permitsTable: UITableView!
    //@IBOutlet weak var addressNotesText: MarginTextField!
    
    var allAreas : NSMutableArray = NSMutableArray()
    
    
    
    @IBOutlet weak var nopermitserror: UILabel!
    
    @IBOutlet weak var aealbl: UILabel!
    
    @IBOutlet weak var distancelbl: UILabel!
    @IBOutlet weak var violationHistoryTitleAr: UITextField!
    @IBOutlet weak var drivingbtn: UIButton!
    var locationManager: CLLocationManager = CLLocationManager()
    var loc : CLLocationCoordinate2D?

    
    @IBOutlet weak var addressNotes: UITextView!
    var userDefault : UserDefaults = UserDefaults.standard
    
    
    @IBOutlet weak var violationHistoryTitleEng: UITextField!
    @IBOutlet weak var cmpnyaddrsnts: UILabel!
    
    @IBOutlet weak var saveaddressNotesBtn: UIButton!
    @IBOutlet weak var companyNotes: UITextView!
    @IBAction func saveNotes(_ sender: AnyObject) {
    
        self.updatedata()
        
    }
    
    
    
    @IBOutlet weak var areaBtn: UIButton!
    func updateCompanyArea(_ areaId : String) {
        let loginUrl = Constants.baseURL + "updateCompanyArea?companyID=" + self.appDel.taskDao.company.company_id! + "&area_id=" + areaId
        print(loginUrl)
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "updatearea")
        

        
    }// end of the method
    
    func areaCodeDetected(_ area: AreaDao) {
        self.areaBtn.setTitle(area.area_name_ar, for: UIControlState())
       // print(area.area_name_ar)
        self.updateCompanyArea(area.area_id!)
    }
    
    
    
    
    @IBAction func openAreaPopup(_ sender: UIButton) {
    
        
        if Reachability.isConnectedNetwork() {
//            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            self.outerScroll.setContentOffset(CGPointMake(0, 400), animated: true)
//                
//            }

            
            let popController = storyboard!.instantiateViewController(withIdentifier: "cnt_area") as! AreasViewController
            popController.view.backgroundColor = UIColor().withAlphaComponent(1.0)
            popController.del = self
            popController.fromDetail = 1
           
            
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            //popController.modalInPopover = true
            
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = sender // button
            popController.popoverPresentationController?.sourceRect = sender.bounds
            self.present(popController, animated: true, completion: nil)
            
            
        }else {
            let alert = UIAlertController(title: "", message: localisation.localizedString(key: "general.checkinternet"), preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }

    
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }

    
    @IBOutlet weak var prosavebtn: UIButton!
    @IBOutlet weak var companyntslbl: UILabel!
    var history : TaskHistoryDao?
    
    
    @IBAction func savePro(_ sender: AnyObject) {
     self.updatedata()
        
    }
    @IBOutlet weak var companyNoteslbl: UILabel!
    
    @IBOutlet weak var companyNotesText: MarginTextField!
    let databaseManager = DatabaseManager()
    
    @IBOutlet weak var addressNoteslbl: UILabel!
    @IBOutlet weak var addressValuelbl: UILabel!
    @IBOutlet weak var licenseNoValueLbl: UILabel!
    @IBOutlet weak var companyDetaillbl: UILabel!
    @IBOutlet weak var saveLocationBtn: UIButton!
    @IBOutlet weak var warningHistorylbl: UILabel!
    @IBOutlet weak var violationHistorylbl: UILabel!
    @IBOutlet weak var nowarningslbl: UILabel!
    @IBAction func saveLocationMethod(_ sender: AnyObject) {
        if self.appDel.userLocation != nil {
            self.appDel.taskDao.company.lat = "\(self.appDel.userLocation!.latitude)"
            self.appDel.taskDao.company.lon = "\(self.appDel.userLocation!.longitude)"
            
            // TODO: Track the user action that is important for you.
           // Answers.logContentView(withName: "Tweet", contentType: "Video", contentId: "1234", customAttributes: ["Favorites Count":20, "Screen Orientation":"Landscape"])

            self.updatedata()
            
        
        } // end of the userLocation
        
    }
    @IBOutlet weak var noViolationsLbl: UILabel!
    @IBOutlet weak var violationsTable: UITableView!
    @IBOutlet weak var warningsTable: UITableView!
    @IBOutlet weak var violationView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var outerScroll: UIScrollView!
    @IBOutlet weak var companyDetailView: UIView!
    var warnings : NSMutableArray = NSMutableArray()
    
    var violations : NSMutableArray = NSMutableArray()
    
    
    @IBAction func onMyMethod(_ sender: AnyObject) {
//        if self.appDel.taskDao.is_submitted == "0" {
//            self.informUser()
//            return
//        }

        
        
        if Reachability.connectedToNetwork() {
        self.appDel.showIndicator = 1
        }
        else {
        let alert : UIAlertController = UIAlertController(title:localisation.localizedString(key: "general.checkinternet"), message: "", preferredStyle: UIAlertControllerStyle.alert)
        let action1 : UIAlertAction = UIAlertAction(title: localisation.localizedString(key: "tasks.cancelonway"), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
        return
        }
        
        if self.appDel.taskDao.task_status == "on_way" {
        self.setupChangeTaskStatus(self.appDel.taskDao.task_id)
        }
        else {
            if self.appDel.alreadyOnTheWay == 1 {
//            let alert = UIAlertController(title: "On Way", message:"You can only make one task 'On Way'" , preferredStyle: UIAlertControllerStyle.Alert)
//                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
//               alert.addAction(action)
//                self.presentViewController(alert, animated: true, completion: nil)
//           

                SCLAlertView().showError(localisation.localizedString(key: "tasks.onmyway"), subTitle: localisation.localizedString(key: "tasks.You can only make one task 'On Way'"))
                
                
                return
                
            }
        self.makeOnMyWay()
        }
    }
    
    
    func informUser(){
        let alert = UIAlertController(title: "Co-Inspection", message: "This task is not submitted by first inspector", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    

    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBAction func startMethod(_ sender: AnyObject) {
        if self.appDel.taskDao.is_submitted == "0" {
            self.informUser()
            return
        }

        
        
        if Reachability.connectedToNetwork() {
        
        if self.appDel.userLocation != nil {
      //  self.performSegueWithIdentifier("sw_companytoquestions", sender: nil)
            self.appDel.showIndicator = 1
            self.uploadTheLocation()
        
        }
        } // end of the network check
        else if self.appDel.taskDao.is_pool == "1" {
//            let listAlert = SCLAlertView()
//            listAlert.showCloseButton = false
//            
//            for catg in self.appDel.listArray {
//                if let lDao = catg as? ListDao {
//                    listAlert.addButton(lDao.list_name!, action: {
//                        self.appDel.list_id = lDao.list_id!
//                        self.appDel.taskDao.list_id = lDao.list_id!
//                        self.performSegueWithIdentifier("sw_companytoquestions", sender: nil)
//                        
//                    })
//                    
//                }// end of the if
//                
//            }
//            listAlert.addButton(localisation.localizedString(key: "tasks.dismiss"), action: {
//                
//            })
//            listAlert.showInfo("Pool Task", subTitle: self.localisation.localizedString(key:"tasks.pleaseselectinspectiontype"))
//            // end of the for loop
//            
            
         self.setupCatgAlert()
        } // end if the pool if

        
        else {
             self.appDel.list_id = self.appDel.taskDao.list_id
            
            self.performSegue(withIdentifier: "sw_companytoquestions", sender: nil)

            
        } // network not available
        
        
    }
    
    func uploadTheLocation(){
        if self.appDel.userLocation != nil{
            self.appDel.showIndicator = 1
            let numLat = NSNumber(value: (self.appDel.userLocation!.latitude) as Double as Double)
            let numLon = NSNumber(value: (self.appDel.userLocation!.longitude) as Double as Double)
            
            //  let stLat:String = numLat.stringValue
            //let loginUrl = Constants.baseURL + "updateInspectorLocation?inspector_id=" + self.appDel.user.user_id + "&latitude=" + numLat.stringValue + "&longitude=" + numLon.stringValue
            if self.appDel.user.user_id != nil {
            let loginUrl = Constants.baseURL + "updateInspectorLocation?inspector_id=\(self.appDel.user.user_id) & latitude= \(numLat.stringValue)&longitude=\(numLon.stringValue)"
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "uploadlocation")
            }
        }
    }
    
    
    
    @IBOutlet weak var warningView: UIView!
    
    
    @IBOutlet weak var companyName_arLBL: UITextField!
    
    @IBOutlet weak var companyNameEn_lbl: UITextField!
    @IBOutlet weak var activityCodeLblValue: UILabel!
    @IBOutlet weak var onMyWayBtn: UIButton!
    @IBOutlet weak var companynamearview: UIView!
    @IBOutlet weak var companynamear: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var phonelbl: UILabel!
    @IBOutlet weak var companyCategorylbl: UILabel!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var pro_emailsText: UITextField!
    @IBOutlet weak var proNameText: UITextField!
    @IBOutlet weak var mobileNumberlbl: UILabel!
    
    @IBOutlet weak var pro_mobileText: UITextField!
    @IBOutlet weak var proEmailLbl: UILabel!
    @IBOutlet weak var pro_nameLbl: UILabel!
    @IBOutlet weak var activityCode: UILabel!
    @IBOutlet weak var emailvaluelbl: UILabel!
    @IBOutlet weak var mobilenovalue: UILabel!
    @IBOutlet weak var addresslbl: UILabel!
    @IBOutlet weak var licensenolbl: UILabel!
    @IBOutlet weak var companynamelbl: UILabel!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var licenseView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func saveMethod(_ sender: AnyObject) {
    self.downloadTasks()
        
    }
    @IBAction func driveMethod(_ sender: AnyObject) {
       
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:
            "comgooglemaps://?saddr=\(self.appDel.user.lat!),\(self.appDel.user.lon!)&daddr=\(self.appDel.taskDao.company.lat!),\(self.appDel.taskDao.company.lon!)")!)
      //  self.openMapForPlace()
        } else {
            NSLog("Can't use Google Maps");
            let urlstr : String = "http://maps.google.com/maps?saddr=\(self.appDel.user.lat),\(self.appDel.user.lon)&daddr=\(self.appDel.taskDao.company.lat),\(self.appDel.taskDao.company.lon)"
            UIApplication.shared.openURL(URL(string: urlstr)!)
            
        }
        
        
    }
    
    func openMapForPlace() {
        
        let lat1 : NSString = self.appDel.taskDao.company.lat as! NSString
        let lng1 : NSString = self.appDel.taskDao.company.lon as! NSString
        
        let latitute:CLLocationDegrees =  lat1.doubleValue
        let longitute:CLLocationDegrees =  lng1.doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(self.appDel.taskDao.company.company_name)"
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    @IBOutlet weak var companynametextar: UITextField!
    
    @IBOutlet weak var issueDateValuelbl: UILabel!
    @IBOutlet weak var expiryTextField: UITextField!
    @IBOutlet weak var expiryView: UIView!
    @IBOutlet weak var expirylbl: UILabel!
    
    @IBOutlet weak var companyTypeValue: UILabel!
    @IBOutlet weak var companyTypelbl: UILabel!
    @IBOutlet weak var expiryLblValue: UILabel!
    @IBOutlet weak var issueDateLbl: UILabel!
    @IBOutlet weak var issueDateText: UITextField!
    @IBOutlet weak var issueDateTextField: UITextField!
    @IBOutlet weak var issueDateView: UIView!
    @IBOutlet weak var landlinelbl: UILabel!
    
    @IBOutlet weak var addressNotesTextField: UITextField!
    @IBOutlet weak var landlineValue: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var areaView: UIView!
    @IBOutlet weak var companyNameView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var landline: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var areaText: UITextField!
    @IBOutlet weak var licenseText: UITextField!
    @IBOutlet weak var companyTexr: UITextField!
    @IBOutlet weak var companyView: UIView!
     var localisation : Localisation!
    var appDel:AppDelegate!
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        if self.appDel.backfromCheckList == 1 && self.appDel.showCompanyDetail == 0 {
            //self.onMyWayBtn.backgroundColor = UIColor(red: 101/255, green: 174/255, blue: 223/255, alpha: 1.0)
            //self.onMyWayBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.MakeMeActive()
        }
    }
    
    

    @IBAction func saveProInformation(_ sender: AnyObject) {
    //self.
    }
    
    
    
    
    func MakeMeActive(){
        // This method is used to make inspector active and inactive on criteria based
        if Reachability.connectedToNetwork() && self.appDel.userLocation != nil  {
            var loginUrl : String  = ""
            
            loginUrl = Constants.baseURL + "activeInactiveInspector?inspector_id=" + self.appDel.user.user_id + "&status=active&latitude=\(self.appDel.userLocation!.latitude)&longitude=\(self.appDel.userLocation!.longitude)"
            
            
            
            
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "extraactive")
            self.appDel.backfromCheckList = 0
        }
        else {
            
        }
        
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func downloadHistory(){

    if self.appDel.taskDao.company.company_id != nil && self.appDel.taskDao.company.license_info != nil {
        var history : String  = ""
        self.appDel.showIndicator = 0
      //  self.noViolationsLbl.text = "Loading Violations ......"
      //  self.noViolationsLbl.hidden = false
        
        
        history = Constants.baseURL + "getEstablishmentViolationHistory?companyId=" + self.appDel.taskDao.company.company_id! + "&licenseNo=\(self.appDel.taskDao.company.license_info!)"
        
        print(history)
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(history, idn: "violation_history")
        }
    }
    
    
    func downloadWarning(){
    
        if self.appDel.taskDao.company.company_id != nil {
        var history : String  = ""
        self.appDel.showIndicator = 0
        self.nowarningslbl.text = "Loading Warnings ......"
        self.nowarningslbl.isHidden = false
        
        
        history = Constants.baseURL + "getEstablishmentWarningHistory?companyId=" + self.appDel.taskDao.company.company_id!
        
        
        print(history)
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(history, idn: "warnings")
        }
        
    }
    
    func setupCompanyDetailDownloader(){
        if self.history != nil {
            if self.history!.company_id != nil {
            var history : String  = ""
            self.appDel.showIndicator = 1
            
            
            history = Constants.baseURL + "getCompanyDetailById?companyId=" + self.history!.company_id!
            
            
            print(history)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(history, idn: "company")
            }
            }
    
    }
    func setupCompanyData(){
        if Reachability.connectedToNetwork() {
            self.downloadHistory()
            self.downloadAllAreas()
        }
        if self.appDel.taskDao.company.companyPermits.count > 0 {
            self.permitsTable.isHidden = false
            self.nopermitserror.isHidden = true
        }
        else {
            self.permitsTable.isHidden = true
            self.nopermitserror.isHidden = false
            
        }
    
        self.saveLocationBtn.setTitle(localisation.localizedString(key: "company.updatelocation"), for: UIControlState())
        self.locationMethod()
        self.companyntslbl.text = localisation.localizedString(key: "company.notes")
        self.cmpnyaddrsnts.text = localisation.localizedString(key: "company.addressnotes")
        if self.appDel.taskDao.company.pro_mobile != nil {
            self.pro_mobileText.text = self.appDel.taskDao.company.pro_mobile
        }
        
        if self.appDel.taskDao.company.pro_name != nil {
            self.proNameText.text = self.appDel.taskDao.company.pro_name
        }
        
        if self.appDel.taskDao.company.email_pro != nil {
            self.pro_emailsText.text = self.appDel.taskDao.company.email_pro
        }
        
        
        if self.appDel.taskDao.company.activity_code != nil {
            self.activityCodeLblValue.text = self.appDel.taskDao.company.activity_code
        }
        
        
        if self.appDel.taskDao.company.company_note != nil {
            self.companyNotes.text = self.appDel.taskDao.company.company_note!
            // self.addressNotes.text = self.appDel.taskDao.company.company_note!
        }
        
        if self .appDel.taskDao.company.address_note != nil {
            self.addressNotesTextField.text = self.appDel.taskDao.company.address_note!
        }
        

        
        self.title = localisation.localizedString(key: "company.companydetail")
        
        self.companyNameLbl_en.text = self.appDel.taskDao.company.company_name

      //  self.companyNameEn_lbl.text = self.appDel.taskDao.company.company_name
        self.companyName_ar.text = self.appDel.taskDao.company.company_name_arabic
        self.licenseNoValueLbl.text = self.appDel.taskDao.company.license_info
        self.issueDateValuelbl.text = self.appDel.taskDao.company.license_issue_date
        
        
        self.expiryLblValue .text = self.appDel.taskDao.company.license_expire_date
        
        self.addressValuelbl.text = self.appDel.taskDao.company.address
        self.companyTypeValue.text = self.appDel.taskDao.company.type_name
        self.landlineValue.text = self.appDel.taskDao.company.landline
        self.mobilenovalue.text = self.appDel.taskDao.company.pro_mobile
        self.emailvaluelbl.text = self.appDel.taskDao.company.email
        
        self.star_view.isHidden = true
        
        
        
        self.licensenolbl.text = self.localisation.localizedString(key: "company.licenseno")
        self.addresslbl.text = self.localisation.localizedString(key: "company.address")
        self.phonelbl.text = self.localisation.localizedString(key: "company.mobileno")
        self.landlinelbl.text = self.localisation.localizedString(key: "company.landline")
        self.emaillbl.text = self.localisation.localizedString(key:"company.Email")
        //        self.saveBtn.setTitle(self.localisation.localizedString(key: "company.save"), forState: UIControlState.Normal)
        self.drivingbtn.setTitle(self.localisation.localizedString(key: "company.driving"), for: UIControlState())
        self.companyTypelbl.text = self.localisation.localizedString(key: "company.category")
        //   self.companynamear.text = self.localisation.localizedString(key: "company.namear")
        self.issueDateLbl.text = self.localisation.localizedString(key: "company.issueDate")
        self.expirylbl.text = self.localisation.localizedString(key: "company.expirtydate")
        self.activityCode.text = self.localisation.localizedString(key: "company.activtiycodes")
        self.pro_nameLbl.text = self.localisation.localizedString(key: "finalise.name")
        self.mobileNumberlbl.text = self.localisation.localizedString(key: "finalise.mobilenumber")
        self.proEmailLbl.text = self.localisation.localizedString(key: "finalise.email")
        self.saveaddressNotesBtn.setTitle(localisation.localizedString(key: "company.update"), for: UIControlState())
        self.saveBtn.setTitle(localisation.localizedString(key: "company.update"), for: UIControlState())
        
        self.prosavebtn.setTitle(localisation.localizedString(key: "company.update"), for: UIControlState())
        
        print("company lat \(self.appDel.taskDao.company.lat) company long \(self.appDel.taskDao.company.lon)")
        if self.appDel.taskDao.company.lat != nil && self.appDel.taskDao.company.lon != nil && Int(self.appDel.taskDao.company.lat) < 99 {
            if ((self.appDel.taskDao.company.lat) as NSString).range(of: "0.0").location == NSNotFound && ((self.appDel.taskDao.company.lon) as NSString).range(of: "0.0").location == NSNotFound {
                
                
                self.setupPin()
            }
            
            
        }
        
        self.view.bringSubview(toFront: self.buttonView)
        
        if self.appDel.taskDao.company.activity_code != nil {
        if self.appDel.taskDao.company.activity_code!.contains("Hotel (551099)") {
            self.star_view.isHidden = false
            print("STARS \(self.appDel.taskDao.company.star)")
            self.firststar_1.isHidden = true
            self.secondstart.isHidden = true
            self.thirdstar.isHidden = true
            self.fourstar.isHidden = true
            self.fifthstar.isHidden = true
            if self.appDel.taskDao.company.star != nil {
            if self.appDel.taskDao.company.star!.contains("1") {
                self.firststar_1.isHidden = false
            }
            if self.appDel.taskDao.company.star!.contains("2") {
                self.firststar_1.isHidden = false
                self.secondstart.isHidden = false
            }
            if self.appDel.taskDao.company.star!.contains("3") {
                self.firststar_1.isHidden = false
                self.secondstart.isHidden = false
                self.thirdstar.isHidden = false
            }
            if self.appDel.taskDao.company.star!.contains("4") {
                self.firststar_1.isHidden = false
                self.secondstart.isHidden = false
                self.thirdstar.isHidden = false
                
                self.fourstar.isHidden = false
            }
            if self.appDel.taskDao.company.star!.contains("5") {
                self.firststar_1.isHidden = false
                self.secondstart.isHidden = false
                self.thirdstar.isHidden = false
                self.fourstar.isHidden = false
                self.fifthstar.isHidden = false
            }
            }
            else {
                self.star_view.isHidden = true

            }
        }
        else {
            self.star_view.isHidden = true
            
        }
        
        }
    
    
    
        
    }

    func setupData(){
    
        print("SETUP DATA IS CALLED")
        if Reachability.connectedToNetwork() {
            self.downloadHistory()
        }else {
            //self.violations = self.databaseManager.fetchViolations()
            //self.violationsTable.reloadData()
        }
        
        if self.appDel.taskDao.company.companyPermits.count > 0 {
            self.permitsTable.isHidden = false
            self.nopermitserror.isHidden = true
        }
        else {
            self.permitsTable.isHidden = true
            self.nopermitserror.isHidden = false
            
        }
        
        // self.violationHistoryTitleAr.text = ""
        self.saveLocationBtn.setTitle(localisation.localizedString(key: "company.updatelocation"), for: UIControlState())
        self.locationMethod()
        self.companyntslbl.text = localisation.localizedString(key: "company.notes")
        self.cmpnyaddrsnts.text = localisation.localizedString(key: "company.addressnotes")
        self.appDel.fromCompany = 1
        
        
        
        
        //  self.warningView.layer.borderWidth = 1.0
        //  self.warningView.layer.borderColor = UIColor.whiteColor().CGColor
        //  self.warningView.layer.cornerRadius = 4.0
        //  self.warningView.layer.masksToBounds = true
        self.startBtn.setTitle(localisation.localizedString(key: "tasks.starttask"), for: UIControlState())
        
        if self.appDel.taskDao.company.pro_mobile != nil {
            self.pro_mobileText.text = self.appDel.taskDao.company.pro_mobile
        }
        
        if self.appDel.taskDao.company.pro_name != nil {
            self.proNameText.text = self.appDel.taskDao.company.pro_name
        }
        
        if self.appDel.taskDao.company.email_pro != nil {
            self.pro_emailsText.text = self.appDel.taskDao.company.email_pro
        }
        
        
        if self.appDel.taskDao.company.activity_code != nil {
            self.activityCodeLblValue.text = self.appDel.taskDao.company.activity_code
        }
        
        
        if self.appDel.taskDao.company.company_note != nil {
            self.companyNotes.text = self.appDel.taskDao.company.company_note!
            // self.addressNotes.text = self.appDel.taskDao.company.company_note!
        }
        
        if self .appDel.taskDao.company.address_note != nil {
            self.addressNotesTextField.text = self.appDel.taskDao.company.address_note!
        }
        
        //self.buttonsView.backgroundColor = UIColor(patternImage: UIImage(named: "tablebg")!)
        
        
        
        self.onMyWayBtn.setTitle(localisation.localizedString(key: "tasks.onmyway"), for: UIControlState())
        
        //   self.violationHistorylbl.text = localisation.localizedString(key: "company.violationshistory")
        //  self.warningHistorylbl.text = localisation.localizedString(key: "company.warninghistory")
        //  self.companyDetaillbl.text = localisation.localizedString(key: "company.companydetail")
        self.title = localisation.localizedString(key: "company.companydetail")
        
        
        
        
        if self.appDel.taskDao.task_status == "on_way" {
            
            // self.onMyWayBtn.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
            // self.onMyWayBtn.backgroundColor =  UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 1.0)
            self.onMyWayBtn.setTitle(localisation.localizedString(key: "questions.cancel"), for: UIControlState())
            self.startBtn.isHidden = false
        }
        else {
            /// self.onMyWayBtn.backgroundColor = UIColor(red: 101/255, green: 174/255, blue: 223/255, alpha: 1.0)
            //self.onMyWayBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.startBtn.isHidden = true
            
            
            print("Hidding the start button")
            
        }
        
        if self.appDel.user.status == "Inactive" {
            self.onMyWayBtn.isHidden = true
            self.startBtn.isHidden = true
            print("Hidding the start in inactive")

            
        }
        
        if Reachability.connectedToNetwork(){
        }else {
            self.onMyWayBtn.isHidden = true
            self.startBtn.isHidden = false
            
            
        }
        
        
        
        
        
        //self.startBtn.backgroundColor = UIColor(red: 101/255, green: 174/255, blue: 223/255, alpha: 1.0)
        //self.drivingbtn.backgroundColor = UIColor(red: 101/255, green: 174/255, blue: 223/255, alpha: 1.0)
        self.companyNameLbl_en.text = self.appDel.taskDao.company.company_name
        self.companyName_ar.text = self.appDel.taskDao.company.company_name_arabic
        self.licenseNoValueLbl.text = self.appDel.taskDao.company.license_info
        self.issueDateValuelbl.text = self.appDel.taskDao.company.license_issue_date
        
        
        self.expiryLblValue .text = self.appDel.taskDao.company.license_expire_date
        
        self.addressValuelbl.text = self.appDel.taskDao.company.address
        self.companyTypeValue.text = self.appDel.taskDao.company.type_name
        self.landlineValue.text = self.appDel.taskDao.company.landline
        self.mobilenovalue.text = self.appDel.taskDao.company.pro_mobile
        self.emailvaluelbl.text = self.appDel.taskDao.company.email
        
        
        
        
        
        self.licensenolbl.text = self.localisation.localizedString(key: "company.licenseno")
        self.addresslbl.text = self.localisation.localizedString(key: "company.address")
        self.phonelbl.text = self.localisation.localizedString(key: "company.mobileno")
        self.landlinelbl.text = self.localisation.localizedString(key: "company.landline")
        self.emaillbl.text = self.localisation.localizedString(key:"company.Email")
        //        self.saveBtn.setTitle(self.localisation.localizedString(key: "company.save"), forState: UIControlState.Normal)
        self.drivingbtn.setTitle(self.localisation.localizedString(key: "company.driving"), for: UIControlState())
        self.companyTypelbl.text = self.localisation.localizedString(key: "company.category")
        //   self.companynamear.text = self.localisation.localizedString(key: "company.namear")
        self.issueDateLbl.text = self.localisation.localizedString(key: "company.issueDate")
        self.expirylbl.text = self.localisation.localizedString(key: "company.expirtydate")
        self.activityCode.text = self.localisation.localizedString(key: "company.activtiycodes")
        self.pro_nameLbl.text = self.localisation.localizedString(key: "finalise.name")
        self.mobileNumberlbl.text = self.localisation.localizedString(key: "finalise.mobilenumber")
        self.proEmailLbl.text = self.localisation.localizedString(key: "finalise.email")
        self.saveaddressNotesBtn.setTitle(localisation.localizedString(key: "company.update"), for: UIControlState())
        self.saveBtn.setTitle(localisation.localizedString(key: "company.update"), for: UIControlState())
        
        self.prosavebtn.setTitle(localisation.localizedString(key: "company.update"), for: UIControlState())
       
        print("company lat \(self.appDel.taskDao.company.lat) company long \(self.appDel.taskDao.company.lon)")
        if self.appDel.taskDao.company.lat != nil && self.appDel.taskDao.company.lon != nil {
        if self.appDel.taskDao.company.lat != nil && self.appDel.taskDao.company.lon != nil && Int(self.appDel.taskDao.company.lat) < 99 {
            if ((self.appDel.taskDao.company.lat) as NSString).range(of: "0.0").location == NSNotFound && ((self.appDel.taskDao.company.lon) as NSString).range(of: "0.0").location == NSNotFound && ((self.appDel.taskDao.company.lat) as NSString).range(of: ".000").location ==  NSNotFound {
                
                
                self.setupPin()
            }
            
            
        }
        }
       
        self.view.bringSubview(toFront: self.buttonView)

        
        
    }
    
    func setupPermits(){
        
        if self.appDel.taskDao != nil {
            if Reachability.connectedToNetwork() {
        let loginUrl = Constants.baseURL + "getCompanyPermitsByID?companyID=\(self.appDel.taskDao.company.company_id!)"
        
        
        
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "companyPermits")
        
            } // end of the internet checl
            else  if self.appDel.is_adhoc_inspection == 1{
                let database = DatabaseManager()
                self.appDel.taskDao.company.companyPermits = database.fetchAllPermitsByLicenseNo(self.appDel.taskDao.company.license_info)
                
                
                  print("Permit count \(self.appDel.taskDao.company.companyPermits.count)")
            
                if self.appDel.taskDao.company.companyPermits.count > 0 {
                    self.permitsTable.isHidden = false
                    self.nopermitserror.isHidden = true
                    self.permitsTable.reloadData()
                    
                }

                
            }// end of the condition
        }
        

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func hideKeyPad(){
    self.companyNotes.resignFirstResponder()
    }
    
    @IBAction func openMakani(_ sender: UIButton) {
        let popController = storyboard!.instantiateViewController(withIdentifier: "cnt_makani") as! MakaniViewController
        popController.view.backgroundColor = UIColor().withAlphaComponent(1.0)
       // popController.del = self
       // print("Makani \(self.appDel.taskDao.company.makani)")
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.isModalInPopover = true
        popController.preferredContentSize =  CGSize(width: 300, height: 250)

        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.unknown
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender // button
        popController.popoverPresentationController?.sourceRect = sender.bounds
        self.present(popController, animated: true, completion: nil)
        

    
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    
    func downloadAllAreas(){
        let loginUrl = Constants.baseURL + "getAreaListing"
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "areas")
        
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        self.violations = NSMutableArray()
        print("From History\(self.appDel.fromHistoryToResult)")
        //self.startBtn.hidden = true
       // let tap = UIGestureRecognizer(target: self, action: #selector(CompanyViewController.hideKeyPad))
       // self.outerScroll.addGestureRecognizer(tap)
        
        self.companyNotes.backgroundColor = UIColor(patternImage: UIImage(named: "newbigtextarea")!)
        
        self.title = ""
        //print("area id \(self.appDel.taskDao.company.area_id)")
        if self.appDel.taskDao != nil {
            if self.appDel.taskDao!.company != nil {
                if self.appDel.taskDao!.company!.area_id != nil {
                   self.downloadAllAreas()
                }
            }
        }
        
        
        
        self.localisation = Localisation()
        
        
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }
        if self.appDel.fromHistoryToResult == 1 {
            self.buttonView.isHidden = true
           
            if UIDevice.current.userInterfaceIdiom == .pad {
            self.topConst.constant = -30
            self.view.layoutIfNeeded()
            }
            else {
                self.topConst.constant = -30
                self.view.layoutIfNeeded()
            }
        self.setupCompanyDetailDownloader()
        }
        else{
            //self.topConst.constant = -98  // CHANGED
            if UIDevice.current.userInterfaceIdiom == .phone {
                self.topConst.constant = -30
                self.view.layoutIfNeeded()
            
            }
            self.view.layoutIfNeeded()
           self.setupData()
           self.setupPermits()
        }
        if self.appDel.fromHistoryToResult != 1 {
        if self.appDel.taskDao.company.activity_code != nil && self.appDel.taskDao.company.star != nil{
            if self.appDel.taskDao.company.activity_code!.contains("Hotel (551099)") {
            self.star_view.isHidden = false
                print("STARS \(self.appDel.taskDao.company.star)")
            self.firststar_1.isHidden = true
            self.secondstart.isHidden = true
            self.thirdstar.isHidden = true
            self.fourstar.isHidden = true
            self.fifthstar.isHidden = true
                if self.appDel.taskDao.company.star!.contains("1") {
                self.firststar_1.isHidden = false
                }
                if self.appDel.taskDao.company.star!.contains("2") {
                     self.firststar_1.isHidden = false
                    self.secondstart.isHidden = false
                }
                if self.appDel.taskDao.company.star!.contains("3") {
                    self.firststar_1.isHidden = false
                    self.secondstart.isHidden = false
                    self.thirdstar.isHidden = false
                }
                if self.appDel.taskDao.company.star!.contains("4") {
                    self.firststar_1.isHidden = false
                    self.secondstart.isHidden = false
                    self.thirdstar.isHidden = false

                    self.fourstar.isHidden = false
                }
                if self.appDel.taskDao.company.star!.contains("5") {
                    self.firststar_1.isHidden = false
                    self.secondstart.isHidden = false
                    self.thirdstar.isHidden = false
                    self.fourstar.isHidden = false
                    self.fifthstar.isHidden = false
                }
                
            }
            else {
            self.star_view.isHidden = true
            
            }
        }
        else {
        self.star_view.isHidden = true
        }
        }
        if self.appDel.showCompanyDetail == 1 {
        self.buttonView.isHidden = true
        }
        else if self.appDel.fromHistoryToResult == 0{
            self.buttonView.isHidden = false
            
        }
        
//        if self.appDel.taskDao.company.area_name != nil {
//        self.areaBtn.setTitle(self.appDel.taskDao.company.area_name, forState: UIControlState.Normal)
//        }
            }
    
    func updatedata(){
       // http://dev.einspection.net/DTCMServiceAPI/InspectionApi/updateCompanyInfo?company_id=1059&pro_contact_no=0312312312&pro_name=somnal&pro_email=info@som.com&address_note=10thfloor,%20clock%20street&company_note=This%20is%20test%20notes&latitude=24.3213213&longitude=67.4324234
        
        self.appDel.showIndicator = 1
        var loginUrl : String?
        if self.appDel.taskDao.company.contact_designation == nil {
        self.appDel.taskDao.company.contact_designation = ""
        }
        
        
        if self.appDel.taskDao.company.lat != nil {
         loginUrl = Constants.baseURL + "updateCompanyInfo?company_id=\(self.appDel.taskDao.company.company_id!)&pro_contact_no=\(self.pro_mobileText.text!)&pro_name=\(self.proNameText.text!)&pro_email=\(self.pro_emailsText.text!)&address_note=\(self.addressNotesTextField.text!)&company_note=\(self.companyNotes.text!)&latitude=\(self.appDel.taskDao.company.lat!)&longitude=\(self.appDel.taskDao.company.lon!)&contact_designation=\(self.appDel.taskDao.company.contact_designation!)"
        
        print(loginUrl)
        
        
        }
        else {
            if self.appDel.userLocation != nil {
                 loginUrl = Constants.baseURL + "updateCompanyInfo?company_id=\(self.appDel.taskDao.company.company_id!)&pro_contact_no=\(self.pro_mobileText.text!)&pro_name=\(self.proNameText.text!)&pro_email=\(self.pro_emailsText.text!)&address_note=\(self.addressNotesTextField.text!)&company_note=\(self.companyNotes.text!)&latitude=\(self.appDel.userLocation!.latitude)&longitude=\(self.appDel.userLocation!.longitude)&contact_designation=\(self.appDel.taskDao.company.contact_designation!)"
                
                
            }
            else {
                 loginUrl = Constants.baseURL + "updateCompanyInfo?company_id=\(self.appDel.taskDao.company.company_id!)&pro_contact_no=\(self.pro_mobileText.text!)&pro_name=\(self.proNameText.text!)&pro_email=\(self.pro_emailsText.text!)&address_note=\(self.addressNotesTextField.text!)&company_note=\(self.companyNotes.text!)&contact_designation=\(self.appDel.taskDao.company.contact_designation!)"
                
                
            }
            
            //print(loginUrl)
            
            
            
        }
        if Reachability.connectedToNetwork() {
        if loginUrl != nil {
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl!, idn: "editcompany")
            if self.addressNotesTextField.text != nil {
             self.appDel.taskDao.company.address_note = self.addressNotesTextField.text!
            }
            //self.appDel.taskDao.company.address_note = self.addressNotes.text!
            
            if self.companyNotes.text != nil {
            self.appDel.taskDao.company.company_note = self.companyNotes.text!
            }
            }
        
        
        } // end of the internet check
        else {
            
//            if self.appDel.taskDao.company.company_id != nil && loginUrl != nil {
//            self.appDel.userDefault.setObject(loginUrl, forKey: self.appDel.taskDao.company.company_id!)
//            var companyStr = self.appDel.userDefault.objectForKey("company") as? String
//                if companyStr != nil {
//                    companyStr = companyStr! + "," + self.appDel.taskDao.company.company_id!
//                    
//                }
//               self.appDel.userDefault.setObject(companyStr, forKey: "companycount")
//               self.appDel.userDefault.synchronize()
//                
//            } // end of the if

            if self.appDel.taskDao.company.company_id != nil && loginUrl != nil {
                if let companyArray = self.appDel.userDefault.object(forKey: "companies") as? NSArray {
                    let mutableArray = NSMutableArray(array: companyArray)
                    
                    mutableArray.add(loginUrl!)
                    self.databaseManager.addAddressNotes(addressNotesTextField.text!, company_notes: self.companyNotes.text, pro_name: self.proNameText.text, pro_email: self.pro_emailsText.text, pro_mobile: self.pro_mobileText.text, company_id: self.appDel.taskDao.company.company_id!)
                    self.appDel.taskDao.company.company_note = self.companyNotes.text
                    self.appDel.taskDao.company.address_note = self.addressNotesTextField.text
                    self.appDel.taskDao.company.pro_mobile = self.pro_mobileText.text
                    self.appDel.taskDao.company.pro_name = self.proNameText.text
                    self.appDel.taskDao.company.email_pro = self.pro_emailsText.text
                    
                
                } // end of the if
                else {
                let companyArray = NSMutableArray()
                companyArray.add(loginUrl!)
                self.appDel.userDefault.set(companyArray, forKey: "companies")
                    self.databaseManager.addAddressNotes(addressNotesTextField.text!, company_notes: self.companyNotes.text, pro_name: self.proNameText.text, pro_email: self.pro_emailsText.text, pro_mobile: self.pro_mobileText.text, company_id: self.appDel.taskDao.company.company_id!)
                    self.appDel.taskDao.company.company_note = self.companyNotes.text
                    self.appDel.taskDao.company.address_note = self.addressNotesTextField.text
                    self.appDel.taskDao.company.pro_mobile = self.pro_mobileText.text
                    self.appDel.taskDao.company.pro_name = self.proNameText.text
                    self.appDel.taskDao.company.email_pro = self.pro_emailsText.text
                    
                   
                    
                } // end of the else
                
            
            }
            
            self.appDel.taskDao.company.company_note = self.companyNotes.text
            self.appDel.taskDao.company.address_note = self.addressNotesTextField.text
            self.appDel.taskDao.company.pro_mobile = self.pro_mobileText.text
            self.appDel.taskDao.company.pro_name = self.proNameText.text
            self.appDel.taskDao.company.email_pro = self.pro_emailsText.text
            
            
            
        }
    
    }
    
    func setupPin(){
        self.mapView.removeAnnotations(mapView.annotations)
        
        var oneLoc : CLLocationCoordinate2D?
        
        if Util.validateCoordinates(self.appDel.taskDao.company.lat, lon: self.appDel.taskDao.company.lon) {
        
        //        if self.appDel.taskDao.company.lat != nil && self.appDel.taskDao.company.lat != "0.00000000" && ((self.appDel.taskDao.company.lat) as NSString).rangeOfString(".000").location ==  NSNotFound {
                    let companylocation = CLLocationCoordinate2DMake((self.appDel.taskDao.company.lat as NSString).doubleValue, (self.appDel.taskDao.company.lon as NSString).doubleValue)
                    // Drop a pin
                    //print("Task priority \(task.priority)")
                    
                    let dropPin = ColorPointAnnotation()
                    dropPin.task = self.appDel.taskDao
                    dropPin.imageName = "pingreen"
                    
                    
                    
                    dropPin.coordinate = companylocation
                    
                    dropPin.title = self.appDel.taskDao.company.company_name
                    
                    mapView.addAnnotation(dropPin)
                    
                    
                    
                    
                    oneLoc = companylocation
                    
                }
        
        if oneLoc != nil {
            let region = MKCoordinateRegionMakeWithDistance(oneLoc!, 5000, 5000)
            self.mapView.setRegion(region, animated: true)
        }
        else {
            if Util.returnUserLocation().lon != 0 {
        let companylocation = CLLocationCoordinate2DMake(Util.returnUserLocation().lat,Util.returnUserLocation().lon)
        let region = MKCoordinateRegionMakeWithDistance(companylocation, 5000, 5000)
        self.mapView.setRegion(region, animated: true)
                
            }
            }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadTasks(){
        
   //     var loginUrl = Constants.baseURL + "updateCompanyInfo?company_id=" + self.appDel.taskDao.company.company_id! + "&landline=" + self.landline.text + "&email_address=" + self.email.text + "&phone_no=" + self.phone.text
        
        
        let loginUrl = Constants.baseURL + "updateCompanyInfo?company_id=\(self.appDel.taskDao.company.company_id!)&landline=\(self.landline.text)&email_address=\(self.email.text)&phone_no=\(self.phone.text)"
        
        
        
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "editcompany")
        
        
    }
    
    func setupChangeTaskStatus(_ task_id : String){
        
        let  loginUrl = Constants.baseURL + "changeTaskStatus?task_id=\(task_id)"
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        self.appDel.showIndicator = 1
        self.distancelbl.text = ""
        downloader.startDownloader(loginUrl, idn: "tasksstatus")
        
    }
    
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        
        let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        ///print(str)
        //print(identity)
        
         if identity == "editcompany" {
          //   print(str)
            if self.appDel.taskDao != nil {
                if self.appDel.taskDao.task_id != nil {
            self.databaseManager.updateTaskDetail(self.appDel.taskDao)
                }
            }
            self.setupPin()
            
        }
        if identity == "companyPermits" {
        let parser = JsonParser()
            
            self.appDel.taskDao.company.companyPermits = parser.parseDetailPermits(data)
           // print("Permits Count ::: \(self.appDel.taskDao.company.companyPermits.count)")
            
            if self.appDel.taskDao.company.companyPermits.count > 0 {
                self.permitsTable.isHidden = false
                self.nopermitserror.isHidden = true
                self.permitsTable.reloadData()

            }
            else {
            print("No Permits Found")
                
            }
        
        }
        if identity == "company" {
            print(str)
            
            let parser  = JsonParser()
            print("Company detail")
            self.appDel.taskDao = TaskDao()
            self.appDel.taskDao.company =  parser.parseDetailCompany(data)
            
            self.setupPermits()
            self.setupCompanyData()

            
        return
            
        }
        if identity == "updatearea" {
        
        
        }
        
        if identity == "areas" {
        
        let parser = JsonParser()
        self.allAreas = parser.parseArea(data)
            if self.appDel.taskDao != nil {
            if self.appDel.taskDao.company != nil {
            for area in allAreas {
                if let area1 = area as? AreaDao {
                    
                    if area1.area_id != nil   {
                    if self.appDel.taskDao.company.area_id == area1.area_id {
                    self.areaBtn.setTitle(area1.area_name_ar, for: UIControlState())
                            }
                    
                    }
                }
            }
                
            }
        }
        }
        
        if identity == "uploadlocation" {
            if self.appDel.taskDao.parent_task_id != nil {
            if (self.appDel.taskDao.parent_task_id! as NSString).intValue > 1 {
                self.appDel.show_result = 1
            }
            }
            if self.appDel.taskDao.inspection_type == "co-inspection" {
                
                self.appDel.show_result = 1
            
            }
             if self.appDel.taskDao.is_pool == "1" {
//                let listAlert = SCLAlertView()
//                  listAlert.showCloseButton = false
//                
//                for catg in self.appDel.listArray {
//                    if let lDao = catg as? ListDao {
//                        listAlert.addButton(lDao.list_name!, action: {
//                            self.appDel.list_id = lDao.list_id!
//                            self.appDel.taskDao.list_id = lDao.list_id!
//                            self.performSegueWithIdentifier("sw_companytoquestions", sender: nil)
//                            
//                        })
//                        
//                    }// end of the if
//                    
//                }
//                listAlert.addButton(localisation.localizedString(key: "tasks.dismiss"), action: {
//                    
//                })
//                
//                listAlert.showInfo("Pool Task", subTitle: "Please select inspection type")
                
                self.setupCatgAlert()
                
                // end of the for loop
                
            } // end if the pool if
             else {
            self.performSegue(withIdentifier: "sw_companytoquestions", sender: nil)
            }
        }
        else if identity == "uploadInspectorslocation" {
        
            //let numLat = NSNumber(double: (self.appDel.userLocation!.latitude) as Double)
            //let numLon = NSNumber(double: (self.appDel.userLocation!.longitude) as Double)
            if self.appDel.userLocation != nil  {
            
            self.appDel.taskDao.company_lat = String(self.appDel.userLocation!.latitude)
            self.appDel.taskDao.company_lon = String(self.appDel.userLocation!.longitude)
           self.setupPin()
            }
            
        
        }
            
        else if identity == "onMyWay" {
            self.appDel.showIndicator = 0
            
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            print(str)
            if (str?.contains("success") != nil) {
                print("Successfully status updated")
                self.appDel.taskDao.task_status = "on_way"
                self.appDel.user.status = "on_way"
                self.databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status: self.appDel.taskDao.task_status)
                self.startBtn.isHidden = true
                //self.locationMethod()
                self.checkDistance()
                self.onMyWayBtn.setTitle(localisation.localizedString(key: "questions.cancel"), for: UIControlState())
                
             //   self.onMyWayBtn.setTitleColor(UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0), forState: UIControlState.Normal)
              //  self.onMyWayBtn.backgroundColor =  UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 1.0)
                
            }
            return
        }
            
        else if identity == "tasksstatus" {
            self.appDel.taskDao.task_status = "Not Started"
            self.appDel.alreadyOnTheWay = 0
            
            self.appDel.user.status =  "Inactive"
            self.makeMeInactive("")
            self.databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status: self.appDel.taskDao.task_status)
            
            
            return
        }
    
            
        else if identity == "active" {
            self.appDel.user.status =  "active"
            self.onMyWayBtn.setTitle(localisation.localizedString(key: "tasks.onmyway"), for: UIControlState())
            
            self.startBtn.isHidden = true
            //self.onMyWayBtn.backgroundColor = UIColor(red: 101/255, green: 174/255, blue: 223/255, alpha: 1.0)
            //self.onMyWayBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
        
        }

        else if identity == "violation_history" {
          // let dataStr = NSString(data: data, encoding: NSUTF8StringEncoding)
           // print(dataStr)
            let parser = JsonParser()
            //let tempViolationArray = parser.parserOldViolations(data).reversed() as! NSMutableArray
            self.violations = NSMutableArray(array:parser.parserOldViolations(data).reversed())
            self.violationsTable.reloadData()
            if self.violations.count > 0 {
           // self.noViolationsLbl.hidden = true
            }
            else {
               // self.noViolationsLbl.text = "No Violations available.."
                
           // self.noViolationsLbl.hidden = false
                
            }
            
            self.violationHistoryTitleAr.text = "سجل المخالفات(\(self.violations.count))"
           self.violationHistoryTitleEng.text = "Violations History (\(self.violations.count))"
        //self.downloadWarning()
            
            
        }
        else if identity == "warnings" {
        
//            //let dataStr = NSString(data: data, encoding: NSUTF8StringEncoding)
//            //print(dataStr)
//            let parser = JsonParser()
//            self.warnings = parser.parserWarnings(data)
//            self.warningsTable.reloadData()
//            if self.warnings.count > 0 {
//            self.nowarningslbl.hidden = true
//            }
//            else {
//            self.nowarningslbl.text = "No Warnings available.."
//                
//            self.nowarningslbl.hidden = false
//            }
            
        }
        else if identity != "extraactive"{
//        self.email.resignFirstResponder()
//        self.landline.resignFirstResponder()
//        self.phone.resignFirstResponder()
//        
//        let alert : UIAlertController = UIAlertController(title: "", message: "Updated Successfully", preferredStyle: UIAlertControllerStyle.Alert)
//        let action : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
//       alert.addAction(action)
//        self.presentViewController(alert, animated: true, completion: nil)
//     
        }
        
        
        else if identity == "company"{
        
            let parser  = JsonParser()
            print("Company detail")
            self.appDel.taskDao = TaskDao()
           self.appDel.taskDao.company =  parser.parseDetailCompany(data)
            self.setupData()
        }// end of the company
       
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func makeMeInactive(_ reason : String){
        // This method is used to make inspector active and inactive on criteria based
        if Reachability.connectedToNetwork() {
            var loginUrl : String  = ""
            if self.appDel.user.status !=  "Inactive" {
               // loginUrl = Constants.baseURL + "activeInactiveInspector?inspector_id=" + self.appDel.user.user_id + "&status=inactive&latitude=\(self.appDel.userLocation!.latitude)&longitude=\(self.appDel.userLocation!.longitude)"
                
            }
            else {
                loginUrl = Constants.baseURL + "activeInactiveInspector?inspector_id=" + self.appDel.user.user_id + "&status=active&latitude=\(self.appDel.userLocation!.latitude)&longitude=\(self.appDel.userLocation!.longitude)"
                
            }
            
            
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "active")
        }
        else {
            let alert = UIAlertController(title: "Please check internet connection", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == violationsTable {
            if UIDevice.current.userInterfaceIdiom == .pad {
            return 99
            }
            else {
            return 55
            }
            
            
        }
        else {
        return 57
        }

    }
    
    func makeOnMyWay(){
        if Reachability.connectedToNetwork() {
            
        }
        else {
            let alert : UIAlertController = UIAlertController(title:"Please check internet connection", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let action1 : UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        if self.appDel.user.status == "Inactive" {
            //  tasks.youareinactive
            let alertController = UIAlertController(title:localisation.localizedString(key: "tasks.youareinactive"), message:localisation.localizedString(key: "tasks.inactiveMessage"), preferredStyle: UIAlertControllerStyle.alert)
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
            return
            
        }
        
        
            
        if self.appDel.userLocation != nil{
            
            let numLat = NSNumber(value: (self.appDel.userLocation!.latitude) as Double as Double)
            let numLon = NSNumber(value: (self.appDel.userLocation!.longitude) as Double as Double)
            
            //  let stLat:String = numLat.stringValue
            let loginUrl = Constants.baseURL + "setOnWayStatus?inspector_id=" + self.appDel.user.user_id + "&task_id=\(self.appDel.taskDao.task_id!)&latitude=" + numLat.stringValue + "&longitude=" + numLon.stringValue
            
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "onMyWay")
            
        }
        
    }

    
    //MARK:- TABLEVIEW DELEGATE AND DATA SOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == self.warningsTable {
//        return self.warnings.count
//        }
        if tableView == violationsTable {
        return self.violations.count
        }
        else {
            if self.appDel.taskDao != nil   {
                print("Permits count \(self.appDel.taskDao.company.companyPermits.count)")
                
          return  self.appDel.taskDao.company.companyPermits.count
            }
            else {
               print("Task dao null")
            return 0
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == permitsTable {
             if self.appDel.is_adhoc_inspection != 1 { // if internet is conncted load online permits
            let permit = self.appDel.taskDao.company.companyPermits.object(at: indexPath.row) as! PermitDao
            self.appDel.selectedPermit = permit
               
                let story : UIStoryboard?
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                story = UIStoryboard(name: "Main", bundle: nil)
                }
                else {
                story = UIStoryboard(name: "Main_iPhone", bundle: nil)
                }
        
              let cnt = story?.instantiateViewController(withIdentifier: "cnt_fileview") as? FileViewController
            if self.navigationController == nil {
            print("Navigation controller is nil")
              //   cnt.
                cnt?.modalPresentationStyle = .popover
                cnt!.popoverPresentationController?.sourceView = self.view
                cnt!.preferredContentSize = CGSize(width: 850, height: 800)
                
                self.present(cnt!, animated: true, completion: nil)
            }
            self.navigationController?.pushViewController(cnt!, animated: true)
        }
            else {
            // If internet is not connected  load offline permit data cnt_offlinepermitdata'
                
                let permit = self.appDel.taskDao.company.companyPermits.object(at: indexPath.row) as! MainPermitDao
                self.appDel.offlinePermit = permit
                
                let story : UIStoryboard?
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    story = UIStoryboard(name: "Main", bundle: nil)
                }
                else {
                    story = UIStoryboard(name: "Main_iPhone", bundle: nil)
                }

                let cnt = story?.instantiateViewController(withIdentifier: "cnt_offlinepermitdata") as? OfflinePermitDataViewController
                if self.navigationController == nil {
                    print("Navigation controller is nil")
                    //   cnt.
                    cnt?.modalPresentationStyle = .popover
                    cnt!.popoverPresentationController?.sourceView = self.view
                    cnt!.preferredContentSize = CGSize(width: 900, height: 1000)
                    
                    self.present(cnt!, animated: true, completion: nil)
                }
                self.navigationController?.pushViewController(cnt!, animated: true)
                
            }
        }
        

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if tableView == warningsTable {
//        let cell =  tableView.dequeueReusableCellWithIdentifier("cell_violationhistory") as! ViolationHistoryTableViewCell
//        let dao  = self.warnings.objectAtIndex(indexPath.row) as! WarningsDao
//        if dao.question_desc != nil {
//            if dao.question_desc != nil && dao.warning_duration != nil {
//        cell.violation_title.text = dao.question_desc! + "(" + dao.warning_duration!+")"
//            }
//            }
//        
//        
//        if dao.entry_datetime != nil  {
//        cell.violation_date.text = dao.entry_datetime!
//        }
//        return cell
//        }
//        else {
//            let cell =  tableView.dequeueReusableCellWithIdentifier("cell_violationhistory") as! ViolationHistoryTableViewCell
//            let dao  = self.violations.objectAtIndex(indexPath.row) as! ViolationHistoryDao
//            if dao.violation_name != nil && dao.violation_name != ""  {
//                cell.violation_title.text = dao.violation_name!
//            }
//            else if dao.violation_name_ar != nil && dao.violation_name_ar != "" {
//                
//                cell.violation_title.text = dao.violation_name_ar!
//                
//            }
//            
//            if dao.violation_date != nil  {
//                let str = dao.violation_date! as NSString
//                let dateStrArray = str.componentsSeparatedByString(":")
//                //print(dateStrArray)
//                //print(dateStrArray.count)
//                if dateStrArray.count == 3 {
//                  // print(dateStrArray)
//                cell.violation_date.text = dateStrArray[0] + ":" + dateStrArray[1]
//                }else {
//                cell.violation_date.text = str as String
//
//                }
//                
//                }
//            return cell
        
        if tableView == self.violationsTable {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell_violationhistory") as! ViolationHistoryTableViewCell
        let dao  = self.violations.object(at: indexPath.row) as! ViolationHistoryDao
        if self.appDel.selectedLanguage == 1 {
            if dao.violation_name != nil && dao.violation_name != ""  {
                cell.violation_title.text = dao.violation_name!
            }
            else if dao.violation_name_ar != nil && dao.violation_name_ar != "" {
                
                cell.violation_title.text = dao.violation_name_ar!
                
            }
            
            if dao.violationpaystatusName != nil {
                cell.paymentstatusvalue.text = dao.violationpaystatusName
            }
            else if dao.violationpaystatusName_ar != nil{
                cell.paymentstatusvalue.text = dao.violationpaystatusName_ar
            }
            else {
                cell.paymentstatusvalue.text = ""
                
            }
            
            if dao.InspectionHOSStatusName != nil {
                cell.hosstatusvalue.text = dao.InspectionHOSStatusName
            }
            else if dao.InspectionHOSStatusName_Arb != nil {
                cell.hosstatusvalue.text = dao.InspectionHOSStatusName_Arb
                
            }
            else {
                cell.hosstatusvalue.text = ""
                
            }
        }
        else
            if self.appDel.selectedLanguage == 2 {
                if dao.violation_name_ar != nil && dao.violation_name_ar != ""  {
                    cell.violation_title.text = dao.violation_name_ar!
                }
                else if dao.violation_name != nil && dao.violation_name != "" {
                    
                    cell.violation_title.text = dao.violation_name!
                    
                }
                
                if dao.violationpaystatusName_ar != nil {
                    cell.paymentstatusvalue.text = dao.violationpaystatusName_ar
                }
                else if dao.violationpaystatusName != nil{
                    cell.paymentstatusvalue.text = dao.violationpaystatusName
                }
                else {
                    cell.paymentstatusvalue.text = ""
                    
                }
                
                if dao.InspectionHOSStatusName_Arb != nil {
                    cell.hosstatusvalue.text = dao.InspectionHOSStatusName_Arb
                }
                else if dao.InspectionHOSStatusName != nil {
                    cell.hosstatusvalue.text = dao.InspectionHOSStatusName
                    
                }
                else {
                    cell.hosstatusvalue.text = ""
                    
                }
        }
        
        
        
        
        
        if dao.Remarks != nil  && dao.Remarks_Arb != nil && dao.Remarks != "" && dao.Remarks_Arb != "" {
           // cell.notesbtn.hidden = false
            cell.notesbtn.tag = indexPath.row
            cell.notesbtn.addTarget(self, action: #selector(CompanyViewController.showRemarks(_:)), for: UIControlEvents.touchUpInside)
            
        }
        else {
            cell.notesbtn.isHidden = true
        }
        
        //        "company.hosstatus" = "حالة رئيس القسم";
        //        "company.paymentstatus" = "حالة عملية الدفع";
        
        
        cell.hosstatuslbl.text = localisation.localizedString(key: "company.hosstatus")
        cell.paymentStatuslbl.text = localisation.localizedString(key: "company.paymentstatus")
        
        
        if dao.violation_date != nil  {
            let str = dao.violation_date! as NSString
            let dateStrArray = str.components(separatedBy: ":")
            //print(dateStrArray)
            //print(dateStrArray.count)
            if dateStrArray.count == 3 {
                // print(dateStrArray)
                cell.violation_date.text = dateStrArray[0] + ":" + dateStrArray[1]
            }else {
                cell.violation_date.text = str as String
                
            }
            
        }
        return cell
            
        }
        else {
        
            let cell =  tableView.dequeueReusableCell(withIdentifier: "cell_permit") as! PermitCells
            if self.appDel.is_adhoc_inspection != 1 {
                
                // if internet is connected please use online permits ,
            let permit = self.appDel.taskDao.company.companyPermits.object(at: indexPath.row) as! PermitDao
           // cell.companyName.setTitle(permit.company_name, forState: UIControlState.Normal)
            cell.startDateVal.text = permit.issue_date
            cell.startDatelbl.text = localisation.localizedString(key: "tasks.startdate")
            cell.expiryDatelbl.text = localisation.localizedString(key: "tasks.enddate")
            cell.permitTylelbl.text = localisation.localizedString(key: "permit.subvenue")
            cell.permitNolbl.text = localisation.localizedString(key: "permit.permitno")
                
            
            
            cell.expiryDateVal.text = permit.expire_date
            cell.permitNoVal.text = permit.permitID
            cell.permitTypeVal.text = permit.sub_venue
            }
            else {
            // If Internet is not connected please load offline permits
            let permit = self.appDel.taskDao.company.companyPermits.object(at: indexPath.row) as! MainPermitDao
                cell.startDatelbl.text = localisation.localizedString(key: "tasks.startdate")
                cell.expiryDatelbl.text = localisation.localizedString(key: "tasks.enddate")
                cell.permitTylelbl.text = localisation.localizedString(key: "permit.subvenue")
                cell.permitNolbl.text = localisation.localizedString(key: "permit.permitno")
                cell.startDateVal.text = permit.startDate
                cell.expiryDateVal.text = permit.expiryDate
                cell.permitNoVal.text = permit.permitID
                cell.permitTypeVal.text = permit.subVenue

                
                
                
            }
            
            //"tasks.startdate" = "Start Date";
            //"tasks.enddate" = "End Date";

            
            
            
            
        return cell
        
        }
        


        
       // }
        
        
        
        
    }
    
    @objc func showRemarks(_ sender : UIButton){
//        if sender.tag < self.violations.count {
//            let dao = self.violations.objectAtIndex(sender.tag) as! ViolationHistoryDao
//            self.appDel.violationHistoryDao = dao
//            let cnt : RemarksViewController = storyboard?.instantiateViewControllerWithIdentifier("cnt_remarks")  as! RemarksViewController
//            //cnt.btn = sender
//            
//            //cnt.notesText.text = self.notes.objectForKey(String(sender.questionid)) as? String
//            
//            
//            
//            cnt.modalPresentationStyle = .FormSheet
//            presentViewController(cnt, animated: true, completion: nil)
//        }
        
    }
    
    // MARK:- MapView delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        let reuseId = "pin"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if anView == nil {
            anView = MKAnnotationView(annotation:annotation , reuseIdentifier: reuseId)
        }
        
        
    
        
        if let anon = annotation as? ColorPointAnnotation {
            //print("setting up print")
            anView!.image =  UIImage(named: anon.imageName)
            if anon.task?.priority == "3" {
                anView!.image = UIImage(named: "pinred")
                
                //  pinView.pinColor = MKPinAnnotationColor.Red
                
            }
            else if anon.task?.priority == "2" {
                anView!.image = UIImage(named: "pinorange")
                
                // pinView.pinColor = MKPinAnnotationColor.Green
            }
            else if anon.task?.priority == "1"{
                anView!.image = UIImage(named: "pingreen")
                
                
                //   pinView.pinColor = MKPinAnnotationColor.Purple
                
            }
            else {
                //  pinView.pinColor = MKPinAnnotationColor.Red
                
                
            }
        }
        
        
        // anView = pinView
        anView!.canShowCallout = true
        
        
        return anView
    }
    
    
   // MARK:- Location Method 
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
        
        
        
        
    {
        
        
        
        //print("Location updated")
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        self.loc = coord
        self.appDel.userLocation = coord
        
        self.userDefault.set(coord.latitude, forKey: "lat")
        self.userDefault.set(coord.longitude, forKey: "lon")
        self.userDefault.synchronize()
        
       
        
        let userLocation = CLLocationCoordinate2DMake(coord.latitude, coord.longitude)
        let region = MKCoordinateRegionMakeWithDistance(userLocation, 1000, 1000)
        
        
        self.appDel.user.lat = coord.latitude
        self.appDel.user.lon = coord.longitude
        
        self.checkDistance()
        
        
        // Handle location updates here
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error)
    {
        print(error.localizedDescription)
        // Handle errors here
    }
    func requiredMethod(){
        let alert : UIAlertController = UIAlertController(title: "Location Required", message: "You have to authorise location from device settings before start", preferredStyle: UIAlertControllerStyle.alert)
        let action1 : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action1)
        
        self.present(alert, animated: true, completion: nil)
    }
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            self.requiredMethod()
          //  self.locationStatus = -1
            
        }
        else {
           // self.locationStatus = 1
            
        }
        
        // App may no longer be authorized to obtain location
        //information. Check status here and respond accordingly.
        
    }
    
    
    func setupCatgAlert(){
        let listAlert = SCLAlertView()
        listAlert.showCloseButton = false
        var categoryCount : Int = 0
        if Reachability.connectedToNetwork() {
            categoryCount = self.appDel.taskDao.company.categories.count
        }
        else {
            if self.appDel.taskDao.company.categoryCount != nil {
                categoryCount = self.appDel.taskDao.company.categoryCount!.intValue
            }
        }
        print("Category Count in \(categoryCount)")
        if categoryCount == 0 || self.appDel.user.categories == nil{
            for catg in self.appDel.listArray {
                
                if let lDao = catg as? ListDao {
                    listAlert.addButton(lDao.list_name!, action: {
                        self.appDel.list_id = lDao.list_id!
                        self.appDel.taskDao.list_id = lDao.list_id!
                        self.performSegue(withIdentifier: "sw_companytoquestions", sender: nil)
                    })
                    
                    
                }// end of the if
                
            }
            listAlert.addButton(localisation.localizedString(key: "tasks.dismiss"), action: {
                
            })
            
            
            listAlert.showInfo("Pool Task", subTitle: self.localisation.localizedString(key:"tasks.pleaseselectinspectiontype"))
            
            
        } // if categories in company are not availabe
        else {
            let catgIdArray = (self.appDel.user.categories as? NSString)?.components(separatedBy: ",") as! NSArray
            print("user categories \(catgIdArray)")
            for catg in self.appDel.listArray  {
                if let lDao = catg as? ListDao {
                    
                    for userCatg in catgIdArray {
                        if let userCatg1 = userCatg as? String {
                            if userCatg1 == lDao.catg_id {
                                listAlert.addButton(lDao.list_name!, action: {
                                    self.appDel.list_id = lDao.list_id!
                                    self.appDel.taskDao.list_id = lDao.list_id!
                                    self.performSegue(withIdentifier: "sw_companytoquestions", sender: nil)
                                    
                                })
                            }
                        }
                    }
                }// end of the if
            } // end of the for loop
            
            
            
            listAlert.addButton(localisation.localizedString(key: "tasks.dismiss"), action: {
                
            })
            
            
            listAlert.showInfo("Pool Task", subTitle: self.localisation.localizedString(key:"tasks.pleaseselectinspectiontype"))
            
        }
        
    }

    
    
    // MARK:- Methods to update the buttonsView
    func checkDistance(){
        print("Check distance method is called")
        
        if self.appDel.taskDao != nil && self.appDel.taskDao.company.lat != nil && self.appDel.taskDao.company.lon != nil {
            //print("Lat :\(self.appDel.taskDao.company.lat)")
            //print("Lon :\(self.appDel.taskDao.company.lon)")
            
            
            if ((self.appDel.taskDao.company.lat) as NSString).range(of: "0.0").location ==  NSNotFound  && self.appDel.taskDao.company.lat != "0" && ((self.appDel.taskDao.company.lat) as NSString).range(of: ".000").location ==  NSNotFound {
                print("lOCATION vALID")
                
                if  self.appDel.user.status == "on_way"{
                    print("On My Way")
                    for catg in self.appDel.user.configArray {
                        if let  catgDao = catg as? ConfigurationDao {
                            
                            //print("CATG ID \(self.appDel.taskDao.category_id) config id \(catgDao.category_id)")
                            if self.appDel.taskDao.category_id != nil {
                                if catgDao.category_id! == self.appDel.taskDao.category_id! {
                                    print("Both are equal \(catgDao.location_check)")
                                    if catgDao.location_check == "0" {
                                        self.startBtn?.isHidden = false
                                        self.startBtn?.accessibilityLabel = "enable"
                                        return
                                    }
                                }
                            }// end of the nil check
                        } // end of let  catgDao = catg as? ConfigurationDao
                    }
                    
                    
                    let loc : CLLocation = CLLocation(latitude: Double(self.appDel.taskDao.company.lat)!, longitude:Double(self.appDel.taskDao.company.lon)!)
                    
                    
                    print("is on the way")
                    
                    let oldLoc:CLLocation = CLLocation(latitude:self.appDel.userLocation!.latitude  ,longitude: self.appDel.userLocation!.longitude)
                    //            let oldLoc:CLLocation = CLLocation(latitude:Double(latStr)!  ,longitude: Double(lonStr)!)
                    let distance:CLLocationDistance = loc.distance(from: oldLoc)
                    if distance <= Double(self.appDel.TASK_RADIUS) && self.startBtn != nil {
                        self.startBtn?.isHidden = false
                        self.startBtn?.accessibilityLabel = "enable"
                        
                        // self.currentStartBtn?.setBackgroundImage(UIImage(named: "starttask_icon"), forState: UIControlState.Normal)
                        
                    }
                        
                    else  if startBtn != nil {
                        // currentStartBtn!.accessibilityLabel = "disable"
                        // self.currentStartBtn?.setBackgroundImage(UIImage(named: "disablestartbtn"), forState: UIControlState.Normal)
                        //cell.startBtn.enabled = false
                        self.startBtn.accessibilityLabel = "disable"
                        
                        //self.startBtn.enabled = false
                        self.startBtn?.isHidden = true
                        
                    }
                    self.distancelbl.text = String(format : "Distance to location : %.2f meter(s)",distance)
                    
                }
                else {
                    self.startBtn?.accessibilityLabel = "enable"
                    if Reachability.connectedToNetwork() {
                        self.startBtn?.isHidden = true
                        
                    }
                    else {
                        self.startBtn?.isHidden = false
                        
                    }
                    //self.currentStartBtn?.setBackgroundImage(UIImage(named: "starttask_icon"), forState: UIControlState.Normal)
                    self.distancelbl.text = ""
                    print("user is not on the way")
                }
                
                
                //   "Distance to location :\(distance) meters"
                //  self.uploadTheLocation()
            }
            else {
                
                //self.currentStartBtn?.accessibilityLabel = "enable"
                //                self.startBtn.accessibilityLabel = "enable"
                //                self.startBtn?.hidden = false
                
                //self.currentStartBtn?.setBackgroundImage(UIImage(named: "starttask_icon"), forState: UIControlState.Normal)
                self.distancelbl.text = ""
                if self.appDel.user.status == "on_way"  && self.appDel.taskDao.task_status == "on_way" {
                    self.startBtn.isHidden = false
                }
                print("Location not valid")
            }
        }
        else {
            self.distancelbl.text = ""
            if self.appDel.user.status == "on_way"  && self.appDel.taskDao.task_status == "on_way" {
                self.startBtn.isHidden = false
                
            }
        }
        
        if self.appDel.taskDao != nil {
        if self.appDel.taskDao.task_id != self.appDel.onMyWayTask?.task_id {
            self.startBtn.isHidden = true
            
        }
        }
    }
    

    
    func locationMethod(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 3.0
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    }

    
    


    
    
   }
