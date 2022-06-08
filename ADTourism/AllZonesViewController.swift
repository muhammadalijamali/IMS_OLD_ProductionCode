//
//  AllZonesViewController.swift
//  ADTourism
//
//  Created by MACBOOK on 11/27/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol ZonesDelegate{
    @objc optional func zoneCodeDetected(_ area: ZoneDao)
}

class AllZonesViewController: UIViewController,MainJsonDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var zoneTableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    var zones : NSMutableArray = NSMutableArray()
    var del : ZonesDelegate?
    var searchArray : NSMutableArray = NSMutableArray()
    var isSearching : Int = 0
    var localisation : Localisation!
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var claearBtn: UIButton!
    
    
    @IBAction func clearAll(_ sender: UIButton) {
     self.dismiss(animated: true, completion: nil)
    }
    
    var fromDetail :  Int = 0 // 1 means from company detal so dont show all tasks and tasks without area
    //tasks.alltasks
    @IBOutlet weak var areaTable: UITableView!
    func downloadZones(){
        let loginUrl = Constants.baseURL + "getInspectorAssignedZones?inspectorID=\(appDel.user.user_id!)"
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "zones")
        
        
        
    }// end of the downloadAreas
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSearching == 1 {
            del?.zoneCodeDetected!(self.searchArray.object(at: indexPath.row) as! ZoneDao)
            
        }
        else {
            del?.zoneCodeDetected!(self.zones.object(at: indexPath.row) as! ZoneDao)
        }
        self.dismiss(animated: true, completion: nil)
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "zones" {
            let str = String(data: data as Data, encoding: String.Encoding.utf8)
          //  print(str)
            
            let parser = JsonParser()
            if self.fromDetail == 0 {
                
//                let zone = ZoneDao()
//                zone.zone_id = "0"
//                zone.zone_name = "All Tasks"
//                zone.zone_name_ar = "كل المهام"
//                self.zones.addObject(zone)
//                
               
            }
            
            
            
            
            self.zones.addObjects(from: parser.parseZone(data) as [AnyObject])
            
            
            
            
            //self.areas = parser.parseArea(data)
            // print(self.areas)
            self.zoneTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        if self.appDel.allZones.count <= 0 {
        self.downloadZones()
        }
        else {
            self.zones = self.appDel.allZones
        }
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        
        let observer = notificationCenter.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.searchField, queue: mainQueue) { _ in
            // print("observer " + self.searchTextField.text!)
            
            //self.searchTasks()
            self.filterCompanyName()
            //let timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "lazyTasksDownloader", userInfo: nil, repeats: true)
            
            
            
            // self.dataTable.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    func filterCompanyName(){
        self.searchArray = NSMutableArray()
        
        
        
        print("Filter company \(self.searchField.text!)")
        //        let area = AreaDao()
        //        area.area_id = "0"
        //        area.area_name = "All Tasks"
        //        area.area_name_ar = "All Tasks"
        //        self.searchArray.addObject(area)
        //
        //        let area1 = AreaDao()
        //        area1.area_id = "-1"
        //        area1.area_name = "Tasks without Area"
        //        area1.area_name_ar = "Tasks without Area"
        //        self.searchArray.addObject(area1)
        //
        
        self.isSearching = 1
        if self.searchField.text == "" {
        self.searchArray = zones
        self.zoneTableView.reloadData()
            return
            
        }
        
        for zone in self.zones{
            if let zone1 = zone as? ZoneDao{
                //print(area1.area_name_ar)
                if zone1.zone_name_ar!.lowercased().contains(self.searchField.text!) || (zone1.zone_name!.lowercased().contains(self.searchField.text!)) {
                    self.isSearching = 1
                    print("Found")
                    self.searchArray.add(zone1)
                    print("searching\(self.searchArray.count)")
                    
                }
            }// end of the condition
            else {
                print("Not an area object")
            }
            
        }
        self.zoneTableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func adaptivePresentationStyleForPresentationController(_ controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching == 1 {
            return self.searchArray.count
        }
        else {
            return zones.count
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var zone : ZoneDao?
        
        
        if self.isSearching == 1 {
            zone = self.searchArray.object(at: indexPath.row) as? ZoneDao
        }
        else {
            zone = self.zones.object(at: indexPath.row) as? ZoneDao
        }
        
        print("Cell is")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_area")
        let lbl = cell?.contentView.viewWithTag(100) as? UILabel
        //        if self.appDel.selectedLanguage == 1 {
        //            lbl?.text = area!.area_name
        //        }
        //        else {
        lbl?.text = zone?.zone_name_ar
        // }
        
        return cell!
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
