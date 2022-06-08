//
//  AppDelegate.swift
//  ADTourism
//
//  Created by Administrator on 8/19/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit
import CoreData
import Parse
import Fabric
import Crashlytics
import PKHUD
import Firebase
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

//import Appsee


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate , MainJsonDelegate , SessionDelegate{
    
    var window: UIWindow?
    var userDefault : UserDefaults = UserDefaults.standard
    var fileDownloading : Int = 0
    var vpnManager = VPNManager()
    var vpnConnected : Bool = false
    var interConnection : Bool = true
    var apple_deviceToken : String?
    var addedSubvenueCompany : String?
    var addedSafariCompany : String?
    
    var searchedCar : String?
    var searchedDriver: String?
    var currentBtn : ADButton?
    var user : UserDao!
    var selectedCode : String? = ""
    var backfromCheckList : Int = 0
    var fromCompany : Int = 0
    var selectedActivityCode : ActivityCodeDao?
    var selectedPoolOption : Int = 0  // 1 by the map , 2 by the activity code , 3 for the company name / Licene no , 4 address / area
    var selectedLicense : String?
    var selectedAddress : String?
    var taskCount : Int = 0
    var listArray : NSMutableArray = NSMutableArray()
    var completedTask : TaskDao?
    var selectedUrgency : Int = 0
    var selectedReportType : Int = 0 // 1 tasks 2 timing
    var progressBar : UIProgressView!
    var selectedPermit : PermitDao?
    var fromLogin : Int = 0
    var chatUser : ChatUsers?
    var history_task : TaskHistoryDao?
    var TASK_RADIUS : Int = 1000
    var selectedMakani : String?
    var globalCompanies : NSMutableArray = NSMutableArray()
    var allAreas : NSMutableArray = NSMutableArray()
    var allZones  : NSMutableArray = NSMutableArray()
    var currentZoneTask : TaskDao?
    var saveMakani : Int = 0
    var onMyWayTask : TaskDao?
    var allQCategories : NSMutableArray = NSMutableArray()
    var allCountries : NSMutableArray = NSMutableArray()
    
    
    
    var taskDao : TaskDao!
    var notesDict : NSMutableDictionary!
    var lat:Double?
    var lon : Double?
    var totalSpendSecond : Int = 0
    var violationHistoryDao : ViolationHistoryDao?
    
    var inspector_active : Int = 1 // 1 is active 0 not active
    var fromHistoryToResult : Int = 1
    var questions : NSMutableArray!
    var selectedViolation : NSMutableDictionary!
    var imageToShow : UIImage!
    var showIndicator : Int = 0
    var selectedLanguage : Int = 1 // 1 for english 2 for arabic
    var calenderHisyoty : Int = 0
    var indexPathBank : NSMutableDictionary = NSMutableDictionary()
    var show_result : Int = 0
    var timer : Timer?
    let userDefaults : UserDefaults = UserDefaults.standard
    var pendingtasks = NSArray()
    let offlineManager = OfflineFileUploader()
    var allAnsweredArray : NSMutableArray!
    var tasks_duration : Int = 0
    var calculatedWarnings : NSMutableDictionary = NSMutableDictionary()
    var searchedCompany : CompanyDao?
    var userLocation : CLLocationCoordinate2D?
    var  alreadyOnTheWay : Int = 0
    var locationManager: CLLocationManager = CLLocationManager()
    var locationTimer : Timer?
    var fromSearch : Int = 0
    
    var locationArray : NSMutableArray = NSMutableArray()
    var is_adhoc_inspection : Int = 0  // check if inspection is adhoc
    var list_id : String?
    var pendingClosedTask : NSArray? = NSArray()
    var pendingTasksCount : Int = 0
    var closedTaskCount : Int = 0
    var processing : Int = 0 // 0 not processing 1 processing
    var unique : String = ""
    var currentTime : String = ""
    var editedCompanies : NSMutableArray?
    var isUnlicense : Int = 0
    var showCompanyDetail : Int = 0
    var incidentEnlargeImage : UIImage?
    var showIncidentMedia : Int = 0
    var onMytimer : Timer?
    var externalOrg : ExternalOrgDao?
    var reportType : Int?
    var notifDao : NotifDao?
    var allTasks:NSMutableArray = NSMutableArray()
    var fileSession : SessionFileDownLoader?
    var offlinePermit : MainPermitDao?
    var allCategories : NSMutableArray = NSMutableArray()
    var selectedIndividual : IndividualDao?
    var inspectionByIndividual : Int = 0;
    var selectedSubVenue : SubVenueDao?
    var selectedVehicles : NSMutableArray = NSMutableArray()
    var selectedDrivers : NSMutableArray = NSMutableArray()
    var pendingZoneTasks  = NSArray()
    var PathToDelete : String?
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK:- UPLOAD LOCATION METHODS
    func locationMethod(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // locationManager.distanceFilter = 500.0
        locationManager.delegate = self
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        
        locationManager.startUpdatingLocation()
        
    }
    
    @objc func uploadTheLocation(){
        if self.userLocation != nil && Reachability.connectedToNetwork() && self.user != nil{
            self.showIndicator = 0
            print("STATUS STATUS  \(self.user.status)")
            
            
            if self.user.status != "Inactive" {
                self.locationManager.startUpdatingLocation()
                let numLat = NSNumber(value: (self.userLocation!.latitude) as Double as Double)
                let numLon = NSNumber(value: (self.userLocation!.longitude) as Double as Double)
                
                //  let stLat:String = numLat.stringValue
                if user.user_id != nil {
                let loginUrl = Constants.baseURL + "updateInspectorLocation?inspector_id=\(user.user_id!) & latitude= \(numLat.stringValue)&longitude=\(numLon.stringValue)"
                print("Loc in delegate")
                
                let downloader : DataDownloader = DataDownloader()
                downloader.delegate = self
                downloader.startDownloader(loginUrl, idn: "uploadlocation")
                }
            }
            else {
                print("Inactive")
                self.locationManager.stopUpdatingLocation()
                
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
        
        
        
    {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        self.userLocation = coord
        
        self.userDefault.set(coord.latitude, forKey: "lat")
        self.userDefault.set(coord.longitude, forKey: "lon")
        self.userDefault.synchronize()
        //print("Location updted")
        
        if self.user != nil {
            self.user.lat = coord.latitude
            self.user.lon = coord.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error)
    {
        print(error.localizedDescription)
        // Handle errors here
    }
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
        }
        else {
            
        }
        
        // App may no longer be authorized to obtain location
        //information. Check status here and respond accordingly.
        
    }
    
    
    
    
    
    
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        
        let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        print(str)
        
        if identity == "uploadlocation" {
            //print("location uploaded")
            
        }
            
        else if identity == "tasks"{
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            print(str)
            // HUD.flash(.label("Sumbitted"))
            
            
            self.pendingTasksCount = self.pendingTasksCount + 1
            
            if self.pendingTasksCount == self.pendingtasks.count {
                self.pendingTasksCount = 0
                self.processing = 0
                //                if self.pendingClosedTask?.count != 0 {
                //                self.checkInternetUpload()
                //                }
                //                else {
                //                 self.processing = 0
                //
                //               // self.timer?.invalidate()
                //                }
                //                //self.pendingTasksCount = self.pendingTasksCount + 1
                //
                
            }
            else {
                self.checkInternetUpload()
            }
        }
            //            else  if identity == "closed"{
            //            self.closedTaskCount = self.closedTaskCount + 1
            //
            //                if self.closedTaskCount == self.pendingClosedTask?.count {
            //                    if self.pendingtasks.count != 0 {
            //                        self.checkInternetUpload()
            //                    }
            //                    else {
            //                 //self.timer?.invalidate()
            //                        self.processing = 0
            //
            //                    }
            //                 self.closedTaskCount = 0
            //
            //
            //                }
            //                else {
            //
            //                self.checkInternetUpload()
            //                }
            //
            //
            //        }
        else if identity == "permissions" {
            
            
        } // end if the permissions
        
        
        
        
        
    }
    
    
    func setupProgressbar(){
        self.progressBar = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        if UIDevice.current.userInterfaceIdiom == .pad {
            progressBar.frame = CGRect(x: 0, y: 1020, width: 770, height: 100)
        }
        else {
            progressBar.frame = CGRect(x: 0, y: 561, width: 320, height: 100)
            
        }
        //CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
        //progressView.transform = transform;
        
        let btn = UIButton(type:  UIButtonType.roundedRect)
        btn.frame = CGRect(x: 900, y: 10, width: 50, height: 50)
        btn.setTitle("View", for: UIControlState())
        
        progressBar.addSubview(btn)
        
        
        let transform = CGAffineTransform(scaleX: 1.0, y: 6.0)
        
        progressBar.transform = transform
        progressBar.tintColor = UIColor.red
        
        
        UIView.animate(withDuration: 1.0 ,
                       animations: {
                        self.progressBar.transform = CGAffineTransform(scaleX: 150.5, y: 150.5)
                        
        },
                       completion: { finish in
                        UIView.animate(withDuration: 0.3, animations: {
                            let transform = CGAffineTransform(scaleX: 1.0, y: 6.0)
                            
                            self.progressBar.transform = transform
                            
                            
                            
                        })
        })
        
        
        self.window?.addSubview(progressBar)
        self.window?.bringSubview(toFront: progressBar)
        
    }
    func removeprogressbar(){
        self.progressBar.removeFromSuperview()
        
    }
    func setupFileDownload(){
        print("File download method called")
        self.progressBar = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        progressBar.frame = CGRect(x: 0, y: 1020, width: 770, height: 100)
        //CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
        //progressView.transform = transform;
        let transform = CGAffineTransform(scaleX: 1.0, y: 6.0)
        
        progressBar.transform = transform
        progressBar.tintColor = UIColor.red
        
        
        UIView.animate(withDuration: 1.0 ,
                       animations: {
                        self.progressBar.transform = CGAffineTransform(scaleX: 150.5, y: 150.5)
                        
                        
                        
                        
        },
                       completion: { finish in
                        UIView.animate(withDuration: 0.3, animations: {
                            let transform = CGAffineTransform(scaleX: 1.0, y: 6.0)
                            
                            
                            
                            self.progressBar.transform = transform
                            
                            
                            
                        })
        })
        
        
        
        fileSession = SessionFileDownLoader()
        fileSession?.del = self
        fileSession?.setupSessionDownload("")
        self.window?.addSubview(progressBar)
        self.window?.bringSubview(toFront: progressBar)
    }
    
    func updateProgress(_ progress: Float, identity: String) {
        print("Progress is \(progress)")
        self.progressBar.setProgress(progress, animated: true)
        self.fileDownloading = 1
        if progress == 1.0 {
            self.fileDownloading = 0
            
        }
    }
    
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        // print("Registered for notification")
        //application.registerForRemoteNotifications()
    }
    func setupCatg(){
        
        /*
         let listDao = ListDao()
         listDao.list_id =  "9"
         listDao.list_name = "الشركات السياحية"
         listDao.catg_id = "8"
         
         
         self.appDel.listArray.addObject(listDao)
         
         let listDao1 = ListDao()
         listDao1.list_id =  "10"
         listDao1.list_name = "الرحلات السياحية البرية"
         listDao1.catg_id = "9"
         
         self.appDel.listArray.addObject(listDao1)
         
         let listDao2 = ListDao()
         listDao2.list_id =  "11"
         listDao2.list_name = "المخيمات السياحية و تصريح الفعاليات"
         listDao2.catg_id = "10"
         self.appDel.listArray.addObject(listDao2)
         
         
         let listDao3 = ListDao()
         listDao3.list_id =  "13"
         listDao3.list_name = "الارشاد السياحي"
         listDao3.catg_id = "12"
         self.appDel.listArray.addObject(listDao3)
         
         let listDao4 = ListDao()
         listDao4.list_id =  "14"
         listDao4.list_name = "تفتيش الفعاليات"
         listDao4.catg_id = "13"
         self.appDel.listArray.addObject(listDao4)
         
         let listDao5 = ListDao()
         listDao5.list_id =  "15"
         listDao5.list_name = "بيوت العطلات"
         listDao5.catg_id = "14"
         self.appDel.listArray.addObject(listDao5)
         
         let listDao6 = CategoriesDao()
         listDao6.catg_id = "17"
         listDao6.list_id =  "18"
         listDao6.catg_name = "الدرهم السياحي"
         self.appDel.listArray.addObject(listDao6)
         
         */
        
        self.allCategories = NSMutableArray()
        
        let categoryDao1 = CompanyCategoryDao()
        categoryDao1.category_id = "8"
        categoryDao1.list_id =  "9"
        categoryDao1.category_name = "الشركات السياحية"
        self.allCategories.add(categoryDao1)
        
        
        let categoryDao7 = CompanyCategoryDao()
        
        categoryDao7.category_id = "12"
        categoryDao7.list_id =  "13"
        categoryDao7.category_name = "الارشاد السياحي"
        self.allCategories.add(categoryDao7)
        
        
        
        let categoryDao2 = CompanyCategoryDao()
        categoryDao2.category_id = "9"
        categoryDao2.list_id =  "10"
        categoryDao2.category_name = "الرحلات السياحية البرية"
        self.allCategories.add(categoryDao2)
        
        
        let categoryDao3 = CompanyCategoryDao()
        categoryDao3.category_id = "10"
        categoryDao3.list_id = "11"
        categoryDao3.category_name = "المخيمات السياحية و تصريح الفعاليات"
        self.allCategories.add(categoryDao3)
        
        
        let categoryDao4 = CompanyCategoryDao()
        categoryDao4.category_id = "13"
        categoryDao4.list_id = "14"
        categoryDao4.category_name = "تفتيش الفعاليات"
        self.allCategories.add(categoryDao4)
        
        
        let categoryDao11 = CompanyCategoryDao()
        categoryDao11.category_id = "14"
        categoryDao11.list_id = "15"
        categoryDao11.category_name = "بيوت العطلات"
        self.allCategories.add(categoryDao11)
        
        
        
        let categoryDao5 = CompanyCategoryDao()
        categoryDao5.category_id = "15"
        categoryDao5.list_id = "16"
        categoryDao5.category_name = "معايير التصنيف لفئة الفخمة"
        self.allCategories.add(categoryDao5)
        
        
        let categoryDao10 = CompanyCategoryDao()
        categoryDao10.category_id = "16"
        categoryDao10.list_id = "17"
        categoryDao10.category_name = "معايير التصنيف لفئة السياحية"
        self.allCategories.add(categoryDao10)
        
        
        
        
       
        let categoryDao6 = CompanyCategoryDao()
        categoryDao6.category_id = "17"
        categoryDao6.list_id = "18"
        categoryDao6.category_name = "الدرهم السياحي"
        self.allCategories.add(categoryDao6)
        
        
        let categoryDao99 = CompanyCategoryDao()
        
        //  categoryDao99.catg_id = "19"
        // categoryDao99.list_id = "20"
        
        categoryDao99.category_id = "18"
        categoryDao99.list_id = "19"
        
        categoryDao99.category_name = "مخالفات ترخيص وتصنيف"
        self.allCategories.add(categoryDao99)
        
        
        
        
        
        let categoryDao999 = CompanyCategoryDao()
        categoryDao999.category_id = "20"
        categoryDao999.list_id = "21"
        categoryDao999.category_name = "الرقابة على فعاليات الاعمال وغيرها"
        self.allCategories.add(categoryDao999)
        
        let categoryDao9199 = CompanyCategoryDao()
        categoryDao9199.category_id = "21"
        categoryDao9199.list_id = "22"
        categoryDao9199.category_name = "DST Check List"
          self.allCategories.add(categoryDao9199)
        
        let categoryDao9299 = CompanyCategoryDao()
        categoryDao9299.category_id = "22"
        categoryDao9299.list_id = "23"
        categoryDao9299.category_name = "بلدية دبي"
        self.allCategories.add(categoryDao9299)
        
       let categoryDao92999 = CompanyCategoryDao()
              categoryDao92999.category_id = "23"
              categoryDao92999.list_id = "24"
              categoryDao92999.category_name = "COVID-19"
            self.allCategories.add(categoryDao92999)
    }
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //  Parse.setApplicationId("T94n0xReQGGt4JKKo2BbVTl8Yqjg98XUykpXmMJK",
        //     clientKey: "bcpscJOla5QNEd9rQaeFA6YnaZ1PoyYpNEtJL394")
        // Register for Push Notitications
        
        if self.hasJailbreak() {

            exit(0)
        }
        
        FirebaseApp.configure()
        
        self.locationMethod()
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        
        //Fabric.with([Crashlytics.self])
        //Fabric.with([Appsee.self])
        self.setupCatg()
        self.totalSpendSecond = 0
        // [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
        //UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        // NSUserDefaults.standardUserDefaults().setValue(@(NO), forKey: <#T##String#>)
        //UINavigationBar.appearance().shadowImage = UIImage()
        
        application.isStatusBarHidden = true
        self.locationTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(AppDelegate.uploadTheLocation), userInfo: nil, repeats: true)
        if application.applicationState != UIApplicationState.background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.responds(to: #selector(getter: UIApplication.backgroundRefreshStatus))
            let oldPushHandlerOnly = !self.responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsKey.remoteNotification] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpened(launchOptions: launchOptions)
            }
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(AppDelegate.checkTimer), userInfo: nil, repeats: true)
            }
        }
        
        
        //        let navigationBarAppearace = UINavigationBar.appearance()
        //        //let font = UIFont(name: "DroidArabicKufi", size: 15.0)
        //        let font = UIFont(name: "Dubai", size: 15.0)
        //
        //        if let font = font {
        //            navigationBarAppearace.titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1.0)];
        //        }
        //
        
        let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // Override point for customization after application launch.
        let installation = PFInstallation.current()
        //installation.badge = 0
        //self.keepCheckingInternet()
        //self.uploadMedia("549")
        if var lang = userDefault.integer(forKey: "lang") as? Int {
            print("Inside if \(lang)")
            if lang == 0 {
                lang = 1
            }
            self.selectedLanguage = lang
        }
        else {
            self.selectedLanguage = 2
        }
        
        self.setupVPNTimer()
        print("\(self.selectedLanguage) selected")
        if userDefaults.object(forKey: "username") != nil {
            let newUser = UserDao()
            newUser.user_id = self.userDefaults.object(forKey: "user_id") as! String
            newUser.username = self.userDefaults.object(forKey: "username") as! String
            newUser.firstname = self.userDefaults.object(forKey: "firstname") as! String
            //    newUser.lastname = self.userDefaults.objectForKey("lastname") as! String
            newUser.categories = self.userDefaults.object(forKey: "categories") as? String
            newUser.status = self.userDefaults.object(forKey: "status") as? String
            newUser.job_title = self.userDefaults.object(forKey: "job_title") as? String
            newUser.email = self.userDefaults.object(forKey: "email") as? String
            newUser.shift = self.userDefaults.object(forKey: "shift") as? String
            newUser.contactno = self.userDefaults.object(forKey: "contactno") as? String
            newUser.hosName = self.userDefaults.object(forKey: "hosname") as? String
            newUser.hosMobileNo = self.userDefaults.object(forKey: "hosmobile") as? String
            newUser.employee_id = self.userDefaults.object(forKey: "employee_id") as? String
            newUser.inactive_notes = self.userDefaults.object(forKey: "inactive_notes") as? String
            newUser.categories = self.userDefaults.object(forKey: "categories") as? String
            
            
            user = newUser
            var storyboard : UIStoryboard?
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                storyboard = UIStoryboard(name: "Main", bundle: nil)
            }
            else {
                storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
                
            }
            let initialViewController = storyboard!.instantiateViewController(withIdentifier: "cnt_reveal") as! SWRevealViewController
            
            self.window?.rootViewController = initialViewController
            
            
            
            
            
        } // end of the if
        else
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let initialViewController = storyboard.instantiateInitialViewController()
                self.window?.rootViewController = initialViewController
                
                
                
            }
            else {
                let storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
                
                let initialViewController = storyboard.instantiateInitialViewController()
                self.window?.rootViewController = initialViewController
                
                
        }
        // self.setupFileDownload()
        
        
        return true
    }
    
    func setupVPNTimer(){
        if self.userDefault.object(forKey: "vpn_username") != nil {
            
            let vpn = VPNDao()
            vpn.VPN_USER = self.userDefault.value(forKey: "vpn_username") as! String
            print("VPN USER" + vpn.VPN_USER)
            vpn.VPN_PASSWORD = self.userDefault.value(forKey: "vpn_password") as! String
            vpn.VPN_SERVER = self.userDefault.value(forKey: "vpn_server") as! String
            vpn.SERVER_IDENTIFIER = self.userDefault.value(forKey: "vpn_group") as! String
            vpn.LOCAL_IDENTIFIER = self.userDefault.value(forKey: "vpn_group") as! String
            vpn.SHARED_SECRET = self.userDefault.value(forKey: "vpn_sharedsecret") as! String
            
            
            
            self.vpnManager.startVPN()
            self.vpnManager.startVPNTimer(vpn)
        }
        else {
            print("VPN USERNAME IS NILL")
        }
    }
    
    @objc func checkTimer(){
        if self.processing == 1 {
            print("Processing \(processing)")
        }
        else {
            self.keepCheckingInternet()
        }
    }
    
    func keepCheckingInternet(){
        userDefault = UserDefaults.standard
        pendingTasksCount = 0
        self.closedTaskCount = 0
        let database = DatabaseManager()
        self.pendingtasks = NSMutableArray()
        self.pendingClosedTask = NSMutableArray()
        
        if self.user != nil {
            self.pendingtasks = database.getAllUnSubmittedTasks()
        }
        else {
            return
        }
        self.checkInternetUpload()
    }
    
    
    func failed(_ identity: String)  {
        print("Failed")
        DispatchQueue.main.async {
            HUD.flash(.error)
            
            
        }
        self.processing = 0
    }
    func submittedTask(_ task_id: String) {
        let tempMutableAray = NSMutableArray(array: self.pendingtasks)
        tempMutableAray.remove(task_id)
        let tempStr = tempMutableAray.componentsJoined(by: ":")
        self.userDefaults.set(tempStr, forKey: "tasks")
        print("task Submitted")
    }
    
    func checkInternetUpload(){
        
        if Reachability.connectedToNetwork() {
            
            if self.pendingtasks.count > 0 {
                
                self.processing = 1
                // PKHUD.sharedHUD.show()
                
                DispatchQueue.main.async {
                    HUD.flash(.labeledProgress(title: "", subtitle: "Submitting Task(\(self.pendingTasksCount+1)/\(self.pendingtasks.count))"), delay: 3.0){  _ in
                        
                        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                        
                    }
                }
                let offlineTask = self.pendingtasks.object(at: self.pendingTasksCount) as! TaskResultsDao
                let keystr = offlineTask.task_id
                print("Offline Task Id \(keystr)")
                
                let downloader  = DataDownloader()
                downloader.delegate = self
                
                if  keystr != nil {
                    let request = Data(offlineTask.json_string!.utf8)
                    let task = TaskDao()
                    task.task_id = keystr
                    self.taskDao = task
                    if offlineTask.type == 3 { // IND
                        downloader.task_id = keystr!
                        downloader.iden = "tasks"
                        downloader.startSendingPostOffline(request , url:URL(string: Constants.saveIndServay)!,ide: "tasks", keyStr: keystr!)
                        let array = (offlineTask.unique_id! as NSString).components(separatedBy: ",")
                        if array.count > 1 {
                            self.uploadMedia(array[0],identifier: array[1])
                        }
                    } // END OF THE INDIVIDUAL
                        
                        
                    else if offlineTask.type == 4 && offlineTask.task_id != nil &&   offlineTask.json_string != nil
                        // CLOSE TASKS
                    {
                        downloader.iden = "tasks"
                        downloader.setupCloseTaskGetRequest(task_id: offlineTask.task_id!, requestStr: offlineTask.json_string!,type : 4)
                        
                    }
                        
                        
                    else if offlineTask.type == 1 { // GENERAL TASKS
                        downloader.iden = "tasks"
                        downloader.task_id = keystr!
                        downloader.startSendingPostOffline(request , url:URL(string: Constants.saveServay)!,ide: "tasks", keyStr: keystr!)
                        print("Sending Request on \(Constants.saveServay)")
                        let array = (offlineTask.unique_id! as NSString).components(separatedBy: ",")
                        print("Task id \(downloader.task_id) total media \(array.count) array \(array)")
                        
                        if array.count > 1 {
                            self.uploadMedia(array[0],identifier: array[1])
                        }
                    }
                        
                    else if offlineTask.type == 5 { // ZONE
                        downloader.iden = "tasks"
                        downloader.setupCloseTaskGetRequest(task_id: offlineTask.task_id!, requestStr: offlineTask.json_string!,type : 5)
                        
                    }
                    else if offlineTask.type == 9 {
                        downloader.iden = "tasks"
                        downloader.task_id = keystr!
                        downloader.startSendingPostOffline(request , url:URL(string: Constants.saveOfflinePassedInspections)!,ide: "tasks", keyStr: keystr!)
                        print("Sending Request on \(Constants.saveOfflinePassedInspections)")
                        let array = (offlineTask.unique_id! as NSString).components(separatedBy: ",")
                        if array.count > 1 {
                            self.uploadMedia(array[0],identifier: array[1])
                        }
                    }
                    else if offlineTask.type == 12 {
                        downloader.iden = "tasks"
                        downloader.task_id = keystr!
                        downloader.startSendingPostOffline(request , url:URL(string: Constants.saveOfflineCloseTasks)!,ide: "tasks", keyStr: keystr!)
                        print("Sending Request on \(Constants.saveOfflinePassedInspections)")
                        
                    }
                    
                    
                    
                }
                
            }
            //  }
            //            let closedTask = self.userDefault.object(forKey: "closed") as? NSArray
            //
            //           // print("Closed array \(closedTask?.count)")
            //            if closedTask != nil {
            //                  var errorStr : Int = 0
            //              // for var a = 0 ; a < closedTask!.count ; a += 1 {
            //                for a in 0 ..< closedTask!.count {
            //
            //
            ////                if self.pendingClosedTask?.count > 0 && self.closedTaskCount < self.pendingClosedTask?.count {
            ////                    processing = 1
            ////
            //                let task_id = closedTask?.object(at: a) as? String
            //                    print("Closed Task id \(task_id)")
            //                    if task_id != nil {
            //
            //                        print(task_id! + ",closed")
            //
            //                       let request = self.userDefault.object(forKey: task_id! + ",closed") as? String
            //                        if request != nil {
            ////                        let downloader  = DataDownloader()
            ////                        downloader.delegate = self
            ////                        print("closing task with task id \(task_id)")
            //                    //  downloader.setOfflineGetRequest(request!, idn: "closed")
            ////                        self.userDefault.removeObjectForKey(task_id! + ",closed")
            //                            //
            //                            var response: URLResponse?
            //                            var error: NSError?
            //                            let urlstr1 = request!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            //                            let ourl : URL =  URL(string: urlstr1 as! String)!
            //                            let  urlRequest : NSMutableURLRequest = NSMutableURLRequest (url:ourl)
            //                            urlRequest.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
            //
            //
            //                            do {
            //                                let data : Data? = try NSURLConnection.sendSynchronousRequest(urlRequest as URLRequest, returning: &response)
            //                                if data != nil {
            //
            //                                    self.userDefault.removeObject(forKey: task_id! + ",closed")
            //                                }
            //                            } catch (let e) {
            //                                errorStr = 1
            //                                print(e)
            //                            }
            //
            //                        }
            //
            //
            //                //    }// end of the task_id
            //                }
            //
            //            }// end of the for loop
            //                if errorStr != 1 {
            //                self.userDefault.removeObject(forKey: "closed")
            //                }
            //            }
            
            
            // self.userDefaults.removeObjectForKey("tasks")
            
            let permissions = self.userDefault.object(forKey: "permissions") as? NSMutableArray
            if permissions != nil {
                for  a in  0 ..< permissions!.count  {
                    let request = permissions?.object(at: a) as? String
                    if request != nil {
                        let downloader  = DataDownloader()
                        downloader.delegate = self
                        
                        downloader.setOfflineGetRequest(request!, idn: "permissions")
                        
                        
                    } // end of checking nil
                    
                }// end of the for loop
                self.userDefault.removeObject(forKey: "permissions")
            }
            
            let companies = self.userDefault.object(forKey: "companies") as? NSMutableArray
            if companies != nil {
                for  b in 0 ..< companies!.count {
                    let companyUrl = companies?.object(at: b) as? String
                    if companyUrl != nil {
                        let downloader  = DataDownloader()
                        downloader.delegate = self
                        
                        downloader.setOfflineGetRequest(companyUrl!, idn: "company")
                        
                    } // end of the companyURL
                    
                } /// end of the companies array
                
                self.userDefault.removeObject(forKey: "companies")
            }
            
            
            
            
            
            //            let zoneTask = self.userDefault.object(forKey: "zone") as? NSArray
            //
            //            if zoneTask != nil {
            //                var errorStr : Int = 0
            //                for a in 0  ..< zoneTask!.count  {
            //
            //                    let task_id = zoneTask?.object(at: a) as? String
            //                    print("zone Task id \(task_id)")
            //                    if task_id != nil {
            //                        print(task_id! + ",zone")
            //
            //                        let request = self.userDefault.object(forKey: task_id! + ",zone") as? String
            //                        if request != nil {
            //
            //                            var response: URLResponse?
            //                            //var error: NSError?
            //                            let urlstr1 =  request!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            //                            let ourl : URL =  URL(string: urlstr1 as! String)!
            //                            var  urlRequest : URLRequest = URLRequest (url:ourl)
            //                            urlRequest.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
            //
            //
            //                            do {
            //                                print("Sending Zone request")
            //                                let data : Data? = try NSURLConnection.sendSynchronousRequest(urlRequest, returning: &response)
            //                                if data != nil {
            //                                    let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //                                    print("zone response \(str)")
            //                                    self.userDefault.removeObject(forKey: task_id! + ",zone")
            //                                    errorStr = 0
            //                                }
            //                                else {
            //                                print("Zone data is nil")
            //                                }
            //                            } catch (let e) {
            //                                errorStr = 1
            //                                print("Error in zone \(e)")
            //                            }
            //
            //                        }
            //
            //
            //                        //    }// end of the task_id
            //                    }
            //
            //                }// end of the for loop
            //                if errorStr == 0 {
            //                self.userDefault.removeObject(forKey: "zone")
            //                }
            //            }
            
            
            
            
            self.userDefaults.synchronize()
            
            
            
            
        }
    }
    func uploadMedia(_ task_id : String , identifier : String){
        print("Uploading for task \(task_id)")
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: NSString = paths[0] as NSString
        let dataPath = documentsDirectory.appendingPathComponent("\(task_id),\(identifier)")
        print("Data Path \(dataPath)")
        
        if (FileManager.default.fileExists(atPath: dataPath)) {
            let audioPath = documentsDirectory.appendingPathComponent("\(task_id),\(identifier)/audio")
            if FileManager.default.fileExists(atPath: audioPath) {
                var error : NSError?
                
                let array: [AnyObject]?
                do {
                    array = try FileManager.default.contentsOfDirectory(atPath: audioPath) as [AnyObject]
                } catch let error1 as NSError {
                    error = error1
                    array = nil
                }
                for pathStr in array as! [String]{
                    let fullPath = "\(audioPath)/\(pathStr)"
                    print(fullPath)
                    let data = try? Data(contentsOf: URL(fileURLWithPath: fullPath))
                    let q_id = (pathStr as NSString).deletingPathExtension
                    print("Q_ID \(q_id)")
                    offlineManager.pathToDelete = fullPath
                    offlineManager.createMultipart(pathStr, imageData: data, type: "audio", q_id: q_id ,task_id: task_id ,identifier: identifier)
                    var error : NSError?
                    /*
                    do {
                        try FileManager.default.removeItem(atPath: fullPath)
                    } catch let error1 as NSError {
                        error = error1
                    }
                    if error !=  nil {
                        print(error)
                    }
                   */
                    
 
                }
            }
            
            
            
            let imagePath = documentsDirectory.appendingPathComponent("\(task_id),\(identifier)/image")
            print("Image Path \(imagePath)")
            
            if FileManager.default.fileExists(atPath: audioPath) {
                var error : NSError?
                
                let array: [String]?
                do {
                    array = try FileManager.default.contentsOfDirectory(atPath: imagePath)
                } catch let error1 as NSError {
                    error = error1
                    array = nil
                }
                for pathStr in array as! [String]{
                    let fullPath = "\(imagePath)/\(pathStr)"
                    print(fullPath)
                    let data = try? Data(contentsOf: URL(fileURLWithPath: fullPath))
                    let q_id = (pathStr as NSString).deletingPathExtension
                    print("Q_ID \(q_id)")
                                       offlineManager.pathToDelete = fullPath
                    offlineManager.createMultipart(pathStr, imageData: data, type: "image", q_id: q_id.components(separatedBy: ",")[0] ,task_id: task_id ,identifier: identifier)
                    var error : NSError?
                    
//                    do {
//
//                        try FileManager.default.removeItem(atPath: fullPath)
//                    } catch let error1 as NSError {
//                        error = error1
//                    }
//                    if error !=  nil {
//                        print(error)
//                    }
                }
                
                
            }
            
        }
        else {
            print("file does not exits at \(dataPath)")
        }
        
        // self.uploadTasktToVMS(task_id)
        
    }
    
    func uploadTasktToVMS(_ task_id : String){
        let urlStr = Constants.baseURL + "uploadOfflineMediaToVMS?task_id=\(task_id)"
        print(urlStr)
        
        let u = URL(string: urlStr)!
        var request1 = URLRequest(url: u)
        
        
        
        request1.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        
        
        //  let returnData = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        // let str = NSString(data: returnData! , encoding: NSUTF8StringEncoding)
        
        //print(str)
        NSURLConnection.sendAsynchronousRequest(request1, queue: OperationQueue.main, completionHandler:{(response:URLResponse?, responseData:Data?, error: Error?)  in
            
            
        })
        
        
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // print("Device Registered")
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        //print("Device Token:", tokenString)
        
        self.apple_deviceToken = tokenString
        
        self.userDefaults.setValue(self.apple_deviceToken, forKey: "deviceToken")
        self.userDefaults.synchronize()
        
        //let installation = PFInstallation.currentInstallation()
        //installation.setDeviceTokenFromData(deviceToken)
        //installation.saveInBackground()
        //print("Device Registered\(deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //        if error.code == 3010 {
        //            print("Push notifications are not supported in the iOS Simulator.")
        //        } else {
        //            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        //        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        PFPush.handle(userInfo)
        if application.applicationState == UIApplicationState.inactive {
            PFAnalytics.trackAppOpened(withRemoteNotificationPayload: userInfo)
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        if self.fileSession != nil {
            //            if self.fileSession!.progress == 1.0 {
            //            print("Progress completed")
            //            }
            
            self.progressBar.setProgress((self.fileSession?.progress)!, animated: true)
            print((self.fileSession?.progress)!)
            if self.fileSession!.progress < 1.0 {
                fileSession?.downloadTask.resume()
            }
        }
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        //       var installation = PFInstallation.currentInstallation()
        //      installation.badge = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appninja.ADTourism" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "ADTourism", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("ADTourism.sqlite")
        // print(url)
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                            NSMigratePersistentStoresAutomaticallyOption : true]
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
    func deactiveTask(_ task_id : String){
        let urlStr = Constants.baseURL + "changeTaskStatus?task_id=\(task_id)"
        print(urlStr)
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {
                (response: URLResponse?, data: Data?, error: Error?) -> Void in
                print("tasks deactived", terminator: "")
            }
        }
    }
    
    
    func hasJailbreak() -> Bool {
        #if arch(i386) || arch(x86_64)
        print("Simulator")
        return false
        #else
        return FileManager.default.fileExists(atPath: "/private/var/lib/apt")
        #endif
    } // end of the if
    
    
    
    
}

