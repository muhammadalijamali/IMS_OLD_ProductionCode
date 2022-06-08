//
//  FilterPopupViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 8/27/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit
@objc protocol TaskFilterDelegate
{
    func filterSelected(_ startDate : String , endDate : String , orderBy : String,filterArea : AreaDao?,zoneDao : ZoneDao?)
    
    @objc optional func clearFilter()
    

}


class FilterPopupViewController: UIViewController , DateSelectorDelegate,AreasDelegate,ZonesDelegate,UIPopoverPresentationControllerDelegate,UIAdaptivePresentationControllerDelegate {

    @IBOutlet weak var filterByCompanyNameBtn: UIButton!
    @IBOutlet weak var startDateBtn: ADButton!
    var localisation : Localisation!
    var areaDao : AreaDao?
    var zoneDao : ZoneDao?
    
    
    @IBOutlet weak var zoneBtn: UIButton!
    
    @IBAction func filterByZoneMethod(_ sender: UIButton) {
    
        if Reachability.isConnectedNetwork() {
           
            let popController = storyboard!.instantiateViewController(withIdentifier: "cnt_zones") as! AllZonesViewController
            popController.view.backgroundColor = UIColor().withAlphaComponent(1.0)
            popController.del = self
            
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            popController.isModalInPopover = false
            
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = sender // button
            popController.popoverPresentationController?.sourceRect = sender.bounds
            self.present(popController, animated: true, completion: nil)

        
            
            
        } // end of the check internet
        
    }
    
    
    @IBOutlet weak var areaBtn: UIButton!
    var whichDate : Int = 0
    func areaCodeDetected(_ area: AreaDao) {
        
        self.areaDao = area
        self.areaBtn.setTitle(self.areaDao?.area_name_ar, for: UIControlState())
        self.zoneDao = nil
        self.zoneBtn.setTitle("Filter By Zone", for: UIControlState())
    }
    
    func zoneCodeDetected(_ area: ZoneDao) {
       self.zoneBtn.setTitle(area.zone_name_ar, for: UIControlState())
       self.zoneDao = area
       self.areaDao = nil
       self.areaBtn.setTitle("Filter By Areas", for: UIControlState())
        
    }
    
    @IBAction func areaMethod(_ sender: UIButton) {
        if Reachability.isConnectedNetwork() {
            let popController = storyboard!.instantiateViewController(withIdentifier: "cnt_area") as! AreasViewController
            popController.view.backgroundColor = UIColor().withAlphaComponent(1.0)
            popController.del = self
            
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            popController.isModalInPopover = false
            
            
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

    
    var firstDate : Date?
    var secondDate : Date?
    var del : TaskFilterDelegate?
    var startDateStr : String = ""
    var endDateStr : String = ""
     var sortBy : String = ""
    
    var appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func clearMethod(_ sender: UIButton) {
   del?.clearFilter!()
   self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var clearBtn: UIButton!
    
    
    @IBAction func filterByNameMethod(_ sender: UIButton) {
        let listAlert = SCLAlertView()
        listAlert.showCloseButton = false
        listAlert.addButton(localisation.localizedString(key: "tasks.filterbyname"), action: {
            self.sortBy = "name"
            
            self.filterByCompanyNameBtn.setTitle(self.localisation.localizedString(key: "tasks.filterbyname"), for: UIControlState())
        })
        
        listAlert.addButton(localisation.localizedString(key: "tasks.filterbydate"), action: {
            
            self.sortBy = "date"
            
            self.filterByCompanyNameBtn.setTitle(self.localisation.localizedString(key: "tasks.filterbydate"), for: UIControlState())
            
        })
        
        
        listAlert.addButton(localisation.localizedString(key: "tasks.dismiss"), action: {
            
            
            
        })
       
        listAlert.showInfo(self.localisation.localizedString(key: "tasks.sortTaskList"), subTitle: "")

    }
    @IBAction func dismissMethod(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var filterTasksBtn: UIButton!
    
    @IBAction func filterTasksMethod(_ sender: UIButton) {
    
        if del == nil {
        print("delegate is nill")
        }
        
       // print(zoneDao?.zone_name)
        del?.filterSelected(startDateStr, endDate: endDateStr, orderBy: sortBy,filterArea: self.areaDao,zoneDao: zoneDao)
       self.dismiss(animated: true, completion: nil)
     }
    func dateDeletced(_ date: Date, button: ADButton) {
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "YYYY-MM-dd"
        formatter1.locale = Locale(identifier: "en_US")
        
        
        
        
        if self.whichDate == 0 {
            self.firstDate = date
            self.startDateBtn.setTitle(formatter1.string(from: self.firstDate!), for: UIControlState())
            self.startDateStr = formatter1.string(from: self.firstDate!)
            
            //   self.firstText.text = formater.stringFromDate(date)
            if self.firstDate != nil && self.secondDate != nil {
                //  self.setupPermitDownloaderWithDates()
                // self.setupDownloaderWithDate(self.reportType, startDate: formater.stringFromDate(self.firstDate!), endDate: formater.stringFromDate(self.secondDate!))
                
                
            } // end of the if
        }
        else {
            //    self.secondText.text = formater.stringFromDate(date)
            self.endDateBtn.setTitle(formatter1.string(from: date), for:UIControlState())
            self.endDateStr = formatter1.string(from: date)
            
            self.secondDate = date
            
            if self.firstDate != nil {
                // self.setupPermitDownloaderWithDates()
                //self.setupDownloaderWithDate(self.reportType, startDate: formater.stringFromDate(self.firstDate!), endDate: formater.stringFromDate(self.secondDate!))
                
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
        
                present(
            menuViewController,
            animated: true,
            completion: nil)
    }
    
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
        
        present(
            menuViewController,
            animated: true,
            completion: nil)

    
    }
    @IBOutlet weak var endDateBtn: ADButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        self.filterByCompanyNameBtn.setTitle(localisation.localizedString(key: "tasks.filterbyname"), for: UIControlState())
        self.startDateBtn.setTitle(localisation.localizedString(key: "tasks.startdate"), for: UIControlState())
        self.endDateBtn.setTitle(localisation.localizedString(key: "tasks.enddate"), for: UIControlState())
        self.filterTasksBtn.setTitle(localisation.localizedString(key: "tasks.filter"), for: UIControlState())
        /*
         "tasks.startdate" = "Start Date";
         "tasks.enddate" = "End Date";
         "tasks.sortTaskList" = "Sort Task List";
         "tasks.filterbyname" = "Sort By Name";
         "tasks.filterbydate" = "Sort By Date";
         

           */
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
