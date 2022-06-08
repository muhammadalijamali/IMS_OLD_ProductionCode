//
//  TaskHistoryViewController.swift
//  ADTourism
//
//  Created by Administrator on 9/22/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit
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


class TaskHistoryViewController: UIViewController , UITableViewDelegate ,HistoryNotesDelegate,UITableViewDataSource , MainJsonDelegate , DateSelectorDelegate,UIPopoverPresentationControllerDelegate,UIAdaptivePresentationControllerDelegate,HistoryFilterDelegate,InspectorSelectedDelegate{
    var localisation : Localisation!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var startDatelbl: UILabel!
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var secondText: UITextField!
    @IBOutlet weak var firstText: UITextField!
    
    let formater : DateFormatter = DateFormatter()
    var historyDao : TaskHistoryDao?
    var currentArea : AreaDao?
    var currentZone : ZoneDao?
    
    
    var totalRecords : Int = 15
    var currentCounter : Int = 15
    var increment : Int = 15
    var START_COUNTER : Int = 0
    
    let limit : Int = 20
    var selectedAssignmentStr : String?
    var taskToEdit : TaskHistoryDao?
    var databaseManager = DatabaseManager()
    
     func clearFilter() {
        self.currentArea = nil
        self.currentZone = nil
        self.firstDate = self.yesterDay()
        self.secondDate = Date()
        self.allCompletedTasks = NSMutableArray()
        self.startBtn.setTitle(formater.string(from: self.yesterDay()), for: UIControlState())
        self.endBtn.setTitle(formater.string(from: Date()), for: UIControlState())
        
        totalRecords  = 15
        currentCounter = 15
        increment  = 15
        START_COUNTER  = 0
        if Reachability.connectedToNetwork() {
            
            self.setupDownloader("report")
        }
        else {
            let alert = UIAlertController(title: "", message: localisation.localizedString(key: "general.checkinternet"), preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }

    }
    @IBAction func clearMethod(_ sender: UIButton) {
    self.currentArea = nil
    self.currentZone = nil
        self.firstDate = self.yesterDay()
        self.secondDate = Date()
        self.allCompletedTasks = NSMutableArray()
        self.startBtn.setTitle(formater.string(from: self.yesterDay()), for: UIControlState())
        self.endBtn.setTitle(formater.string(from: Date()), for: UIControlState())
    
        totalRecords  = 15
         currentCounter = 15
         increment  = 15
         START_COUNTER  = 0
        if Reachability.connectedToNetwork() {
            
            self.setupDownloader("report")
        }
        else {
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
    
    func areaCodeDetected(_ area: AreaDao) {
        if area.area_id == "0" {
        self.currentArea = nil
        }
        else {
        self.currentArea = area
        
        }
        self.allCompletedTasks = NSMutableArray()
        
        self.setupDownloader("report")
        
        
    }

    func historyfilterSelected(_ filterArea: AreaDao?, zoneDao: ZoneDao?) {
    
    self.allCompletedTasks = NSMutableArray()

        totalRecords  = 15
        currentCounter  = 15
        increment  = 15
        START_COUNTER  = 0
       
        self.currentArea = filterArea
    self.currentZone = zoneDao
    self.setupDownloader("")
    }
    
    
    
    @IBAction func areaMethod(_ sender: UIButton) {
    
        if Reachability.isConnectedNetwork() {
           
            
            let popController = storyboard!.instantiateViewController(withIdentifier: "cnt_historyfilterpopup") as! HistoryFilterPopupViewController
            popController.view.backgroundColor = UIColor().withAlphaComponent(1.0)
            popController.del = self
            popController.fromHistory = 1
            
            
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
           // popController.modalInPopover = true
            
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
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
    
    @IBAction func searchMethod(_ sender: UIButton) {
        totalRecords  = 15
        currentCounter = 15
        increment  = 15
        START_COUNTER  = 0

        self.setupDownloaderWithDate(self.filter_task_type, startDate: formater.string(from: self.firstDate!), endDate: formater.string(from: self.secondDate!))
        self.allCompletedTasks = NSMutableArray()
        
    
    }
    

    
    var filter_task_type : String = "all"  // 0  for all 1 for closed // 2 for completed task
     var SEARCH_BY : Int = 0
    
    @IBOutlet weak var selectTypeBtn: ADButton!
    
    @IBOutlet weak var typelbl: UILabel!
    
    func resetCounterData(){
        totalRecords  = 15
        currentCounter = 15
        increment = 15
         START_COUNTER = 0
        self.allCompletedTasks = NSMutableArray()
        
        
        
    }
    
    @IBAction func selectTypeMethod(_ sender: AnyObject) {
     let alert =  SCLAlertView()
        alert.showCloseButton = false
        
        alert.addButton("All Tasks", action: {
           
        self.filter_task_type = "all"
        self.resetCounterData()
         self.setupDownloaderWithDate(self.filter_task_type, startDate: self.startBtn.title(for: UIControlState())!, endDate: self.endBtn.title(for: UIControlState())!)
            
            
            self.allCompletedTasks = NSMutableArray()
           
            
            
            
        })
        alert.addButton("Closed Tasks", action: {
           
            self.filter_task_type = "closed"
            self.resetCounterData()
             self.setupDownloaderWithDate(self.filter_task_type, startDate: self.startBtn.title(for: UIControlState())!, endDate: self.endBtn.title(for: UIControlState())!)
       
           
            
            
        })
        alert.addButton("Completed Tasks", action: {
           
            self.filter_task_type = "completed"
            self.resetCounterData()
             self.setupDownloaderWithDate(self.filter_task_type, startDate: self.startBtn.title(for: UIControlState())!, endDate: self.endBtn.title(for: UIControlState())!)
        
            
            
            
            
        })
        
        alert.addButton(localisation.localizedString(key: "questions.cancel"),tag:250 , action: {
           
            
        })
        
        
        alert.showInfo(localisation.localizedString(key: "history.selecttype"), subTitle: "")
        
        

        
    }
    
    @IBOutlet weak var noRecordsFoundlbl: UILabel!
    @IBOutlet weak var endDatelbl: UILabel!
    var firstDate : Date?
    var secondDate : Date?
    var whichDate : Int = 0 // 0 first date 1 second data
    var reportType : String = "report"
    
    
    @IBOutlet weak var history_title: UILabel!
    
    @IBOutlet weak var startBtn: ADButton!
    
    
    @IBAction func startBtnMethod(_ sender: AnyObject) {
    
    }
    @IBAction func endBtnMethod(_ sender: AnyObject) {
    }
    
    
    
    
    @IBOutlet weak var endBtn: ADButton!
    
    @IBOutlet weak var sideMenuBtn: UIButton!
   
    @IBAction func sideMenuMethod(_ sender: AnyObject) {
    self.revealViewController().revealToggle(animated: true)
    }
    
    
    
    @IBAction func startDate(_ sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let menuViewController: DateSelectorViewController = storyboard.instantiateViewController(withIdentifier: "cnt_date") as! DateSelectorViewController
        menuViewController.delegate = self
       menuViewController.button = (sender as! ADButton)
        self.whichDate = 0
        self.appDel.calenderHisyoty = 1
        
        
        
        menuViewController.modalPresentationStyle = .popover
        //menuViewController.preferredContentSize = CGSizeMake(50, 100)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .any
        // popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = (sender as! UIButton)
        
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
    // end of the onMyWay
    
    func setupOnMyWay(){
    
    }
    @IBAction func endDate(_ sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let menuViewController: DateSelectorViewController = storyboard.instantiateViewController(withIdentifier: "cnt_date") as! DateSelectorViewController
        menuViewController.delegate = self
        menuViewController.button = (sender as! ADButton)
        self.whichDate = 1
        self.appDel.calenderHisyoty = 1
        
        
        
        menuViewController.modalPresentationStyle = .popover
        //menuViewController.preferredContentSize = CGSizeMake(50, 100)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .any
        // popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = (sender as! UIButton)
        
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
    func dateDeletced(_ date: Date, button: ADButton) {
        
        currentCounter = 15
        increment  = 15
        START_COUNTER  = 0

        let formater : DateFormatter = DateFormatter()
        formater.dateFormat = "YYYY-MM-dd"
        formater.locale = Locale(identifier: "en_US")


        if self.whichDate == 0 {
            self.firstDate = date
            self.startBtn.setTitle(formater.string(from: self.firstDate!), for: UIControlState())
            
         //   self.firstText.text = formater.stringFromDate(date)
//            if self.firstDate != nil && self.secondDate != nil {
//                self.allCompletedTasks = NSMutableArray()
//                
//                self.setupDownloaderWithDate(self.filter_task_type, startDate: formater.stringFromDate(self.firstDate!), endDate: formater.stringFromDate(self.secondDate!))
//                
//                
//            } // end of the if
        }
        else {
        //    self.secondText.text = formater.stringFromDate(date)
          self.endBtn.setTitle(formater.string(from: date), for:UIControlState())
           self.secondDate = date
            
            if self.firstDate != nil {
               
                
            }
          //  self.setupDownloaderWithDate(self.ty, startDate: <#String#>, endDate: <#String#>)
        }
     }
    @IBAction func typeBtnMethod(_ sender: AnyObject) {
    
    let alert = UIAlertController(title: localisation.localizedString(key: "history.selecttype"), message: "", preferredStyle: UIAlertControllerStyle.alert)
        let action1 = UIAlertAction(title: localisation.localizedString(key: "finalise.violations"), style: UIAlertActionStyle.default, handler:{ Void in
       
          self.reportType = "violations"
           // self.setupDownloader("violations")
            self.typeBtn.setTitle(self.localisation.localizedString(key: "finalise.violations"), for: UIControlState())
            
            
        })
       
//        let action2 = UIAlertAction(title: "Warnings", style: UIAlertActionStyle.Default, handler:{
//           
//            self.reportType = "warning"
//            self.typeBtn.setTitle("Report : Warning", forState: UIControlState.Normal)
//            
//            self.setupDownloader("warning")
//            
//        })
        
        let action3 = UIAlertAction(title: localisation.localizedString(key: "history.selectall"), style: UIAlertActionStyle.default, handler:{ Void in
           
            self.reportType = "report"
            self.typeBtn.setTitle(self.localisation.localizedString(key: "history.selectall"), for: UIControlState())
            
            self.setupDownloader("report")
            
            
        })
        
        
        let action4 = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.cancel, handler:nil)
        
        
        
        alert.addAction(action1)
        //alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
       // self.firstText.text = ""
        //self.secondText.text = ""
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBOutlet weak var typeBtn: ADButton!
    @IBOutlet weak var dataTable: UITableView!
    var allCompletedTasks : NSMutableArray = NSMutableArray()
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var allHistoryTasks : NSMutableArray!
    
   
    

    override func viewWillAppear(_ animated: Bool) {
        self.appDel.showIndicator =  1
        self.appDel.fromHistoryToResult = 0
        self.navigationController?.isNavigationBarHidden = true
        self.appDel.taskDao = nil
        if self.view.superview != nil {
        self.view.superview!.layer.cornerRadius = 0;
        }
        
    }
    //MARK:-  GET YESTERDAY'S DATE
    func yesterDay() -> Date {
        
        let today: Date = Date()
        
        let daysToAdd:Int = -1
        
        // Set up date components
        var dateComponents: DateComponents = DateComponents()
        dateComponents.day = daysToAdd
        
        // Create a calendar
        let gregorianCalendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let yesterDayDate: Date = (gregorianCalendar as NSCalendar).date(byAdding: dateComponents, to: today, options:NSCalendar.Options(rawValue: 0))!
        
        return yesterDayDate
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
        
        if Reachability.connectedToNetwork() {
            
            self.setupDownloader("report")
        }
        else {
            let alert = UIAlertController(title: "", message: localisation.localizedString(key: "general.checkinternet"), preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        

        
        
        //self.tit
        self.typeBtn.setTitle(localisation.localizedString(key: "history.selecttype"), for: UIControlState())
        
         self.typelbl.text = localisation.localizedString(key: "history.type")
        
        self.history_title.text = localisation.localizedString(key: "history.taskhistory")
        
        
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }

        formater.dateFormat = "YYYY-MM-dd"
        formater.locale = Locale(identifier: "en_US")
         self.appDel.showIndicator = 1
        if UIDevice.current.userInterfaceIdiom == .pad {
        self.startView.backgroundColor = UIColor(patternImage: UIImage(named: "tab_text")!)
        self.endView.backgroundColor = UIColor(patternImage: UIImage(named: "tab_text")!)
       // self.typeView.backgroundColor = UIColor(patternImage: UIImage(named: "tab_text")!)
        self.dataTable.backgroundColor = UIColor(patternImage: UIImage(named: "tablebg")!)
        }
        //self.dataTable.contentOffset = CGPointMake(0, 200)
        self.dataTable.setContentOffset(CGPoint(x: 0, y: 64), animated: true)
        self.startDatelbl.text = localisation.localizedString(key: "tasks.startdate")
        self.endDatelbl.text = localisation.localizedString(key: "tasks.enddate")
       
        
            
        

        // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "taskbg")!)
        
     //   self.firstText.attributedPlaceholder = NSAttributedString(string:localisation.localizedString(key: "tasks.startdate"),
         //   attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
       // self.secondText.attributedPlaceholder = NSAttributedString(string:localisation.localizedString(key: "tasks.enddate"),
        //    attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        
        self.selectTypeBtn.setTitle(localisation.localizedString(key: "history.selecttype"), for: UIControlState())
        self.startBtn.setTitle(localisation.localizedString(key: "tasks.startdate"), for: UIControlState())
        self.endBtn.setTitle(localisation.localizedString(key: "tasks.enddate"), for: UIControlState())
        
        
//        self.firstText.attributedPlaceholder = NSAttributedString(string:"تاريخ البدء",
//            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
//        
   //     self.secondText.attributedPlaceholder = NSAttributedString(string:"تاريخ الانتهاء",
    //        attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        
        self.navigationController?.isNavigationBarHidden = true
        self.title = ""
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        self.firstDate = self.yesterDay()
        self.secondDate = Date()
        
        self.startBtn.setTitle(formater.string(from: self.yesterDay()), for: UIControlState())
        self.endBtn.setTitle(formater.string(from: Date()), for: UIControlState())

        
      //  self.noRecordsFoundlbl.hidden = true

        
        // Do any additional setup after loading the view.
    }
    func setupDownloader(_ type : String){
     
        self.appDel.showIndicator = 1
        self.SEARCH_BY = 1
        
        
        if self.currentArea == nil && self.currentZone == nil{
        let loginUrl = Constants.baseURL + "getInspectorAllInspectionsReport?inspector_id=\(appDel.user.user_id!)&type=\(self.filter_task_type)&start=\(self.START_COUNTER)&limit=\(limit)"
        
        
        print(loginUrl)
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "history")
        }
        else  if self.currentArea !=  nil && self.currentZone == nil {
            let loginUrl = Constants.baseURL + "getInspectorAllInspectionsReport?inspector_id=\(appDel.user.user_id!)&type=\(self.filter_task_type)&start=\(self.START_COUNTER)&limit=\(limit)&area_id=\(self.currentArea!.area_id!)"
            
            
            print(loginUrl)
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "history")
            
        }
        
        else  if self.currentArea ==  nil && self.currentZone != nil {
            print(self.currentZone?.zone_id)
            
            let loginUrl = Constants.baseURL + "getInspectorAllInspectionsReport?inspector_id=\(appDel.user.user_id!)&type=\(self.filter_task_type)&start=\(self.START_COUNTER)&limit=\(limit)&zone_id=\(self.currentZone!.zone_id!)"
            
            
            print(loginUrl)
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "history")
            
        }
        
        else  if self.currentArea !=  nil && self.currentZone != nil {
            let loginUrl = Constants.baseURL + "getInspectorAllInspectionsReport?inspector_id=\(appDel.user.user_id!)&type=\(self.filter_task_type)&start=\(self.START_COUNTER)&limit=\(limit)&zone_id=\(self.currentZone!.zone_id!)&area_id=\(self.currentArea!.area_id!)"
            
            
            print(loginUrl)
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "history")
            
        }
    }
    
    func setupTaskDetailDownloader(_ task_id : String , list_id : String){
        let loginUrl = Constants.baseURL + "getTaskQuestionListWithResult?listID=\(list_id)&taskID=\(task_id)"
        
        self.appDel.showIndicator = 1
        print(loginUrl)
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "taskDetail")
        
        
    } // end of tje setupTaskDetailDownloader
    
    
    func setupDownloaderWithDate(_ type : String , startDate : String , endDate : String) {
        if type == "all" {
        self.selectTypeBtn.setTitle("All Tasks", for: UIControlState())
            
        }
        else if type == "closed" {
            self.selectTypeBtn.setTitle("Closed Tasks", for: UIControlState())
            
        }
        else if type == "completed" {
            self.selectTypeBtn.setTitle("Completed Tasks", for: UIControlState())
            
        }
          //self.selectTypeBtn.setTitle(type, forState: UIControlState.Normal)
         self.appDel.showIndicator = 1
         self.SEARCH_BY = 2
        if self.currentArea == nil {
        let loginUrl = Constants.baseURL + "getInspectorAllInspectionsReport?inspector_id=" + appDel.user.user_id! + "&type=" + self.filter_task_type + "&start_date="+startDate+"&end_date="+endDate+"&start=\(self.START_COUNTER)&limit=\(limit)"
        
        
        
        print(loginUrl)
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "history")
        }
        else {
            let loginUrl = Constants.baseURL + "getInspectorAllInspectionsReport?inspector_id=" + appDel.user.user_id! + "&type=" + self.filter_task_type + "&start_date="+startDate+"&end_date="+endDate+"&start=\(self.START_COUNTER)&limit=\(limit)&area_id=\(self.currentArea!.area_id!)"
            
            
            
            print(loginUrl)
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "history")
            
        }
    
    }
    
    
    func inspectorsSelected(_ allInspector: NSMutableDictionary) {
        var str : String = ""
        var allKeys = allInspector.allKeys
        
        for a in 0  ..< allKeys.count  {
            
            
            let dao = allInspector.object(forKey: allKeys[a]) as! InspectorBtn
            
            // print("ID is \(allKeys[a]) but id in dictionary is \(dao.inspectorDao!.id)")
            
            // print("\(dao.inspectorDao!.name) id \(dao.inspectorDao!.id)")
            if str == "" {
                str = dao.inspectorDao!.id!
            }
            else {
                str =  str + "," + dao.inspectorDao!.id!
            }
            
        } // end of the for loop
        // print(str)
        if self.taskToEdit != nil {
            self.taskToEdit!.coInspectors = str
        }
        
        if Reachability.isConnectedNetwork() {
            
            self.appDel.showIndicator = 0
            let loginUrl = "\(Constants.baseURL)addRemoveTaskCoInspectors?inspectorID=\(self.appDel.user.user_id!)&taskID=\(self.taskToEdit!.id!)&inspectorsList=\(self.taskToEdit!.coInspectors!)"
            ///print(loginUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "editCoInspectors")
            
        }
        else {
            if self.taskToEdit != nil {
//                self.databaseManager.updateCoInspector(task_id: self.taskToEdit!.task_id, unique_id:  self.taskToEdit!.uniqueid, coinspectors:  self.taskToEdit!.coninspectors)
//
//                self.tableArray = NSMutableArray()
//                self.tableArray.addObjects(from: databaseManager.fetchTasks() as [AnyObject])
//                self.appDel.allTasks = self.tableArray
//                self.dataTable.reloadData()
//
            }


        } // end of the else
        
        
        
    }
    
    
    @objc func editCoInspection(sender : ADButton){
        
        
       // print("CoInspectors \(sender.taskDao.coninspectors)")
        // let coinspectorArray = sender.taskDao.coninspectors.components(separatedBy: ",")
        self.taskToEdit = sender.historyTask
        let inspectors = DatabaseManager().fetchInspectorsOnBehalfofIds(allIds: sender.historyTask!.coInspectors?.split(separator: ",") as! NSArray)
        
        let insDict = NSMutableDictionary()
        for ins in inspectors as! [InspectorDao] {
            let btn = InspectorBtn()
            btn.inspectorDao = ins
            insDict.setValue(btn, forKey: ins.id!)
        }
        let vc = storyboard!.instantiateViewController(withIdentifier: "cnt_addCoinspection") as! AddCoinspectionController
        vc.previousDict = insDict
        
        vc.del = self
        //            vc.del = self
        //            if self.allSelectedInspectors != nil {
        //                vc.previousDict = self.allSelectedInspectors
        //            }
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        
        let parser = JsonParser()
        if identity == "historynotes" {
            //let str = NSString(data: data, encoding: NSUTF8StringEncoding)
            //print(str)
            self.allCompletedTasks = NSMutableArray()
            
             currentCounter = 15
             increment  = 15
            START_COUNTER  = 0

            
          //  self.setupDownloaderWithDate(self.reportType, startDate: formater.stringFromDate(self.firstDate!), endDate: formater.stringFromDate(self.secondDate!))
          self.setupDownloader("report")
            
        }
        if identity == "taskDetail" {
          //  let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
          //  print(str)
            
            let allQuestion = parser.parseQuestionsForHistory(data)
            self.appDel.questions = allQuestion.0
            self.appDel.allQCategories = allQuestion.1
            
            self.performSegue(withIdentifier: "sw_hisorytoresult", sender: nil)
        
        
        }
        
        else if identity == "history" {
       // self.allCompletedTasks = NSMutableArray()
       let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        print(str)
        
        // self.allCompletedTasks.addObject("")
        let allTasks = parser.parseHistory(data)
            
            for  a in 0  ..< allTasks.count  {
            let singleDao : TaskHistoryDao  = allTasks.object(at: a) as! TaskHistoryDao
            self.allCompletedTasks.add(singleDao)
            
            //print("Total Records \(self.allCompletedTasks.count)")
           // print(singleDao.questions)
        }
        
            if allTasks.count <= 0 && START_COUNTER == 0 {
                let alert = UIAlertController(title: "", message: localisation.localizedString(key: "general.norecordsfound"), preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: localisation.localizedString(key: "tasks.dismiss"), style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)

            
            }
            
        }
        else if identity == "editCoInspectors" {
            let parser = JsonParser()
            let edit = parser.parseEditInspectorsResponse(data)
            
            if edit.resposeType == "error" {
                if edit.error_code == Constants.task_Is_Closed {
                    SCLAlertView().showError("", subTitle:"You can't delete inspector as task is already closed", closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
                    
                }
                else if edit.error_code == Constants.task_Is_Already_Submitted {
                    SCLAlertView().showError("", subTitle:"You can't delete inspector as task is already Submitted", closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
                }
                else if edit.error_code == Constants.no_Task_Found {
                    
                    SCLAlertView().showError("", subTitle:"Task is not available", closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
                }
                else if edit.error_code == Constants.not_Owner_Of_Task {
                    
                    SCLAlertView().showError("", subTitle:"Only Owner of the task is allowed to update Inspectors", closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
                }
                
                
                
            }//
            self.allCompletedTasks = NSMutableArray()
            
          self.setupDownloader("report")
            
        }
        
        
        
        
        
            self.dataTable.reloadData()
    }
    
    @IBOutlet weak var taskTable: UITableView!

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


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func showDetail(_ sender : UIButton){
        self.appDel.fromHistoryToResult = 1
        let task : TaskHistoryDao = self.allCompletedTasks.object(at: sender.tag) as! TaskHistoryDao
        if task.task_status == "unfinished"{
            let popoverVC = storyboard?.instantiateViewController(withIdentifier: "cnt_reasonNav") as! UINavigationController
            let cnt : ReasonNotCompleteViewController = storyboard?.instantiateViewController(withIdentifier: "cnt_reason")  as! ReasonNotCompleteViewController
            cnt.fromHistory = 1
           cnt.closed_reason = task.unfinished_reason
           cnt.closed_notes = task.unfinished_note
            
            
            
            
            //cnt.delegate = self
            
            cnt.modalPresentationStyle = UIModalPresentationStyle.formSheet
            present(cnt, animated: true, completion: nil)
            
      return
            
        }
        
        self.appDel.questions = task.questions
        self.appDel.history_task = task
        
        if task.id != nil && task.list_id != nil {
            print("Task id \(task.id) list id \(task.list_id)")
            
        self.setupTaskDetailDownloader(task.id!,list_id : task.list_id!)
        }// end of the condition
        //self.performSegueWithIdentifier("sw_hisorytoresult", sender: nil)
    }
    @objc func showPermit(_ sender : UIButton) {
                //   self.appDel.taskDao = self.allHistoryTasks.objectAtIndex(sender.tag) as! TaskDao
            
       let history = self.allCompletedTasks.object(at: sender.tag) as! TaskHistoryDao
        
        self.appDel.selectedPermit = history.permitDao
        let cnt = storyboard?.instantiateViewController(withIdentifier: "cnt_fileview") as? FileViewController
        self.navigationController?.pushViewController(cnt!, animated: true)
        
    }
    
    
    func showZoneTasks(_ sender : UIButton) {
    
    
    }//  end 
    
    @objc func showZoneAssignments(_ sender  : UIButton) {
        
        let tasksDao : TaskHistoryDao = self.allCompletedTasks.object(at: sender.tag) as! TaskHistoryDao
        self.allCompletedTasks = NSMutableArray()
        self.dataTable.reloadData()
        
        let loginUrl = Constants.baseURL + "getInspectorAllInspectionsReport?inspector_id=\(appDel.user.user_id!)&type=\(self.filter_task_type)&start=\(self.START_COUNTER)&limit=\(limit)&assigned_zone_id=\(tasksDao.id!)"
            
            
            print(loginUrl)
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "history")
        
        
        
        
    } // end of the showZoneAssignments
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : HistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_historytitle") as! HistoryTableViewCell
       

//        if(indexPath.row == 0){
//            //cell = tableView.dequeueReusableCellWithIdentifier("cell_historyData") as! HistoryTableViewCell
//            cell.taskno.text = localisation.localizedString(key: "tasks.number")
//            cell.task.text = localisation.localizedString(key: "tasks.name")
//            cell.company.setTitle(localisation.localizedString(key: "tasks.company"), forState: UIControlState.Normal)
//         //   cell.tasktypelbl.text = localisation.localizedString(key: "tasks.status")
//            cell.completiondate.text = localisation.localizedString(key: "tasks.duedate")
//            cell.viewdetailBtn.hidden = true
//            
//            
//            
//            
//            
//            return cell
//        }
//        else {
             cell = tableView.dequeueReusableCell(withIdentifier: "cell_historyData") as! HistoryTableViewCell
             cell.permitIdBtn.setTitle("" ,for: UIControlState())
             let tasksDao : TaskHistoryDao = self.allCompletedTasks.object(at: indexPath.row) as! TaskHistoryDao
             self.historyDao = tasksDao
        
        
            //  cell.tasksNo.text =  String(
            cell.task.text = tasksDao.task_name
            cell.viewdetailBtn.tag = indexPath.row
            cell.viewdetailBtn.isHidden = false
        //print("Violation Count \(tasksDao.violations_count)")
          if tasksDao.violations_count != nil {
            if tasksDao.violations_count != "0" {
            cell.flagImage.isHidden = false
            }
            else {
             cell.flagImage.isHidden = true
            }
        }
        else {
            cell.flagImage.isHidden = true
            
        }
        
            cell.viewdetailBtn.setTitle(self.localisation.localizedString(key: "history.viewdetails"), for: UIControlState())
        
        if tasksDao.priority == "1" {
            cell.colorIndicator.backgroundColor = UIColor(red:46/255, green: 204/255, blue: 113/255, alpha: 1.0)
            
        }
        else if tasksDao.priority == "2" {
            cell.colorIndicator.backgroundColor = UIColor(red:246/255, green: 142/255, blue: 90/255, alpha: 1.0)
            
        
        }
        else if tasksDao.priority == "3" {
        cell.colorIndicator.backgroundColor = UIColor(red:231/255, green: 76/255, blue: 60/255, alpha: 1.0)
        }
        
          cell.notesBtn.history_taskid = tasksDao.id!
        
        
          cell.notesBtn.addTarget(self, action: #selector(TaskHistoryViewController.showHistoryNotes(_:)), for: UIControlEvents.touchUpInside)
          cell.notesBtn.hisory_notes = tasksDao.task_notes
        if tasksDao.task_status == "unfinished" {
        
            cell.inspectiondateValue.text = tasksDao.visited_date!
            cell.notesBtn.isHidden = true
            
        }
        else {
        cell.inspectiondateValue.text = tasksDao.completed_date
            cell.notesBtn.isHidden = false
            
        }
        
        
        if tasksDao.isZoneTask == 1 {
           print(tasksDao.zone_name_ar)
        cell.company.setTitle(tasksDao.zone_name_ar, for: UIControlState())
            
        cell.inspection_date.text = tasksDao.zone_expiryDate
        cell.categoryTitlelbl.isHidden = true
        cell.categoryValue.isHidden = true
        cell.notesBtn.isHidden = true
        cell.viewdetailBtn.tag = indexPath.row
        cell.viewdetailBtn.removeTarget(self, action: #selector(TaskHistoryViewController.showDetail(_:)), for: UIControlEvents.touchUpInside)
        cell.viewdetailBtn.addTarget(self, action: #selector(TaskHistoryViewController.showZoneAssignments(_:)), for: UIControlEvents.touchUpInside)
         cell.taskno.text = String(indexPath.row + 1)
            
            return cell
        } // end of the isZoneTask
        
        cell.viewdetailBtn.removeTarget(self, action: #selector(TaskHistoryViewController.showZoneAssignments(_:)), for: UIControlEvents.touchUpInside)
        
        cell.viewdetailBtn.addTarget(self, action: #selector(TaskHistoryViewController.showDetail(_:)), for: UIControlEvents.touchUpInside)
        
        print(tasksDao.task_status)
        if tasksDao.coInspectors != "" && tasksDao.coInspectors != self.appDel.user.user_id  && tasksDao.taskOwnerID != nil && tasksDao.task_status != "completed" && tasksDao.task_status != "unfinished"{
            print(tasksDao.taskOwnerID)
            if let owner = tasksDao.taskOwnerID {
                if owner == self.appDel.user.user_id {
                    cell.editBtn.isHidden = false
                    cell.editBtn.historyTask = tasksDao
                    cell.editBtn.addTarget(self, action: #selector(TasksViewController.editCoInspection(sender:)), for: UIControlEvents.touchUpInside)
                    
                    
                }// end o the
                else {
                    cell.editBtn.isHidden = true
                    cell.editBtn.removeTarget(self, action: #selector(TasksViewController.editCoInspection(sender:)), for: UIControlEvents.touchUpInside)
                    
                }
            }
            
            //        cell.editCoInspection.isHidden = false
            //        cell.editCoInspection.taskDao = tasksDao
            //            cell.editCoInspection.addTarget(self, action: #selector(TasksViewController.editCoInspection(sender:)), for: UIControlEvents.touchUpInside)
            //
        }else {
            cell.editBtn.isHidden = true
            cell.editBtn.removeTarget(self, action: #selector(TasksViewController.editCoInspection(sender:)), for: UIControlEvents.touchUpInside)
        }
        
        cell.inspection_date.text = localisation.localizedString(key: "history.inspectiondate")
        if tasksDao.taskType == 1 {
            cell.permitIdBtn.isHidden = false
            if tasksDao.area_nameAr != nil {
              print("Area name \(tasksDao.area_nameAr)")
           cell.permitIdBtn.setTitle("\(tasksDao.area_nameAr!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))", for: UIControlState())
            }
            
         cell.company.setTitle(tasksDao.company_name, for: UIControlState())
            cell.company.tag = indexPath.row
           cell.company.addTarget(self, action: #selector(TaskHistoryViewController.companyTapped(_:)), for: UIControlEvents.touchUpInside)
        
        
            if self.appDel.selectedLanguage == 1 && tasksDao.company_name != nil {
                
                
                       cell.company.setTitle(tasksDao.company_name, for: UIControlState())
                
            }
            else  if  self.appDel.selectedLanguage == 2 && tasksDao.company_name_arabic != nil {
                
                
                cell.company.setTitle(tasksDao.company_name_arabic, for: UIControlState())
                
               
            }
            else {
            
                cell.company.setTitle(tasksDao.company_name, for: UIControlState())
                
                
                
                
                
            }

        
        
        }
        else {
            
        
            cell.company.setTitle(tasksDao.driver_name, for: UIControlState())
            
            if tasksDao.emiratesID != nil && tasksDao.emiratesID != "" {
                cell.permitIdBtn.isHidden = false
                cell.permitIdBtn.setTitle(" \(tasksDao.emiratesID!) - Emirates Id" ,for: UIControlState())
            }
            else if tasksDao.drivingLicenseNo != nil && tasksDao.drivingLicenseNo != "" {
                cell.permitIdBtn.isHidden = false
                cell.permitIdBtn.setTitle(" \(tasksDao.drivingLicenseNo!) - License No." ,for: UIControlState())
                
            }
            
            else if tasksDao.passprot != nil && tasksDao.passprot != "" {
                cell.permitIdBtn.isHidden = false
                cell.permitIdBtn.setTitle(" \(tasksDao.passprot!) - Passport No." ,for: UIControlState())
                
            }
            
            
        }
        
            //  cell.group.text = tasksDao.group_name
            cell.taskno.text = String(indexPath.row + 1)
            cell.completiondate.text = tasksDao.due_date
            cell.categoryValue.text = tasksDao.list_title
            cell.categoryTitlelbl.text = localisation.localizedString(key: "tasks.category")
        if tasksDao.permitDao != nil && tasksDao.taskType == 1{
            cell.permitIdBtn.isHidden = false
        if tasksDao.permitDao!.sub_venue != nil  {
            if tasksDao.permitDao!.sub_venue! != "" {
                cell.permitIdBtn.setTitle("\(tasksDao.permitDao!.sub_venue!) - \(tasksDao.permitDao!.permitID!)", for: UIControlState())
            }
            else {
                cell.permitIdBtn.setTitle("\(tasksDao.permitDao!.permitID!)", for: UIControlState())
            }
        }
        else {
            cell.permitIdBtn.setTitle("\(tasksDao.permitDao!.permitID!)", for: UIControlState())
        }
        cell.permitIdBtn.tag = indexPath.row
            
        cell.permitIdBtn.addTarget(self, action: #selector(TaskHistoryViewController.showPermit(_:)), for: UIControlEvents.touchUpInside)
        } // end of the permit dao
        else {
//        /cell.permitIdBtn.hidden = true
        }
        
//            if let creator = tasksDao.creator {
//                if creator == "admin" {
//                    cell.contentView.backgroundColor = UIColor.whiteColor()
//                }
//                else {
//                    cell.contentView.backgroundColor = UIColor(red: 231/255, green: 212/255, blue: 215/255, alpha: 1)
//                }
//            }
            

        
   //     }
        
//        if indexPath.row % 2 == 0 {
//            cell.contentView.backgroundColor = UIColor(red: 244/255, green: 237/255, blue: 237/255, alpha: 1)
//        }
//        else {
//            cell.contentView.backgroundColor = UIColor(red: 244/255, green: 241/255, blue: 241/255, alpha: 1)
//        }

        
        if tasksDao.subVenueName != nil && cell.permitIdBtn != nil {
        cell.permitIdBtn.isHidden = false
        cell.permitIdBtn.setTitle("\(tasksDao.subVenueName!)", for: UIControlState())
        }
        
        if  (tasksDao.list_id == "10" || tasksDao.list_id == "11") && tasksDao.external_notes != nil {
            cell.permitIdBtn.isHidden = false
            cell.permitIdBtn.setTitle("\(tasksDao.external_notes!)", for: UIControlState())
        }
        
        return cell
        
    }
    
    @objc func companyTapped(_ sender : UIButton) {
    self.appDel.fromHistoryToResult = 1
        
    let cnt = self.storyboard!.instantiateViewController(withIdentifier: "cnt_companydetail") as! CompanyViewController
        let task : TaskHistoryDao = self.allCompletedTasks.object(at: sender.tag) as! TaskHistoryDao
        cnt.history = task
        if cnt.history != nil {
        self.navigationController?.pushViewController(cnt, animated: true)
        }
        else {
        print("History is done")
        }
    }
    @objc func showHistoryNotes(_ sender : ADButton){
    //showNotes
        
       // let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("showNotes") as! UINavigationController
        let cnt : HistoryNotesViewController = storyboard?.instantiateViewController(withIdentifier: "cnt_historynotes")  as! HistoryNotesViewController
        //cnt.btn = sender
        cnt.del = self
        
        cnt.history_task_id = sender.history_taskid!
        cnt.allNotes = sender.hisory_notes
        //cnt.notesText.text = self.notes.objectForKey(String(sender.questionid)) as? String
        
        
  
        cnt.modalPresentationStyle = .formSheet
        present(cnt, animated: true, completion: nil)

      
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= self.allCompletedTasks.count - 1
        {
        
        if self.historyDao != nil {
        if self.historyDao?.total_count > self.currentCounter
        {
            self.currentCounter = self.currentCounter + self.limit
            START_COUNTER = START_COUNTER + limit
            
            
            if self.SEARCH_BY == 1 {
            self.setupDownloader("report")
            }
            else if self.SEARCH_BY == 2
            {
                if self.firstDate != nil && self.secondDate != nil {
             self.setupDownloaderWithDate(self.reportType, startDate: formater.string(from: self.firstDate!), endDate: formater.string(from: self.secondDate!))
                }
                
            }
            }
        }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     //  print("Count \(self.allCompletedTasks.count)")
        return self.allCompletedTasks.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.appDel.fromHistoryToResult = 1
//        let task : TaskHistoryDao = self.allCompletedTasks.objectAtIndex(indexPath.row) as! TaskHistoryDao
//        
//        self.appDel.questions = task.questions
//        
//        self.performSegueWithIdentifier("sw_hisorytoresult", sender: nil)
//        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    func historyNotesSaved(_ data: String, history_taskId: String) {
    
        if Reachability.connectedToNetwork() {
           self.appDel.showIndicator = 1 
            let loginUrl = Constants.baseURL + "updateTaskNotes"
            
           // let loginUrl = Constants.baseURL + "updateTaskNotes?inspector_id=" + self.appDel.user.user_id + "&task_notes=" + data + "&task_id=" + history_taskId
            
            
            print(loginUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
           
            
            //downloader.startDownloader(loginUrl, idn: "historynotes")
           downloader.sendPostHistoryNotes("historynotes", url:  URL(string: loginUrl)!, notes: data, inspector_id: self.appDel.user.user_id, task_id: history_taskId)
            
            
        } // end of the reachability
        
        
        
    }
    

}


