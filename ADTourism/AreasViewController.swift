//
//  AreasViewController.swift
//  ADTourism
//
//  Created by MACBOOK on 11/6/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit
@objc protocol AreasDelegate{
    @objc optional func areaCodeDetected(_ area: AreaDao)
}

class AreasViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MainJsonDelegate , UITextFieldDelegate{

    @IBOutlet weak var bar: UIView!
    @IBOutlet weak var clearbtn: UIButton!
    
    var areas : NSMutableArray = NSMutableArray()
    var del : AreasDelegate?
    var searchArray : NSMutableArray = NSMutableArray()
    var isSearching : Int = 0
    var localisation : Localisation!
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var fromDetail :  Int = 0 // 1 means from company detal so dont show all tasks and tasks without area
    //tasks.alltasks
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var areaTable: UITableView!
    func downloadArea(){
        let loginUrl = Constants.baseURL + "getAreaListing"
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "areas")
        

    
    }// end of the downloadAreas
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSearching == 1 {
            del?.areaCodeDetected!(self.searchArray.object(at: indexPath.row) as! AreaDao)
            
        }
        else {
        del?.areaCodeDetected!(self.areas.object(at: indexPath.row) as! AreaDao)
        }
     self.dismiss(animated: true, completion: nil)
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "areas" {
        let str = String(data: data as Data, encoding: String.Encoding.utf8)
           print(str)
            
            let parser = JsonParser()
            if self.fromDetail == 0 {
            
//            let area = AreaDao()
//            area.area_id = "0"
//            area.area_name = "All Tasks"
//            area.area_name_ar = "كل المهام"
//            self.areas.addObject(area)
          
            let area1 = AreaDao()
            area1.area_id = "-1"
            area1.area_name = "Tasks without Area"
            area1.area_name_ar = "المهام دون منطقة"
            self.areas.add(area1)
            }
            
            
            
            
            self.areas.addObjects(from: parser.parseArea(data) as [AnyObject])
            
            
            
            
            
            
            //self.areas = parser.parseArea(data)
           // print(self.areas)
           self.areaTable.reloadData()
        }
    }
    
    
    
    
    @IBAction func clearAll(_ sender: UIButton) {
    
                    let area = AreaDao()
                    area.area_id = "0"
                    area.area_name = "Filter By Areas"
                    area.area_name_ar = "Filter By Areas"
       del?.areaCodeDetected!(area)
       self.dismiss(animated: true, completion: nil)
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.fromDetail == 1 {
            self.clearbtn.isHidden = true
            self.bar.isHidden = true
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
         self.downloadArea()
        
       print("From detail \(self.fromDetail)")
        
        print("From Detail \(self.fromDetail)")
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
        self.searchArray = areas
            self.areaTable.reloadData()
            
            return
        }
        
        for area in self.areas{
            if let area1 = area as? AreaDao{
               //print(area1.area_name_ar)
                if area1.area_name_ar!.lowercased().contains(self.searchField.text!) || (area1.area_name!.lowercased().contains(self.searchField.text!)) {
                self.isSearching = 1
                 print("Found")
                self.searchArray.add(area1)
                 print("searching\(self.searchArray.count)")
                
                }
            }// end of the condition
            else {
            print("Not an area object")
            }
            
        }
        self.areaTable.reloadData()
    
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
        return areas.count
        }
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var area : AreaDao?
        
        
        if self.isSearching == 1 {
         area = self.searchArray.object(at: indexPath.row) as? AreaDao
        }
        else {
        area = self.areas.object(at: indexPath.row) as? AreaDao
        }
        
        print("Cell is")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_area")
        let lbl = cell?.contentView.viewWithTag(100) as? UILabel
//        if self.appDel.selectedLanguage == 1 {
//            lbl?.text = area!.area_name
//        }
//        else {
        lbl?.text = area!.area_name_ar
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
