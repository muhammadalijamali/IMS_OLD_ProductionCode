//
//  OptionViewController.swift
//  ADTourism
//
//  Created by Administrator on 9/19/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit
import Parse
import PKHUD

class OptionViewController: UIViewController , MainJsonDelegate , CLLocationManagerDelegate {

    @IBOutlet weak var syncBtn: UIButton!
    var localisation : Localisation!
    var locationManager: CLLocationManager = CLLocationManager()
    var loc : CLLocationCoordinate2D?
    var userDefault : UserDefaults = UserDefaults.standard
    var locationStatus : Int?   // - 1 for unauthorised and 1 for authorised
    var database = DatabaseManager()
    
    
    
  
    func locationMethod(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // locationManager.distanceFilter = 500.0
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    }
    

    @IBAction func syncMethod(_ sender: AnyObject) {
        if Reachability.connectedToNetwork() {
            let downloader  = DataDownloader()
            downloader.delegate = self
            self.appDel.showIndicator = 1
            // println(array)
            for keystr in pendingtasks as! [String] {
                let dataArray = self.userDefaults.object(forKey: keystr) as! NSMutableArray
                let task = TaskDao()
                task.task_id = keystr
                self.appDel.taskDao = task
                downloader.startSendingPost(dataArray, url:URL(string: Constants.saveServay)!, ide: "submit" , duration : 0)
            }
    
            }

    }
    
    func downloadAllDump(){
        if Reachability.connectedToNetwork() {
            let downloader  = DataDownloader()
            downloader.delegate = self
            self.appDel.showIndicator = 1
            
            downloader.startDownloader(Constants.baseURL + "getCompaniesActivityDump", idn: "dump")
            
            
        
        }
    
    }
    @IBAction func active_inactimeMethod(_ sender: AnyObject) {
        self.makeActive()
    }
    @IBOutlet weak var active_inactivebtn: UIButton!
    var appDel : AppDelegate!

    @IBOutlet weak var DevModeLbl: UILabel!
    
    @IBAction func inspectionMethod(_ sender: AnyObject) {
    }
    @IBOutlet weak var inspectionBtn: UIButton!
    
    @IBOutlet weak var historyBtn: UIButton!
    
    @IBAction func historyMethod(_ sender: AnyObject) {
    }
    let userDefaults = UserDefaults.standard
    var pendingtasks : NSArray = NSArray()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationMethod()

    }
    // MARK:- ViewController methods 
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDel = UIApplication.shared.delegate! as! AppDelegate
        if Constants.mode == 1 {
        self.DevModeLbl.isHidden = true
            
        }
        else {
        self.DevModeLbl.isHidden = false
        }
        //println(NSUserDefaults.standardUserDefaults().dictionaryRepresentation());
        // println(userDefaults.objectForKey("tasks"))
        self.appDel.keepCheckingInternet()
        let count = userDefaults.dictionaryRepresentation().keys
               //self.syncBtn.setTitle("\(count)", forState: UIControlState.Normal)
        
//        let str = userDefaults.objectForKey("tasks") as? NSString
//        
//        if str != nil {
//        self.pendingtasks = str!.componentsSeparatedByString(",")
//        
//            self.syncBtn.setTitle("\(self.pendingtasks.count)", forState: UIControlState.Normal)
//        
//        }
//        if self.database.isCompaniesAddedAlready() {
//        }
//        else {
//       
        if self.database.isCompaniesAddedAlready() {}
        else {
        self.downloadAllDump()
        }
        // }
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
         self.navigationController?.setNavigationBarHidden(false, animated: true)
         self.title = ""
        self.localisation = Localisation()
        
        
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }
        
        self.inspectionBtn.setTitle(localisation.localizedString(key: "option.inspection"), for: UIControlState())
        
        self.historyBtn.setTitle(localisation.localizedString(key: "option.history"), for: UIControlState())
       
        
        // Do any additional setup after loading the view.
    
        if self.appDel.user.status != "Inactive" {
            //    self.activeBtn.title = "غير فعالة"
            //self.active_inactivebtn.setTitle("غير فعالة", forState: UIControlState.Normal)
            self.active_inactivebtn.setTitle(localisation.localizedString(key: "tasks.makemeinactive"), for: UIControlState())
            //self.active_inactivebtn.setTitle("Make me Inactive", forState: UIControlState.Normal)
            self.title = ""
            self.active_inactivebtn.backgroundColor = UIColor(red: 110/255, green: 177/255, blue: 223/255, alpha: 1)
        }
        else {
            //   self.activeBtn.title = "فعال"
            //  self.active_inactivebtn.setTitle("فعال", forState: UIControlState.Normal)
            self.active_inactivebtn.setTitle(localisation.localizedString(key: "tasks.makemeactive"), for: UIControlState())
            // navigationController!.navigationBar.barTintColor = UIColor.redColor()
            self.title = localisation.localizedString(key: "tasks.youareinactive")
            
            navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.red]
            
            
            self.active_inactivebtn.backgroundColor = UIColor.red
        }

        self.uploadToken()
    
    }

    @IBAction func logoutMethod(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeActive(){
        // if location is not available don't allow inspector to enable to disable
        
        if self.locationStatus == -1 {
        self.requiredMethod()
        return
        }
        else {
        print(loc?.latitude, terminator: "")
        print(loc?.longitude, terminator: "")
            
        }
        
        

        self.localisation = Localisation()
        
        // Shows the selected language
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
        }
        
        
        
        if self.appDel.user.status !=  "Inactive" {
            
        /// THIS IS REMOVED ON BEHALF OF VMS REQUIREMENTS /////
//        let alertController = UIAlertController(title: localisation.localizedString(key: "options.inactivetitle"), message:"" , preferredStyle: UIAlertControllerStyle.Alert)
//        let action1 = UIAlertAction(title: localisation.localizedString(key: "options.inactiveReason1"), style: UIAlertActionStyle.Default, handler: {
//       
//             self.makeMeInactive(self.localisation.localizedString(key: "options.inactiveReason1"))
//         })
//        alertController.addAction(action1)
//        
////        let action2 = UIAlertAction(title: localisation.localizedString(key: "options.inactiveReason2"), style: UIAlertActionStyle.Default, handler: {
////           
////            self.makeMeInactive(self.localisation.localizedString(key: "options.inactiveReason2"))
////        })
////        alertController.addAction(action2)
////        
//        let action3 = UIAlertAction(title: localisation.localizedString(key: "options.inactiveReason3"), style: UIAlertActionStyle.Default, handler: {
//           
//             self.makeMeInactive(self.localisation.localizedString(key: "options.inactiveReason3"))
//        })
//        alertController.addAction(action3)
//        
//       
//        let action4 = UIAlertAction(title: localisation.localizedString(key: "options.inactiveReason4"), style: UIAlertActionStyle.Default, handler: {
//           
//             self.makeMeInactive(self.localisation.localizedString(key: "options.inactiveReason4"))
//            //print("Option4")
//        })
//        alertController.addAction(action4)
//        
//            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
//               
//                print("Cancel", terminator: "")
//            })
//            alertController.addAction(cancel)
//            
//            
//            
//            self.presentViewController(alertController, animated: true, completion: nil)
        
       self.makeMeInactive()
        
        }
        else {
        self.makeMeInactive()
            
            
        } // end of the if
        
    }
    
    func makeMeInactive(){
        // This method is used to make inspector active and inactive on criteria based
        
        if Reachability.connectedToNetwork() {
            if self.loc ==  nil {
            let alert = UIAlertController(title: "Location?", message: "App can not access your location , please restart app or check location settings", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                
                
                return
            }
            
        var loginUrl : String  = ""
        if self.appDel.user.status !=  "Inactive" {
            ///////  THIS IS REMOVED ON BEHALF OF THE VMS ///////////////////

         //   loginUrl = Constants.baseURL + "activeInactiveInspector?inspector_id=" + self.appDel.user.user_id + "&status=inactive&comment=\(reason)&latitude=\(self.loc!.latitude)&longitude=\(self.loc!.longitude)"
            
            loginUrl = Constants.baseURL + "activeInactiveInspector?inspector_id=" + self.appDel.user.user_id + "&status=inactive&latitude=\(self.loc!.latitude)&longitude=\(self.loc!.longitude)"
            
            
        }
        else {
            loginUrl = Constants.baseURL + "activeInactiveInspector?inspector_id=" + self.appDel.user.user_id + "&status=active&latitude=\(self.loc!.latitude)&longitude=\(self.loc!.longitude)"
            
        }
        
        
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "active")
        }
            else {
                let alert = UIAlertController(title: localisation.localizedString(key: "searchcompany.pleasecheckinternetconnection"), message: "", preferredStyle: UIAlertControllerStyle.alert)
                let alertAction = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        
        }
    func uploadToken(){
        
        
        let installation = PFInstallation.current()
         if installation.deviceToken != nil {
        let loginUrl : String  =  Constants.baseURL + "updateToken?inspector_id=" + self.appDel.user.user_id + "&device_token=" + installation.deviceToken!
      
            print(loginUrl)
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "token")
        }
        
    }
    
    
    
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        var tempArray : NSMutableArray = NSMutableArray()
        let parser = JsonParser()
        
        if identity == "active" {
            //            if self.appDel.user == 1 {
            //            self.appDel.inspector_active = 0
            //
            //            }
            //            else {
            //             self.appDel.inspector_active = 1
            //            }
            self.checkActiveInActive()
            return
            
        }
        else if identity == "dump" {
            
            print(" \n dump downloaded")
        //let str = NSString(data: data, encoding: NSUTF8StringEncoding)
            //print(str)
            let array = parser.parseCompanies(data)
            let activityCodeArray = parser.parseActivityCodes(data)
            let categoryArray = parser.parseCategories(data)
            let catActArray = parser.parseCatActCodes(data)
            let catCompArray = parser.parseCompanyActCodes(data)
            let mainInspectionList = parser.parseMainInspectionList(data)
            let questionsArray = parser.parseQuestionsForOffline(data)
            
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.dimsBackground = true
            

            
            //let catCompanyArray = parser.pa
            
            self.database.deleteAllCompanies()
            self.database.deleteAllActivityCodes()
            self.database.deleteAllCatAct()
            self.database.deleteAllCatCompany()
            self.database.deleteAllMainInspectionList()
            self.database.deleteAllQuestion()
            self.database.deleteAllOptions()
            self.database.deleteAllExtraOptions()
            

            
            
            self.database.addCompanies(array)
            self.database.addActivityCode(activityCodeArray)
            self.database.addCatActCodes(catActArray)
            self.database.addInspectionListMain(mainInspectionList)
            database.addInspectionList(questionsArray, taskid: "0")
            
            //self.database.addInspectionList(allQuestions, taskid: "0")
            
            
        //    print(self.database.getActivityCodes())
            self.database.deleteAllCategories()
            print("adding category \(categoryArray.count)")
            self.database.addCategories(categoryArray)
            self.database.addCatCompanyCodes(catCompArray)
            
            print("All Main List \(self.database.fetchAllInspectionMainListAll())")
            print("categories \(self.database.getCategories())")
             PKHUD.sharedHUD.hide(animated: true)
          //  print("Act Categiry \(self.database.getCatActCodes())")
          //  print("addCatCompanyCodes \(self.database.getCatCompanyCodes())")
        self.uploadToken()
        //self.setupQuestionsDownload()
        }
        
//        else if identity == "questionsdump" {
//        
//            let questionsArray = parser.parseQuestionsForOffline(data)
//            database.addInspectionList(questionsArray, taskid: "0")
//            //let questionsArray = database.fetchQuestionListByList_Id()
//            
//          //  self.userDefault.setValue("1", forKey: "sync")
//          //  self.userDefault.synchronize()
//        
//        }
    }
    
    func setupQuestionsDownload(){
        if Reachability.connectedToNetwork() {
            let downloader  = DataDownloader()
            downloader.delegate = self
            self.appDel.showIndicator = 1
            
            downloader.startDownloader(Constants.baseURL + "getQListDump", idn: "questionsdump")
            
            
            
        }
        
    
    
    }
    func checkActiveInActive(){
        
        
        if self.appDel.user.status == "Inactive" {
            //    self.activeBtn.title = "غير فعالة"
            //self.active_inactivebtn.setTitle("غير فعالة", forState: UIControlState.Normal)
            self.active_inactivebtn.setTitle(localisation.localizedString(key: "tasks.makemeinactive"), for: UIControlState())
           
         //   self.active_inactivebtn.setTitle("Make me Inactive", forState: UIControlState.Normal)
            
            //self.active_inactivebtn.setTitle("Make me Inactive", forState: UIControlState.Normal)
            self.title = ""
            self.active_inactivebtn.backgroundColor = UIColor(red: 110/255, green: 177/255, blue: 223/255, alpha: 1)
            self.appDel.user.status = "Active"
            
        }
        else {
            //   self.activeBtn.title = "فعال"
            //  self.active_inactivebtn.setTitle("فعال", forState: UIControlState.Normal)
           // self.active_inactivebtn.setTitle("Make me active", forState: UIControlState.Normal)
            // 
             self.active_inactivebtn.setTitle(localisation.localizedString(key: "tasks.makemeactive"), for: UIControlState())
            navigationController!.navigationBar.barTintColor = UIColor.red
            self.title = localisation.localizedString(key: "tasks.youareinactive")
            
            navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.red]
            self.appDel.user.status = "Inactive"
            
            
            self.active_inactivebtn.backgroundColor = UIColor.red
        }
        
        
        
    }
    
    func requiredMethod(){
        let alert : UIAlertController = UIAlertController(title:localisation.localizedString(key: "option.locationrequired"), message:localisation.localizedString(key: "option.You have to authorize location from device"), preferredStyle: UIAlertControllerStyle.alert)
        let action1 : UIAlertAction = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action1)
        
        self.present(alert, animated: true, completion: nil)
    }

    //MARK:- Location methods which are required
    func locationManager(_ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus) {
           print("Location status \(status)", terminator: "")
            if status == CLAuthorizationStatus.denied {
                self.locationStatus = -1
                
            self.requiredMethod()
                
            } // end of the status
            else {
                self.locationStatus = 1

                print("Location Authorised", terminator: "")
            
            }
            
    } // end of the didAuthorizationStatus

    func locationManager(_ manager: CLLocationManager,
        didFailWithError error: Error)
    {
    
    } // end of the locationManager
    
    func locationManager(_ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation])
        
    {
    
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        self.loc = coord
        self.userDefault.set(coord.latitude, forKey: "lat")
        self.userDefault.set(coord.longitude, forKey: "lon")
        self.userDefault.synchronize()
        
        
        self.appDel.user.lat = coord.latitude
        self.appDel.user.lon = coord.longitude
       
    
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
