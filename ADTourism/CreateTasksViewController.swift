//
//  CreateTasksViewController.swift
//  ADTourism
//
//  Created by Administrator on 2/1/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit
import MapKit
import DropDown
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CreateTasksViewController: UIViewController , MainJsonDelegate , InspectorSelectedDelegate, SessionDataDelegate,SubVenueSelectedDelegate{
  
    
    @IBOutlet weak var addSubVenueBtn: UIButton!
    @IBOutlet weak var addSubvenuelbl: UILabel!
    
    @IBOutlet weak var taskTypelbl: UILabel!
    
    @IBOutlet weak var taskTypeValue: UILabel!
    var taskType : [TaskTypeDao]?
    var dropDown  = DropDown()
    var selectedTaskType : String = ""
    
    
    @IBAction func showTaskType(_ sender: UIButton) {
        if taskType != nil {
            dropDown.dataSource = taskType!.compactMap({appDel.selectedLanguage == 1 ? $0.ins_type_name : $0.ins_type_name_arb})
            
            //dropDown.dataSource = taskType.compactMap({appDel.selectedLanguage == "en" ?  $0.ins_type_name! : $0.ins_type_name_arb!})
            dropDown.anchorView = sender //5
            dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = {(index: Int, item: String) in //8
            sender.setTitle(item, for: .normal) //9
             // self.selectedAcountType = AccountType.compactMap($0.a)
                if self.taskType!.count > index {
                    self.selectedTaskType = self.taskType![index].id!
                    self.taskTypeValue.text = item
                    
              }
            }
        }
        else {
            print("Task type is nill")
        }
        
    }
    var subVenueId : String?
    var allSubVenues : NSMutableDictionary?
    var selectedCatg : CategoriesDao?
    var categoryDict : NSMutableDictionary = NSMutableDictionary()
    var subVenueValues : String = ""
    
    var  rightActivity : UIActivityIndicatorView = UIActivityIndicatorView()

    
    @IBAction func addSubVenueMethod(_ sender: UIButton) {
    
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "cnt_addSubVenue") as! AddSubVenueViewController
        //vc.finishDel = self
        vc.del = self
        if self.allSelectedSubVenues != nil {
            vc.previousDict = self.allSelectedSubVenues
        }
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(vc, animated: true, completion: nil)

    }
    func subVenueSelected(_ allSubvenues: NSMutableDictionary) {
       // print("All SubVenues \(allSubvenues)")
        self.allSubVenues = allSubvenues
        
        var str : String = ""
        var allKeys = allSubvenues.allKeys
        
        for a in 0  ..< allKeys.count  {
            
            let dao = allSubvenues.object(forKey: allKeys[a]) as! InspectorBtn
            if str == "" {
                str = dao.subVenue!.subVenue!
                self.subVenueId = dao.subVenue?.subVenue_id
                 self.appDel.selectedSubVenue = dao.subVenue
                
            }
            else {
                str =  str + "," + dao.subVenue!.subVenue!
                self.subVenueId = self.subVenueId! + "," + (dao.subVenue?.subVenue_id)!
            }
            
        } // end of the for loop
        
        subVenueValues = str
        print("All Subvenue Str \(str)")
        
          print("All Subvenue Ids \(self.subVenueId)")
        self.allSelectedSubVenues = allSubvenues
        
        self.subVenueValue.text = str
        if str == "" {
            self.addSubVenueBtn.setImage(UIImage(named:"addinspection"), for: UIControlState())
            
        }
        else {
            self.addSubVenueBtn.setImage(UIImage(named:"editcoinspection"), for: UIControlState())
        }

        
    }
    @IBOutlet weak var subVenueValue: UILabel!
    
    @IBOutlet weak var addCoinspectionBtn: UIButton!
    @IBOutlet weak var addCoinspectionTitle: UILabel!
    
    @IBOutlet weak var inspectorsLbl: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var companynotes: UILabel!
    @IBOutlet weak var addressnoteslbl: UILabel!
    @IBOutlet weak var addressNotes: UILabel!
    @IBOutlet weak var expirydatelbl: UILabel!
    @IBOutlet weak var expiryDatetitellbl: UILabel!
    var allSelectedInspectors : NSMutableDictionary?
    var allSelectedSubVenues : NSMutableDictionary?
    
    
    @IBOutlet weak var inspectorView: UIView!
    
    @IBAction func addCoInspectionMethod(_ sender: AnyObject) {
        //cnt_addCoinspection
        let vc = storyboard!.instantiateViewController(withIdentifier: "cnt_addCoinspection") as! AddCoinspectionController
        //vc.finishDel = self
        vc.del = self
        if self.allSelectedInspectors != nil {
            vc.previousDict = self.allSelectedInspectors
        }
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    func inspectorsSelected(_ allInspector: NSMutableDictionary) {
       print("All Inspectors \(allInspector)")
        
        var str : String = ""
        var allKeys = allInspector.allKeys
        
        for a in 0  ..< allKeys.count  {
            
            
            let dao = allInspector.object(forKey: allKeys[a]) as! InspectorBtn
            
           // print("ID is \(allKeys[a]) but id in dictionary is \(dao.inspectorDao!.id)")
            
           // print("\(dao.inspectorDao!.name) id \(dao.inspectorDao!.id)")
            if str == "" {
                str = dao.inspectorDao!.name!
            }
            else {
                str =  str + "," + dao.inspectorDao!.name!
            }
       
        } // end of the for loop
        // print(str)
        
        self.allSelectedInspectors = allInspector
        
       // print("All Inspector in Inspector Selected Method \(self.allSelectedInspectors?.allKeys)")
        self.inspectorsLbl.text = str
        if str == "" {
            self.addCoinspectionBtn.setImage(UIImage(named:"addinspection"), for: UIControlState())
            
        }
        else {
            self.addCoinspectionBtn.setImage(UIImage(named:"editcoinspection"), for: UIControlState())
        }
    } // end of the function
    
    @IBOutlet weak var issueDatelbl: UILabel!
    @IBOutlet weak var issuedatetitlelbl: UILabel!
    @IBOutlet weak var licensenotitlelbl: UILabel!
    @IBOutlet weak var licenseno: UILabel!
    @IBOutlet weak var englishnamelbl: UILabel!
    @IBOutlet weak var timeSpentlbl: UILabel!
    @IBOutlet weak var timerlbl: UILabel!
    var userDefault : UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var companyNotesValue: UILabel!
    let database = DatabaseManager()
    var categories = NSMutableArray()
    
    
    @IBAction func drivingMethod(_ sender: AnyObject) {
        if self.appDel.searchedCompany?.lat != nil &&  self.appDel.searchedCompany?.lon != nil {
            if self.appDel.searchedCompany!.lat! != "0.00000000" &&  self.appDel.searchedCompany!.lon! != "0.00000000" {
                let urlstr : String = "http://maps.google.com/maps?saddr=\(self.appDel.user.lat!),\(self.appDel.user.lon!)&daddr=\(self.appDel.searchedCompany!.lat!),\(self.appDel.searchedCompany!.lon!)"
                UIApplication.shared.openURL(URL(string: urlstr)!)
            }
            else {
                
                let alert = UIAlertController(title: "Driving Directions", message: "Can not apply route", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            
            let alert = UIAlertController(title: "Driving Directions", message: "Can not apply route", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBOutlet weak var activityCodevalue: UILabel!
    @IBOutlet weak var activityCodelbl: UILabel!
    @IBOutlet weak var landlineValue: UILabel!
    @IBOutlet weak var phoneValue: UILabel!
    @IBOutlet weak var phonelbl: UILabel!
    @IBOutlet weak var addressValue: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var landline: UILabel!
    @IBOutlet weak var drivingBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var companyNameView: UIView!
    
    @IBOutlet weak var arabicNameLbl: UILabel!
    @IBOutlet weak var companyNameArabicView: UIView!
    @IBOutlet weak var companyNameArabicTextField: UITextField!
    @IBOutlet weak var companyNameArabicLbl: UILabel!
    
    @IBOutlet weak var licenselbl: UILabel!
    @IBOutlet weak var licenseTextField: UITextField!
    @IBOutlet weak var licenseView: UIView!
    
    @IBOutlet weak var issueDatalbl: UILabel!
    @IBOutlet weak var issueDateView: UIView!
    @IBOutlet weak var issueDateTextField: UITextField!
    var localisation : Localisation!
    var databaseManager = DatabaseManager()
    
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var createInspectionBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBAction func backMethod(_ sender: AnyObject) {
       if self.appDel.fromSearch == 1 {
        self.navigationController?.popViewController(animated: true)
       }
        else {
      
        self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
        
        }
        
    }
    
    
    func createSafariTasks(){
        
        print(self.appDel.selectedDrivers)
        print(self.appDel.selectedVehicles)
        let downloader = DataDownloader()
        downloader.delegate = self
        self.appDel.searchedCompany?.selectedCatg = self.selectedCatg?.catg_id
        var fullInspectorIds = ""
        if self.allSelectedInspectors != nil {
            if self.allSelectedInspectors!.count != 0 {
               
                //This loop will take all inspector ids and srore
                let array = self.allSelectedInspectors?.allKeys
                for a in 0  ..< array!.count {
                    let str = array![a] as! String
                    if fullInspectorIds == "" {
                        fullInspectorIds = str
                    }
                    else {
                        fullInspectorIds = fullInspectorIds + "," + str
                    }
                }
            }
        }
                print(fullInspectorIds)
        downloader.setupCreateSafariInspectionsPost("createsafari", urlstr: "\(Constants.baseURL)" + "createExternalNotesTasks",coInspectorsIds : fullInspectorIds)
        //downloader.setupCreateSafariInspectionsPost("createsafari", url: Constants.baseURL + "createAdhocInspection?companyId=\(self.appDel.searchedCompany!.company_id!)&, companyId: <#T##String#>, inspector: <#T##String#>)
        
//        print(Constants.baseURL + "getCompanyDetailById?companyId=\(self.appDel.searchedCompany?.company_id)")
//        let  detailUrl = Constants.baseURL + "getCompanyDetailById?companyId=\(self.appDel.searchedCompany!.company_id!)"
//        let downloader : DataDownloader = DataDownloader()
//        downloader.delegate = self
//        self.appDel.showIndicator = 1
//        downloader.startDownloader(detailUrl, idn: "detail")
//
        
        
    }// end of the createSafariTasks
    
    @IBAction func createInspectionMethod(_ sender: AnyObject) {
        
        if self.appDel.searchedCompany?.selectedCatg == nil {
            let alert = UIAlertController(title: localisation.localizedString(key: "company.companycategory"), message: localisation.localizedString(key: "company.selectcategory"), preferredStyle: UIAlertControllerStyle.alert)
            let alertaction = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(alertaction)
            self.present(alert, animated: true, completion: nil)
            self.categoryBtn.layer.borderColor = UIColor.red.cgColor
            self.categoryBtn.layer.borderWidth = 2.0
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 3
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.categoryBtn.center.x - 10, y: self.categoryBtn.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.categoryBtn.center.x + 10, y: self.categoryBtn.center.y))
            self.categoryBtn.layer.add(animation, forKey: "position")
        }
     
//        else if self.appDel.searchedCompany?.selectedCatg == "13" && self.allSubVenues?.count < 0 {
//        
//            let alert = UIAlertController(title: "Sub-Venue", message: "To perform تفتيش الفعاليات select sub-venue!", preferredStyle: UIAlertControllerStyle.Alert)
//            let alertaction = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.Cancel, handler: nil)
//            alert.addAction(alertaction)
//            self.presentViewController(alert, animated: true, completion: nil)
//            return 
//        }

        else {
            if self.selectedCatg == nil {
                return
                
            }
            
            print("Driver Count is \(self.appDel.selectedDrivers.count)")
            print("Car Count is \(self.appDel.selectedVehicles.count)")
            
            if Reachability.connectedToNetwork() {
                self.setupCreateDownloader()
            }
                // this condition
            else if (self.selectedCatg!.list_id == "10" || self.selectedCatg!.list_id == "11") && (self.appDel.selectedDrivers.count > 0 || self.appDel.selectedVehicles.count > 0){
                let lists = databaseManager.fetchInspectionListMainByCategory(self.appDel.searchedCompany!.selectedCatg!)
                
                print("Selected Drivers \(self.appDel.selectedDrivers.count)")
                print("Selected Cars \(self.appDel.selectedVehicles.count)")
                var vehcileCount : Int = 0
                
                for externalNote in self.appDel.selectedVehicles {
                    
                if let externalNoteStr  = externalNote as? String {
                let taskD = TaskDao()
                    print("License Info \(self.appDel.searchedCompany!.license_info)")
                    
                    taskD.task_id = "0"
                    let someDate = Date()
                    vehcileCount += 1
                    // convert Date to TimeInterval (typealias for Double)
                    var timeInterval = (someDate.timeIntervalSince1970)
                    
                    // convert to Integer
                   let myInt = Int(timeInterval)*1000 + vehcileCount
                    
                //taskD.uniqueid = "\(myInt+vehcileCount)v\(vehcileCount)"
                   taskD.uniqueid = "\(myInt)"
                    print("Adding task with Unique Id \(taskD.uniqueid!)")
                    //  232232331v4
                    print("Car Unique id \(taskD.uniqueid)")
                    
                taskD.company = CompanyDao()
                taskD.company_id = self.appDel.searchedCompany!.company_id
                taskD.company_name = self.appDel.searchedCompany!.company_name
                 taskD.company.license_expire_date = self.appDel.searchedCompany!.license_expire_date
                taskD.company.license_issue_date = self.appDel.searchedCompany!.license_issue_date
                taskD.company.address = self.appDel.searchedCompany!.address
                taskD.taskOwner = self.appDel.user.user_id
                taskD.company_name_ar = self.appDel.searchedCompany!.company_name_arabic
                taskD.category_id = self.selectedCatg!.catg_id
              
                taskD.task_status = "Not Started"
                taskD.external_notes = externalNoteStr
                    
                let dateformat = DateFormatter()
                dateformat.dateFormat = "yyyy-dd-MM HH:mm:ss"
                taskD.due_date = dateformat.string(from: Date())
                
              //  taskD.list_id = self.selectedCatg!.list_id!
                taskD.company.license_info = self.appDel.searchedCompany!.license_info
                taskD.company.area_id = self.appDel.searchedCompany!.area_id
                
                taskD.company.company_id = self.appDel.searchedCompany!.company_id
                 print("Company id \(self.appDel.searchedCompany!.company_id)")
                    
                taskD.company.address = self.appDel.searchedCompany!.address
                taskD.company.categories = self.appDel.searchedCompany!.categories
                taskD.company.landline = self.appDel.searchedCompany!.landline
                taskD.company.email = self.appDel.searchedCompany!.email
                taskD.company.activity_code = self.appDel.searchedCompany!.activity_code
                taskD.company.lat = self.appDel.searchedCompany!.lat
                taskD.company.lon = self.appDel.searchedCompany!.lon
                taskD.company.pro_mobile = self.appDel.searchedCompany!.pro_mobile
                taskD.company.pro_name = self.appDel.searchedCompany!.pro_name
                taskD.company.email_pro = self.appDel.searchedCompany!.email_pro
                    
                    if self.appDel.searchedCompany!.contact_designation != nil {
                    taskD.company.contact_designation = self.appDel.searchedCompany!.contact_designation
                    }
                    if self.appDel.searchedCompany!.contact_provider_name != nil {
                    taskD.company.contact_provider_name = self.appDel.searchedCompany!.contact_provider_name
                    }
                    
                    if self.appDel.searchedCompany!.contact_provided_by != nil {
                    taskD.company.contact_provided_by = self.appDel.searchedCompany!.contact_provided_by!
                    }
                    
               // taskD.company.contact_designation = self.appDel.searchedCompany!.contact_designation
                    
                // print("PRO NO for created \(taskD.company.pro_mobile)")
                    
                 //   print("Create Task")
                 //   print(taskD.company.contact_designation)
                 //   print(taskD.company.contact_provider_name)
                 //   print(taskD.company.contact_provided_by)
                    
                    var fullInspectorIds : String = ""
                    if self.allSelectedInspectors != nil {
                    let array = self.allSelectedInspectors?.allKeys
                    for a in 0  ..< array!.count {
                        let str = array![a] as! String
                        if fullInspectorIds == "" {
                            fullInspectorIds = str
                        }
                        else {
                            fullInspectorIds = fullInspectorIds + "," + str
                        }
                    }
                    if fullInspectorIds != "" {
                       taskD.coninspectors = fullInspectorIds
                    }
                    }
                    
                    
                taskD.company.company_name = self.appDel.searchedCompany!.company_name
                taskD.company.company_name_arabic = self.appDel.searchedCompany!.company_name_arabic
                taskD.list_title = self.selectedCatg!.catg_name
                taskD.is_pool = "0"
                    if lists.count > 0 {
                        let list = lists.object(at: 0) as? InspectionMainListDao
                        taskD.list_id = list?.id
                    } // end of the if
                    
                    
                 print("list id \(taskD.list_id)")
                
                self.databaseManager.addTask(taskD)
                } // end of the
                }
                vehcileCount = 0
                
                // now add tasks for Driver No
                var driverCount : Int = 0
                
                for externalNote in self.appDel.selectedDrivers {
                    if let externalNoteStr  = externalNote as? String {
                        let taskD = TaskDao()
                        print("License Info \(self.appDel.searchedCompany!.license_info)")
                        
                        taskD.task_id = "0"
                        driverCount += 1
                        
                        taskD.company = CompanyDao()
                        taskD.company_id = self.appDel.searchedCompany!.company_id
                        taskD.company_name = self.appDel.searchedCompany!.company_name
                        taskD.company.license_expire_date = self.appDel.searchedCompany!.license_expire_date
                        taskD.company.license_issue_date = self.appDel.searchedCompany!.license_issue_date
                        taskD.company.address = self.appDel.searchedCompany!.address
                        let someDate = Date()
                        
                        // convert Date to TimeInterval (typealias for Double)
                        let timeInterval = someDate.timeIntervalSince1970
                        
                        // convert to Integer
                        let myInt = Int(timeInterval)*1000 + driverCount * 100
                        //taskD.uniqueid = "\(myInt+driverCount)d\(driverCount)"
                        taskD.uniqueid = "\(myInt)"
                        print("Driver Unique id \(taskD.uniqueid)")
                        
                        
                        taskD.company_name_ar = self.appDel.searchedCompany!.company_name_arabic
                        taskD.category_id = self.selectedCatg!.catg_id
                        
                        taskD.task_status = "Not Started"
                        taskD.external_notes = externalNoteStr
                        
                        let dateformat = DateFormatter()
                        dateformat.dateFormat = "yyyy-dd-MM HH:mm:ss"
                        taskD.due_date = dateformat.string(from: Date())
                        let lists = databaseManager.fetchInspectionListMainByCategory(self.appDel.searchedCompany!.selectedCatg!)
                        if lists.count > 0 {
                            let list = lists.object(at: 0) as? InspectionMainListDao
                        taskD.list_id = list?.id
                        }
                        
                        print("list id \(taskD.list_id)")
                        //taskD.list_id = self.selectedCatg!.list_id!
                        taskD.company.license_info = self.appDel.searchedCompany!.license_info
                        taskD.company.area_id = self.appDel.searchedCompany!.area_id
                        taskD.company.company_id = self.appDel.searchedCompany!.company_id
                        taskD.company.address = self.appDel.searchedCompany!.address
                         taskD.taskOwner = self.appDel.user.user_id
                        taskD.company.categories = self.appDel.searchedCompany!.categories
                        taskD.company.landline = self.appDel.searchedCompany!.landline
                        taskD.company.email = self.appDel.searchedCompany!.email
                        taskD.company.activity_code = self.appDel.searchedCompany!.activity_code
                        taskD.company.lat = self.appDel.searchedCompany!.lat
                        taskD.company.lon = self.appDel.searchedCompany!.lon
                        taskD.company.company_name = self.appDel.searchedCompany!.company_name
                        taskD.company.company_name_arabic = self.appDel.searchedCompany!.company_name_arabic
                        taskD.company.pro_mobile = self.appDel.searchedCompany!.pro_mobile
                        taskD.company.pro_name = self.appDel.searchedCompany!.pro_name
                        taskD.company.email_pro = self.appDel.searchedCompany!.email_pro
                        if self.appDel.searchedCompany!.contact_designation != nil {
                            taskD.company.contact_designation = self.appDel.searchedCompany!.contact_designation
                        }
                        if self.appDel.searchedCompany!.contact_provider_name != nil {
                            taskD.company.contact_provider_name = self.appDel.searchedCompany!.contact_provider_name
                        }
                        
                        if self.appDel.searchedCompany!.contact_provided_by != nil {
                            
                            taskD.company.contact_provided_by = self.appDel.searchedCompany!.contact_provided_by!
                            
                        }
                        
                     //    print("All Inspector in Inspector Create Method \(self.allSelectedInspectors?.allKeys)")
                        var fullInspectorIds : String = ""
                        if self.allSelectedInspectors != nil {
                            let array = self.allSelectedInspectors?.allKeys
                            for a in 0  ..< array!.count {
                                let str = array![a] as! String
                                if fullInspectorIds == "" {
                                    fullInspectorIds = str
                                }
                                else {
                                    fullInspectorIds = fullInspectorIds + "," + str
                                }
                            }
                            if fullInspectorIds != "" {
                                taskD.coninspectors = fullInspectorIds
                            }
                        }
                        
                        
                        //print("Create Task")
                        //print(taskD.company.contact_designation)
                        //print(taskD.company.contact_provider_name)
                        //print(taskD.company.contact_provided_by)
                        
                        
                        
                        taskD.list_title = self.selectedCatg!.catg_name
                        taskD.is_pool = "0"
                        
                        
                        self.databaseManager.addTask(taskD)
                    } // end of the
                }

                driverCount = 0
                
                
                
                
                 self.appDel.addedSubvenueCompany = self.appDel.searchedCompany?.company_name
                var storyboard : UIStoryboard?
                if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    storyboard = UIStoryboard(name: "Main", bundle: nil)
                }
                else {
                    storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
                    
                }
                let initialViewController = storyboard!.instantiateViewController(withIdentifier: "cnt_reveal") as! SWRevealViewController
                
                self.appDel.window?.rootViewController = initialViewController
               
                

                
                
            } // end of the if
                

            else {
                if self.appDel.searchedCompany!.selectedCatg != nil {
                    let lists = databaseManager.fetchInspectionListMainByCategory(self.appDel.searchedCompany!.selectedCatg!)
                    if lists.count > 0 {
                        let list = lists.object(at: 0) as? InspectionMainListDao
                        self.appDel.is_adhoc_inspection = 1
                        let task = TaskDao()
                        
                        self.appDel.list_id = list?.id
                        if self.subVenueId != nil {
                            task.external_notes = "التفتيش \(subVenueValues)"
                        }
                        task.task_id = "0"
                        task.task_status = "started"
                        task.list_id = list?.id
                        task.company = self.appDel.searchedCompany
                       
                        var fullInspectorIds : String = ""
                        if self.allSelectedInspectors != nil {
                            let array = self.allSelectedInspectors?.allKeys
                            for a in 0  ..< array!.count {
                                let str = array![a] as! String
                                if fullInspectorIds == "" {
                                    fullInspectorIds = str
                                }
                                else {
                                    fullInspectorIds = fullInspectorIds + "," + str
                                }
                            }
                            if fullInspectorIds != "" {
                                task.coninspectors = fullInspectorIds
                            }
                        } // CoInspectors
                        
                        self.appDel.taskDao = task
                        
                        if UIDevice.current.userInterfaceIdiom == .pad {
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let cnt = story.instantiateViewController(withIdentifier: "cnt_questions") as! QuestionListViewController
                        // self.navigationController?.popToViewController((self.navigationController?.viewControllers[3])!, animated: true)
                        self.navigationController?.pushViewController(cnt, animated: true)
                        }
                        else {
                            let story = UIStoryboard(name: "Main_iPhone", bundle: nil)
                            let cnt = story.instantiateViewController(withIdentifier: "cnt_questions") as! QuestionListViewController
                            // self.navigationController?.popToViewController((self.navigationController?.viewControllers[3])!, animated: true)
                            self.navigationController?.pushViewController(cnt, animated: true)
                            
                        }
                        
                    }// check if lists exists in database for category
                } // if selected category is not nil than show
                
                
            }
            
        }
    }
    func setupPermitURL(){
        let session = SessionDataDownloader()
        session.del = self
        let permitUrl = Constants.baseURL + "downloadPermitsByLicense"
        
        print(permitUrl)
        
        session.setupSessionDownload(permitUrl, session_id: String(describing: Date().addingTimeInterval(1970)))

    }
    
    func dataDownloader(_ data: Data) {
        
    }
    func downloadAllTaskTypes(){
        
            let typeUrl = Constants.baseURL + "getInspectionTypeList"
        
            print(typeUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(typeUrl, idn: "taskType")
            
        }
       
            
    
    
    func setupCreateDownloader(){
        var subVenue : String = ""
        var taskType : String = ""
       ///Add Subvenues if available
        if self.subVenueId != nil  {
        subVenue = "&subvenue_id=\(self.subVenueId!)"
        }
        if self.selectedTaskType != ""  {
        taskType = "&inspection_type_id=\(self.selectedTaskType)"
        }
        var fullInspectorIds = ""
        if self.allSelectedInspectors != nil {
            if self.allSelectedInspectors!.count != 0 {
                
                
                //This loop will take all inspector ids and srore
                let array = self.allSelectedInspectors?.allKeys
                for a in 0  ..< array!.count {
                    let str = array![a] as! String
                    if fullInspectorIds == "" {
                        fullInspectorIds = str
                    }
                    else {
                        fullInspectorIds = fullInspectorIds + "," + str
                    }
                }
                print("CoInspectors \(fullInspectorIds)")
        // execute conditions if selected Co-Inspectors
            }
        }
        if self.selectedCatg!.list_id != "10" && self.selectedCatg!.list_id != "11" {
      
        if fullInspectorIds != "" {
         //       Create CoInspection for companies and subvenues if exists
            
                fullInspectorIds = fullInspectorIds + "," + self.appDel.user.user_id
                 let  detailUrl = Constants.baseURL + "createAdhocCoInspection?companyId=\(self.appDel.searchedCompany!.company_id!)&inspectorId=\(fullInspectorIds)&categoryId=\(self.selectedCatg!.catg_id!)\(subVenue)&ownerID=\(self.appDel.user.user_id!)\(taskType)"
                
                
                let downloader : DataDownloader = DataDownloader()
                print(detailUrl)
                downloader.delegate = self
                self.appDel.showIndicator = 1
                downloader.startDownloader(detailUrl, idn: "create")
                
            }
            else {
             // if there are no CoInspectors create single inspection for a company and if exits for Subvenues
            
            
                let  detailUrl = Constants.baseURL + "createAdhocInspection?companyId=\(self.appDel.searchedCompany!.company_id!)&inspectorId=\(self.appDel.user.user_id!)&categoryId=\(self.selectedCatg!.catg_id!)\(subVenue)\(taskType)"
                let downloader : DataDownloader = DataDownloader()
                print(detailUrl)
                downloader.delegate = self
                self.appDel.showIndicator = 1
                downloader.startDownloader(detailUrl, idn: "create")
                
            }
            
        
    }
            
            
        else {
            print("List id \(self.selectedCatg?.list_id)")
            if (self.selectedCatg!.list_id == "10" || self.selectedCatg!.list_id == "11") && (self.appDel.selectedDrivers.count > 0 || self.appDel.selectedVehicles.count > 0)  {
               self.createSafariTasks()
            }// end of the if
            else {
//                print(self.appDel.searchedCompany!.selectedCatg!)
//                let  detailUrl = Constants.baseURL + "createAdhocInspection?companyId=\(self.appDel.searchedCompany!.company_id!)&inspectorId=\(self.appDel.user.user_id!)&categoryId=\(self.selectedCatg!.catg_id!)\(subVenue)"
//                let downloader : DataDownloader = DataDownloader()
//                downloader.delegate = self
//                self.appDel.showIndicator = 1
//                downloader.startDownloader(detailUrl, idn: "create")

                
                if fullInspectorIds != "" {
                    //       Create CoInspection for companies and subvenues if exists
                    
                    fullInspectorIds = fullInspectorIds + "," + self.appDel.user.user_id
                    let  detailUrl = Constants.baseURL + "createAdhocCoInspection?companyId=\(self.appDel.searchedCompany!.company_id!)&inspectorId=\(fullInspectorIds)&categoryId=\(self.selectedCatg!.catg_id!)\(subVenue)&ownerID=\(self.appDel.user.user_id!)"
                    
                    
                    let downloader : DataDownloader = DataDownloader()
                    print(detailUrl)
                    downloader.delegate = self
                    self.appDel.showIndicator = 1
                    downloader.startDownloader(detailUrl, idn: "create")
                    
                }
                else {
                    // if there are no CoInspectors create single inspection for a company and if exits for Subvenues
                    
                    
                    let  detailUrl = Constants.baseURL + "createAdhocInspection?companyId=\(self.appDel.searchedCompany!.company_id!)&inspectorId=\(self.appDel.user.user_id!)&categoryId=\(self.selectedCatg!.catg_id!)\(subVenue)"
                    let downloader : DataDownloader = DataDownloader()
                    print(detailUrl)
                    downloader.delegate = self
                    self.appDel.showIndicator = 1
                    downloader.startDownloader(detailUrl, idn: "create")
                    
                }
                
                
            
            }
        }//
        
        
    }
    @IBOutlet weak var companyCategoryLbl: UILabel!
    
    func defaultCategory(){
        let catgIdArray = (self.appDel.user.categories as? String)?.components(separatedBy: ",") as? NSArray
        
        if self.appDel.offlinePermit!.permitID!.contains("SFA")  {
            print(catgIdArray)
            let checkCatg = catgIdArray?.contains(where: { (value) -> Bool in
              
                if (value as! String) == Constants.SafariDict.object(forKey: "catg_id") as! String {
                    return true
                    
                }
                else {
                    return false
                    
                }
                
            })
            print(checkCatg)
            if checkCatg! == true {
                self.categoryBtn.setTitle(Constants.SafariDict.object(forKey: "name") as! String, for: UIControlState())
                
                self.appDel.searchedCompany?.selectedCatg = Constants.SafariDict.object(forKey: "catg_id") as! String
                //self.selectedCatg = catg
                self.selectedCatg = self.categoryDict.object(forKey: Constants.SafariDict.object(forKey: "catg_id") as! String) as? CategoriesDao
                print(self.appDel.searchedCompany?.selectedCatg)
                print(self.selectedCatg)
                
                
            }
            else {
                let innerAlert = UIAlertController(title: self.localisation.localizedString(key: Constants.SafariDict.object(forKey: "name") as! String), message:"\(self.localisation.localizedString(key: "searchcompany.permission")) \(Constants.SafariDict.object(forKey: "name") as! String)", preferredStyle: UIAlertControllerStyle.alert)
                
                
                
                let action = UIAlertAction(title: self.localisation.localizedString(key:"searchcompany.askforpermission"), style: UIAlertActionStyle.default, handler: {
                    Void in
                    
                    self.appDel.searchedCompany?.selectedCatg = Constants.SafariDict.object(forKey: "catg_id") as! String
                    
                    
                    self.selectedCatg = self.categoryDict.object(forKey: Constants.SafariDict.object(forKey: "catg_id") as! String) as? CategoriesDao
                    
                    
                    self.setupPermission()
                    
                })
                //if Reachability.connectedToNetwork() {
                innerAlert.addAction(action)
                // } //
                
                let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:nil)
                innerAlert.addAction(cancel)
                
                self.present(innerAlert, animated: true, completion: nil)
                return
            }
            
            
        }
        else {
            self.categoryMethod(self)
        }
      /*
        if self.appDel.offlinePermit!.permitID!.contains("CMP")  {
           let checkCatg = catgIdArray?.contains(where: { (value) -> Bool in
                if (value as! String) == Constants.CampDict.object(forKey: "catg_id") as! String {
                    return true
                    
                }
                else {
                    return false
                    
                }
                
            })
            if checkCatg! {
                self.categoryBtn.setTitle(Constants.CampDict.object(forKey: "name") as! String, for: UIControlState())
                
                self.appDel.searchedCompany?.selectedCatg = Constants.CampDict.object(forKey: "catg_id") as! String
                //self.selectedCatg = catg
                self.selectedCatg = self.categoryDict.object(forKey: Constants.CampDict.object(forKey: "catg_id") as! String) as? CategoriesDao
                  print(self.selectedCatg)
                
            }
            else {
                let innerAlert = UIAlertController(title: self.localisation.localizedString(key: Constants.CampDict.object(forKey: "name") as! String), message:"\(self.localisation.localizedString(key: "searchcompany.permission")) \(Constants.CampDict.object(forKey: "name") as! String)", preferredStyle: UIAlertControllerStyle.alert)
                
                
                
                let action = UIAlertAction(title: self.localisation.localizedString(key:"searchcompany.askforpermission"), style: UIAlertActionStyle.default, handler: {
                    Void in
                    
                    self.appDel.searchedCompany?.selectedCatg = Constants.CampDict.object(forKey: "catg_id") as! String
                    
                    self.selectedCatg = self.categoryDict.object(forKey: Constants.CampDict.object(forKey: "catg_id") as! String) as? CategoriesDao
                    
                    
                    self.setupPermission()
                    
                })
                //if Reachability.connectedToNetwork() {
                innerAlert.addAction(action)
                // } //
                
                let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:nil)
                innerAlert.addAction(cancel)
                
                self.present(innerAlert, animated: true, completion: nil)
                return
            }
            
            
        }
        */
        
    }
    @IBAction func categoryMethod(_ sender: AnyObject) {
        //        if self.appDel.searchedCompany?.categories.count > 0 {
        //        if self.appDel.searchedCompany?.categories.count == 1 {
        //
        //        }
        //        else {
        
        
        
        let alert = UIAlertController(title: localisation.localizedString(key: "company.companycategory"), message:"", preferredStyle: UIAlertControllerStyle.alert)
        alert.navigationController?.setNavigationBarHidden(true, animated: true)
        if self.appDel.searchedCompany?.categories.count == 0 {
            print("Count 0")
            //self.appDel.searchedCompany?.categories = self.database.fetchAllCategories()
            self.appDel.searchedCompany?.categories = self.categories
            
        }else {
            print("Categoires \(self.appDel.searchedCompany?.categories)")
        }
        
       // print("All company categories count \(self.appDel.searchedCompany?.categories.count)")
        for catg in self.appDel.searchedCompany?.categories as! [CategoriesDao]
        {
            
            print("Catg id \(catg.catg_id) category name \(catg.catg_name)")
            let action = UIAlertAction(title: catg.catg_name!, style: UIAlertActionStyle.default, handler: {
                 Void in
               
                let catgIdArray = (self.appDel.user.categories as? NSString)?.components(separatedBy: ",") as? NSArray
                // Above array represents which categories are assigned to an user , in user dao these categories are in an array so tokenise
                
               // print("user catg id \(catgIdArray)")
                
                var found : Int = 0
                print("Categopry Arrat Id \(self.appDel.searchedCompany?.categories)")
                if catgIdArray == nil {
                    print("User does not have any permission")
                    self.appDel.searchedCompany?.selectedCatg = nil
                    self.categoryBtn.setTitle("", for: UIControlState())
                    
                    let innerAlert = UIAlertController(title: self.localisation.localizedString(key: catg.catg_name!), message:"\(self.localisation.localizedString(key: "searchcompany.permission")) \(catg.catg_name!)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    
                    
                    let action = UIAlertAction(title: self.localisation.localizedString(key:"searchcompany.askforpermission"), style: UIAlertActionStyle.default, handler: {
                         Void in
                       
                        self.appDel.searchedCompany?.selectedCatg = catg.catg_id
                        
                        self.selectedCatg = self.categoryDict.object(forKey: catg.catg_id!) as? CategoriesDao
                        
                        
                        self.setupPermission()
                        
                    })
                    //if Reachability.connectedToNetwork() {
                    innerAlert.addAction(action)
                    // } //
                    
                    let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:nil)
                    innerAlert.addAction(cancel)
                    
                    self.present(innerAlert, animated: true, completion: nil)
                    return
                    
                }
                var catgFound : Int = 0
                // retrieve from usr
                for var catgId in catgIdArray as! [String] {
                    
                    if catgIdArray != nil {
                        if catgId == catg.catg_id {
                            found = 1
                            for task in self.appDel.allTasks {
                                if let t = task as? TaskDao {
                                    //print("\(catgId) == \(t.category_id!) for company Id  \(t.company.company_id!) == \(self.appDel.searchedCompany!.company_id!)")
                                    if t.category_id == catgId && t.company.company_id! == self.appDel.searchedCompany!.company_id!{
                                        catgFound = 1
                                        print("Found \(catgFound)")
                                    } // end of the of
                                    
                                } // end of the if
                            } // end of the for loop
                            if catgFound == 0 {
                                
                                self.categoryBtn.setTitle(catg.catg_name, for: UIControlState())
                                
                                
                                self.appDel.searchedCompany?.selectedCatg = catg.catg_id
                                
                                
                              // self.selectedCatg = catg
                                self.selectedCatg = self.categoryDict.object(forKey: catg.catg_id!) as? CategoriesDao
                                
                                print("Selected \(catg.catg_id)")
                                print(self.selectedCatg!.catg_id)
                                
                                
                            }
                            else {
                                if self.appDel.completedTask != nil {
                                    if self.appDel.completedTask!.category_id == self.appDel.taskDao!.category_id {
                                        self.categoryBtn.setTitle(catg.catg_name, for: UIControlState())
                                        
                                        self.appDel.searchedCompany?.selectedCatg = catg.catg_id
                                        //self.selectedCatg = catg
                                        self.selectedCatg = self.categoryDict.object(forKey: catg.catg_id!) as? CategoriesDao
                                        

                                    }
                                    else {
                                        self.categoryBtn.setTitle(catg.catg_name, for: UIControlState())
                                        
                                        self.appDel.searchedCompany?.selectedCatg = catg.catg_id
//                                        self.selectedCatg = catg
                                        self.selectedCatg = self.categoryDict.object(forKey: catg.catg_id!) as? CategoriesDao
                                        

                                    }
                                }
                                else {
                                    self.categoryBtn.setTitle(catg.catg_name, for: UIControlState())
                                    
                                    self.appDel.searchedCompany?.selectedCatg = catg.catg_id
                                    
                                    //self.selectedCatg = catg
                                    self.selectedCatg = self.categoryDict.object(forKey: catg.catg_id!) as? CategoriesDao
                                    

                                    
//                                SCLAlertView().showError("", subTitle:"Task for '\(self.appDel.searchedCompany!.company_name)' on category '\(catg.catg_name!)' is already in your tasks list", closeButtonTitle:self.localisation.localizedString(key: "tasks.dismiss"))
                                }
                                return
                            }
                            
                        }
                        else {
                            print("Not Found")
                        }
                    } // end of the catgId
                    
                }
                if found == 0 {
                    
                    self.appDel.searchedCompany?.selectedCatg = nil
                    self.categoryBtn.setTitle("", for: UIControlState())
                    
                    let innerAlert = UIAlertController(title: self.localisation.localizedString(key: catg.catg_name!), message:"\(self.localisation.localizedString(key: "searchcompany.permission")) \(catg.catg_name!)", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: self.localisation.localizedString(key:"searchcompany.askforpermission"), style: UIAlertActionStyle.default, handler: {
                         Void in
                       
                        self.appDel.searchedCompany?.selectedCatg = catg.catg_id
                        self.selectedCatg = self.categoryDict.object(forKey: catg.catg_id!) as? CategoriesDao
                        
                        //self.selectedCatg = catg

                        self.setupPermission()
                        
                    })
                    //if Reachability.connectedToNetwork() {
                    innerAlert.addAction(action)
                    // } //
                    
                    let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:nil)
                    innerAlert.addAction(cancel)
                    
                    self.present(innerAlert, animated: true, completion: nil)
                    
                    
                    
                } // end of the found
                
                UIView.animate(withDuration: 2, animations: {
                    
                    self.categoryBtn.layer.borderColor = UIColor.green.cgColor
                    
                })
                
                
            })
            alert.addAction(action)
        }
        
        
        let cancelAction = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        //}
        //}
    }

    func setupPermission(){
        let permissionURL = Constants.baseURL + "requestToCreateNonPermitAdhocInspection?company_id=" + self.appDel.searchedCompany!.company_id! + "&inspector_id=\(self.appDel.user.user_id!)&category_id=\(self.appDel.searchedCompany!.selectedCatg!)"
        print(permissionURL)
        
        if Reachability.connectedToNetwork() {
            let downloader : DataDownloader = DataDownloader()
            
            downloader.delegate = self
            downloader.startDownloader(permissionURL, idn: "permission")
        }
        else {
            
            var array = userDefault.object(forKey: "permissions") as? NSArray
            var mutableArray = NSMutableArray()
            if array != nil {
                mutableArray = NSMutableArray(array: array!)
                mutableArray.add(permissionURL)
            }
            else {
                mutableArray.add(permissionURL)
                
            }
            
            self.userDefault.set(mutableArray, forKey: "permissions")
            self.userDefault.synchronize()
            self.navigationController?.popViewController(animated: true)
        }
        
    } // end of the setup Permissions
    @objc func countSeconds(){
        //self.timerSecond = timerSecond + 1
        
        self.appDel.totalSpendSecond = self.appDel.totalSpendSecond + 1
        
        let minutes : Int = (self.appDel.totalSpendSecond / 60)
        let hours : Int = minutes / 60
        
        let second  = (self.appDel.totalSpendSecond % 60)
        
        
        
        
       // self.timerlbl.text = "\(hours):\(minutes):\(second)"
        
    }
    
    
    @IBOutlet weak var expiryDatelbl: UILabel!
    @IBOutlet weak var expiryDateview: UIView!
    @IBOutlet weak var expiryDateTextField: UITextField!
    var secondsTimer : Timer?
    
    @IBOutlet weak var outerView: UIView!
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.secondsTimer?.invalidate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.secondsTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CreateTasksViewController.countSeconds), userInfo: nil, repeats: true)
    
    }
    
    func setupCatg(){
        self.categories = NSMutableArray()
        
        
        let categoryDao1 = CategoriesDao()
        categoryDao1.catg_id = "8"
        categoryDao1.catg_name = "الشركات السياحية"
        categoryDao1.list_id = "9"
        self.categories.add(categoryDao1)
        self.categoryDict.setObject(categoryDao1, forKey: categoryDao1.catg_id! as NSCopying)
        
        
        let categoryDao7 = CategoriesDao()
        
        categoryDao7.catg_id = "12"
        categoryDao7.list_id = "13"
        
        categoryDao7.catg_name = "الارشاد السياحي"
        self.categories.add(categoryDao7)
        self.categoryDict.setObject(categoryDao7, forKey: categoryDao7.catg_id! as NSCopying)
        
        
        
        let categoryDao2 = CategoriesDao()
        categoryDao2.catg_id = "9"
        categoryDao2.list_id = "10"
        
        categoryDao2.catg_name = "الرحلات السياحية البرية"
        self.categories.add(categoryDao2)
        self.categoryDict.setObject(categoryDao2, forKey: categoryDao2.catg_id! as NSCopying)
        
        
        let categoryDao3 = CategoriesDao()
        categoryDao3.catg_id = "10"
        categoryDao3.list_id = "11"
        
        categoryDao3.catg_name = "المخيمات السياحية و تصريح الفعاليات"
        self.categories.add(categoryDao3)
        self.categoryDict.setObject(categoryDao3, forKey: categoryDao3.catg_id! as NSCopying)
        
        
        
              let categoryDao9299 = CategoriesDao()
              categoryDao9299.catg_id = "22"
              categoryDao9299.list_id = "23"
              categoryDao9299.catg_name = "بلدية دبي"
              self.categories.add(categoryDao9299)
              
              self.categoryDict.setObject(categoryDao9299, forKey: categoryDao9299.catg_id! as NSCopying)

        
        
        
        let categoryDao4 = CategoriesDao()
        categoryDao4.catg_id = "13"
        categoryDao4.list_id = "14"
        
        categoryDao4.catg_name = "تفتيش الفعاليات"
        self.categories.add(categoryDao4)
        self.categoryDict.setObject(categoryDao4, forKey: categoryDao4.catg_id! as NSCopying)
        
        
        let categoryDao5 = CategoriesDao()
        categoryDao5.catg_id = "14"
        categoryDao5.list_id = "15"
        
        categoryDao5.catg_name = "بيوت العطلات"
        self.categories.add(categoryDao5)
        self.categoryDict.setObject(categoryDao5, forKey: categoryDao5.catg_id! as NSCopying)
        
        
        let categoryDao6 = CategoriesDao()
        
        categoryDao6.catg_id = "17"
        categoryDao6.list_id = "18"
        
        categoryDao6.catg_name = "الدرهم السياحي"
        self.categories.add(categoryDao6)
        self.categoryDict.setObject(categoryDao6, forKey: categoryDao6.catg_id! as NSCopying)
        
        
        let categoryDao99 = CategoriesDao()

        categoryDao99.catg_id = "18"
        categoryDao99.list_id = "19"

        categoryDao99.catg_name = "مخالفات ترخيص وتصنيف"
        self.categories.add(categoryDao99)
        self.categoryDict.setObject(categoryDao99, forKey: categoryDao99.catg_id! as NSCopying)
        
        
        
        let categoryDao999 = CategoriesDao()
        categoryDao999.catg_id = "20"
        categoryDao999.list_id = "21"
        categoryDao999.catg_name = "الرقابة على فعاليات الاعمال وغيرها"
        self.categories.add(categoryDao999)
        
        self.categoryDict.setObject(categoryDao999, forKey: categoryDao999.catg_id! as NSCopying)

        let categoryDao9199 = CategoriesDao()
        categoryDao9199.catg_id = "21"
        categoryDao9199.list_id = "22"
        categoryDao9199.catg_name = "DST Check List"
        self.categories.add(categoryDao9199)
        self.categoryDict.setObject(categoryDao9199, forKey: categoryDao9199.catg_id! as NSCopying)

        
        
        let categoryDao91999 = CategoriesDao()
              categoryDao91999.catg_id = "23"
              categoryDao91999.list_id = "24"
              categoryDao91999.catg_name = "COVID-19"
              self.categories.add(categoryDao91999)
              self.categoryDict.setObject(categoryDao91999, forKey: categoryDao91999.catg_id! as NSCopying)

              
        
      
//
//
//
        
        
//        let listDao6 = CategoriesDao()
//        
//        listDao6.catg_name = "Holiday Homes-Deluxe"
//        listDao6.catg_id = "16"
//        self.appDel.listArray.addObject(listDao6)
//        
//        
//        let listDao7 = CategoriesDao()
//        listDao7.catg_name = "Holiday Homes-Standard"
//        listDao7.catg_id = "17"
//        self.appDel.listArray.addObject(listDao7)
        

        
        print("categories in database \(self.categories.count)")
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }
        self.downloadAllTaskTypes()
        self.setupCatg()
        self.createInspectionBtn.layer.cornerRadius = 5.0
        self.createInspectionBtn.layer.masksToBounds = true
        
//        if Reachability.connectedToNetwork() {
//
//        }
//        else {
//            self.inspectorView.isHidden = true
//        }
        
        
        // self.companyNameLbl.text = self.localisation.localizedString(key: "company.companyname")
        
       
        rightActivity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        rightActivity.hidesWhenStopped = true
        //  rightActivity.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightActivity)

        
        self.companyCategoryLbl.text = self.localisation.localizedString(key: "company.category")
        self.taskTypelbl.text = self.localisation.localizedString(key: "task.type")
        
        self.licensenotitlelbl.text = self.localisation.localizedString(key: "company.licenseno")
        // self.companyNameArabicLbl.text = self.localisation.localizedString(key: "company.namear")
        
        self.issuedatetitlelbl.text = self.localisation.localizedString(key: "company.issueDate")
        //self.expiryDatelbl.text = self.localisation.localizedString(key: "company.expirtydate")
        self.expiryDatetitellbl.text = self.localisation.localizedString(key: "company.expirtydate")
        self.addSubvenuelbl.text = self.localisation.localizedString(key: "company.addsubvenue")
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateTasksViewController.addCoInspectionMethod(_:)))
        tap.numberOfTapsRequired = 1
        
        // self.inspectorsLbl.addGestureRecognizer(tap)
        self.inspectorView.addGestureRecognizer(tap)
        
        
        self.drivingBtn.setTitle(self.localisation.localizedString(key: "company.driving"), for: UIControlState())
        self.addressLbl.text = self.localisation.localizedString(key: "company.address")
        
        
        self.createInspectionBtn.setTitle(self.localisation.localizedString(key: "tasks.createinspection"), for: UIControlState())
        self.phoneLabel.text = localisation.localizedString(key: "company.mobileno")
        
        print("License expiry \(self.appDel.searchedCompany?.license_expire_date)")
        
        //self.co.text = self.localisation.localizedString(key: "company.category")
        
        self.landline.text = localisation.localizedString(key: "company.landline")
        
        self.activityCodelbl.text = localisation.localizedString(key: "company.activtiycodes")
        
        self.addCoinspectionTitle.text = localisation.localizedString(key: "tasks.addInspector")
        
        //  self.activityCodelbl.text = localisation.localizedString(key: "company.activtiycodes")
        // "tasks.addInspector" = "إضافة مفتش";
        // "tasks.searchInspector" = "بحث عن مفتش...";
        
        
        self.companynotes.text = localisation.localizedString(key: "company.notes")
        
        self.addressnoteslbl.text = localisation.localizedString(key: "company.addressnotes")
        
        // "company.notes" = "Company Notes";
        // "company.addressnotes" = "Address Notes";
        
        
        
        
        
        
        // self.typeText.text = self.appDel.taskDao.company.type_name
        
        
        //  self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_bg")!)
        // self.outerView.backgroundColor = UIColor(patternImage: UIImage(named: "tablebg")!)
        if Reachability.connectedToNetwork() {
            print("Network connected")
            self.setupDetailCompanyDownloader()
        }
        else {
            self.drivingBtn.isEnabled = false
            
            //            if self.appDel.searchedCompany?.company_name != nil {
            //                self.companyNameTextField.text = self.appDel.searchedCompany!.company_name!
            //            }
            //
            //            if self.appDel.searchedCompany?.company_name_arabic != nil {
            //                self.companyNameArabicTextField.text = self.appDel.searchedCompany!.company_name_arabic!
            //            }
            //
            //            if self.appDel.searchedCompany!.license_info != nil {
            //                self.licenseTextField.text = self.appDel.searchedCompany!.license_info!
            //
            //            }
            //            if self.appDel.searchedCompany!.license_issue_date != nil {
            //                self.issueDateTextField.text = self.appDel.searchedCompany!.license_issue_date!
            //
            //            }
            //            if self.appDel.searchedCompany!.license_expire_date != nil {
            //                self.expiryDateTextField.text = self.appDel.searchedCompany?.license_expire_date
            //
            //            }
            //            if self.appDel.searchedCompany?.landline != nil {
            //            self.landlineValue.text = self.appDel.searchedCompany?.landline
            //            }
            //
            //            if self.appDel.searchedCompany?.phone_no != nil {
            //            self.phoneValue.text = self.appDel.searchedCompany?.phone_no
            //            }
            //
            
            self.setupValues()
//            let activitys = self.databaseManager.fetchActivitiesFromCompany(self.appDel.searchedCompany!.company_id!)
//            let catgs = self.databaseManager.fetchCategoriesIdsOnActivity(activitys)
//            let categories = self.databaseManager.categoriesOnIds(catgs)
//            print(categories)
//            self.appDel.searchedCompany?.categories = categories
//            self.appDel.searchedCompany?.type_name = ""
//            for var a = 0 ; a < self.appDel.searchedCompany?.categories.count ; a += 1 {
//                if let cat = self.appDel.searchedCompany?.categories.objectAtIndex(a) as? CategoriesDao {
//                    if self.appDel.searchedCompany!.type_name == "" {
//                        self.appDel.searchedCompany?.type_name =  cat.catg_name!
//                    }
//                    else {
//                        self.appDel.searchedCompany?.type_name =  (self.appDel.searchedCompany?.type_name)! + "," + cat.catg_name!
//                    }
//                    print("Category name \(self.appDel.searchedCompany?.type_name)")
//                    
//                    //self.appDel.searchedCompany?.category_name_ar = (self.appDel.searchedCompany?.category_name_ar)! + cat.category_name_ar!
//                }
//            }
//            
//            
//            if self.appDel.searchedCompany?.categories.count == 1 {
//                let catg = self.appDel.searchedCompany?.categories.objectAtIndex(0) as! CategoriesDao
//                //self.appDel.searchedCompany?.selectedCatg = catg.catg_id
//                //self.categoryBtn.setTitle(catg.catg_name!, forState: UIControlState.Normal)
//                
//                
//                
//            } else if self.appDel.searchedCompany?.categories.count > 1 {
//                self.categoryMethod(self)
//                
//                
//                
//            }
//            
           
        }
        
        print(self.appDel.offlinePermit)
        
        if self.appDel.offlinePermit != nil {
            self.defaultCategory()
        }
        else {
            if Reachability.connectedToNetwork() {
                
                
            }
            else {
            self.categoryMethod(self)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupDetailCompanyDownloader(){
        self.rightActivity.startAnimating()
        
        print(Constants.baseURL + "getCompanyDetailById?companyId=\(self.appDel.searchedCompany?.company_id)")
        let  detailUrl = Constants.baseURL + "getCompanyDetailById?companyId=\(self.appDel.searchedCompany!.company_id!)"
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        self.appDel.showIndicator = 1
        downloader.startDownloader(detailUrl, idn: "detail")
        
    }
    
    //MARK:- Downloader methods
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        
        self.rightActivity.stopAnimating()
        let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        print(str)
        
        if identity == "detail" {
            let parser = JsonParser()
            self.appDel.searchedCompany = parser.parseDetailCompany(data)
            self.setupValues()
            if self.appDel.offlinePermit != nil {
                self.defaultCategory()
            }
            else {
             self.categoryMethod(self)
            }
            
        }
        if identity == "permission" {
            
            self.navigationController?.popViewController(animated: true)
            
        }
        if identity == "taskType" {
            let parser = JsonParser()
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
             //print("task type \(str)")
           
            let taskTypes = parser.parseTaskType(data)
            self.taskType = taskTypes as NSArray as! [TaskTypeDao]
            //print("Task type count \(self.taskType?.count)")
           
            // print("Total Task Types \(taskTypes.count)")
        }
        if identity == "createsafari" {
        
       // self.navigationController?.popToRootViewControllerAnimated(true)
            var storyboard : UIStoryboard?
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                storyboard = UIStoryboard(name: "Main", bundle: nil)
            }
            else {
                storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
                
            }
            let initialViewController = storyboard!.instantiateViewController(withIdentifier: "cnt_reveal") as! SWRevealViewController
            
            self.appDel.window?.rootViewController = initialViewController
             self.appDel.addedSubvenueCompany = self.appDel.searchedCompany?.company_name
            
            
        }
        if identity == "create" {
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
             print("SUBVENUE COUNT \(self.allSubVenues?.count)")
            if self.allSubVenues?.allKeys.count > 0 {
                if str!.contains("success") {
                    self.appDel.addedSubvenueCompany = self.appDel.searchedCompany?.company_name
                self.navigationController?.popToRootViewController(animated: true)
                return
                }
           
            }
            //            if ((str?.containsString("success")) != nil) {
            //              //  self.navigationController?.viewControllers[2].navigationController?.performSegueWithIdentifier("sw_createtotasks", sender: nil)
            //              //  self.performSegueWithIdentifier("sw_createtotasks", sender: nil)
            //             // let story = UIStoryboard(name: "Main", bundle: nil)
            //             //   let cnt = story.instantiateViewControllerWithIdentifier("cnt_tasks") as! TasksViewController
            //              //self.navigationController?.viewControllers[1].navigationController?.pushViewController(cnt, animated: true)
            //               self.navigationController?.popToViewController((self.navigationController?.viewControllers[3])!, animated: true)
            //
            //
            //            }
            //            else {
            //
            //            let alert = UIAlertController(title: "Error, Please try again", message: "Technical Info: \(str) ", preferredStyle: UIAlertControllerStyle.Alert)
            //            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
            //              alert.addAction(action)
            //              self.presentViewController(alert, animated: true, completion: nil)
            //
            //            }
            
            print(str)
            
            let parser = JsonParser()
            let dao = parser.parseCreatedTask(data)
            if dao.response == "success" {
                dao.category_id = self.appDel.searchedCompany?.selectedCatg
                
                self.appDel.taskDao = dao
                print("list id \(self.appDel.taskDao.list_id)")
                
                self.appDel.list_id = self.appDel.taskDao.list_id
                self.setupPermitURL()
                if UIDevice.current.userInterfaceIdiom == .pad {
                let story = UIStoryboard(name: "Main", bundle: nil)
                let cnt = story.instantiateViewController(withIdentifier: "cnt_questions") as! QuestionListViewController
                // self.navigationController?.popToViewController((self.navigationController?.viewControllers[3])!, animated: true)
                self.navigationController?.pushViewController(cnt, animated: true)
                }
                else {
                    let story = UIStoryboard(name: "Main_iPhone", bundle: nil)
                    let cnt = story.instantiateViewController(withIdentifier: "cnt_questions") as! QuestionListViewController
                    // self.navigationController?.popToViewController((self.navigationController?.viewControllers[3])!, animated: true)
                    self.navigationController?.pushViewController(cnt, animated: true)
                    
                }
                
            }
            else {
                
            }
            
            
            
        }
        
    }
    
    
    func setupValues(){
        
        
        print(self.appDel.searchedCompany?.company_name)
        if self.appDel.searchedCompany?.company_name != nil {
            self.englishnamelbl.text = self.appDel.searchedCompany!.company_name!
            
            // self.companyNameLbl.text = self.appDel.searchedCompany!.company_name!
        }
        
        
        if self.appDel.searchedCompany?.company_name_arabic != nil {
            //self.companyNameArabicTextField.text = self.appDel.searchedCompany!.company_name_arabic!
            
            self.arabicNameLbl.text = self.appDel.searchedCompany!.company_name_arabic!
        }
       
        
        if self.appDel.searchedCompany?.address != nil {
            self.addressValue.text =  self.appDel.searchedCompany?.address
        }
        
        
        if self.appDel.searchedCompany!.license_info != nil {
            //  self.licenseTextField.text = self.appDel.searchedCompany!.license_info!
            self.licenseno.text = self.appDel.searchedCompany!.license_info!
        }
        if self.appDel.searchedCompany!.license_issue_date != nil {
            //self.issueDateTextField.text = self.appDel.searchedCompany!.license_issue_date!
            self.issueDatelbl.text = self.appDel.searchedCompany!.license_issue_date!
        }
        if self.appDel.searchedCompany!.license_expire_date != nil {
            // self.expiryDateTextField.text = self.appDel.searchedCompany?.license_expire_date
            self.expirydatelbl.text = self.appDel.searchedCompany?.license_expire_date
            
        }
        
        if self.appDel.searchedCompany!.activity_code != nil {
            self.activityCodevalue.text = self.appDel.searchedCompany!.activity_code
            
        }
        
        
        
        
        if self.appDel.searchedCompany!.landline != nil {
            self.landlineValue.text = self.appDel.searchedCompany!.landline
        }
        
        if self.appDel.searchedCompany!.phone_no != nil {
            self.phoneValue.text = self.appDel.searchedCompany?.phone_no
        }
        
        if self.appDel.searchedCompany?.activity_code != nil {
            self.activityCodevalue.text = self.appDel.searchedCompany?.activity_code
        }
        
        if self.appDel.searchedCompany?.company_note != nil {
            self.companyNotesValue.text = self.appDel.searchedCompany?.company_note
        }
        
        if self.appDel.searchedCompany?.address_note != nil {
            self.addressNotes.text = self.appDel.searchedCompany?.address_note
            
        }
        
        
        
        
        
        
        
        //            if self.appDel.searchedCompany?.categories.count == 1 {
        //                let catg = self.appDel.searchedCompany?.categories.objectAtIndex(0) as! CategoriesDao
        //            self.appDel.searchedCompany?.selectedCatg = catg.catg_id
        //            self.categoryBtn.setTitle(catg.catg_name!, forState: UIControlState.Normal)
        //
        //            }
        //            else if self.appDel.searchedCompany?.categories.count > 1 {
        //            self.categoryMethod(self)
        //
        //           }
        //
       // self.categoryMethod(self)
        if self.appDel.searchedCompany?.lat != nil  && self.appDel.searchedCompany?.lon != nil {
        if Util.validateCoordinates(self.appDel.searchedCompany!.lat!, lon: self.appDel.searchedCompany!.lon!) {
        let companylocation = CLLocationCoordinate2DMake((self.appDel.searchedCompany!.lat! as NSString).doubleValue, (self.appDel.searchedCompany!.lon! as NSString).doubleValue)
            // Drop a pin
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = companylocation
            if self.appDel.searchedCompany!.company_name != nil{
                dropPin.title = self.appDel.searchedCompany!.company_name!
            }
            
            
            mapView.addAnnotation(dropPin)
        }
        }
        
        
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
