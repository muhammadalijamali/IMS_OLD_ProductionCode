//
//  HistoryFilterPopupViewController.swift
//  ADTourism
//
//  Created by MACBOOK on 12/4/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol HistoryFilterDelegate
{
    func historyfilterSelected(_ filterArea : AreaDao?,zoneDao : ZoneDao?)
    @objc optional func clearFilter()
    
    
}
class HistoryFilterPopupViewController: UIViewController ,TaskFilterDelegate,UIPopoverPresentationControllerDelegate,UIAdaptivePresentationControllerDelegate,MainJsonDelegate,ZonesDelegate,AreasDelegate{

    var del : HistoryFilterDelegate?
    var selectedZone : ZoneDao?
    var selectedArea : AreaDao?
    var fromHistory : Int = 0
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
  //  tasks.filter
    var localisation : Localisation!

    @IBOutlet weak var bar: UIImageView!
    @IBOutlet weak var clearBtn: UIButton!
    @IBAction func clearMethod(_ sender: UIButton) {
   self.del?.clearFilter!()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func closeMethod(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var filterbtn: UIButton!
    
    
    @IBAction func searchMethod(_ sender: UIButton) {
    
    self.dismiss(animated: true, completion: nil)
        if del == nil {
        print("Delegate is nil")
        
        }
        del?.historyfilterSelected(selectedArea, zoneDao: selectedZone)
    }
    
    
    @IBAction func filterAreasMethod(_ sender: UIButton) {
        if Reachability.isConnectedNetwork() {
            let popController = storyboard!.instantiateViewController(withIdentifier: "cnt_area") as! AreasViewController
            popController.view.backgroundColor = UIColor().withAlphaComponent(1.0)
            popController.del = self
            
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            popController.isModalInPopover = false
            
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = sender // button
            popController.popoverPresentationController?.sourceRect = sender.bounds
            self.present(popController, animated: true, completion: nil)
        }
        
    
    }
    
    func filterSelected(_ startDate: String, endDate: String, orderBy: String, filterArea: AreaDao?, zoneDao: ZoneDao?) {
        
    }
    func zoneCodeDetected(_ area: ZoneDao) {
        
       print("Zone is selected")
        self.selectedZone = area
        if self.selectedZone != nil {
            if self.selectedZone!.zone_name_ar != nil {
            self.filterZoneBtn.setTitle(self.selectedZone!.zone_name_ar, for: UIControlState())
            
            }
            }
        else {
        print("Selected Zone is nil")
        }
    
        
    }
    
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "areas" {
        
            let str = String(data: data as Data, encoding: String.Encoding.utf8)
            print(str)
            
                let parser = JsonParser()
            
//                let area = AreaDao()
//                area.area_id = "0"
//                area.area_name = "All Tasks"
//                area.area_name_ar = "كل المهام"
//                self.appDel.allAreas.addObject(area)
//                
                let area1 = AreaDao()
                area1.area_id = "-1"
                area1.area_name = "Tasks without Area"
                area1.area_name_ar = "المهام دون منطقة"
                self.appDel.allAreas.add(area1)
            
            
            
            
            
            self.appDel.allAreas.addObjects(from: parser.parseArea(data) as [AnyObject])
            
            
            
            
        } // end of the areas
        
        if identity == "zones" {
        
                let str = String(data: data as Data, encoding: String.Encoding.utf8)
                print(str)
                
                let parser = JsonParser()
            
//                    let zone = ZoneDao()
//                    zone.zone_id = "0"
//                    zone.zone_name = "All Tasks"
//                    zone.zone_name_ar = "كل المهام"
//                    self.appDel.allZones.addObject(zone)
//            
            
            self.appDel.allZones.addObjects(from: parser.parseZones(data) as [AnyObject])
                
                
                

            
        } // end of the areas
        
        
    } // 
    
    
    func areaCodeDetected(_ area: AreaDao) {
        self.selectedArea = area
        if self.selectedArea != nil {
            if self.selectedArea!.area_name_ar != nil {
            self.filterAreasBtn.setTitle(area.area_name_ar, for: UIControlState())
            }
        }
        else {
        print("Selected Area is nil")
        }
    }
    
    
//    func filterSelected(startDate: String, endDate: String, orderBy: String, filterArea: AreaDao?, zoneDao: ZoneDao?) {
//        
//    }
//    

    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }
    
    @IBAction func filterZoneMethod(_ sender: UIButton) {
        if Reachability.isConnectedNetwork() {
            
            let popController = storyboard!.instantiateViewController(withIdentifier: "cnt_zones") as! AllZonesViewController
            popController.view.backgroundColor = UIColor().withAlphaComponent(1.0)
            popController.del = self
            
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            popController.isModalInPopover = false
            
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = sender // button
            popController.popoverPresentationController?.sourceRect = sender.bounds
            self.present(popController, animated: true, completion: nil)
            
            
            
            
        } // end of the check internet
        
    
    }
    @IBOutlet weak var filterZoneBtn: UIButton!
    @IBOutlet weak var filterAreasBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.appDel.allAreas.count <= 0 {
        self.setupAllAreas()
        } // end of the if
        
        if self.appDel.allZones.count <= 0 {
        self.setupAllZonesDownload()
        }// end of the zones
        
        self.localisation = Localisation()
        
        
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }
        
        
        self.filterbtn.setTitle(localisation.localizedString(key: "tasks.filter"), for: UIControlState())
        
        
    
        
        
        // Do any additional setup after loading the view.
    }

    func setupAllZonesDownload(){
        if Reachability.connectedToNetwork() {
            let loginUrl = Constants.baseURL + "getInspectorAssignedZones?inspectorID=\(appDel.user.user_id!)"
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "zones")
        } // end of the
    
    }
    
    func setupAllAreas(){
        if Reachability.connectedToNetwork() {
            let loginUrl = Constants.baseURL + "getAreaListing"
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "areas")
        
        } // end o
    
    
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
