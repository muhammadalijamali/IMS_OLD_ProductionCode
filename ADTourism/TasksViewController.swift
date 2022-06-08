//
//  TasksViewController.swift
//  ADTourism
//
//  Created by Administrator on 8/22/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit
import CoreLocation
import Parse
import MapKit
import Fabric
import Crashlytics
import PKHUD
class TasksViewController: UIViewController , UITableViewDataSource , UITableViewDelegate, MainJsonDelegate , CLLocationManagerDelegate ,MKMapViewDelegate,SessionDelegate,SessionDataDelegate,QuestionListSessionDataDelegate,UITextFieldDelegate,DateSelectorDelegate,UIPopoverPresentationControllerDelegate,UIAdaptivePresentationControllerDelegate,TaskFilterDelegate , AreasDelegate,ZonesDelegate,HistoryFilterDelegate,InspectorSelectedDelegate {
    @IBOutlet weak var sortTaskBtn: ADButton!
    var currentArea : AreaDao?
    
    var taskToEdit : TaskDao?
    
    @IBOutlet weak var selectAllToggle: UISwitch!
    @IBOutlet weak var selectAllView: UIView!
    
    @IBOutlet weak var makaniBtn: UIButton!
    
    
    var firstDate : Date?
    var secondDate : Date?
    
    var startDateStr : String = ""
    var endDateStr : String = ""
    var sortBy : String = ""
    var TASK_RADIUS : Int = 1000
    var zoneDao : ZoneDao?
    var orderBy : String =  ""
    var userDefaults  = UserDefaults.standard
    
    func historyfilterSelected(_ filterArea : AreaDao?,zoneDao : ZoneDao?)
    {
        self.currentArea = filterArea
        self.zoneDao = zoneDao
        if filterArea?.area_id == "0" {
            self.currentArea = nil
            self.currentArea = filterArea
        }
        else {
            self.currentArea = filterArea
            
        }
        
        print(zoneDao?.zone_name)
    self.filterSelected(self.startDateStr, endDate: self.endDateStr, orderBy: self.orderBy, filterArea: self.currentArea, zoneDao: self.zoneDao)
    
    }
    
    
    func clearFilter() {
        
    self.zoneDao = nil
    self.currentArea = nil
    sortBy  = ""
    self.downloadTasks()
        
    }
    
    
    func deSelectAll(){
        
        self.selectedTasks.removeAllObjects()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            // Here you will get the animation you want
            self.submitBtnView.alpha = 1.0
        }, completion: { _ in
            // Here you hide it when animation done
            self.submitBtnView.isHidden = false
            self.submitTaskBtn.setTitle("Submit(\(self.selectedTasks.count)) tasks without violations", for: UIControlState.normal)
        })
         self.dataTable.reloadData()
    }
    
    @IBAction func selectAllAction(_ sender: UISwitch) {
        if (sender.isOn) {
            self.selectAllTask()
        }
        else {
            
        self.deSelectAll()
        }
        if self.selectedTasks.count > 0 {
            
            
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                // Here you will get the animation you want
                self.submitBtnView.alpha = 1.0
            }, completion: { _ in
                // Here you hide it when animation done
                self.submitBtnView.isHidden = false
                self.submitTaskBtn.setTitle("Submit(\(self.selectedTasks.count)) tasks without violations", for: UIControlState.normal)
            })
            
        }
        else {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                // Here you will get the animation you want
                self.submitBtnView.alpha = 0.0
            }, completion: { _ in
                // Here you hide it when animation done
                self.submitBtnView.isHidden = true
            })
            
            
        }
    }
    
    
    @IBAction func openAreaPopop(_ sender: UIButton) {
//        if Reachability.isConnectedNetwork() {
//            let popController = storyboard!.instantiateViewControllerWithIdentifier("cnt_area") as! AreasViewController
//            popController.view.backgroundColor = UIColor().colorWithAlphaComponent(1.0)
//            popController.del = self
//            
//            popController.modalPresentationStyle = UIModalPresentationStyle.Popover
//            //popController.modalInPopover = true
//            
//            
//            // set up the popover presentation controller
//            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Up
//            popController.popoverPresentationController?.delegate = self
//            popController.popoverPresentationController?.sourceView = sender // button
//            popController.popoverPresentationController?.sourceRect = sender.bounds
//            self.presentViewController(popController, animated: true, completion: nil)
//        }else {
//            let alert = UIAlertController(title: "", message: localisation.localizedString(key: "general.checkinternet"), preferredStyle: UIAlertControllerStyle.Alert)
//            let action = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.Cancel, handler: nil)
//            alert.addAction(action)
//            self.presentViewController(alert, animated: true, completion: nil)
//            
//        }
//
        
        
        
        
        
        
        
        self.newSearchField.resignFirstResponder()
    
        if Reachability.isConnectedNetwork() {
            
            
            self.selectedTasks.removeAllObjects()
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                // Here you will get the animation you want
                self.submitBtnView.alpha = 0.0
                }, completion: { _ in
                    // Here you hide it when animation done
                    self.submitBtnView.isHidden = true
            })
            
            self.newSearchField.text = ""
            self.isSearching = 0
            self.isCompanySearching = 0
            
            self.searchArray = NSMutableArray()
            self.selectedTasks.removeAllObjects()
            self.appDel.addedSubvenueCompany = ""
            self.dataTable.reloadData()
            

            
            let popController = storyboard!.instantiateViewController(withIdentifier: "cnt_historyfilterpopup") as! HistoryFilterPopupViewController
            popController.view.backgroundColor = UIColor().withAlphaComponent(1.0)
            popController.del = self
            
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
   
    
    func areaCodeDetected(_ area: AreaDao) {
        self.currentArea = area
        if self.currentArea?.area_id == "0" {
        self.currentArea = nil
        }
        self.downloadTasks()
    }
    
    
    @IBAction func makaniMethod(_ sender: UIButton) {
    
        let popController = storyboard!.instantiateViewController(withIdentifier: "cnt_makani") as! MakaniViewController
        popController.view.backgroundColor = UIColor().withAlphaComponent(1.0)
        // popController.del = self
        popController.fromTask = 1
        popController.preferredContentSize = CGSize(width: 300, height: 105)
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.isModalInPopover = true
        
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.unknown
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender // button
        popController.popoverPresentationController?.sourceRect = sender.bounds
        self.present(popController, animated: true, completion: nil)
        

    
    
    }
    
    
    @IBAction func filterpopupMethod(_ sender: UIButton) {
        self.newSearchField.resignFirstResponder()
        
        if Reachability.isConnectedNetwork() {
            
            
            
            self.selectedTasks.removeAllObjects()
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                // Here you will get the animation you want
                self.submitBtnView.alpha = 0.0
                }, completion: { _ in
                    // Here you hide it when animation done
                    self.submitBtnView.isHidden = true
            })
            self.newSearchField.text = ""
            self.isSearching = 0
            self.isCompanySearching = 0
            
            self.searchArray = NSMutableArray()
            self.selectedTasks.removeAllObjects()
            self.appDel.addedSubvenueCompany = ""
            self.dataTable.reloadData()
            

            
            
            
            
        let popController = storyboard!.instantiateViewController(withIdentifier: "cnt_filterpopup") as! FilterPopupViewController
               popController.view.backgroundColor = UIColor().withAlphaComponent(1.0)
          popController.del = self
        
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.isModalInPopover = true
      
        
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
    
    func filterSelected(_ startDate: String, endDate: String, orderBy: String, filterArea: AreaDao?, zoneDao: ZoneDao?) {
        
       
        if filterArea != nil {
            if filterArea?.area_id == "0" {
            self.currentArea = nil
            //self.currentArea = filterArea
            }
            else {
                self.currentArea = filterArea
                
            }
//                print(filterArea?.area_id)
//        print(filterArea?.area_name)
//            print(filterArea?.area_name_ar)
//            
            
        }
        else {
        self.currentArea = nil
        }
        
        self.zoneDao = zoneDao
        
        //self.currentArea = filterArea

        
        self.orderBy = orderBy
        
        self.zoneDao = zoneDao

        var loginUrl : String = ""
        if self.currentArea == nil && self.zoneDao == nil {
            print("Zone is nil and Area is nil")
            loginUrl = Constants.baseURL + "getInspectorTaskLists?inspector_id=\(user.user_id!)&from_date=\(startDate)&to_date=\(endDate)&order_by=\(orderBy)&order_lang=eng"
            
        }
        else if self.currentArea != nil && self.zoneDao == nil {
        loginUrl = Constants.baseURL + "getInspectorTaskLists?inspector_id=\(user.user_id!)&from_date=\(startDate)&to_date=\(endDate)&order_by=\(orderBy)&order_lang=eng&area_id=\(self.currentArea!.area_id!)"
        
        }
        else if self.currentArea != nil && self.zoneDao != nil {
            loginUrl = Constants.baseURL + "getInspectorTaskLists?inspector_id=\(user.user_id!)&from_date=\(startDate)&to_date=\(endDate)&order_by=\(orderBy)&order_lang=eng&area_id=\(self.currentArea!.area_id!)&zone_id=\(zoneDao!.zone_assignment_id!)"
            
        }
        
        else if self.currentArea == nil && self.zoneDao != nil {
         //print(orderBy)
         //   print(zoneDao!.zone_assignment_id!)
         //   print(startDate)
          //  print(endDate)
            
            print(self.zoneDao!.zone_id!)
            
            
            loginUrl = Constants.baseURL + "getInspectorTaskLists?inspector_id=\(user.user_id!)&from_date=\(startDate)&to_date=\(endDate)&order_by=\(orderBy)&order_lang=eng&zone_id=\(zoneDao!.zone_id!)"
            
        }
        print(loginUrl)
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        self.appDel.showIndicator = 1
        print(loginUrl)
        downloader.startDownloader(loginUrl, idn: "alltasks")
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }

    
    
    @IBOutlet weak var endDateBtn: ADButton!
    var whichDate : Int = 0 // 0 first date 1 second data

    @IBOutlet weak var startDatebtn: ADButton!
    @IBAction func endDateMethod(_ sender: ADButton) {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let menuViewController: DateSelectorViewController = storyboard.instantiateViewController(withIdentifier: "cnt_date") as! DateSelectorViewController
        menuViewController.delegate = self
        menuViewController.button = sender
        self.whichDate = 1
        self.appDel.calenderHisyoty = 0
        
        
        
        menuViewController.modalPresentationStyle = .popover
        //menuViewController.preferredContentSize = CGSizeMake(50, 100)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .any
        // popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sender
        
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
       let formatter1 = DateFormatter()
        formatter1.dateFormat = "YYYY-MM-dd"
        formatter1.locale = Locale(identifier: "en_US")
        

        
        
        if self.whichDate == 0 {
            self.firstDate = date
            self.startDatebtn.setTitle(formatter1.string(from: self.firstDate!), for: UIControlState())
            self.startDateStr = formatter1.string(from: self.firstDate!)
            
            //   self.firstText.text = formater.stringFromDate(date)
            if self.firstDate != nil && self.secondDate != nil {
                self.filterSelected(self.startDateStr, endDate: self.endDateStr, orderBy: self.sortBy,filterArea: self.currentArea,zoneDao: zoneDao)
                //  self.setupPermitDownloaderWithDates()
                // self.setupDownloaderWithDate(self.reportType, startDate: formater.stringFromDate(self.firstDate!), endDate: formater.stringFromDate(self.secondDate!))
                
                
            } // end of the if
        }
        else {
            //    self.secondText.text = formater.stringFromDate(date)
            self.endDateBtn.setTitle(formatter1.string(from: date), for:UIControlState())
            self.secondDate = date
            self.endDateStr = formatter1.string(from: date)
            
            if self.firstDate != nil {
                // self.setupPermitDownloaderWithDates()
                //self.setupDownloaderWithDate(self.reportType, startDate: formater.stringFromDate(self.firstDate!), endDate: formater.stringFromDate(self.secondDate!))
                
               self.filterSelected(self.startDateStr, endDate: self.endDateStr, orderBy: self.sortBy,filterArea: self.currentArea,zoneDao: zoneDao)
            }
            //  self.setupDownloaderWithDate(self.ty, startDate: <#String#>, endDate: <#String#>)
        }

    }
    @IBAction func startDateMethod(_ sender: ADButton) {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let menuViewController: DateSelectorViewController = storyboard.instantiateViewController(withIdentifier: "cnt_date") as! DateSelectorViewController
        menuViewController.delegate = self
        menuViewController.button = sender
        self.whichDate = 0
        self.appDel.calenderHisyoty = 0
        
        
        
        menuViewController.modalPresentationStyle = .popover
        //menuViewController.preferredContentSize = CGSizeMake(50, 100)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .any
        // popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sender
        
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
    @IBAction func sortTaskMethod(_ sender: UIButton) {
      /*
        let listAlert = SCLAlertView()
        listAlert.showCloseButton = true
        listAlert.addButton("Sort By Name", action: {
        self.sortBy = "name"
        self.sortTaskBtn.setTitle("Company Name", forState: UIControlState.Normal)
            self.filterSelected(self.startDateStr, endDate: self.endDateStr, orderBy: self.sortBy)
            
        })
        
        listAlert.addButton("Sort By Date", action: {
        self.sortBy = "date"
            self.sortTaskBtn.setTitle("By Date", forState: UIControlState.Normal)
            self.filterSelected(self.startDateStr, endDate: self.endDateStr, orderBy: self.sortBy)
            
        })
      
        
        listAlert.showInfo("Sort Task List", subTitle: "")
        */
        
        
        
        
        let listAlert = SCLAlertView()
        listAlert.showCloseButton = true
        listAlert.addButton(localisation.localizedString(key: "tasks.filterbyname"), action: {
            self.sortBy = "name"
            
            self.sortTaskBtn.setTitle(self.localisation.localizedString(key: "tasks.filterbyname"), for: UIControlState())
        self.filterSelected(self.startDateStr, endDate: self.endDateStr, orderBy: self.sortBy,filterArea: self.currentArea,zoneDao: self.zoneDao)
        })
        
        listAlert.addButton(localisation.localizedString(key: "tasks.filterbydate"), action: {
            
            self.sortBy = "date"
            
            self.sortTaskBtn.setTitle(self.localisation.localizedString(key: "tasks.filterbydate"), for: UIControlState())
            self.filterSelected(self.startDateStr, endDate: self.endDateStr, orderBy: self.sortBy,filterArea: self.currentArea,zoneDao: self.zoneDao)
        })
        
        
        listAlert.showInfo(self.localisation.localizedString(key: "tasks.sortTaskList"), subTitle: "")

        
        
     
    }
    @IBOutlet weak var submitBtnView: UIView!
    
    @IBOutlet weak var poolBtn: UIButton!
    @IBOutlet weak var locationlbl: UILabel!
    @IBOutlet weak var newSearchField: UITextField!
    @IBOutlet weak var searchbar: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activelbl: UILabel!
    @IBOutlet weak var currentTasksLbl: UILabel!
    var companyNameArray : NSMutableArray = NSMutableArray()
    var toggleNoAction : Int = 0
    
    
    var tasksToDownload : NSMutableArray = NSMutableArray()
    
    var tasksCounter : Int = 0
    
    var currentStartBtn : UIButton?
    
    
    var onMytimer : Timer?
    
    var checkTaskOnWay : Int = 0
    var is_pool : Int = 0
    var isCompanySearching : Int = 0
    var selectedTasks : NSMutableDictionary = NSMutableDictionary()
    
    
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    @IBOutlet weak var addTaskBtn: UIButton!
    @IBAction func addTaskMethod(_ sender: AnyObject) {
                if self.appDel.user.status != nil {
                    if self.appDel.user.status == "Inactive"  && Reachability.connectedToNetwork(){
        
                        SCLAlertView().showError(localisation.localizedString(key: "tasks.youareinactive"), subTitle:localisation.localizedString(key: "tasks.inactiveMessage"), closeButtonTitle:localisation.localizedString(key: "tasks.dismiss"))
        
        
        
                        return
        
        
        
                    }
        
                }
                if self.onTheWayTasksCount == 1  && Reachability.connectedToNetwork() && self.appDel.taskDao.isZoneTask != 1{
                    let alert = UIAlertController(title:localisation.localizedString(key:"tasks.createinspection"), message: localisation.localizedString(key: "tasks.You are already on the way, You can not create new inspection "), preferredStyle: UIAlertControllerStyle.alert)
                    let cancel = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
        
        
         self.performSegue(withIdentifier: "sw_makeSearch", sender: nil)
        
 }
    
    let formater : DateFormatter = DateFormatter()
    @IBOutlet weak var overlay: UIImageView!
    @IBOutlet weak var activeToggle: UISwitch!
    var searchArray : NSMutableArray = NSMutableArray()
    var is_Searching : Int = 0
    
    @IBAction func myLocationMethod(_ sender: AnyObject) {
        if self.appDel.user.lat != nil && self.appDel.user.lon != nil{
            let companylocation = CLLocationCoordinate2DMake(self.appDel.user.lat , self.appDel.user.lon)
           // self.companyLat = self.appDel.user.lat
           // self.companyLon =  self.appDel.user.lon
            
            
            // Drop a pin
            
            
            
            let region = MKCoordinateRegionMakeWithDistance(companylocation, 1000, 1000)
            self.mapView.setRegion(region, animated: true)
        }

    
    }
   
    
  
        
    
    @IBAction func active_InactiveTouchup(_ sender: UISwitch) {
        //        if sender.on {
        //        sender.setOn(false, animated: true)
        //        }
        //        else {
        //            sender.setOn(true, animated: true)
        //
        //        }
        
        if  Reachability.connectedToNetwork() {
            if loc == nil {
                let listAlert = SCLAlertView()
                listAlert.showCloseButton = false
                listAlert.addButton("Okay", action: {
                    
                })
                listAlert.showInfo("Location?", subTitle: "Location not available")
                
                return
                
            }
            
            
        }
        else {
            SCLAlertView().showError("Network", subTitle: localisation.localizedString(key: "searchcompany.pleasecheckinternetconnection"))
            if (self.activeToggle.isOn == false){
                self.activeToggle.setOn(true, animated: true)
            }
            else {
                self.activeToggle.setOn(false, animated: true)
                
            }
            return
        }
        
        self.appDel.showIndicator = 1
        if self.onTheWayTasksCount == 1 && self.appDel.user.status != "Inactive" {
            print("User is on my way and He is inactive")
            self.appDel.showIndicator = 0
            let alert = SCLAlertView()
            // self.activeToggle.setOn(true, animated: true)
            
            alert.addButton(self.localisation.localizedString(key: "tasks.cancelonmyway"), action: {
               
                
                self.appDel.alreadyOnTheWay = 0
                self.onTheWayTasksCount = 0
                self.appDel.taskDao.task_status = "Not Started"
                self.databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status:self.appDel.taskDao.task_status)
                
               
                if self.appDel.taskDao.isZoneTask == 1 {
                self.cancelOnMyWayZoneActive(self.appDel.taskDao)
                   
                }
                else {
                 self.makeActive()
                }
                
                
                //self.cancelOnMyWay(UIButton())
                if self.is_pool == 1  {
                    let alert1 = SCLAlertView()
                    alert1.addButton(self.localisation.localizedString(key: "general.yes"), action: {
                       
                        self.setupPoolRelease()
                    })
                    alert1.addButton(self.localisation.localizedString(key: "general.no"), action: {
                       
                        
                    })
                    alert1.showCloseButton = false
                    alert1.showError("", subTitle: self.localisation.localizedString(key: "tasks.doyouwanttoreleasepooltasks"))
                    
                    return
                } // end of the pool condition
            })
            alert.addButton(self.localisation.localizedString(key: "tasks.dismiss"), action: {
               
                //self.toggleNoAction = 1
                self.activeToggle.setOn(true, animated: true)
                
                return
            })
            alert.showCloseButton = false
            alert.showError("", subTitle: self.localisation.localizedString(key: "tasks.inactiveonmyway"))
            //// Alert for pool tasks
            return
        }
        else if self.is_pool == 1 && self.appDel.user.status != "Inactive" {
            self.appDel.showIndicator = 0
            self.makeActive()
            // self.appDel.user.status = "active"
            let alert1 = SCLAlertView()
            alert1.addButton(self.localisation.localizedString(key: "general.yes"), action: {
               
                
                self.setupPoolRelease()
                //self.makeActive()
                
                
            })
            alert1.addButton(self.localisation.localizedString(key: "general.no"), action: {
               
                //self.makeActive()
            })
            alert1.showCloseButton = false
            alert1.showError("", subTitle: self.localisation.localizedString(key: "tasks.doyouwanttoreleasepooltasks"))
            return
            
            
        } // end of the pool condition
        
        
        
        
        //        if self.is_pool == 1 && self.appDel.user.status != "Inactive" {
        //
        //            let alert1 = SCLAlertView()
        //            alert1.addButton(self.localisation.localizedString(key: "general.yes"), action: {
        //               
        //
        //
        //                self.setupPoolRelease()
        //            })
        //            alert1.addButton(self.localisation.localizedString(key: "general.no"), action: {
        //               
        //
        //            })
        //            alert1.showCloseButton = false
        //            alert1.showError("", subTitle: self.localisation.localizedString(key: "tasks.doyouwanttoreleasepooltasks"))
        //
        //
        //        } // end of the pool condition
        //
        
        
        
        
        self.makeActive()
        
        
        
    }
    

    
    
    @IBAction func switch_makeActiveInActive(_ sender: AnyObject) {
//        print("ToggleNoAction \(toggleNoAction)")
//        if self.toggleNoAction ==  1 {
//           self.toggleNoAction = 0
//            print("go back \(toggleNoAction)")
//            return
//        }
           return
        print("Swtich called")
        if  Reachability.connectedToNetwork() {
            if loc == nil {
                let listAlert = SCLAlertView()
                listAlert.showCloseButton = false
                listAlert.addButton("Okay", action: {
                    
                })
                listAlert.showInfo("Location?", subTitle: "Location not available")
                
                return
                
            }

            
        }
        else {
            SCLAlertView().showError("Network", subTitle: localisation.localizedString(key: "searchcompany.pleasecheckinternetconnection"))
            return
        }
        
        self.appDel.showIndicator = 1 
        if self.onTheWayTasksCount == 1 && self.appDel.user.status != "Inactive" {
            print("User is on my way and He is inactive")
            self.appDel.showIndicator = 0
            let alert = SCLAlertView()
           // self.activeToggle.setOn(true, animated: true)
            
            alert.addButton(self.localisation.localizedString(key: "tasks.cancelonmyway"), action: {
               
                
                self.appDel.alreadyOnTheWay = 0
                self.onTheWayTasksCount = 0
                self.appDel.taskDao.task_status = "Not Started"
                self.databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status:self.appDel.taskDao.task_status)
                
                self.makeActive()
                
                
                //self.cancelOnMyWay(UIButton())
                if self.is_pool == 1  {
                    let alert1 = SCLAlertView()
                    alert1.addButton(self.localisation.localizedString(key: "general.yes"), action: {
                       
                        self.setupPoolRelease()
                        })
                    alert1.addButton(self.localisation.localizedString(key: "general.no"), action: {
                       
                        
                    })
                    alert1.showCloseButton = false
                    alert1.showError("", subTitle: self.localisation.localizedString(key: "tasks.doyouwanttoreleasepooltasks"))
                    
                 return
                } // end of the pool condition
                })
            alert.addButton(self.localisation.localizedString(key: "tasks.dismiss"), action: {
               
                //self.toggleNoAction = 1
                //self.activeToggle.setOn(true, animated: true)
                
                return
                })
            alert.showCloseButton = false
            alert.showError("", subTitle: self.localisation.localizedString(key: "tasks.inactiveonmyway"))
           //// Alert for pool tasks
            return
        }
        else if self.is_pool == 1 && self.appDel.user.status != "Inactive" {
            self.appDel.showIndicator = 0
            self.makeActive()
           // self.appDel.user.status = "active"
            let alert1 = SCLAlertView()
            alert1.addButton(self.localisation.localizedString(key: "general.yes"), action: {
               
                
                self.setupPoolRelease()
                //self.makeActive()
                
                
            })
            alert1.addButton(self.localisation.localizedString(key: "general.no"), action: {
               
                //self.makeActive()
            })
            alert1.showCloseButton = false
            alert1.showError("", subTitle: self.localisation.localizedString(key: "tasks.doyouwanttoreleasepooltasks"))
            return

            
        } // end of the pool condition

        
        
        
//        if self.is_pool == 1 && self.appDel.user.status != "Inactive" {
//            
//            let alert1 = SCLAlertView()
//            alert1.addButton(self.localisation.localizedString(key: "general.yes"), action: {
//               
//                
//                
//                self.setupPoolRelease()
//            })
//            alert1.addButton(self.localisation.localizedString(key: "general.no"), action: {
//               
//                
//            })
//            alert1.showCloseButton = false
//            alert1.showError("", subTitle: self.localisation.localizedString(key: "tasks.doyouwanttoreleasepooltasks"))
//            
//            
//        } // end of the pool condition
//        
        
        
        
        
        self.makeActive()
    
    }
    func setupPoolRelease(){
    
        let  releaseUrl = Constants.baseURL + "releaseInspectorPoolTasks?inspector_id=\(self.user.user_id!)"
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        self.appDel.showIndicator = 1
        print(releaseUrl)
        downloader.startDownloader(releaseUrl, idn: "releasepool")

        
    }
    @IBOutlet weak var myLocationBtn: UIButton!
    @IBOutlet weak var btnBottomCons: NSLayoutConstraint!
    @IBOutlet weak var bottomMarginCons: NSLayoutConstraint!
    @IBAction func createInspectionMethod(_ sender: AnyObject) {
//        if self.appDel.user.status != nil {
//            if self.appDel.user.status == "Inactive"  && Reachability.connectedToNetwork(){
//                
//                SCLAlertView().showError(localisation.localizedString(key: "tasks.youareinactive"), subTitle:localisation.localizedString(key: "tasks.inactiveMessage"), closeButtonTitle:localisation.localizedString(key: "tasks.dismiss"))
//                
//                
//                
//                return
//          
//                
//                
//            }
//            
//        }
//        if self.onTheWayTasksCount == 1  && Reachability.connectedToNetwork() {
//            let alert = UIAlertController(title:localisation.localizedString(key:"tasks.createinspection"), message: localisation.localizedString(key: "tasks.You are already on the way, You can not create new inspection "), preferredStyle: UIAlertControllerStyle.Alert)
//            let cancel = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.Cancel, handler: nil)
//            alert.addAction(cancel)
//            self.presentViewController(alert, animated: true, completion: nil)
//            return
//        }

        
       // self.performSegueWithIdentifier("sw_makeSearch", sender: nil)
   let cnt = storyboard?.instantiateViewController(withIdentifier: "cnt_incidentreport") as! IncidentReportViewController
        
       self.navigationController?.pushViewController(cnt, animated: true)
        
    }
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var minmapbtn: NSLayoutConstraint!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var heightofmap: NSLayoutConstraint!
    @IBAction func minmaxMethod(_ sender: AnyObject) {
      
        if UIDevice.current.userInterfaceIdiom == .phone {
            if self.heightofmap.constant == 178 {
                self.heightofmap.constant = 574
                self.minmapbtn.constant = 0
                self.minMap.setImage(UIImage(named: "mapupicon"), for: UIControlState())
                
            }
            else {
                self.heightofmap.constant = 178
                self.minmapbtn.constant = 390
                self.minMap.setImage(UIImage(named: "mapdownicon"), for: UIControlState())
            }
       
        }
        
        if self.heightofmap.constant == 666  {
           self.heightofmap.constant = 0
            self.minmapbtn.constant = 00
            self.minMap.setImage(UIImage(named: "mapupicon"), for: UIControlState())
            
            
        } else if self.heightofmap.constant == 0{
        self.heightofmap.constant = 666
            self.minmapbtn.constant = 660
            self.minMap.setImage(UIImage(named: "mapdownicon"), for: UIControlState())
            

        }
      //  self.mapView.layoutIfNeeded()
      //  self.view.layoutIfNeeded()
        self.view.bringSubview(toFront: self.mapView)
        self.view.bringSubview(toFront: self.menuBtn)
        self.view.bringSubview(toFront: self.createInspectionBtn)
        self.view.bringSubview(toFront: self.myLocationBtn)
        self.view.bringSubview(toFront: self.addTaskBtn)
        self.view.bringSubview(toFront: self.poolBtn)
        self.view.bringSubview(toFront: self.makaniBtn)
        
        
                self.view.bringSubview(toFront: self.minMap)
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [], animations: {
            //Do all animations here
            self.mapView.layoutIfNeeded()
            self.minMap.layoutIfNeeded()
            
            }, completion: {
                //Code to run after animating
                (value: Bool) in
        })
        
        
    }
    @IBOutlet weak var createInspectionBtn: UIButton!
    @IBOutlet weak var addCompanyBtn: UIButton!
    @IBOutlet weak var tasksMessage: UILabel!
    @IBAction func active_inactimeMethod(_ sender: AnyObject)
    {
        if self.onTheWayTasksCount == 1 {
            let alert = SCLAlertView()
            alert.addButton("Cancel 'On MyWay' and Set In Actvie", action: {
               
            })
            alert.addButton("Cancel", action: {
               
                
            })
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.makeActive()
    }
    @IBOutlet weak var active_inactivebtn: UIButton!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var startDateView: UIView!
    var frommethod : Int = 0
    var timer:Timer!
    var buttonClicked : Int! = 0
    var localisation : Localisation!
    let databaseManager = DatabaseManager()
    var locationStatus : Int?   // - 1 for unauthorised and 1 for authorised
    var onTheWayTasksCount : Int = 0
    
    
    @IBOutlet weak var minMap: UIButton!
    @IBAction func backMethod(_ sender: AnyObject) {
        //self.minMap.hidden = true
        return
        print("back method called")
        
        self.view.bringSubview(toFront: self.mapView)
        self.view.bringSubview(toFront: self.minMap)
        self.view.bringSubview(toFront: self.myLocationBtn)
        
        print(self.mapView.frame.height)
        
        self.minMap.setImage(UIImage(named: "doublearrow_up"), for: UIControlState())
//                    UIView.animateWithDuration(0.3, animations: { () ->
//                     //   self.mapView.frame = CGRectMake(20.0, 112.0, 728, 796)
//                        //self.minMap.hidden = false
//                   self.bottomMarginCons.constant = 100
//                    self.mapView.updateConstraints()
//                    })
//
        
        // self.minMap.hidden = true
        if self.bottomMarginCons.constant == 420 {
        self.minMap.setImage(UIImage(named: "doublearrow_up"), for: UIControlState())
            self.bottomMarginCons.constant = 60
            self.btnBottomCons.constant = 80
           
            
            
//            UIView.animateWithDuration(0.3, animations: { () ->
//              //  self.mapView.frame = CGRectMake(20.0, 112.0, 728, 796)
//                //self.minMap.hidden = false
//                self.mapView.layoutIfNeeded()
//            })
//   

        
        }
        else {
        
//        UIView.animateWithDuration(0.3, animations: { () ->
            self.minMap.setImage(UIImage(named: "doublearrow_down"), for: UIControlState())
//            self.mapView.frame = CGRectMake(20.0, 112.0, 728, 796)
//        })

        self.bottomMarginCons.constant = 420
        self.btnBottomCons.constant = 438
            
        }
        //self.mapView.setNeedsDisplay()
    
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [], animations: {
            //Do all animations here
            self.mapView.layoutIfNeeded()
            self.minMap.layoutIfNeeded()
            }, completion: {
                //Code to run after animating
                (value: Bool) in
        })

        
//        UIView.animateWithDuration(0.2, animations: { () ->
//            //  self.mapView.frame = CGRectMake(20.0, 112.0, 728, 796)
//            //self.minMap.hidden = false
//            //self.minMap.hidden = false
//            self.mapView.layoutIfNeeded()
//            self.minMap.layoutIfNeeded()
//        })

    }

    
    var userDefault : UserDefaults = UserDefaults.standard
    
    
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBAction func activeMethod(_ sender: AnyObject) {
 
        //self.makeActive()
    }
    @IBOutlet weak var activeBtn: UIBarButtonItem!
    
    @IBAction func logout(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var dataTable: UITableView!
    var tableArray : NSMutableArray! = NSMutableArray()
    var appDel : AppDelegate!
    var user : UserDao!
    var locationManager: CLLocationManager = CLLocationManager()
    var loc : CLLocationCoordinate2D?
    var locationUploaded : Int = 0 // 0 not sent 1 locations sent
    var isSearching : Int = 0
    
    
    @IBOutlet weak var startDateField: UITextField!
    
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var usernamelbl: UILabel!

    func locationMethod(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //locationManager.distanceFilter = 3.0
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
       // locationManager.startMonitoringSignificantLocationChanges()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      //    self.appDel.fromHistoryToResult = 1
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear called")
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        self.appDel.selectedIndividual = nil
        self.appDel.offlinePermit = nil
        self.appDel.inspectionByIndividual = 0
      //  print("View will appear called")
        
//        if self.appDel.fromCompany == 1 {
//            self.appDel.fromCompany = 0
//            self.dataTable.reloadData()
//           // self.downloadTasks()
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//            
//
//        return
//        }
        self.user = appDel.user
        self.onTheWayTasksCount = 0
        self.appDel.isUnlicense = 0
        self.appDel.completedTask = nil
        
        
        self.appDel.alreadyOnTheWay = 0
        self.buttonClicked = 0
        self.appDel.fromHistoryToResult = 0
        self.appDel.show_result = 0
        self.appDel.totalSpendSecond =  0
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.appDel.selectedDrivers = NSMutableArray()
        self.appDel.selectedVehicles = NSMutableArray()
        
        
        
        
        tasksCounter = 0
     //  if Reachability.connectedToNetwork() {
      //  self.appDel.keepCheckingInternet()
//        self.databaseManager.deleteEverything()
//
//        //self.downloadTasks()
//          self.setUpProfileDownloader()
//            if self.appDel.backfromCheckList == 1 {
//             print("back from checklist")
//                self.appDel.user.status = "active"
//                self.MakeMeActive()
//                let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "lazyTasksDownloader", userInfo: nil, repeats: false)
//            
//            }
//            else {
             // self.downloadTasks()
//
//            
         //   self.dataTable.reloadData()
//            }
            
        
       // self.setupVersionNumber()
        
       // }
            
       // else {
            // DISBALE OFFLINE FOR NOW
//            self.tableArray = NSMutableArray()
//      
       //self.tableArray = NSMutableArray()
       // self.tableArray.addObject("")
//        self.tableArray.addObjectsFromArray(databaseManager.fetchTasks() as [AnyObject])
//        self.appDel.allTasks = self.tableArray
//        self.setupPins()
//        self.dataTable.reloadData()
//        print("Categories \(self.appDel.user.categories)")
//        
            if user.categories != nil {
                if user.categories!.contains("12") {
                    self.addTaskBtn.isHidden = false
                    
                }
                else {
                    self.addTaskBtn.isHidden = true
                    
                }
            } // end of the user.categories

        self.selectedTasks.removeAllObjects()
         self.submitBtnView.isHidden = true
        if Reachability.connectedToNetwork() {
        self.appDel.showIndicator = 1
         self.downloadTasks()
      
            
        }
        else {
            self.tableArray = NSMutableArray()

            self.tableArray.addObjects(from: databaseManager.fetchTasks() as [AnyObject])
            self.appDel.allTasks = self.tableArray
            self.setupPins()
            self.dataTable.reloadData()
        }
        
            
    //    }
      // self.checkActiveInActive()
        
        
        if Reachability.connectedToNetwork() {
        
        }
        else {
            if self.appDel.addedSubvenueCompany != nil && self.appDel.addedSubvenueCompany != ""{
                self.newSearchField.text = self.appDel.addedSubvenueCompany
                self.searchTasks()
            }
            
        }
    
       SyncOfflinePermits().setupOfflinePermits()
       setupInspectorsDownload()
        
    }
//    func makeActive(){
//       
//        var loginUrl : String  = ""
//        if self.appDel.user.status !=  "Inactive" {
//         loginUrl = Constants.baseURL + "activeInactiveInspector?inspector_id=" + user.user_id + "&status=inactive"
//        }
//        else {
//            loginUrl = Constants.baseURL + "activeInactiveInspector?inspector_id=" + user.user_id + "&status=active"
//            
//        }
//        
//        
//        let downloader : DataDownloader = DataDownloader()
//        downloader.delegate = self
//        downloader.startDownloader(loginUrl, idn: "active")
//        
//
//        
//    }
    
    func reloadOfflineTable(){
        self.tableArray = NSMutableArray()
        
        self.tableArray.addObjects(from: databaseManager.fetchTasks() as [AnyObject])
        self.appDel.allTasks = self.tableArray
        self.setupPins()
        self.dataTable.reloadData()

    }
    
    @objc func lazyTasksDownloader(){
        self.downloadTasks()

    }
    
    func checkTimer(){
        if Reachability.connectedToNetwork(){
        self.appDel.showIndicator = 0
        //    self.appDel.keepCheckingInternet()

       self.downloadTasks()
        }
    }
    
    
    func showAppleProgressHUD() {
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            PKHUD.sharedHUD.show()
        
        
    }
    @objc func mapTapped(){
       // print("tap on map")
//       / self.mapView.frame.height = 500
        
         self.minMap.setImage(UIImage(named: "doublearrow_up"), for: UIControlState())
        self.view.bringSubview(toFront: self.mapView)
        self.view.bringSubview(toFront: self.minMap)
         self.view.bringSubview(toFront: self.myLocationBtn)
        self.view.bringSubview(toFront: self.addTaskBtn)
        self.view.bringSubview(toFront: self.poolBtn)
        
        
        self.bottomMarginCons.constant = 60
        self.btnBottomCons.constant = 80
       
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [], animations: {
            //Do all animations here
            self.mapView.layoutIfNeeded()
            self.minMap.layoutIfNeeded()
            }, completion: {
                //Code to run after animating
                (value: Bool) in
        })
        
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            //  self.mapView.frame = CGRectMake(20.0, 112.0, 728, 796)
            //self.minMap.hidden = false
            //self.minMap.hidden = false
           
        })
        self.view.bringSubview(toFront: self.locationlbl)
        self.view.bringSubview(toFront: self.addTaskBtn)
        self.view.bringSubview(toFront: self.poolBtn)
        
        
            }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }


    @IBAction func showHideMenu(_ sender: AnyObject) {
       if self.revealViewController().frontViewPosition == FrontViewPosition.left {
        print("its open")
       // self.overlay.hidden = false
        }
        else {
        print("its not open")
        //self.overlay.hidden = true
        }
    self.revealViewController().revealToggle(animated: true)
    }
    
    func setUpProfileDownloader(){
        if Reachability.connectedToNetwork() {
            self.appDel.showIndicator = 0
            let loginUrl = Constants.baseURL + "getInspectorProfile?user_id=" + self.appDel.user.user_id
            ///print(loginUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "profile")
            
            
            
            
        }
    }

    func setupInspectorsDownload(){
        if Reachability.connectedToNetwork() {
            self.appDel.showIndicator = 0
            let loginUrl = Constants.baseURL + "getInspectorShiftInspectors?inspector_id=" + self.appDel.user.user_id
            ///print(loginUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "inspector")
            
            
            
            
        }
        
    }
    
    
    func uploadToken(){
      
        
       // let installation = PFInstallation.currentInstallation()
          
       // if installation.deviceToken != nil {
        if let token = self.userDefault.object(forKey: "deviceToken") as? String {
            let loginUrl : String  =  Constants.baseURL + "updateToken?inspector_id=" + self.appDel.user.user_id + "&device_token=" + token
            //print(loginUrl)
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "token")
        }
        
    }

    
    
    @IBAction func showPool(_ sender: AnyObject) {
                if self.appDel.user.status != nil {
                    if self.appDel.user.status == "Inactive"  && Reachability.connectedToNetwork(){
        
                        SCLAlertView().showError(localisation.localizedString(key: "tasks.youareinactive"), subTitle:localisation.localizedString(key: "tasks.inactiveMessage"), closeButtonTitle:localisation.localizedString(key: "tasks.dismiss"))
        
        
        
                        return
        
        
                    
                    }
                    
                }
        
    self.performSegue(withIdentifier: "sw_showpool", sender: nil)
    }
    
    
    func checkDistance(){
        if self.appDel.taskDao == nil || self.appDel.userLocation == nil  {
            
            
            return
            
        }
        if self.appDel.taskDao.company == nil {
            return
        }
        if self.appDel.taskDao.category_id != nil {
            for catg in self.appDel.user.configArray {
                
                if let  catgDao = catg as? ConfigurationDao {
                    // print("CATG ID \(self.appDel.taskDao.category_id) config id \(catgDao.category_id)")
                    if catgDao.category_id! == self.appDel.taskDao.category_id! {
                        //print("Both are equal \(catgDao.location_check)")
                        if catgDao.location_check == "0" {
                            self.currentStartBtn?.accessibilityLabel = "enable"
                            
                            self.currentStartBtn?.setBackgroundImage(UIImage(named: "starttask_icon"), for: UIControlState())
                            // print("Enable Enable Enable")
                            //
                            return
                        }
                    }
                    
                } // end of the for loop
            }
        }
        //if self.appDel.taskDao.category_id
        if self.appDel.taskDao != nil && self.appDel.taskDao.company.lat != nil && self.appDel.taskDao.company.lon != nil {
            // print("Lat :\(self.appDel.taskDao.company.lat)")
            // print("Lon :\(self.appDel.taskDao.company.lon)")
            
            
            if ((self.appDel.taskDao.company.lat) as NSString).range(of: "0.0").location ==  NSNotFound && self.appDel.taskDao.company.lat != "0" && ((self.appDel.taskDao.company.lat) as NSString).range(of: ".000").location ==  NSNotFound {
                print("lOCATION vALID")
                
                if  self.appDel.user.status == "on_way"{
                    if Double(self.appDel.taskDao.company.lat) != nil && Double(self.appDel.taskDao.company.lon) != nil
                    {
                        
                        var lat = Double(self.appDel.taskDao.company.lat)
                        var lon = Double(self.appDel.taskDao.company.lon)
                        let loc : CLLocation = CLLocation(latitude: lat!.roundToPlaces(4), longitude:lon!.roundToPlaces(4))
                        /*
                         let lat = Float(self.appDel.userLocation!.latitude)
                         let lon = Float(self.appDel.userLocation!.longitude)
                         
                         
                         let oldLoc:CLLocation = CLLocation(latitude:Double(lat)  ,longitude: Double(lon))
                         */
                        var lat1 =  Double(self.appDel.userLocation!.latitude)
                        var lon1 = Double(self.appDel.userLocation!.longitude)
                        
                        let userLat = lat1.roundToPlaces(4)
                        let userLon = lon1.roundToPlaces(4)
                        
                        let oldLoc:CLLocation = CLLocation(latitude:userLat  ,longitude: userLon)
                        //            let oldLoc:CLLocation = CLLocation(latitude:Double(latStr)!  ,longitude: Double(lonStr)!)
                        let distance:CLLocationDistance = loc.distance(from: oldLoc)
                        if distance <= Double(self.appDel.TASK_RADIUS) && self.currentStartBtn != nil {
                            self.currentStartBtn?.isEnabled = true
                            self.currentStartBtn?.accessibilityLabel = "enable"
                            
                            self.currentStartBtn?.setBackgroundImage(UIImage(named: "starttask_icon"), for: UIControlState())
                            
                        }
                            
                        else  if currentStartBtn != nil {
                            currentStartBtn!.accessibilityLabel = "disable"
                            self.currentStartBtn?.setBackgroundImage(UIImage(named: "disablestartbtn"), for: UIControlState())
                            //cell.startBtn.enabled = false
                            
                            
                            
                        }
                        self.locationlbl.text = String(format : "Distance: %.2f m(s)",distance)
                        
                    }
                    else {
                        self.currentStartBtn?.accessibilityLabel = "enable"
                        
                        self.currentStartBtn?.setBackgroundImage(UIImage(named: "starttask_icon"), for: UIControlState())
                        
                    }
                }
                else {
                    self.currentStartBtn?.accessibilityLabel = "enable"
                    
                    self.currentStartBtn?.setBackgroundImage(UIImage(named: "starttask_icon"), for: UIControlState())
                    
                    print("You are not on the way")
                }
                
                
                //   "Distance to location :\(distance) meters"
                //  self.uploadTheLocation()
            }
            else {
                
                self.currentStartBtn?.accessibilityLabel = "enable"
                
                self.currentStartBtn?.setBackgroundImage(UIImage(named: "starttask_icon"), for: UIControlState())
                
                print("Location not valid")
            }
        }
    }
    
    func setupOnMyTimer(){
        if self.appDel.onMytimer != nil {
        self.appDel.onMytimer?.invalidate()
        self.appDel.onMytimer = nil
            
        }
     //   self.appDel.onMytimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(TasksViewController.checkDistance), userInfo: nil, repeats: true)
        
    }
    
    func setupVersionNumber(){
        if Reachability.connectedToNetwork() {
        self.activityIndicator.startAnimating()
        let versionUrl = Constants.baseURL + "getAppVersion"
        print(versionUrl)
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(versionUrl, idn: "version")
        }
    }
    
    @objc func scrollToTop(){
        dataTable.setContentOffset(CGPoint.zero, animated:false)
        
    }
       override func viewDidLoad() {
        super.viewDidLoad()
        self.selectAllView.isHidden = true
        //databaseManager.deleteAllLogs()
        
        
        //print("View did load called")
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        //self.setupVersionNumber()
        
//        if self.appDel.allTasks.count > 0 {
//        self.tableArray = self.appDel.allTasks
//        self.setupPins()
//        self.dataTable.reloadData()
//        }
//        else {
//            self.appDel.showIndicator = 1
//            self.activityIndicator.startAnimating()
//        }
//        self.downloadTasks()
        
        
        self.activeToggle.onTintColor =  UIColor(red: 34/255, green: 167/255, blue: 240/255, alpha: 1)
        self.navigationItem.hidesBackButton = true
        self.appDel.fromHistoryToResult = 0
        //self.appDel.showIndicator = 1
        self.selectAllView.layer.cornerRadius = 6.0
        
        
     
        
        if Reachability.isConnectedNetwork() {
            if self.databaseManager.fetchAllCountries().count <= 0 {
                
                self.setupCountryDownload()
            }
            
        }
        
        Fabric.with([Crashlytics.self])
        formater.dateFormat = "MMM dd yyyy  hh:mm a"
        if self.appDel.timer == nil {
       // self.appDel.keepCheckingInternet()
        }
//        if self.appDel.fileDownloading == 0 {
//            
//        
//        self.appDel.setupFileDownload()
//        }
        
     
        
        self.navigationItem.rightBarButtonItem = nil
        self.user = appDel.user
   //     self.searchbar.backgroundColor = UIColor(patternImage: UIImage(named: "newsearchbar")!)
//        if self.appDel.userLocation != nil {
//        let loc : CLLocation = CLLocation(latitude: 25.25134922, longitude: 55.34429026)
//            print("lATITUDE \(self.appDel.userLocation!.latitude)")
//        let oldLoc:CLLocation = CLLocation(latitude:self.appDel.userLocation!.latitude  ,longitude: self.appDel.userLocation!.longitude)
//        
//        
//        let distance:CLLocationDistance = loc.distanceFromLocation(oldLoc)
//        self.locationlbl.text = "Distance is \(distance/1000)"
//        
//        }
        

            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_bg")!)
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
          self.localisation.setPreferred("en", fallback: "ar")
          }
        else {
              self.localisation.setPreferred("ar", fallback: "en")
          }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TasksViewController.mapTapped))
      //  self.mapView.addGestureRecognizer(tap)
        //self.searchView.backgroundColor = UIColor(patternImage: UIImage(named: "password_tab")!)
        self.startDateView.backgroundColor = UIColor(patternImage: UIImage(named: "password_tab")!)
        self.tasksMessage.text = localisation.localizedString(key: "tasks.currenttasks")
        self.submitTaskBtn.setTitle(localisation.localizedString(key: "tasks.submitwithoutviolations"), for: UIControlState())
        self.appDel.isUnlicense = 0
        self.appDel.listArray = NSMutableArray()
        
        let listDao = ListDao()
        listDao.list_id =  "9"
        listDao.list_name = "الشركات السياحية"
        listDao.catg_id = "8"
        
        
        self.appDel.listArray.add(listDao)
        
        let listDao1 = ListDao()
        listDao1.list_id =  "10"
        listDao1.list_name = "الرحلات السياحية البرية"
        listDao1.catg_id = "9"
        
        self.appDel.listArray.add(listDao1)
        
        let listDao2 = ListDao()
        listDao2.list_id =  "11"
        listDao2.list_name = "المخيمات السياحية و تصريح الفعاليات"
        listDao2.catg_id = "10"
        self.appDel.listArray.add(listDao2)
        
        
        let listDao3 = ListDao()
        listDao3.list_id =  "13"
        listDao3.list_name = "الارشاد السياحي"
        listDao3.catg_id = "12"
        self.appDel.listArray.add(listDao3)
        
        let listDao4 = ListDao()
        listDao4.list_id =  "14"
        listDao4.list_name = "تفتيش الفعاليات"
        listDao4.catg_id = "13"
        self.appDel.listArray.add(listDao4)
        
        let listDao5 = ListDao()
        listDao5.list_id =  "15"
        listDao5.list_name = "بيوت العطلات"
        listDao5.catg_id = "14"
        self.appDel.listArray.add(listDao5)
        
        let listDao6 = ListDao()
        listDao6.catg_id = "17"
        listDao6.list_id =  "18"
        listDao6.list_name = "الدرهم السياحي"
        self.appDel.listArray.add(listDao6)
        
        let categoryDao99 = ListDao()
        
        categoryDao99.catg_id = "18"
        categoryDao99.list_id = "19"
        
        categoryDao99.list_name = "مخالفات ترخيص وتصنيف"
        self.appDel.listArray.add(categoryDao99)
        
        
        let categoryDao999 = ListDao()
        categoryDao999.catg_id = "20"
        categoryDao999.list_id = "21"
        categoryDao999.list_name = "الرقابة على فعاليات الاعمال وغيرها"
        self.appDel.listArray.add(categoryDao999)
        
        let categoryDao9199 = ListDao()
        categoryDao9199.catg_id = "21"
        categoryDao9199.list_id = "22"
        categoryDao9199.list_name = "DST Check List"
        self.appDel.listArray.add(categoryDao9199)
       
        let categoryDao9299 = ListDao()
            categoryDao9299.catg_id = "22"
            categoryDao9299.list_id = "23"
            categoryDao9299.list_name = "بلدية دبي"
            self.appDel.listArray.add(categoryDao9299)
            
        
        let categoryDao9399 = ListDao()
      
                   categoryDao9399.catg_id = "23"
                   categoryDao9399.list_id = "24"
                   categoryDao9399.list_name = "COVID-19"
        self.appDel.listArray.add(categoryDao9399)
                 

        
        
//        let listDao6 = ListDao()
//        listDao6.list_id =  "15"
//        listDao6.list_name = "Holiday Homes-Deluxe"
//        listDao6.catg_id = "16"
//        self.appDel.listArray.addObject(listDao6)
//        
//        
//        let listDao7 = ListDao()
//        listDao7.list_id =  "16"
//        listDao7.list_name = "Holiday Homes-Standard"
//        listDao7.catg_id = "17"
//        self.appDel.listArray.addObject(listDao7)
        

        
        
        
        
        
//        if ((self.appDel.user.categories?.containsString("12")) != nil) {
//            self.addTaskBtn.hidden = false
//            
//        }
//        else {
//            self.addTaskBtn.hidden = true
//            
//        }
//        
        

        self.endDateView.backgroundColor = UIColor(patternImage: UIImage(named: "password_tab")!)
        
        self.dataTable.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        
        self.newSearchField.placeholder = localisation.localizedString(key: "tasks.searcktasks")
        
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        
        let observer = notificationCenter.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.newSearchField, queue: mainQueue) { _ in
            // print("observer " + self.searchTextField.text!)
         
            //self.searchTasks()
            self.filterCompanyName()
            //let timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "lazyTasksDownloader", userInfo: nil, repeats: true)
            
            
            
           // self.dataTable.reloadData()
        }
        
       
        
        
       //self.timer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: "checkTimer", userInfo: nil, repeats: true)
        let wm = localisation.localizedString(key: "tasks.welcome")
        
       // self.usernamelbl.text = "\(wm) \(self.user.firstname)"
        self.appDel.fromHistoryToResult = 0
        self.searchField.attributedPlaceholder = NSAttributedString(string:localisation.localizedString(key: "tasks.search"),
            attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.startDateField.attributedPlaceholder = NSAttributedString(string:localisation.localizedString(key: "tasks.startdate"),
            attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.endDateField.attributedPlaceholder = NSAttributedString(string:localisation.localizedString(key: "tasks.enddate"),
            attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
        
        self.addCompanyBtn.setTitle(self.localisation.localizedString(key: "tasks.addnewcompany"), for: UIControlState())
       // self.createInspectionBtn.setTitle(self.localisation.localizedString(key: "tasks.createinspection"), forState: UIControlState.Normal)
        self.currentTasksLbl.text = localisation.localizedString(key: "tasks.tasklist")
        self.activelbl.text = localisation.localizedString(key: "task.active")
        
        
        
         self.title = ""
        self.locationMethod()
        let aa = self.userDefault.double(forKey: "lat")
        let bb = self.userDefault.double(forKey: "lon")
        if aa != 0 {
        let location2D : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: aa, longitude: bb)
        print(self.appDel.userLocation)
            self.appDel.userLocation = location2D
            
            self.loc = location2D
             }
        
       
        if self.appDel.user.status != "Inactive" {
             self.title = ""
            self.activeToggle.setOn(true, animated: true)
                   }
        else {
            self.activeToggle.setOn(false, animated: true)
        
            
        }
    
        //self.tableArray = NSMutableArray()
       // self.downloadTasks()
        self.view.bringSubview(toFront: self.createInspectionBtn)
        self.view.bringSubview(toFront: self.addTaskBtn)
        self.view.bringSubview(toFront: self.poolBtn)
        
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        //self.setUpProfileDownloader()
        
        //self.title = "sdfsd"

        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    func setupCountryDownload(){
        let loginUrl = Constants.baseURL + "getCountriesListing"
        
        
        print(loginUrl)
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "country")
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        customView.backgroundColor = UIColor.clear
        return customView
        
    }
    
    
    func filterCompanyName(){
        if self.newSearchField.text == "" {
            self.isCompanySearching = 0
            self.isSearching = 0
            // print("returning textfield is empty")
            self.companyNameArray = NSMutableArray()
            self.selectedTasks = NSMutableDictionary()
            
            self.appDel.addedSubvenueCompany = ""
            self.dataTable.reloadData()
            self.submitBtnView.isHidden = true
            self.selectAllView.isHidden = true
            self.selectAllToggle.isOn = false
            
            
            return
        }
         self.companyNameArray = NSMutableArray()
        
        self.isCompanySearching = 1
        for a in 0  ..< self.tableArray.count  {
            
            let task = self.tableArray.object(at: a) as! TaskDao
            //print("searching for \(self.newSearchField.text!)in\(task.company.company_name)")
            
            if task.company.company_name.lowercased().range(of: self.newSearchField.text!.lowercased()) != nil  || task.company.company_name_arabic.lowercased().range(of: self.newSearchField.text!.lowercased()) != nil {
                var allreadyAdded : Int = 0
                for b in 0 ..< self.companyNameArray.count {
                    let searchedTask = self.companyNameArray.object(at: b) as! TaskDao
                    
                    if task.company.company_name == searchedTask.company.company_name {
                        allreadyAdded = 1
                    }
                    
                }
               
                if allreadyAdded == 0 {
                    self.companyNameArray.add(task)
                }
                else {
                    // print("Already added so dont need to add")
                }
                // print("adding task")
            }// end of the for loop
            else {
                //  print("Not Found \(self.newSearchField.text!)in\(task.company.company_name)")
            }
        }
        self.dataTable.allowsSelection = true
        self.dataTable.reloadData()
        

        
    }
    func searchTasks(){
     //   print("triggered")
        if self.newSearchField.text == "" {
            self.isCompanySearching = 0
            self.isSearching = 0
           // print("returning textfield is empty")
            self.searchArray = NSMutableArray()
            self.dataTable.reloadData()
            self.selectAllView.isHidden = true
            
            
            return
        }
        self.searchArray = NSMutableArray()
        
        self.isCompanySearching = 0
        isSearching = 1
        for a in 0  ..< self.tableArray.count  {
           let task = self.tableArray.object(at: a) as! TaskDao
            //print("searching for \(self.newSearchField.text!)in\(task.company.company_name)")
            
           // print("Searching \(task.company.company_name.lowercaseString.rangeOfString(self.newSearchField.text!) )")
            if self.newSearchField.text! == task.company.company_name || self.newSearchField.text! == task.company.company_name_arabic {
                self.searchArray.add(task)
          
            }// end of the for loop
            else {
           // print("Not Found \(self.newSearchField.text) in \(task.company.company_name)")
            }
        }
       self.dataTable.allowsSelection = true
        self.selectAllView.isHidden = false
        self.dataTable.reloadData()
        //self.searchField.text = ""
        
        

    }
    
    func uploadTheLocation(){
        if self.loc != nil && Reachability.connectedToNetwork(){
            
            let numLat = NSNumber(value: (self.loc!.latitude) as Double as Double)
            let numLon = NSNumber(value: (self.loc!.longitude) as Double as Double)
            self.appDel.showIndicator = 0
            //  let stLat:String = numLat.stringValue
            if user.user_id != nil {
            let loginUrl = Constants.baseURL + "updateInspectorLocation?inspector_id=\(user.user_id!) & latitude= \(numLat.stringValue)&longitude=\(numLon.stringValue)"
           
            
       // let loginUrl = Constants.baseURL + "updateInspectorLocation?inspector_id=" + user.user_id + "&latitude=" + numLat.stringValue + "&longitude=" + numLon.stringValue
            
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "uploadlocation")
            }
        }
    }
    func dataDownloader(_ data: Data) {
       let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
      // print("Response \(str)")
      // print("Data Downloader")
         print("Data downloading the tasks \(Date()) ")
        self.dataDownloaded(NSData(data: data)  as Data as! NSMutableData, identity: "alltasks")
    }

    func downloadTasks(){
        
//        let session = SessionDataDownloader()
//        
//        session.del = self
//        let loginUrl = Constants.baseURL + "getInspectorTaskLists?inspector_id=" + self.appDel.user.user_id
//        print(loginUrl)
//        
//        
//        session.setupSessionDownload(loginUrl, session_id: String(NSDate().dateByAddingTimeInterval(1970)))
//        
//        
//        print("Start downloading the tasks \(NSDate()) ")
//        
//        if self.appDel.allTasks.count <= 0 {
//        self.activityIndicator.startAnimating()
//        }

        
       // self.activityIndicator.startAnimating()
        print("Initiated download at \(Date())")
        var loginUrl : String?
        if self.currentArea != nil {
            
        
            loginUrl = Constants.baseURL + "getInspectorTaskLists?inspector_id=" + user.user_id! + "&area_id=\(self.currentArea!.area_id!)"
        }
        else {
            loginUrl = Constants.baseURL + "getInspectorTaskLists?inspector_id=" + user.user_id!
            
        }
            
            
            print(loginUrl)
         PKHUD.sharedHUD.show()
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        self.appDel.showIndicator = 0
        downloader.startDownloader(loginUrl!, idn: "alltasks")
       // self.activityIndicator.startAnimating()

        
        
        
        
        
    }
    
    func MakeMeActive(){
        // This method is used to make inspector active and inactive on criteria based
        if Reachability.connectedToNetwork() {
            if self.loc != nil {
                if self.loc?.latitude != nil && self.loc?.longitude != nil {
            var loginUrl : String  = ""
            
                loginUrl = Constants.baseURL + "activeInactiveInspector?inspector_id=" + self.appDel.user.user_id + "&status=active&latitude=\(self.loc!.latitude)&longitude=\(self.loc!.longitude)"
                
            
            
            
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "extraactive")
            self.appDel.backfromCheckList = 0
        
                } // end of lat,lon test
            } // end of location check
        
        } // end of the network check
        
        
        

    }
    func checkActiveInActive(){
        
        if self.appDel.user.status == "Inactive" {
        //    self.activeBtn.title = "غير فعالة"
        //self.active_inactivebtn.setTitle("غير فعالة", forState: UIControlState.Normal)
            //self.active_inactivebtn.setTitle(localisation.localizedString(key: "tasks.makemeinactive"), forState: UIControlState.Normal)
            
            // self.active_inactivebtn.setTitle("Make me Inactive", forState: UIControlState.Normal)
            //self.active_inactivebtn.setTitle("Make me Inactive", forState: UIControlState.Normal)
            self.title = ""
            self.activeToggle.setOn(true, animated: true)
            //self.userDefaults.objectForKey("status") as? String
            
            // self.active_inactivebtn.backgroundColor = UIColor(red: 105/255, green: 173/255, blue: 227/255, alpha: 1)
            self.appDel.user.status = "Active"
            self.userDefault.set(self.appDel.user.status, forKey: "status")
            
         self.dataTable.reloadData()
            
            
        }
        else  {
         //   self.activeBtn.title = "فعال"
          //  self.active_inactivebtn.setTitle("فعال", forState: UIControlState.Normal)
          //  self.active_inactivebtn.setTitle(localisation.localizedString(key: "tasks.makemeactive"), forState: UIControlState.Normal)
            
            //  self.active_inactivebtn.setTitle("Make me active", forState: UIControlState.Normal)
           // navigationController!.navigationBar.barTintColor = UIColor.redColor()
           //self.title = "You are Inactive"
          // self.title = localisation.localizedString(key: "tasks.youareinactive")
           // navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
            self.appDel.user.status = "Inactive"
            self.userDefault.set(self.appDel.user.status, forKey: "status")
            
            self.activeToggle.setOn(false, animated: true)
            // self.downloadTasks()
            self.dataTable.reloadData()
            
            //self.active_inactivebtn.backgroundColor = UIColor.redColor()
        }
      self.appDel.userDefault.synchronize()
        
    }
    
    
    
    @objc func calloutBtnPressed(_ sender : ADButton) {
        if self.appDel.user.status == "Inactive" {
            return
        }
        self.appDel.taskDao = sender.taskDao
        
        self.performSegue(withIdentifier: "sw_company", sender: nil)
        
    }
    func zoom() {
        if self.appDel.userLocation != nil {
        let region = MKCoordinateRegionMakeWithDistance(self.appDel.userLocation!, 10000, 10000)
        self.mapView.setRegion(region, animated: true)
        }
        }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        checkSpan()
    }
    
    func checkSpan() {
        let rect = self.mapView.visibleMapRect
        let westMapPoint = MKMapPointMake(MKMapRectGetMinX(rect), MKMapRectGetMidY(rect))
        let eastMapPoint = MKMapPointMake(MKMapRectGetMaxX(rect), MKMapRectGetMidY(rect))
        
        let distanceInMeter = MKMetersBetweenMapPoints(westMapPoint, eastMapPoint)
        
        if distanceInMeter > 50000 {
            zoom()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        let reuseId = "pin"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
      
        if anView == nil {
        anView = MKAnnotationView(annotation:annotation , reuseIdentifier: reuseId)
        }
    
        
        let deleteButton = ADButton(type: UIButtonType.infoDark)
        deleteButton.frame.size.width = 44
        deleteButton.frame.size.height = 44
        if let ann = annotation as? ColorPointAnnotation {
     
            
        deleteButton.taskDao = ann.task
         deleteButton.addTarget(self, action: #selector(TasksViewController.calloutBtnPressed(_:)), for: UIControlEvents.touchUpInside)
        //deleteButton.backgroundColor = UIColor.redColor()
       
        }
        
       anView!.rightCalloutAccessoryView = deleteButton

        
        
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
      //  print("Annotation view selected")
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //print("call out tapped")
        //if let ann = view.annotation as? ColorPointAnnotation {
          //  self.appDel.taskDao = ann.task
            
          //  self.performSegueWithIdentifier("sw_company", sender: nil)
            

            
        //}
    }
    @objc func showPermit(_ sender : UIButton) {
        if self.isSearching == 1 {
            self.appDel.taskDao = self.searchArray.object(at: sender.tag) as! TaskDao
            
        }
        else {
            self.appDel.taskDao = self.tableArray.object(at: sender.tag) as! TaskDao
            
        }
        
        self.appDel.selectedPermit = self.appDel.taskDao.permitDao
        let cnt = storyboard?.instantiateViewController(withIdentifier: "cnt_fileview") as? FileViewController
        self.navigationController?.pushViewController(cnt!, animated: true)

    }
    
    @objc func companyTapped(_ sender :UIButton){
        if self.appDel.user.status == "Inactive" {
        return
        }
        
       // print(sender.tag)
        
        if self.isSearching == 1 {
            self.appDel.taskDao = self.searchArray.object(at: sender.tag) as! TaskDao
            
        }
        else {
            self.appDel.taskDao = self.tableArray.object(at: sender.tag) as! TaskDao
            
        }
      //  self.appDel.taskDao = self.tableArray.objectAtIndex(sender.tag) as! TaskDao
        self.performSegue(withIdentifier: "sw_company", sender: nil)
//        if self.appDel.taskDao.permitDao != nil  {
//            self.appDel.selectedPermit = self.appDel.taskDao.permitDao
//            let cnt = storyboard?.instantiateViewControllerWithIdentifier("cnt_fileview") as? FileViewController
//            self.navigationController?.pushViewController(cnt!, animated: true)
//            
//        }
//        else {
//        
//        
//        self.performSegueWithIdentifier("sw_company", sender: nil)
//        }
        
    }
    
 
    
    func setupPins(){
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        var oneLoc : CLLocationCoordinate2D?
        
        for item in self.tableArray {
            if let task = item as? TaskDao {
                if task.company.lat != nil && task.company.lon != nil {
                }
                else {
                    continue
                }
                //if (task.company.lat as NSString).intValue >= -84 && (task.company.lat as NSString).intValue <= 84 && (task.company.lon as NSString).intValue >= -179 && (task.company.lon as NSString).intValue <= 179{
                
                
                
                //if task.company.lat != nil && task.company.lat != "0.00000000" && ((task.company.lat) as NSString).rangeOfString(".000").location ==  NSNotFound {
                if Util.validateCoordinates(task.company.lat, lon: task.company.lon) {
                    let companylocation = CLLocationCoordinate2DMake((task.company.lat as NSString).doubleValue, (task.company.lon as NSString).doubleValue)
                    // Drop a pin
                    //print("Task priority \(task.priority)")
                    
                    let dropPin = ColorPointAnnotation()
                    dropPin.task = task
                    
                    dropPin.imageName = "pingreen"
                    //  print("Lat: \(task.company.lat)")
                    // print("Lon: \(task.company.lon)")
                    
                    
                    dropPin.coordinate = companylocation
                    
                    if self.appDel.selectedLanguage == 1 && task.company.company_name != nil {
                        // cell.company.setTitle(tasksDao.company.company_name, forState: UIControlState.Normal)
                        dropPin.title = task.company.company_name
                        
                    }
                    else  if  self.appDel.selectedLanguage == 2 && task.company.company_name_arabic != nil {
                        
                        // cell.company.setTitle(tasksDao.company.company_name_arabic, forState: UIControlState.Normal)
                        dropPin.title = task.company.company_name_arabic
                        
                    }
                    else {
                        //cell.company.setTitle(task.company.company_name, forState: UIControlState.Normal)
                        //
                        dropPin.title = task.company.company_name
                    }
                    
                    
                    // dropPin.title = task.company.company_name
                    
                    mapView.addAnnotation(dropPin)
                    
                    
                    
                    
                    oneLoc = companylocation
                    
                }
                
            }
        }
        
        if oneLoc != nil {
            
            let region = MKCoordinateRegionMakeWithDistance(oneLoc!, 20000, 20000)
            
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
                        /// 28/06/2016 this line added when tapping on dismiss was make buttons enable
                        self.appDel.user.status =  "Inactive"
                        self.makeActive()
                        //////
                        self.performSegue(withIdentifier: "sw_questionlist", sender: nil)
                    })
                    
                    
                }// end of the if
                
            }
            listAlert.addButton(localisation.localizedString(key: "tasks.dismiss"), action: {
                
            })
            
            
            listAlert.showInfo("Pool Task", subTitle: self.localisation.localizedString(key:"tasks.pleaseselectinspectiontype"))
            

        } // if categories in company are not availabe
        else {
            let catgIdArray = (self.appDel.user.categories as? NSString)?.components(separatedBy: ",") as! NSArray
            
            for catg in self.appDel.listArray  {
                if let lDao = catg as? ListDao {
                    
                    for userCatg in catgIdArray {
                        if let userCatg1 = userCatg as? String {
                            if userCatg1 == lDao.catg_id {
                                listAlert.addButton(lDao.list_name!, action: {
                                    self.appDel.list_id = lDao.list_id!
                                    self.appDel.taskDao.list_id = lDao.list_id!
                                    self.performSegue(withIdentifier: "sw_questionlist", sender: nil)
                                    
                                })
                            }
                        }
                    }
                }// end of the if
            } // end of the for loop
            
            
            
            listAlert.addButton(localisation.localizedString(key: "tasks.dismiss"), action: {
           //   self.downloadTasks()
            })
            
            
            listAlert.showInfo("Pool Task", subTitle: self.localisation.localizedString(key:"tasks.pleaseselectinspectiontype"))
    
    }
   
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        
        PKHUD.sharedHUD.hide(true)
        
        if identity == "version" {
            let parser = JsonParser()
            let serverVersion : String? = parser.parseVersionNumber(data)
            if serverVersion != nil  {
                if serverVersion! != "N/A" {
                    print("Server version \((serverVersion! as NSString).doubleValue) app Version \((Constants.versionNumber as NSString).doubleValue)")
                    if (serverVersion! as NSString).doubleValue <= (Constants.versionNumber as NSString).doubleValue {
                                self.databaseManager.deleteEverything()
                        
                                //self.downloadTasks()
                                  self.setUpProfileDownloader()
                                    if self.appDel.backfromCheckList == 1 {
                                     print("back from checklist")
                                        self.appDel.user.status = "active"
                                        self.MakeMeActive()
                                        // This timer is very important , main function of this timer is load tasks once last permoformed task is submitted , normally what  its submitted
                                        
                                        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TasksViewController.lazyTasksDownloader), userInfo: nil, repeats: false)
                                    
                                    }
                                    else {
                                        self.downloadTasks()
                        
                                    
                                    }

                    }
                    else {
                        let alert = SCLAlertView()
                        alert.addButton("Download", action: {
                            if Constants.mode == 1 {
                                UIApplication.shared.openURL(URL(string: "https://imsuat.dtcm.gov.ae/app/index.html")!)
                            }
                            else {
                                UIApplication.shared.openURL(URL(string: "https://ims.dtcm.gov.ae/app/index.html")!)
                                
                            }
                        })
                        alert.showCloseButton = false
                        alert.showError("Old App Version", subTitle: "To Continue , please download latest version(\(serverVersion!)) of the app")
                        

                    }//  end of the else
                } // end if the N/A
            } // end of the server version
                    return
            
        }
        
        var tempArray : NSMutableArray = NSMutableArray()
        // so now download tasks and make inspector
        if identity == "tasksstatus" {
            self.onTheWayTasksCount =  0
            self.appDel.alreadyOnTheWay =  0
            self.appDel.user.status =  "Inactive"
            self.appDel.taskDao.task_status = "Not Started"
            self.databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status:self.appDel.taskDao.task_status)
            
            
            
            self.makeActive()
          //  self.databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status: "Not Started")
            self.dataTable.reloadData()
            //self.downloadTasks()
            
            return
        }
        
        if identity == "active" {
//            if self.appDel.user.status ==  "Inactive" {
//            self.appDel.user.status = "Active"
//            }
//            else {
//            self.appDel.user.status =  "Inactive"
//            }
//
             self.checkActiveInActive()
           // self.setUpProfileDownloader()
            return
            
        }
        if identity == "onMyWay" {
            self.appDel.showIndicator = 0
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            if (str?.contains("success") != nil) {
            print("Successfully status updated")
                databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status: "on_way")
                 if Reachability.connectedToNetwork() {
                    self.appDel.user.status = "on_way"
                    self.appDel.taskDao.task_status = "on_way"
                    self.databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status:self.appDel.taskDao.task_status)
                    
                    dataTable.reloadData()
                    //self.downloadTasks()
                }
                
            }
        return
        }
        if identity == "zoneOnMyWay" {
        
            self.appDel.showIndicator = 0
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            if (str?.contains("success") != nil) {
                print("Successfully status updated")
        //        databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status: "on_way")
                if Reachability.connectedToNetwork() {
                    self.appDel.user.status = "on_way"
                    self.appDel.taskDao.task_status = "on_way"
                    self.appDel.taskDao.zoneStatus = "on_way"
                    
                   // self.databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status:self.appDel.taskDao.task_status)
                    
                    dataTable.reloadData()
                    //self.downloadTasks()
                }
                
            }
            return

            
            
        }
        if identity == "cancelOnMyWayZone" {
            self.onTheWayTasksCount =  0
            self.appDel.alreadyOnTheWay =  0
            self.appDel.user.status =  "Actvie"
            self.appDel.taskDao.task_status = "Not Started"
            self.appDel.taskDao.zoneStatus = "Not Started"
            self.dataTable.reloadData()
            self.appDel.onMyWayTask = nil
        
        }
        if identity == "cancelOnMyWayZoneActive" {
        self.makeActive()
          self.appDel.onMyWayTask = nil
        }
        if identity == "zoneStarted" {
            self.appDel.showIndicator = 0
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            if (str?.contains("success") != nil) {
                print("Successfully status updated")
                //        databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status: "on_way")
                if Reachability.connectedToNetwork() {
                    self.appDel.user.status = "active"
                    self.appDel.taskDao.task_status = "started"
                    self.appDel.taskDao.zoneStatus = "started"
                    
                    // self.databaseManager.changeOnMyWayStatus(self.appDel.taskDao.task_id, status:self.appDel.taskDao.task_status)
                    
                    dataTable.reloadData()
                    //self.downloadTasks()
                }
                
            }
            return

            
        }
        if identity == "completezone" {
        self.appDel.currentZoneTask = nil
           
            
        self.downloadTasks()
            
        }
        
        if identity == "uploadlocation" {
           self.locationUploaded = 1
            print(self.buttonClicked, terminator: "")
            
            if self.frommethod == 1 {}
            else if self.buttonClicked == 1 {
                if self.appDel.taskDao.parent_task_id != nil {
                if (self.appDel.taskDao.parent_task_id! as NSString).intValue > 1 {
                    self.appDel.show_result = 1
                    }
                    self.performSegue(withIdentifier: "sw_questionlist", sender: nil)

                }
                    // comment this to hide Category alert.
                    
                else if self.appDel.taskDao.is_pool == "1"{
                    if self.appDel.taskDao.is_pool != nil {
                        if self.appDel.taskDao.is_pool! == "0" {
                            self.performSegue(withIdentifier: "sw_questionlist", sender: nil)
                        }
                        else if self.appDel.taskDao.is_pool == "1" {
                                                        // end of the for loop
                            
                            self.setupCatgAlert()
                        }
                    }

                }
                else {
                 self.performSegue(withIdentifier: "sw_questionlist", sender: nil)
                }
                }
                
        }
            
        if identity == "profile" {
            let parser = JsonParser()
            let str = String(data: data as Data, encoding: .utf8)
           print(str)
            
            
            let user : UserDao = parser.parseProfileData(data)
            //print("Config Count \(user.configArray.count)")
            
            if user.user_id != nil {
                //print(self.appDel.user.status)
                //print(user.status)
                
                self.appDel.user = user
                if self.appDel.user.task_radius != nil {
                    if (Int(self.appDel.user.task_radius!) != nil) {
                    
                 self.appDel.TASK_RADIUS = Int(self.appDel.user.task_radius!)!
                    }
                }
                if user.categories != nil {
                    
                      self.userDefaults.set(user.categories, forKey: "categories")
                    self.userDefaults.synchronize()
                // For Tourist Guide 
                    
                if user.categories!.contains("12") {
                    self.addTaskBtn.isHidden = false
                    
                }
                else {
                    self.addTaskBtn.isHidden = true
                    
                }
                    
                    
                }
                
                
               //print("Status\(self.appDel.user.status)")
                if self.appDel.user.status == "Inactive" {
                self.activeToggle.setOn(false, animated: true)
                }
                else {
                self.activeToggle.setOn(true, animated: true)
                }
                
                
            }
            
                
            else if user.response != nil {
                if user.response == "logout"{
                    
                    //self.appDel.userDefaults.removeObjectForKey("username")
                    //self.appDel.userDefaults.removeObjectForKey("lang")
                    
                    //let cnt = self.storyboard?.instantiateViewControllerWithIdentifier("cnt_startnav") as! UINavigationController
                    //self.presentViewController(cnt, animated: true, completion: nil)
                    
                    print("Used id is nil")
                }
            }

        
        }
            
            
        else if identity == "token" {
        //print("device token uploaded")
        }

        else  if identity == "alltasks"{
             print("Tasks downloaded at \(Date())")
            self.uploadToken()
            self.setUpProfileDownloader()
            
           
            onTheWayTasksCount = 0
            checkTaskOnWay = 0
            is_pool = 0
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            print("In parser : \(str)")
            self.appDel.alreadyOnTheWay = 0
             DispatchQueue.main.async {
            let parser : JsonParser = JsonParser()
            tempArray = parser.parseTasks(data)
            for a in 0  ..< tempArray.count  {
            let task = tempArray.object(at: a) as! TaskDao
                if self.appDel.taskDao != nil && task.task_id != nil  {
                if self.appDel.taskDao.task_id == task.task_id {
                task.task_status = self.appDel.taskDao.task_status
                }
                }
                if task.task_status == "on_way" {
                    
                self.checkTaskOnWay = 1
                self.appDel.user.status = "on_way"
                }
                }
            
            
            
            
            if self.checkTaskOnWay == 1 {
            self.appDel.user.status = "on_way"
            }
             else if self.appDel.user.status != "Inactive" && self.appDel.user.status != "on_way" {
            self.appDel.user.status = "active"
            }
             print(self.appDel.user.status )
                
                
            if tempArray.count == 0 {
            self.activityIndicator.stopAnimating()
            }
            self.appDel.taskCount = tempArray.count
            
           
            
           
            // downlod questions per task
         
           self.downloadQuestionsForAllTasks(tempArray)
                
              self.tableArray = tempArray
              self.appDel.allTasks = tempArray
               UIApplication.shared.applicationIconBadgeNumber = self.tableArray.count
              self.activityIndicator.stopAnimating()
         //  dispatch_async(dispatch_get_main_queue()) {
                self.dataTable.reloadData()
          //      }
                
             self.setupPins()

           // self.tableArray = tempArray
               self.databaseManager.deleteAllTasks()
               self.databaseManager.addTasks(self.tableArray)
                self.downloadQuestionsForAllTasks(tempArray)
                
                
            
                if self.newSearchField.text != "" {
                    self.isSearching = 1
                    self.searchTasks()
                    
                } //
                
            if self.appDel.addedSubvenueCompany != nil && self.appDel.addedSubvenueCompany != ""{
            self.newSearchField.text = self.appDel.addedSubvenueCompany
            self.searchTasks()
                }
            }
            
            self.dataTable.scrollToBottom(animated: false)
            let timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(scrollToTop), userInfo: nil, repeats: false)
            //}
            
        }
        else if identity == "releasepool" {
            self.downloadTasks()

        }
        
        else if identity == "submittask" {
            
            let str = String(data: data as Data, encoding: String.Encoding.utf8)
            print(str)
                 //    self.downloadTasks()
        }
        
        else if identity == "country" {
            
            let parser = JsonParser()
            let str = String(data: data as Data, encoding: String.Encoding.utf8)
            print(str)
            
            self.appDel.allCountries = parser.parserCountries(data)
            self.databaseManager.addCountries(self.appDel.allCountries)
            print("Number of countries \(self.appDel.allCountries)")
            
            
            
            
        }
        else if identity == "inspector" {
            let parser = JsonParser()
            parser.user_id = self.appDel.user.user_id
            let str = String(data: data as Data, encoding: String.Encoding.utf8)
            print(str)
            var inspectorsArray = parser.parseInspectors(data)
            databaseManager.addInspectors(allInspectors: inspectorsArray)
        }// end of the identity
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
        }
    }
   
    
    func downloadAllQuestionListForSingleTask(_ task : TaskDao) {
    
        self.databaseManager.deleteAllQuestion()
        self.databaseManager.deleteAllOptions()
        self.databaseManager.deleteAllExtraOptions()
        
        let loginUrl = "\(Constants.baseURL)getTaskQuestionList?list_id=\(task.list_id!)&task_id=\(task.task_id!)&show_result=1&user_id=\(self.appDel.user.user_id!)&state=offline"
        
        //let loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + task.list_id + "&task_id=" + task.task_id + "&show_result=1&user_id=\(self.appDel.user.user_id)&state=offline"
        
        
        print(loginUrl, terminator: "")
        if let imageUrl = URL(string: loginUrl) {
            let imageRequest: URLRequest = URLRequest(url: imageUrl)
            let queue: OperationQueue = OperationQueue.main
            var error : NSError?
            
            var response : URLResponse?
            let data: Data?
            do {
                
                self.showAppleProgressHUD()
                data = try NSURLConnection.sendSynchronousRequest(imageRequest, returning: &response)
            } catch  {
                //error = error1
                data = nil
            }
            if data != nil {
                
                let parser : JsonParser = JsonParser()
                let array  = parser.parseQuestions(NSMutableData(data: data!))
                if array.0.count == 0 {
                    print(" 0 Array count \(array.0.count)")
                    return
                    
                }
                else {
                    
                    print("Array count \(array.0.count)")
                    self.databaseManager.addInspectionList(array.0, taskid: task.task_id)
                }
                if array.1.count > 0 {
                    self.databaseManager.addCategories(questionCategories: array.1)
                    
                }
                
            }
        }
        
        
        
    }
    func downloadAllQuestionListForTask(_ allTasks : NSMutableArray){
//        self.databaseManager.deleteAllQuestion()
//        self.databaseManager.deleteAllOptions()
//        self.databaseManager.deleteAllExtraOptions()
//        
        self.appDel.showIndicator = 0
        for task in allTasks {
            if let t1 = task as? TaskDao {
               // if self.databaseManager.isQuestionsAvailableOnTasks(t1.task_id) && (t1.parent_task_id! as NSString).intValue <= 1 && t1.inspection_type != "co-inspection"{
                    print(t1.task_id)
                
                if self.databaseManager.isQuestionsAvailableOnTasks(t1.task_id)  {
                    self.activityIndicator.stopAnimating()

                }
                else {
                    if t1.isZoneTask == 1 {
                    continue
                    }
                
                //let loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + t1.list_id + "&task_id=" + t1.task_id + "&show_result=1&user_id=" + self.appDel.user.user_id + "&state=offline"
                    let loginUrl = "\(Constants.baseURL)getTaskQuestionList?list_id=\(t1.list_id!)&task_id=\(t1.task_id!)&show_result=1&user_id=\(self.appDel.user.user_id!)&state=offline"
                    
                    //let loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + t1.list_id + "&task_id=" + t1.task_id + "&show_result=1&user_id=" + self.appDel.user.user_id + "&state=offline"
                    
                
               print(loginUrl, terminator: "")
               print("  ")
                if let imageUrl = URL(string: loginUrl) {
                    let imageRequest: NSMutableURLRequest = NSMutableURLRequest(url: imageUrl)
                    imageRequest.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
                    
                    let queue: OperationQueue = OperationQueue.main
                    var error : NSError?
                    
                    var response : URLResponse?
                    let data: Data?
                    do {
                       // self.appDel.showIndicator = 1
                       // self.showAppleProgressHUD()
                        
                        
                        data = try NSURLConnection.sendSynchronousRequest(imageRequest as URLRequest, returning: &response)
                    } catch  {
                       // error = error1
                        data = nil
                    }
                    if data != nil {
                       // let str = NSString(data: NSMutableData(data: data!), encoding: NSUTF8StringEncoding)
                        //print(str)
                        
                    
                        let parser : JsonParser = JsonParser()
                                                    let array  = parser.parseQuestions(NSMutableData(data: data!))
                                                    if array.0.count == 0 {
                                                        
                                                          print("Retuning arrya has no value")
                                                        return
                        
                                                    }
                                                    else {
                                                        
                                                    self.databaseManager.addInspectionList(array.0, taskid: t1.task_id)
                                                     self.databaseManager.saveAllData()
                                                 self.activityIndicator.stopAnimating()
                                                        
                                                      
                                                    
                        }

                    
                    }
                    else {
                    print("Data is nill")
                    }
                    
                
            }
                }
                }
            
    }
        
        print("Hide in task")
        
        PKHUD.sharedHUD.hide(animated: false)

    }
    // This method is added on 5/3/2016
    // To download Question List Asynchronously
    // Pragma Mark:
    
    func downloadQuestionsForAllTasks(_ allTasks : NSMutableArray){
        //var tasksCounter : Int = 0
         self.tasksToDownload = allTasks
        print(allTasks.count)
        print(tasksCounter)
        
        if allTasks.count > 0 && allTasks.count > tasksCounter  {
            
            if let task = allTasks.object(at: tasksCounter) as? TaskDao {
                if task.isZoneTask == 1 {
                return
                }
                if self.databaseManager.isQuestionsAvailableOnTasks(task.task_id) {
                  //  print("Question available for \(task.task_id)")
                    tasksCounter += 1
                    self.downloadQuestionsForAllTasks(self.tasksToDownload)
                }
                else {
                
//                let loginUrl = Constants.baseURL + "getTaskQuestionList?list_id=" + task.list_id + "&task_id=" + task.task_id + "&show_result=1&user_id=" + self.appDel.user.user_id + "&state=offline"
                    let loginUrl = "\(Constants.baseURL)getTaskQuestionList?list_id=\(task.list_id!)&task_id=\(task.task_id!)&show_result=1&user_id=\( self.appDel.user.user_id!)&state=offline"

            
            
        print("downloadQuestionsForAllTasks \(loginUrl)")
         let generalSesson = QuestionListSessionDownloader()
          generalSesson.del = self
        generalSesson.setupSessionDownload(loginUrl, session_id: task.task_id, iden: "singleTask",task_id: task.task_id)
                }
        }
        }
        
    }// end of the downloadQuestionsForAllTasks
    
    func questionListDataDownloader(_ data: Data, identity: String, task_id: String) {
        if identity == "singleTask" {
        
            let parser : JsonParser = JsonParser()
            let str = String(data: data, encoding: String.Encoding.utf8)
            print("Single task downlaoded \(str)")
            let array  = parser.parseQuestions(NSMutableData(data: data))
            if array.0.count == 0 { return  }
            else {
                print("Questions With task_id \(task_id) atr  \(array.0.count)")
                self.databaseManager.addInspectionList(array.0, taskid: task_id)
                self.databaseManager.saveAllData()
                
                
            } // end of the else
            self.tasksCounter += 1
            
            if self.tasksToDownload.count > self.tasksCounter  {
            
                self.downloadQuestionsForAllTasks(self.tasksToDownload)
            
            }
        }// end of the single task
    }// end of the method
    
    
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == tableView.indexPathsForVisibleRows?.last  {
//          //  self.databaseManager.deleteAllTasks()
//          //  self.databaseManager.addTasks(self.tableArray)
//          //  print("Data added in database")
//            
//        }
//    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func startZoneTask(_ sender : UIButton) {
    
        if self.appDel.user.status != nil {
           
            
            if self.appDel.user.status == "Inactive" {
                //  tasks.youareinactive
                let alertController = UIAlertController(title:localisation.localizedString(key: "tasks.youareinactive"), message:localisation.localizedString(key: "tasks.inactiveMessage"), preferredStyle: UIAlertControllerStyle.alert)
                let cancel = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(cancel)
                self.present(alertController, animated: true, completion: nil)
                return
                
            }
            
        }
        
        if self.isSearching == 1 {
            self.appDel.taskDao = self.searchArray.object(at: sender.tag) as! TaskDao
          
            
            
        }
        else {
            self.appDel.taskDao = self.tableArray.object(at: sender.tag) as! TaskDao
            
            
        }
        
        print( self.appDel.taskDao.parent_zone_status)
        
        if  self.appDel.taskDao.parent_zone_status == "inactive" {
        let alert : UIAlertController = UIAlertController(title:"Zone is Inactive", message: "This zone is inactive,Please contact your supervisor for more info.", preferredStyle: UIAlertControllerStyle.alert)
        let action1 : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
        return
        
        }
        
        if Reachability.connectedToNetwork() {
        
        
        
        }
        
        else if self.appDel.currentZoneTask?.zoneStatus == "started" {
            print(self.appDel.currentZoneTask?.zoneStatus)
            print(self.appDel.currentZoneTask?.zone_id)
            print(self.appDel.currentZoneTask?.zone_name)
            
            
            
//            let alertController = UIAlertController(title: "Zone", message:"Do you want to Complete Zone", preferredStyle: UIAlertControllerStyle.Alert)
//            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil)
//            alertController.addAction(cancel)
//            let start = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.Default, handler: {
//                action in
//                
//               // self.databaseManager.chaneZoneStatus(self.appDel.taskDao)
//                self.databaseManager.changeStatus(self.appDel.taskDao.task_id)
//                self.dataTable.reloadData()
//                print("Start task no intenet")
//                
//                })
//            
//            alertController.addAction(start)
//            self.presentViewController(alertController, animated: true, completion: nil)
            
            self.completeZone(sender)
           return
        
        }
    
        
        let alertController = UIAlertController(title: "Zone", message:"Do you want to start zone?", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancel)
        let start = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.default, handler: {  Void in
       
            
            if self.isSearching == 1 {
                self.appDel.taskDao = self.searchArray.object(at: sender.tag) as! TaskDao
                self.appDel.currentZoneTask = self.appDel.taskDao
                self.appDel.currentZoneTask?.zoneStatus = "started"
                
                
            }
            else {
                self.appDel.taskDao = self.tableArray.object(at: sender.tag) as! TaskDao
                self.appDel.currentZoneTask = self.appDel.taskDao
                self.appDel.currentZoneTask?.zoneStatus = "started"
                
            }
            self.onTheWayTasksCount = 0
            
            if Reachability.connectedToNetwork() {
                
                // when u are inactive you can not start the task
                
                
                if self.onTheWayTasksCount == 1  && self.appDel.taskDao.task_status != "on_way" {
                    
                    
                    let alertController = UIAlertController(title:self.localisation.localizedString(key: "tasks.starttask"), message:"tasks.You can start on task at a time", preferredStyle: UIAlertControllerStyle.alert)
                    let cancel = UIAlertAction(title: self.localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
                    alertController.addAction(cancel)
                    self.present(alertController, animated: true, completion: nil)
                    return
                    
                    
                }
                else {
                    if self.loc != nil{
                        
                        let numLat = NSNumber(value: (self.loc!.latitude) as Double as Double)
                        let numLon = NSNumber(value: (self.loc!.longitude) as Double as Double)
                        //  let stLat:String = numLat.stringValue
                        self.appDel.showIndicator = 1
                        let loginUrl = Constants.baseURL + "updateZoneAssignmentStatus?inspector_id=" + self.user.user_id + "&zone_id=\(self.appDel.taskDao.task_id!)&latitude=" + numLat.stringValue + "&longitude=" + numLon.stringValue + "&status=started"
                        let downloader : DataDownloader = DataDownloader()
                        downloader.delegate = self
                        downloader.startDownloader(loginUrl, idn: "zoneStarted")
                    }
                    
                }// end if the else
                
                
            } // end if the internetcheck
            else
            {
                
               self.databaseManager.chaneZoneStatus(self.appDel.taskDao)
                self.tableArray = NSMutableArray()
                
                self.tableArray.addObjects(from: self.databaseManager.fetchTasks() as [AnyObject])
                self.appDel.allTasks = self.tableArray
                self.dataTable.reloadData()

                
                              print("Start task no intenet")
                
            }
 
        
            
        })
        
        alertController.addAction(start)
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
        
            } // end of the start zone
    
    
    
    
    func informUser(){
        let alert = UIAlertController(title: "Co-Inspection", message: "Task(s) are not submitted by first inspector", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }

    
    
    
    @objc func startTasks(_ sender : UIButton){
        
        
        if self.appDel.taskDao.is_submitted == "0" {
            self.informUser()
            return
        }


        
        print("Start task Pressed")
        
        if sender.accessibilityLabel == "disable" {
            SCLAlertView().showError("", subTitle:localisation.localizedString(key: "tasks.youcanstarttask"), closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
            

        
            
            return
            
        }
        if self.isSearching == 1 {
            self.appDel.taskDao = self.searchArray.object(at: sender.tag) as! TaskDao
            
        }
        else {
            self.appDel.taskDao = self.tableArray.object(at: sender.tag) as! TaskDao
            
        }
        self.appDel.list_id = self.appDel.taskDao.list_id
        
        if Reachability.connectedToNetwork() {
        
        // when u are inactive you can not start the task
            
            if self.appDel.user.status != nil {
            if self.appDel.user.status == "Inactive" && !self.activeToggle.isOn{
          //  tasks.youareinactive
          let alertController = UIAlertController(title:localisation.localizedString(key: "tasks.youareinactive"), message:localisation.localizedString(key: "tasks.inactiveMessage"), preferredStyle: UIAlertControllerStyle.alert)
            let cancel = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
            return
            
        }
                
            }
            

            if self.onTheWayTasksCount == 1  && self.appDel.taskDao.task_status != "on_way" {
                
                
                let alertController = UIAlertController(title:localisation.localizedString(key: "tasks.starttask"), message:"tasks.You can start on task at a time", preferredStyle: UIAlertControllerStyle.alert)
                let cancel = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(cancel)
                self.present(alertController, animated: true, completion: nil)
                return
                
            
            }
            
               // when task is waiting for audit then we need to place show_result = 1 so it will fetch result from server .
        //
         //   print(self.appDel.taskDao.inspection_type)
         //   print(self.appDel.taskDao.waiting_for_audit)
            
       // if self.appDel.taskDao.inspection_type == "co-inspection" && self.appDel.taskDao.waiting_for_audit == "1" {
            if self.appDel.taskDao.inspection_type == "co-inspection" {
                
            self.appDel.show_result = 1
            self.performSegue(withIdentifier: "sw_questionlist", sender: nil)
        }
        else {
        
         if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied{
            self.requiredMethod()
            
            }
        else if self.loc == nil {
            let alert : UIAlertController = UIAlertController(title: "Acquiring Locaton", message: "App trying to record your location , please wait!", preferredStyle: UIAlertControllerStyle.alert)
            let action1 : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            
            let sAlert = SCLAlertView()
            
            sAlert.addButton(localisation.localizedString(key: "questions.cancel"), action:{
                }
            )
            sAlert.addButton(localisation.localizedString(key: "tasks.starttask"), action: {
                //self.performSegueWithIdentifier("sw_questionlist", sender: nil)
                self.frommethod = 0
                self.buttonClicked = 1
                if Reachability.connectedToNetwork() {
                    self.uploadTheLocation()
                    // 28/06/2016 /////// for dismiss///
                    if self.appDel.taskDao.is_pool == "0" {
                        self.appDel.user.status =  "Inactive"
                        self.makeActive()
                    }
                    ///
                    
                   
                }
                else {
                    
                    
                }
                
            })
           sAlert.showCloseButton = false
            sAlert.showEdit(localisation.localizedString(key: "tasks.readytostart"), subTitle: localisation.localizedString(key: "tasks.pleasemakesureyouarereadytostart"))

      //  self.setupCatgAlert()
            
            
        }
        }

        }
    
        else {
            
            if self.appDel.taskDao.is_pool != nil {
                if self.appDel.taskDao.is_pool! == "0" {
                    self.performSegue(withIdentifier: "sw_questionlist", sender: nil)
                }
                else if self.appDel.taskDao.is_pool == "1" {
//                    let listAlert = SCLAlertView()
//                    listAlert.showCloseButton = false
//                    print("User Categories \(self.appDel.user.categories)")
//                    print("Company Categires \(self.appDel.taskDao.company.categories)")
//                    if self.appDel.taskDao.company.categories.count == 0 || self.appDel.user.categories == nil{
//                    for catg in self.appDel.listArray {
//                    
//                        if let lDao = catg as? ListDao {
//                            listAlert.addButton(lDao.list_name!, action: {
//                                self.appDel.list_id = lDao.list_id!
//                                self.appDel.taskDao.list_id = lDao.list_id!
//                                self.performSegueWithIdentifier("sw_questionlist", sender: nil)
//                                
//                            })
//                            
//                        }// end of the if
//                        
//                    }
//                    } // if categories in company are not availabe
//                    else {
//                        let catgIdArray = (self.appDel.user.categories as? NSString)?.componentsSeparatedByString(",") as! NSArray
//
//                        for catg in self.appDel.listArray  {
//                        if let lDao = catg as? ListDao {
//                            
//                            for userCatg in catgIdArray {
//                                if let userCatg1 = userCatg as? String {
//                                    if userCatg1 == lDao.list_id {
//                            listAlert.addButton(lDao.list_name!, action: {
//                                self.appDel.list_id = lDao.list_id!
//                                self.appDel.taskDao.list_id = lDao.list_id!
//                                self.performSegueWithIdentifier("sw_questionlist", sender: nil)
//                                
//                            })
//                                    }
//                                }
//                            }
//                        }// end of the if
//                        } // end of the for loop
//                        
//
//                    
//                    }
//                    
//                    listAlert.addButton(localisation.localizedString(key: "tasks.dismiss"), action: {
//                    
//                    })
//                    
//                    listAlert.showInfo("Pool Task", subTitle: self.localisation.localizedString(key:"tasks.pleaseselectinspectiontype"))
//                    
//                    // end of the for loop
                    
                    
                    self.setupCatgAlert()
                    
                } // end if the pool if
            }
            else {
            

            self.performSegue(withIdentifier: "sw_questionlist", sender: nil)
            }
            
//            let alert = UIAlertController(title: localisation.localizedString(key: "searchcompany.pleasecheckinternetconnection"), message: "", preferredStyle: UIAlertControllerStyle.Alert)
//            let alertAction = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.Cancel, handler: nil)
//            alert.addAction(alertAction)
//            self.presentViewController(alert, animated: true, completion: nil)
//            

        }
    }
   
    @objc func showNotes(_ sender : UIButton) {
        print(sender.tag)
       let tasksDao : TaskDao = self.tableArray.object(at: sender.tag) as! TaskDao
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "cnt_tasksnotes") as! UINavigationController
        let cnt : TaskNotesViewController = popoverVC.topViewController as! TaskNotesViewController
        //print(tasksDao.task_notes)
        cnt.notesString = tasksDao.task_notes
        
        popoverVC.modalPresentationStyle = .popover
        present(popoverVC, animated: true, completion: nil)
        let popoverController = popoverVC.popoverPresentationController
        popoverController!.sourceRect = CGRect(x: 0, y: 0, width: 300, height: 300)
        popoverController!.sourceView = sender
        
        
        popoverController!.permittedArrowDirections = UIPopoverArrowDirection.down
        

    
    }
    // MARK:- UITABLEVIEWCONTROLLER METHODS
    @objc func showLocation(_ sender : ADButton) {
    
        let cnt = self.storyboard!.instantiateViewController(withIdentifier: "cnt_fullmapview") as! FullMapViewController
       
        
        
        cnt.taskDao = sender.taskDao
        
        
        
        self.navigationController?.pushViewController(cnt, animated: true)
        
    
        
        
        
    }// end of the UIButton
    
    
    @IBAction func submitTasks(_ sender: UIButton) {
    //print(self.selectedTasks.count)
    //print(self.selectedTasks.allKeys)
        
        if self.appDel.user.status != nil {
                    if self.appDel.user.status == "Inactive"{
        
                        SCLAlertView().showError(localisation.localizedString(key: "tasks.youareinactive"), subTitle:localisation.localizedString(key: "tasks.inactiveMessage"), closeButtonTitle:localisation.localizedString(key: "tasks.dismiss"))
        
        
        
                        return
        
        
        
                    }
        
    }
        
        
      // Condition to check internet , if available submit tasks online
        if Reachability.connectedToNetwork() {
        let sAlert = SCLAlertView()
        sAlert.addButton(localisation.localizedString(key: "profile.saveinfo"), action: {
        let array = self.selectedTasks.allKeys as? NSArray
            for item in array!  {
                if let t = item as? String {
                    self.databaseManager.changeStatus(t)
                }
            }
            
            let allTask = array!.componentsJoined(by: ",")
        // print("All Tasks are \(allTask)")
            
            var loginUrl = Constants.baseURL + "savePassedInspections?taskIDs=\(allTask)&inspectorID=" + self.user.user_id
            
            if self.appDel.currentZoneTask != nil {
                if self.appDel.currentZoneTask!.zoneStatus == "started" {
                    
                    loginUrl = Constants.baseURL + "savePassedInspections?taskIDs=\(allTask)&inspectorID=" + self.user.user_id + "&zone_id=\(self.appDel.currentZoneTask!.task_id!)"
                    
                } // end of the zone started
            } // end of the
        self.appDel.showIndicator = 1
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "submittask")
                //self.activityIndicator.startAnimating()
        
            
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                // Here you will get the animation you want
                self.submitBtnView.alpha = 0.0
                }, completion: { _ in
                    // Here you hide it when animation done
                    self.submitBtnView.isHidden = true
                     self.selectAllToggle.setOn(false, animated: true)
            })
            
            
            self.newSearchField.text = ""
            self.isSearching = 0
            self.isCompanySearching = 0

            self.searchArray = NSMutableArray()
            self.selectedTasks.removeAllObjects()
            self.appDel.addedSubvenueCompany = ""
            self.selectAllView.isHidden = true
            

            self.tableArray = NSMutableArray()
            // self.tableArray.addObject("")
            self.tableArray.addObjects(from: self.databaseManager.fetchTasks() as [AnyObject])
            self.appDel.allTasks = self.tableArray
            self.setupPins()
            self.dataTable.reloadData()

            

    })
        
        sAlert.addButton("",tag:250, action:{
            
            
            }
        )

        sAlert.showCloseButton = false
        sAlert.showEdit("Submit Task(s)", subTitle: "The Selected task(s) will be submitted, passing all criteria")
    
        
        }
            
      
        else {
            // Condition for offline version
            let array = self.selectedTasks.allKeys as? NSArray
            // this is the array
  
             let date = Date()
            for item in array!  {
                if let t = item as? String {
                    //  print("Task Id to Change \(t)")
                    self.databaseManager.changeStatus(t)
                    if let task = self.selectedTasks.object(forKey: item) as? TaskDao {
                      print(task.company_id)
                      print(task.list_id)
                     // print(task.)
                       
                        let currentTime = Int64(date.timeIntervalSince1970 * 1000)
                        if task.task_id == "0" {
                            print("Unique id \(task.uniqueid)")
                            print("Current Time \(currentTime)")
                            print("Company Id \(task.company.company_id)")
                            
                            print("COOInspectors \(task.coninspectors)")
                            
                            print("Inspector Id \(self.appDel.user.user_id)")
                            print("List Id \(task.list_id)")
//                            var loginUrl = Constants.baseURL + "saveOfflinePassedInspections?inspectorID=\(self.appDel.user.user_id!)&offlineIdentifier=\(task.uniqueid!)&listID=\(task.list_id!)&taskDuration=\("\(Constants.DEFAULT_TASK_DURATION)")&companyID=\(task.company.company_id!)&completedDate=\(currentTime)"
//                            if task.coninspectors != "" {
//                                loginUrl = loginUrl + "&coInspectorsIDs=\(task.coninspectors)"
//
//                            }
                            var loginUrl = DataDownloader().getOfflineTasksForPassed(companyId:task.company.company_id! , list_id: task.list_id!, offlineId: task.uniqueid!, coinspectors: task.coninspectors, externalNotes: task.external_notes)
                            
                             // saveOfflinePassedInspections
                            self.saveTasksToDatabase(json_string: loginUrl, task_id: task.uniqueid!, unique_id: task.uniqueid!, type: 9)
                         self.databaseManager.changeStatusOffline(task.uniqueid!)
                            print(loginUrl)
                            
                            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                                // Here you will get the animation you want
                                self.submitBtnView.alpha = 0.0
                            }, completion: { _ in
                                // Here you hide it when animation done
                                self.submitBtnView.isHidden = true
                                self.selectAllView.isHidden = true
                                 self.selectAllToggle.setOn(false, animated: true)
                            })
                            
                            
                            
                        }
                        else {
                            // Now Task was downloaded and it has task id so inspector can complete task offline with task id
                            var loginUrl = Constants.baseURL + "savePassedInspections?taskIDs=\(task.task_id!)&inspectorID=" + self.user.user_id
                            
                            if self.appDel.currentZoneTask != nil {
                                if self.appDel.currentZoneTask!.zoneStatus == "started" {
                                    
                                    loginUrl = Constants.baseURL + "savePassedInspections?taskIDs=\(task.task_id!)&inspectorID=" + self.user.user_id + "&zone_id=\(self.appDel.currentZoneTask!.task_id!)"
                                    
                                } // end of the zone started
                            } // end of the
                            self.saveTasksToDatabase(json_string: loginUrl, task_id: task.task_id!, unique_id: task.task_id!, type: 4)
                             self.databaseManager.changeStatus(task.task_id)
                            
                            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                                // Here you will get the animation you want
                                self.submitBtnView.alpha = 0.0
                            }, completion: { _ in
                                // Here you hide it when animation done
                                self.submitBtnView.isHidden = true
                                self.selectAllView.isHidden = true
                                 self.selectAllToggle.setOn(false, animated: true)
                            })
                            
                        }
                    /**
 
                         
 
                     **/
                        
                        
                   
                        
                    }
               
                } // end of the if
            } // end if the for loop
            self.tableArray = NSMutableArray()
            
            
            self.tableArray.addObjects(from: databaseManager.fetchTasks() as [AnyObject])
            
            self.appDel.allTasks = self.tableArray
          //  self.setupPins()
            self.filterCompanyName()
            //self.dataTable.reloadData()
            
        }// end of the else
        
       
            
    
    }
    
    @IBOutlet weak var submitTaskBtn: UIButton!
    
    func openPermitMap(_ sender : ADButton){
    }
    
    func selectAllTask(){
        if self.isSearching == 1 {
            
           
            
        for task in self.searchArray as! [TaskDao] {
            
            if task.is_submitted == "0" {
                self.informUser()
                self.selectAllToggle.isOn = false
                return
            }
            var key : String = "0"
            if task.task_id == "0" {
                if task.uniqueid != nil {
                    key = task.uniqueid!
                } // end of the if
            }
            else {
                key = task.task_id
                
            }
            self.selectedTasks.setValue(task, forKey: key)
            
        } // end of the for loop
            
        self.dataTable.reloadData()
        
        }
        }
    
    @objc func selectedTask(_ sender : InspectionRadio) {
        
        
    if sender.task!.is_submitted == "0" {
                self.informUser()
                return
            }
        
         print("Selected Tasks clicked \(self.user.status)")
        if !self.activeToggle.isOn  {
        return
        }
        var key : String = "0"
        if sender.task!.task_id == "0" {
            if sender.task!.uniqueid != nil {
            key = sender.task!.uniqueid!
            } // end of the if
        }
        else {
            key = sender.task!.task_id
        }
        if sender.is_Selected == 1 {
            
          sender.is_Selected = 0
            self.selectedTasks.removeObject(forKey: key)
         sender.setImage(UIImage(named: "toggle"), for: UIControlState())
        }
        else {
           self.selectedTasks.setValue(sender.task, forKey: key)
            sender.is_Selected = 1
             sender.setImage(UIImage(named: "toggle_on"), for: UIControlState())
        }
        
        if self.selectedTasks.count > 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                 // Here you will get the animation you want
                self.submitBtnView.alpha = 1.0
                }, completion: { _ in
                    // Here you hide it when animation done
                     self.submitTaskBtn.setTitle("Submit(\(self.selectedTasks.count)) tasks without violations", for: UIControlState.normal)
                    self.submitBtnView.isHidden = false
            })
        
        }
        else {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                // Here you will get the animation you want
                self.submitBtnView.alpha = 0.0
                }, completion: { _ in
                    // Here you hide it when animation done
                    self.submitBtnView.isHidden = true
            })
            
            
        }
    
    }
    
    func configureZoneCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath,tasksDao : TaskDao) -> UITableViewCell{
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_zone") as! ZoneTableViewCell
        cell.zoneNameBtn.setTitle(tasksDao.zone_name!, for: UIControlState())
        cell.startBtn.addTarget(self, action:#selector(TasksViewController.startZoneTask(_:)) , for: UIControlEvents.touchUpInside)
        
        cell.onMywayBtn.addTarget(self, action: #selector(TasksViewController.onMyWayZoneMethod(_:)), for: UIControlEvents.touchUpInside)
        cell.dueDateVal.text = tasksDao.zone_expiryDate
        //print(tasksDao.zone_expiryDate)
        
        cell.dueDateVal.isHidden = false
        
        if self.appDel.user.status == "Inactive" {
            cell.onMywayBtn.setBackgroundImage(UIImage(named:"onmywaydisable"), for: UIControlState())
            
            
        }
        
        
        cell.startBtn.tag = indexPath.row
        cell.onMywayBtn.tag = indexPath.row
        cell.onMywayBtn.backgroundColor = UIColor(red: 101/255, green: 174/255, blue: 223/255, alpha: 1.0)
        cell.onMywayBtn.setTitleColor(UIColor.white, for: UIControlState())
        cell.startBtn.setTitle(localisation.localizedString(key: "tasks.starttask"), for: UIControlState())
        cell.onMywayBtn.setTitle(localisation.localizedString(key: "tasks.onmyway"), for: UIControlState())
        cell.cancelBtn.setTitle(localisation.localizedString(key: "questions.cancel"), for: UIControlState())
        cell.cancelBtn.tag = indexPath.row
        cell.cancelBtn.addTarget(self, action: #selector(TasksViewController.cancelOnMyWayZone(_:)), for: UIControlEvents.touchUpInside)
        
        
        if tasksDao.task_status == "on_way" {
            self.onTheWayTasksCount = 1
            self.appDel.alreadyOnTheWay = 1
            print("You are on the wayyyyyy")
            self.appDel.onMyWayTask = tasksDao
            self.appDel.taskDao = tasksDao
            
            
            
            
            self.appDel.taskDao.task_status = "on_way"
            
            cell.onMywayBtn.isHidden = true
            cell.startBtn.isHidden = false
            cell.startBtn.accessibilityLabel = "disable"
            self.currentStartBtn = cell.startBtn
            
//            if self.appDel.taskDao.company.lat != nil && self.appDel.taskDao.company.lon != nil {
//                if((self.appDel.taskDao.company.lat) as NSString).rangeOfString("0.0").location ==  NSNotFound {
//                    
//                    
//                    
//                    print("Lat/lon are valid \(self.appDel.taskDao.company.lat)")
//                    
//                    cell.startBtn.accessibilityLabel = "disable"
//                    //cell.startBtn.enabled = false
//                    self.currentStartBtn = cell.startBtn
//                    //self.checkDistance()
//                }
//            }
            
            
            
            cell.cancelBtn.isHidden = false
        } // end of the on my way
        else if tasksDao.zoneStatus == "started" {
            cell.onMywayBtn.isHidden = false
            cell.startBtn.isHidden = true
            cell.cancelBtn.isHidden = true
            self.appDel.currentZoneTask = tasksDao
            print("tasksDao.zoneStatus == started")
            
            cell.onMywayBtn.setBackgroundImage(UIImage(named:"startzone"), for: UIControlState())
            cell.onMywayBtn.setTitle(localisation.localizedString(key: "Complete"), for: UIControlState())
            cell.onMywayBtn.accessibilityLabel = "completezone"
            cell.onMywayBtn.addTarget(self, action: #selector(TasksViewController.completeZone(_:)), for: UIControlEvents.touchUpInside)
            
            
        }
        else {
            
            cell.onMywayBtn.isHidden = false
            cell.startBtn.isHidden = true
            cell.cancelBtn.isHidden = true
            if  self.appDel.user.status == "on_way" {
                // print("userstaus onway")
                // self.appDel.taskDao = tasksDao
                locationlbl.text = ""
                
                
                cell.onMywayBtn.setBackgroundImage(UIImage(named:"onmywaydisable"), for: UIControlState())
            }
            else {
                
                
                if self.appDel.user.status == "Inactive" {
                    cell.onMywayBtn.setBackgroundImage(UIImage(named:"onmywaydisable"), for: UIControlState())
                    
                    
                }
                else {
                cell.onMywayBtn.setBackgroundImage(UIImage(named:"newonwayicon"), for: UIControlState())
                }
                
            }
            
            
            
        }
        
        
        
        
        
        
        cell.dueDateVal.text  = tasksDao.zone_expiryDate
        return cell
        
        

        
    } // end of the Zone Cell
    
    @objc func completeZone(_ sender : UIButton) {
        
        let alertController = UIAlertController(title: "Zone", message:"Do you want to complete zone?", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancel)
        let start = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.default, handler: {
            action in
        
            let numLat = NSNumber(value: (self.loc!.latitude) as Double as Double)
            let numLon = NSNumber(value: (self.loc!.longitude) as Double as Double)
            
            let loginUrl = Constants.baseURL + "updateZoneAssignmentStatus?inspector_id=" + self.user.user_id + "&zone_id=\(self.appDel.taskDao.task_id!)&latitude=" + numLat.stringValue + "&longitude=" + numLon.stringValue + "&status=completed"
            
            if Reachability.isConnectedNetwork() {
                if self.loc != nil{
                    
                    self.appDel.showIndicator = 1
                    
                    let downloader : DataDownloader = DataDownloader()
                    downloader.delegate = self
                    
                    downloader.startDownloader(loginUrl, idn: "completezone")
                }
            
                
            }
            else {
               // self.userDefault.set(loginUrl, forKey: self.appDel.taskDao.task_id + ",zone")
                //
                //                var closedTasks = self.userDefault.object(forKey: "zone") as? NSArray
                //                if closedTasks == nil {
                //                    let array = NSMutableArray()
                //
                //
                //                    array.add(self.appDel.taskDao.task_id)
                //                    closedTasks = array as NSArray
                //
                //
                //                    self.userDefault.set(closedTasks, forKey: "zone")
                
                self.saveTasksToDatabase(json_string: loginUrl, task_id:self.appDel.taskDao.task_id  , unique_id: self.appDel.unique, type : 5)
                self.databaseManager.changeStatus(self.appDel.taskDao.task_id)
                 self.appDel.currentZoneTask = nil
                
                
                
                //                }  // end of if tasks are nil
                //                else {
                //                  //  print(closedTasks?.count)
                //                    let array = NSMutableArray(array: closedTasks!)
                //
                //
                //
                //                    array.add(self.appDel.taskDao.task_id)
                //                    closedTasks = array as NSArray
                //                    self.userDefault.set(closedTasks, forKey: "zone")
                //                    self.databaseManager.changeStatus(self.appDel.taskDao.task_id)
                //
                //
                //
                //
                //
                //                } // end of the else
                
                
                
                self.tableArray = NSMutableArray()
                
                self.tableArray.addObjects(from: self.databaseManager.fetchTasks() as [AnyObject])
                self.appDel.allTasks = self.tableArray
                self.dataTable.reloadData()
                
                
                self.appDel.user.status = "active"
                self.userDefault.synchronize()
                
                
                
            }
        
        
        })
        
        alertController.addAction(start)
        self.present(alertController, animated: true, completion: nil)

        
        
        
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // var cell : TaskTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell_title") as! TaskTableViewCell
        //print("Rendering cell for row \(indexPath.row)  at \(NSDate())")
        if self.isCompanySearching == 1 {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "cell_company") as! TaskCompanyTableViewCell
            let taskDao = self.companyNameArray.object(at: indexPath.row) as! TaskDao
            if taskDao.isZoneTask == 0 {
            if self.appDel.selectedLanguage == 1 && taskDao.company.company_name != nil {
                
                cell.companyTitle.text = taskDao.company.company_name
                
                
                
            }
            else  if  self.appDel.selectedLanguage == 2 && taskDao.company.company_name_arabic != nil {
                
                
                
            cell.companyTitle.text = taskDao.company.company_name_arabic
            }
            else {
                
                cell.companyTitle.text = taskDao.company.company_name
                
            }
            }
            else if taskDao.zone_name != nil{
            cell.companyTitle.text = taskDao.zone_name!
            }
            
            
            //cell.companyTitle.text = taskDao.company.company_name
        
            
            return cell
        }
        var tasksDao : TaskDao = self.tableArray.object(at: indexPath.row) as! TaskDao

        print("Task listing ")
        print(tasksDao.company.contact_designation)
        print(tasksDao.company.contact_provider_name)
        print(tasksDao.company.contact_provided_by)
        
        
        if tasksDao.isZoneTask == 1 && self.isSearching != 1 {
        
          let cell = self.configureZoneCell(tableView, cellForRowAtIndexPath: indexPath, tasksDao: tasksDao)
            return cell
            
        
        }
        
        
           var  cell = tableView.dequeueReusableCell(withIdentifier: "cell_newdetail") as! TaskTableViewCell
        
         //   cell = tableView.dequeueReusableCellWithIdentifier("cell_detail") as! TaskTableViewCell
        //return cell
        //cell.permitNobtn.setTitle("", forState: <#T##UIControlState#>)
        cell.prioritylbl.text = localisation.localizedString(key: "tasks.priority")
        cell.categoryTitle.text = localisation.localizedString(key: "tasks.category")
        //cell.tasksName.text = localisation.localizedString(key: "tasks.type")
       // cell.company.setTitle(localisation.localizedString(key: "tasks.company"), forState: UIControlState.Normal)
        cell.taskstatuslabel.text = localisation.localizedString(key: "tasks.status")
        cell.dueDatelabel.text = localisation.localizedString(key: "tasks.duedate")
        cell.tasktypelabel.text = localisation.localizedString(key: "tasks.type")
        cell.permitNobtn.setTitle("", for: UIControlState())
        cell.permitNobtn.isHidden = true
        
        cell.prioritylbl.isHidden = false
        cell.locIcon.isHidden = true
        
               if self.appDel.taskDao != nil {
            if self.appDel.taskDao.task_id != nil {
        if tasksDao.task_id == self.appDel.taskDao.task_id {
        tasksDao = self.appDel.taskDao
                }
                }
        }
        // cell.notesTitleLbl.text = localisation.localizedString(key: "tasks.notes")
       
        if self.isSearching == 1 {
             tasksDao = self.searchArray.object(at: indexPath.row) as! TaskDao
            
            // this condition is for Safari & Camps
           // if  (tasksDao.list_id != "10" && tasksDao.list_id != "11") {
            print("List id \(tasksDao.list_id)")
            print(tasksDao.company_id)
            
            cell = tableView.dequeueReusableCell(withIdentifier: "cell_newdetailcheckbox") as! TaskTableViewCell
            cell.permitNobtn.setTitle("", for: UIControlState())
            var key : String = "0"
            if tasksDao.task_id == "0" {
                if tasksDao.uniqueid != nil {
                    key = tasksDao.uniqueid!
                } // end of the if
            }
            else {
                key = tasksDao.task_id
                
            }
            
            if self.selectedTasks.object(forKey: key) != nil {
            cell.taskradio.setImage(UIImage(named: "toggle_on"), for: UIControlState())
            cell.taskradio.is_Selected = 1
                
            }
            else {
            cell.taskradio.setImage(UIImage(named: "toggle"), for: UIControlState())
            cell.taskradio.is_Selected = 0
                
            }
            
            

                    if tasksDao.list_title == "DST Checklist" {
                    cell.taskradio.isHidden = true
                        self.selectAllView.isHidden = true
                        
                      }
                    else {
                        cell.taskradio.isHidden = false
            }
//            
//            
        //print("CCCompany id \(tasksDao.company_id)")
         cell.taskradio.task = tasksDao
         cell.taskradio.task_index = indexPath.row
         cell.taskradio.addTarget(self, action: #selector(TasksViewController.selectedTask(_:)), for: UIControlEvents.touchUpInside)
            if self.appDel.user.status == "Inactive" {
                cell.onMyWayBtn.setBackgroundImage(UIImage(named:"onmywaydisable"), for: UIControlState())
                
                
            }
  
            
          
//        }
//        else {
//          //  tasksDao = self.tableArray.objectAtIndex(indexPath.row) as! TaskDao
//
//        }
        }
        else {
            tasksDao = self.tableArray.object(at: indexPath.row) as! TaskDao

        }
        
   // print("Searching \(self.isSearching)")
          //  let tasksDao : TaskDao = self.tableArray.objectAtIndex(indexPath.row) as! TaskDao
        
        //cell.startBtn.hidden = false
           // cell.onMyWayBtn.hidden = false
            
            if tasksDao.task_notes == nil  || tasksDao.task_notes == ""{
            cell.notesBtn.isHidden = true
            cell.notesBtn.tag = indexPath.row
           // cell.notesBtn.taskDao = tas
            cell.notesBtn.addTarget(self, action: #selector(TasksViewController.showNotes(_:)), for: UIControlEvents.touchUpInside)
                
            }
            else {
                cell.notesBtn.tag = indexPath.row
                cell.notesBtn.addTarget(self, action: #selector(TasksViewController.showNotes(_:)), for: UIControlEvents.touchUpInside)
               // print("NOTESSS :\(tasksDao.task_notes)")
                cell.notesBtn.isHidden = false
                
            }
        if tasksDao.is_pool != nil {
        if tasksDao.is_pool! == "1" {
        self.is_pool = 1
        }
        }
            cell.startBtn.tag = indexPath.row
            cell.onMyWayBtn.tag = indexPath.row
            cell.onMyWayBtn.backgroundColor = UIColor(red: 101/255, green: 174/255, blue: 223/255, alpha: 1.0)
            cell.onMyWayBtn.setTitleColor(UIColor.white, for: UIControlState())
            cell.startBtn.setTitle(localisation.localizedString(key: "tasks.starttask"), for: UIControlState())
            cell.onMyWayBtn.setTitle(localisation.localizedString(key: "tasks.onmyway"), for: UIControlState())
            cell.cancelBtn.setTitle(localisation.localizedString(key: "questions.cancel"), for: UIControlState())
            cell.cancelBtn.addTarget(self, action: #selector(TasksViewController.cancelOnMyWay(_:)), for: UIControlEvents.touchUpInside)
        
        if tasksDao.due_date != nil {
        let date : Date? = formater.date(from: tasksDao.due_date)
           // print("Date \(date) \(tasksDao.due_date)")
            if date != nil {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let cal = Calendar.current
        
        
        let unit:NSCalendar.Unit = NSCalendar.Unit.day
        
        
        let components = (cal as NSCalendar).components(unit, from: Date(), to: date!, options: NSCalendar.Options.searchBackwards)
        
       // print(components.day)
            }
            }
//           if Reachability.connectedToNetwork(){
//            
//            }
//            else {
//                cell.onMyWayBtn.setTitle(localisation.localizedString(key: "tasks.starttask"), forState: UIControlState.Normal)
//                
//            }
        if tasksDao.list_title != nil {
        cell.categoryValue.text = tasksDao.list_title
        }
        
        
            cell.startBtn.addTarget(self, action:#selector(TasksViewController.startTasks(_:)) , for: UIControlEvents.touchUpInside)
          //  cell.tasksNo.text =  String(
            if self.appDel.selectedLanguage == 1 && tasksDao.task_type != nil {
                cell.tasksName.text = tasksDao.task_type!
            }
            else if self.appDel.selectedLanguage == 2 && tasksDao.task_type_ar != nil {
                cell.tasksName.text = tasksDao.task_type_ar!
            }
            else {
            cell.tasksName.text = ""
                
            }
            
        
        if tasksDao.incidentDao != nil {
        cell.incidentBtn.isHidden = false
        cell.incidentBtn.tag = indexPath.row
        cell.incidentBtn.taskDao = tasksDao
        cell.incidentBtn.addTarget(self, action: #selector(TasksViewController.showIncidentMedia(_:)), for: UIControlEvents.touchUpInside)
        }
        
            
            cell.startBtn.setTitle(localisation.localizedString(key: "tasks.starttask"), for: UIControlState())
            
            cell.company.setTitle(tasksDao.company.company_name, for: UIControlState())
            cell.company.setTitleColor(UIColor(red: 101/255, green: 174/255, blue: 223/255, alpha: 1), for: UIControlState())
            cell.company.tag = indexPath.row
        
            
            if tasksDao.task_status != nil {
                if tasksDao.task_status! == "waiting_for_audit" {
                    cell.contentView.backgroundColor = UIColor(red: 1, green: 204/255, blue: 153/255, alpha: 1)
                    
                    
                }
                else {
                    
                }
            }
            
           // print("SELECTED LANGAUGE  \(self.appDel.selectedLanguage) COMPANY NAME \(tasksDao.company.company_name_arabic)")
        
        
        if tasksDao.permitDao != nil {
            cell.contentView.bringSubview(toFront: cell.permitNobtn)
            
            cell.permitNobtn.isHidden = false
            
            if tasksDao.permitDao!.lon != nil && tasksDao.permitDao!.lon != nil {
            
                cell.locIcon.isHidden = false
                cell.locIcon.taskDao = tasksDao
                
            cell.locIcon.addTarget(self, action: #selector(TasksViewController.showLocation(_:)), for: UIControlEvents.touchUpInside)
            }
                else {
                cell.locIcon.isHidden = true
                }
            //cell.subVenuelbl.text = tasksDao.permitDao?.sub_venue\\
           // print("sub venue value \(tasksDao.permitDao?.sub_venue)")
            if tasksDao.permitDao!.sub_venue != nil  {
                if tasksDao.permitDao!.sub_venue! != "" {
             cell.permitNobtn.setTitle("\(tasksDao.permitDao!.sub_venue!) - \(tasksDao.permitDao!.permitID!)", for: UIControlState())
                }
                else {
                 cell.permitNobtn.setTitle("\(tasksDao.permitDao!.permitID!)", for: UIControlState())
                }
                }
            else {
             cell.permitNobtn.setTitle("\(tasksDao.permitDao!.permitID!)", for: UIControlState())
            }
            cell.contentView.bringSubview(toFront: cell.subVenuelbl)
          
            cell.prioritylbl.isHidden = true
            cell.permitNobtn.tag = indexPath.row
            
            cell.permitNobtn.addTarget(self, action:#selector(TasksViewController.showPermit(_:)), for: UIControlEvents.touchUpInside)
            }
        else
            if self.appDel.selectedLanguage == 1 && tasksDao.company.company_name != nil {
                cell.locIcon.isHidden = true
                cell.company.setTitle(tasksDao.company.company_name, for: UIControlState())
                
            }
            else  if  self.appDel.selectedLanguage == 2 && tasksDao.company.company_name_arabic != nil {
                 cell.locIcon.isHidden = true
                cell.company.setTitle(tasksDao.company.company_name_arabic, for: UIControlState())
                
            }
            else {
                 cell.locIcon.isHidden = true
                cell.company.setTitle(tasksDao.company.company_name, for: UIControlState())

            }
       // cell.permitNobtn.hidden = true
       // cell.prioritylbl.hidden = false
        
        
            
            
            
           // if self.appDel.selectedLanguage == 1 {
              
                

                if tasksDao.task_status == "Not Started" {
                    cell.tasktypelbl.text = localisation.localizedString(key: "tasks.nostarted")
                    //cell.startBtn.hidden = true
                    
                }
                else if tasksDao.task_status == "Completed" {
                     cell.tasktypelbl.text = localisation.localizedString(key: "tasks.completed")
                    //cell.tasktypelbl.text = "منجز"
                    
                }

                
                if tasksDao.task_status == "on_way" {
                   
                    // if there is any task on the way make its status on the way
                    self.onTheWayTasksCount = 1
                    self.appDel.alreadyOnTheWay = 1
                    self.appDel.onMyWayTask = tasksDao
                    print("You are on the wayyyyyy")
                    self.appDel.taskDao = tasksDao
                    self.appDel.taskDao.task_status = "on_way"
                    cell.tasktypelbl.text = localisation.localizedString(key: "tasks.onmyway")
                     cell.onMyWayBtn.isHidden = true
                    cell.startBtn.isHidden = false
                    if self.appDel.taskDao.company.lat != nil && self.appDel.taskDao.company.lon != nil {
                        if((self.appDel.taskDao.company.lat) as NSString).range(of: "0.0").location ==  NSNotFound {
                            
                    
                    
                    print("Lat/lon are valid \(self.appDel.taskDao.company.lat)")
                    
                    cell.startBtn.accessibilityLabel = "disable"
                    //cell.startBtn.enabled = false
                    self.currentStartBtn = cell.startBtn
                    self.checkDistance()
                    }
                    }
                    cell.cancelBtn.isHidden = false
                    
                   // setupOnMyTimer()
                
                }
                else {
                    cell.tasktypelbl.text = tasksDao.task_status
                   //cell.startBtn.hidden = true
                    locationlbl.text = ""
                    cell.onMyWayBtn.isHidden = false
                    cell.startBtn.isHidden = true
                    cell.cancelBtn.isHidden = true
                    
                    print(self.appDel.user.status )
                    
                    if  self.appDel.user.status == "on_way" {
                       // print("userstaus onway")
                       // self.appDel.taskDao = tasksDao
                        locationlbl.text = ""

                        
                         cell.onMyWayBtn.setBackgroundImage(UIImage(named:"onmywaydisable"), for: UIControlState())
                    }
                    else {
                    cell.onMyWayBtn.setBackgroundImage(UIImage(named:"newonwayicon"), for: UIControlState())
                    
                    }
                  
                    
                    
 

                }
        
       
               // print("Inspection type \(tasksDao.inspection_type) waiting for audit \(tasksDao.waiting_for_audit)")
                if tasksDao.inspection_type != nil && tasksDao.waiting_for_audit != nil {
                if tasksDao.inspection_type == "co-inspection" {
                    cell.tasktypelbl.text = "Co-Inspection"
                    
                }
                    
                }
        
        
        //print("status \(self.appDel.user.status)")
        
        if self.appDel.user.status == "Inactive" {
            cell.onMyWayBtn.setBackgroundImage(UIImage(named:"onmywaydisable"), for: UIControlState())
            
            
        }
        else {
        //cell.onMyWayBtn.setBackgroundImage(UIImage(named:"newonwayicon"), forState: UIControlState.Normal)
        }
        

        
       
            cell.company.addTarget(self, action: #selector(TasksViewController.companyTapped(_:)), for: UIControlEvents.touchUpInside)
            cell.startBtn.setTitle(localisation.localizedString(key: "tasks.starttask"), for: UIControlState())
            cell.onMyWayBtn.tag = indexPath.row
           // cell.onMyWayBtn.hidden = false
            
            //cell.onMyWayBtn.setTitle(localisation.localizedString(key: "tasks.onmyway"), forState: UIControlState.Normal)
            cell.onMyWayBtn.addTarget(self, action: #selector(TasksViewController.onMyWayMethod(_:)), for: UIControlEvents.touchUpInside)
            
                     //  cell.group.text = tasksDao.group_name
           // cell.tasksNo.text = String(indexPath.row)
            cell.dueDate.text = tasksDao.due_date
        
           

            
            if tasksDao.priority != nil {
            //    cell.contentView.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
                
                if tasksDao.priority == "1" {
                cell.prioritylbl.text = localisation.localizedString(key: "tasks.low")
                  //  cell.contentView.backgroundColor = UIColor.whiteColor()
                    cell.priorityIndicator.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
                    cell.prioritylbl.textColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)

                    

                }
                if tasksDao.priority == "2" {
                    cell.prioritylbl.text = localisation.localizedString(key: "tasks.medium")
                    //cell.contentView.backgroundColor = UIColor.whiteColor()
                    cell.priorityIndicator.backgroundColor = UIColor(red: 246/255, green: 142/255, blue: 90/255, alpha: 1.0)
                    cell.prioritylbl.textColor = UIColor(red: 246/255, green: 142/255, blue: 90/255, alpha: 1.0)



                    
                }
                if tasksDao.priority == "3" {
                    cell.priorityIndicator.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                    
                    cell.prioritylbl.text = localisation.localizedString(key: "tasks.high")
                    
                    cell.prioritylbl.textColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)


                }
                
            }
            else {
            cell.prioritylbl.text = ""
            }
        //if tasksDao.coninspectors != "" && tasksDao.taskOwner != nil{
        if tasksDao.coninspectors != "" && tasksDao.coninspectors != self.appDel.user.user_id  && tasksDao.taskOwner != nil {
            print(tasksDao.taskOwner)
            if let owner = tasksDao.taskOwner {
                if owner == self.appDel.user.user_id {
                     cell.editCoInspection.isHidden = false
                    cell.editCoInspection.taskDao = tasksDao
                    cell.editCoInspection.addTarget(self, action: #selector(TasksViewController.editCoInspection(sender:)), for: UIControlEvents.touchUpInside)
                    
                    
                }// end o the
                else {
                    cell.editCoInspection.isHidden = true
                    cell.editCoInspection.removeTarget(self, action: #selector(TasksViewController.editCoInspection(sender:)), for: UIControlEvents.touchUpInside)
                    
                }
            }
            else {
                cell.editCoInspection.isHidden = true
                cell.editCoInspection.removeTarget(self, action: #selector(TasksViewController.editCoInspection(sender:)), for: UIControlEvents.touchUpInside)
                
                
            }
            
//        cell.editCoInspection.isHidden = false
//        cell.editCoInspection.taskDao = tasksDao
//            cell.editCoInspection.addTarget(self, action: #selector(TasksViewController.editCoInspection(sender:)), for: UIControlEvents.touchUpInside)
//
        }else {
               cell.editCoInspection.isHidden = true
            cell.editCoInspection.removeTarget(self, action: #selector(TasksViewController.editCoInspection(sender:)), for: UIControlEvents.touchUpInside)
        }
       
        
      //  print("tasksksksksksks \(tasksDao.isSubVenue)")
        if tasksDao.isSubVenue == "1" {
            cell.permitNobtn.isHidden = false
            cell.permitNobtn.setTitle(tasksDao.subVenueName, for: UIControlState())
        }
        
        print("Area id \(tasksDao.area_id)")
        if tasksDao.area_id != nil {
        //cell.company.setTitle(cell.company.titleForState(UIControlState.Normal)!)
        cell.permitNobtn.setTitle(tasksDao.areaNameAr!, for: UIControlState())
        cell.permitNobtn.isHidden = false
        }
        
        if tasksDao.list_title == "الرحلات السياحية البرية" || tasksDao.list_title == "المخيمات السياحية و تصريح الفعاليات"  {
            if tasksDao.external_notes != nil && tasksDao.area_id == nil {
            cell.permitNobtn.setTitle(tasksDao.external_notes!, for: UIControlState())
            cell.permitNobtn.isHidden = false
            }
        }// end of the if

       
        
     return cell
        
    }
    @objc func showIncidentMedia(_ sender : ADButton) {
    self.appDel.showIncidentMedia = 1
    self.appDel.taskDao = sender.taskDao
    let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "cnt_createincidentcnt"))!
    vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
    self.present(vc, animated: true, completion: nil)
        
    
    }
    @objc func cancelOnMyWayZone(_ sender : UIButton) {
        
        if self.loc != nil{
            
            let numLat = NSNumber(value: (self.loc!.latitude) as Double as Double)
            let numLon = NSNumber(value: (self.loc!.longitude) as Double as Double)
            
            //  let stLat:String = numLat.stringValue
            self.appDel.showIndicator = 1
            var tempTask : TaskDao = TaskDao()
            
            if self.isSearching == 1 {
                tempTask  = self.searchArray.object(at: sender.tag) as! TaskDao
                
            }
            else {
                tempTask = self.tableArray.object(at: sender.tag) as! TaskDao
                
            }
            
            
            let loginUrl = Constants.baseURL + "updateZoneAssignmentStatus?inspector_id=" + user.user_id + "&zone_id=\(tempTask.task_id!)&latitude=" + numLat.stringValue + "&longitude=" + numLon.stringValue + "&status=notstarted"
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "cancelOnMyWayZone")
            
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
        self.taskToEdit!.coninspectors = str
        }
        
        if Reachability.isConnectedNetwork() {
            self.appDel.showIndicator = 0
            let loginUrl = "\(Constants.baseURL)addRemoveTaskCoInspectors?inspectorID=\(self.appDel.user.user_id!)&taskID=\(self.taskToEdit!.task_id!)&inspectorsList=\(self.taskToEdit!.coninspectors)"
            ///print(loginUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "editCoInspectors")
            
            
            
        }
        else {
            if self.taskToEdit != nil {
            self.databaseManager.updateCoInspector(task_id: self.taskToEdit!.task_id, unique_id:  self.taskToEdit!.uniqueid, coinspectors:  self.taskToEdit!.coninspectors)
            
            self.tableArray = NSMutableArray()
            self.tableArray.addObjects(from: databaseManager.fetchTasks() as [AnyObject])
            self.appDel.allTasks = self.tableArray
            self.dataTable.reloadData()
                
            }
        } // end of the else
        
        
        
    }
    
    func setupUpdateCoInspectionDownload(inspector_id : String, CoInspectors : String,task_id : String){
        
        if Reachability.connectedToNetwork() {
            self.appDel.showIndicator = 0
            let loginUrl = Constants.baseURL + "getInspectorShiftInspectors?inspector_id=" + self.appDel.user.user_id
            ///print(loginUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "editCoInspectors")
            
            
            
            
        }
    } // end of the
    
    @objc func editCoInspection(sender : ADButton){
        
        
        print("CoInspectors \(sender.taskDao.coninspectors)")
       // let coinspectorArray = sender.taskDao.coninspectors.components(separatedBy: ",")
        self.taskToEdit = sender.taskDao
        let inspectors = databaseManager.fetchInspectorsOnBehalfofIds(allIds: sender.taskDao.coninspectors.split(separator: ",") as NSArray)
        
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
    
    func cancelOnMyWayZoneActive(_ tempTask  : TaskDao) {
        
        if self.loc != nil{
            
            let numLat = NSNumber(value: (self.loc!.latitude) as Double as Double)
            let numLon = NSNumber(value: (self.loc!.longitude) as Double as Double)
            
            //  let stLat:String = numLat.stringValue
            self.appDel.showIndicator = 1
           
            
            
            let loginUrl = Constants.baseURL + "updateZoneAssignmentStatus?inspector_id=" + user.user_id + "&zone_id=\(tempTask.task_id!)&latitude=" + numLat.stringValue + "&longitude=" + numLon.stringValue + "&status=notstarted"
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "cancelOnMyWayZoneActive")
            
        }
        
    }

    
    
    
    @objc func cancelOnMyWay(_ sender : UIButton) {
        
        if Reachability.connectedToNetwork() {
            
            self.locationlbl.text = ""
            self.setupChangeTaskStatus(self.appDel.taskDao.task_id)
             self.appDel.onMyWayTask = nil
           self.onTheWayTasksCount = 0
        }

    }
    
    @objc func onMyWayZoneMethod(_ sender : UIButton) {
        if self.appDel.user.status ==  "Inactive" {
            print("user is inactive")
            return
        }
       
        var tempTask : TaskDao = TaskDao()
        
        if self.isSearching == 1 {
            tempTask  = self.searchArray.object(at: sender.tag) as! TaskDao
            
        }
        else {
            tempTask = self.tableArray.object(at: sender.tag) as! TaskDao
            
        }
        
        
        if tempTask.parent_zone_status == "inactive" {
            
            let alert : UIAlertController = UIAlertController(title:"Zone is Inactive", message: "This zone is inactive,Please contact your supervisor for more info.", preferredStyle: UIAlertControllerStyle.alert)
            let action1 : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
            return
            
            
        }
        
        
        if tempTask.task_status != "on_way" && self.appDel.user.status == "on_way" {
            return
        }
        else {
        self.appDel.taskDao = tempTask
        
        }

        if Reachability.connectedToNetwork() {
            
            
            if self.loc != nil{
                
           let numLat = NSNumber(value: (self.loc!.latitude) as Double as Double)
           let numLon = NSNumber(value: (self.loc!.longitude) as Double as Double)
            //  let stLat:String = numLat.stringValue
            self.appDel.showIndicator = 1
                if sender.accessibilityLabel == "completezone" {
//                    let loginUrl = Constants.baseURL + "updateZoneAssignmentStatus?inspector_id=" + user.user_id + "&zone_id=\(self.appDel.taskDao.task_id!)&latitude=" + numLat.stringValue + "&longitude=" + numLon.stringValue + "&status=completed"
//                    let downloader : DataDownloader = DataDownloader()
//                    downloader.delegate = self
//                    downloader.startDownloader(loginUrl, idn: "completezone")
//                
                
                }
                else {
            let loginUrl = Constants.baseURL + "updateZoneAssignmentStatus?inspector_id=" + user.user_id + "&zone_id=\(self.appDel.taskDao.task_id!)&latitude=" + numLat.stringValue + "&longitude=" + numLon.stringValue + "&status=on_way"
            let downloader : DataDownloader = DataDownloader()
                downloader.delegate = self
                        downloader.startDownloader(loginUrl, idn: "onMyWay")
                }
            }
        }
        else {
            
            self.startZoneTask(sender)
            
            
        }
    
    }
    @objc func onMyWayMethod(_ sender : UIButton){
        
        if self.appDel.user.status ==  "Inactive" {
            print("user is inactive")
            return
        }
        
        var tempTask : TaskDao = TaskDao()
        
        if self.isSearching == 1 {
            tempTask  = self.searchArray.object(at: sender.tag) as! TaskDao
            
        }
        else {
            tempTask = self.tableArray.object(at: sender.tag) as! TaskDao
            
        }
        
        
        if tempTask.task_status != "on_way" && self.appDel.user.status == "on_way" {
        return
        }
        else {
        self.appDel.taskDao = tempTask
            
        }
        
        
        
        if Reachability.connectedToNetwork() {
        
        }
        else {
            
            
            
            //self.appDel.taskDao = self.tableArray.objectAtIndex(sender.tag) as! TaskDao
            if self.appDel.taskDao.task_status == "on_way"{
                let alert : UIAlertController = UIAlertController(title:localisation.localizedString(key: "general.checkinternet"), message: "", preferredStyle: UIAlertControllerStyle.alert)
                let action1 : UIAlertAction = UIAlertAction(title: localisation.localizedString(key: "tasks.cancelonway"), style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(action1)
                self.present(alert, animated: true, completion: nil)

             return
            }
            
            
            if self.appDel.taskDao.is_pool == "0" {
            self.appDel.list_id = self.appDel.taskDao.list_id
            self.performSegue(withIdentifier: "sw_questionlist", sender: nil)
            }
            else if self.appDel.taskDao.is_pool == "1" {
//                let listAlert = SCLAlertView()
//                  listAlert.showCloseButton = false
//                print("User Categories \(self.appDel.user.categories) company categories \(self.appDel.taskDao.company.categories)")
//                
//                if self.appDel.taskDao.company.categories.count == 0 || self.appDel.user.categories == nil{
//                    for catg in self.appDel.listArray {
//                        
//                        if let lDao = catg as? ListDao {
//                            listAlert.addButton(lDao.list_name!, action: {
//                                self.appDel.list_id = lDao.list_id!
//                                self.appDel.taskDao.list_id = lDao.list_id!
//                                self.performSegueWithIdentifier("sw_questionlist", sender: nil)
//                                
//                            })
//                            
//                        }// end of the if
//                        
//                    }
//                } // if categories in company are not availabe
//                else {
//                    let catgIdArray = (self.appDel.user.categories as? NSString)?.componentsSeparatedByString(",") as! NSArray
//                    
//                    for catg in self.appDel.listArray  {
//                        if let lDao = catg as? ListDao {
//                            
//                            for userCatg in catgIdArray {
//                                if let userCatg1 = userCatg as? String {
//                                    if userCatg1 == lDao.list_id {
//                                        listAlert.addButton(lDao.list_name!, action: {
//                                            self.appDel.list_id = lDao.list_id!
//                                            self.appDel.taskDao.list_id = lDao.list_id!
//                                            self.performSegueWithIdentifier("sw_questionlist", sender: nil)
//                                            
//                                        })
//                                    }
//                                }
//                            }
//                        }// end of the if
//                    } // end of the for loop
//                    
//                    
//                    
//            
//                }
//                listAlert.addButton(localisation.localizedString(key: "tasks.dismiss"), action: {
//                    
//                })
//                listAlert.showInfo("Pool Task", subTitle: self.localisation.localizedString(key:"tasks.pleaseselectinspectiontype"))
//                // end of the for loop

                self.setupCatgAlert()
                
            } // end of the is_pool
            
 
            
            
            
            
            
            //           print("Inspection type \(self.appDel.taskDao.inspection_type)")
//            if self.appDel.taskDao.inspection_type == "co-inspection" && self.appDel.taskDao.waiting_for_audit == "1" {
//                
//                self.appDel.show_result = 1
//                
//            }
            
            
            
            
            
          
            
            

        return
        }
        
        if self.appDel.user == nil {
        return
        }
        if self.appDel.user.status == "Inactive" {
            //  tasks.youareinactive
//            let alertController = UIAlertController(title:localisation.localizedString(key: "tasks.youareinactive"), message:localisation.localizedString(key: "tasks.inactiveMessage"), preferredStyle: UIAlertControllerStyle.Alert)
//            let cancel = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.Cancel, handler: nil)
//            alertController.addAction(cancel)
//            self.presentViewController(alertController, animated: true, completion: nil)
//        

            SCLAlertView().showError(localisation.localizedString(key: "tasks.youareinactive"), subTitle:localisation.localizedString(key: "tasks.inactiveMessage"), closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
  
            
            return
            
        }
        
       // self.appDel.taskDao = self.tableArray.objectAtIndex(sender.tag) as! TaskDao
         self.appDel.showIndicator = 1
//        if self.appDel.taskDao.task_status == "on_way" {
//        
//        
//            if Reachability.connectedToNetwork() {
//               
//            self.setupChangeTaskStatus(self.appDel.taskDao.task_id)
//    
//            }
//            
//            return
//        }
        
        if self.onTheWayTasksCount == 1 {
            SCLAlertView().showWarning(localisation.localizedString(key: "tasks.onmyway"), subTitle: localisation.localizedString(key: "tasks.You can only make one task 'On Way'"))
            
//        let alert = UIAlertController(title: localisation.localizedString(key: "tasks.onmyway"), message: localisation.localizedString(key: "tasks.You can only make one tasks 'On Way'"), preferredStyle: UIAlertControllerStyle.Alert)
//            let cancel = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.Cancel, handler: nil)
//            alert.addAction(cancel)
//            self.presentViewController(alert, animated: true, completion: nil)
//        
            return
        }
       // self.appDel.taskDao = self.tableArray.objectAtIndex(sender.tag) as! TaskDao
        
        self.appDel.list_id = self.appDel.taskDao.list_id
        print("For Task Number ")
          print(self.appDel.taskDao.task_id)
    
        if self.loc != nil{
            
            let numLat = NSNumber(value: (self.loc!.latitude) as Double as Double)
            let numLon = NSNumber(value: (self.loc!.longitude) as Double as Double)
            
            //  let stLat:String = numLat.stringValue
            self.appDel.showIndicator = 1
            
            let loginUrl = Constants.baseURL + "setOnWayStatus?inspector_id=" + user.user_id + "&task_id=\(self.appDel.taskDao.task_id!)&latitude=" + numLat.stringValue + "&longitude=" + numLon.stringValue
            
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "onMyWay")
            
        }
        else {
        
            SCLAlertView().showError("Location", subTitle: "Loction is not available, Please enable location")
        
            print("location is nill")
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let installation = PFInstallation.currentInstallation()
        if self.tableArray.count > 0 {
       // installation.badge = self.tableArray.count
        }
        else {
        //    installation.badge = 0
            
        }
        
        //print("Number of rows")
        if self.isCompanySearching == 1 {
            print("search array count \(self.companyNameArray.count)")
        return self.companyNameArray.count
        }
        
        if self.isSearching == 1 {
        return self.searchArray.count
        }
        else {
        return self.tableArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//        return 50
//        }
//        else {
        if self.isCompanySearching == 1 {
        return 44
        }
        else {
        return 95
        }
       // }
        }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if indexPath.row == 0 {
//        return 
//        }
//        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied{
//            self.requiredMethod()
//            
//        }
//       
//        else if self.loc == nil {
//            let alert : UIAlertController = UIAlertController(title: localisation.localizedString(key: "tasks.acquiringlocation"), message: localisation.localizedString(key: "tasks.apptryingtorecordyourlocationpleasewait!"), preferredStyle: UIAlertControllerStyle.Alert)
//            let action1 : UIAlertAction = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.Cancel, handler: nil)
//            alert.addAction(action1)
//             self.presentViewController(alert, animated: true, completion: nil)
//            
//        }
//        else {
//        
//            let alert : UIAlertController = UIAlertController(title: localisation.localizedString(key: "tasks.starttask"), message: localisation.localizedString(key: "tasks.pleasemakesureyouarereadytostart"), preferredStyle: UIAlertControllerStyle.Alert)
//            let action1 : UIAlertAction = UIAlertAction(title:localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.Cancel, handler: nil)
//            alert.addAction(action1)
//            let action2 : UIAlertAction = UIAlertAction(title: localisation.localizedString(key: "tasks.starttask"), style: UIAlertActionStyle.Default, handler: {
//             //self.performSegueWithIdentifier("sw_questionlist", sender: nil)
//                self.frommethod = 0
//                self.uploadTheLocation()
//                
//            })
//            alert.addAction(action2)
//            self.appDel.taskDao = self.tableArray.objectAtIndex(indexPath.row - 1) as! TaskDao
//            
//            self.presentViewController(alert, animated: true, completion: nil)
//           
//        
//        }
    
        if self.isCompanySearching == 1 {
            self.isSearching = 1
            let taskDao = self.companyNameArray.object(at: indexPath.row) as! TaskDao
            
            if self.appDel.selectedLanguage == 1 && taskDao.company.company_name != nil {
                
                self.newSearchField.text = taskDao.company.company_name
               
                
                
                
            }
            else  if  self.appDel.selectedLanguage == 2 && taskDao.company.company_name_arabic != nil {
                
                
                
                self.newSearchField.text = taskDao.company.company_name_arabic
                
            }
            else {
                
                self.newSearchField.text = taskDao.company.company_name
                
            }
            
           // self.newSearchField.text = taskDao.company.company_name
            self.newSearchField.resignFirstResponder()
            //self.dataTable.reloadData()
            self.dataTable.allowsSelection = false
            self.searchTasks()
            self.isCompanySearching = 0
    
        }
         else {
          
            
        } // end
    }
    
    
    /*
 // MARK:- Making inactive with locations
    User while making inactive need to select reason of beign inactive , also if inspector does not allows locations app will not allow inspector to make him/herself inactive / active
    */
    
    func makeActive(){
        // if location is not available don't allow inspector to enable to disable
        
        if self.locationStatus == -1 {
            self.requiredMethod()
            return
        }
        
        
        
        
        
        
            self.makeMeInactive("")
            
            
       
        
    }
    
    func setupChangeTaskStatus(_ task_id : String){

         let  loginUrl = Constants.baseURL + "changeTaskStatus?task_id=\(task_id)"
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
        self.appDel.showIndicator = 1
         print(loginUrl)
            downloader.startDownloader(loginUrl, idn: "tasksstatus")
    
    }
    func makeMeInactive(_ reason : String){
        // This method is used to make inspector active and inactive on criteria based
        if Reachability.connectedToNetwork() {
            
        var loginUrl : String  = ""
            self.appDel.showIndicator = 0
        if self.appDel.user.status !=  "Inactive" && self.loc != nil {
            loginUrl = Constants.baseURL + "activeInactiveInspector?inspector_id=" + self.appDel.user.user_id + "&status=inactive&latitude=\(self.loc!.latitude)&longitude=\(self.loc!.longitude)"
          self.submitBtnView.isHidden = true
            isCompanySearching = 0
           self.appDel.searchedCompany = nil
           self.isSearching =  0
            //self.appDel.user.status = "Inactive"
            self.selectedTasks = NSMutableDictionary()
          self.newSearchField.text = ""
          self.dataTable.reloadData()
        }
        else {
            if self.loc != nil {
            loginUrl = Constants.baseURL + "activeInactiveInspector?inspector_id=" + self.appDel.user.user_id + "&status=active&latitude=\(self.loc!.latitude)&longitude=\(self.loc!.longitude)"
          //self.appDel.user.status = "Inactive"
            }
        }
        
        
       print("Login url \(loginUrl)")
            
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "active")
        }
        else {
            let alert = UIAlertController(title: localisation.localizedString(key: "general.checkinternet"), message: "", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            
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

    
    func locationManager(_ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation])
        
        
        
        
    {
        
        
        
       // print("Location updated")
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        self.loc = coord
        self.appDel.userLocation = coord
        
        
        self.userDefault.set(coord.latitude, forKey: "lat")
        self.userDefault.set(coord.longitude, forKey: "lon")
        self.userDefault.synchronize()
        
//        
//        if self.appDel.user.lat != nil &&  self.appDel.user.lon != nil {
//            let companylocation = CLLocationCoordinate2DMake(self.appDel.user.lat , self.appDel.user.lon)
//            self.companyLat = self.appDel.user.lat
//            self.companyLon =  self.appDel.user.lon
//            
//            
//            // Drop a pin
//            
        let userLocation = CLLocationCoordinate2DMake(coord.latitude, coord.longitude)
       // let region = MKCoordinateRegionMakeWithDistance(userLocation, 1000, 1000)
       // self.mapView.setRegion(region, animated: true)
        //}
        
        //var aa = self.userDefault.doubleForKey("lat")
        //var bb = self.userDefault.doubleForKey("lon")
        
     //   println(coord.latitude)
     //   println(coord.longitude)
       
       // self.frommethod = 1
        
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
                self.locationStatus = -1

            }
            else {
                self.locationStatus = 1

                     }
            
            // App may no longer be authorized to obtain location
            //information. Check status here and respond accordingly.
            
    }
    
    

    
    
}
extension Double {
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
       // print(round(self * divisor) / divisor)
        return Darwin.round(self * divisor) / divisor
    }
}


