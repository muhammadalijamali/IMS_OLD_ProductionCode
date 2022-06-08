//
//  PoolViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 6/7/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class PoolViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , MainJsonDelegate {

    @IBOutlet weak var reddot: UIImageView!
    @IBOutlet weak var taskCountlbl: UILabel!
      var localisation : Localisation!
    
    let LOWCOLOR : UIColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
    let MEDIUMCOLOR : UIColor =  UIColor(red:246/255 , green: 142/255, blue: 90/255, alpha: 1.0)
    let HIGHCOLOR : UIColor =  UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
    
    
    @IBOutlet weak var taskListbtn: UIButton!
    var poolArray : NSMutableArray = NSMutableArray()
    let del : AppDelegate = UIApplication.shared.delegate as! AppDelegate
     
    let formater : DateFormatter = DateFormatter()
    var startCounter : Int = 0
    var processing : Int = 0
    var totalRecords : Int = 0
    
    let SEARCH_BY_ACTIVITYCODE : Int =  2
    let SEARCH_BY_LICENSE : Int = 3
    let SEARCH_BY_ADDRESS : Int = 4
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear pool options is \(del.selectedPoolOption)")
        
        if del.selectedPoolOption != 0 {
        self.setupPoolDownloader()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.title = ""
        
    }
    
    @objc func showCompanyDetail(_ sender : ADButton){
         let tasksDao : TaskDao = self.poolArray.object(at: sender.tag) as! TaskDao
        self.del.fromHistoryToResult = 1
        
        let cnt = self.storyboard!.instantiateViewController(withIdentifier: "cnt_companydetail") as! CompanyViewController
        let history = TaskHistoryDao()
        history.company_id = tasksDao.company_id
        
        cnt.history = history
        
        
        self.navigationController?.pushViewController(cnt, animated: true)
        
        //cnt_companydetail
        
    }
    
    
    @IBAction func showTaskListing(_ sender: AnyObject) {
    self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var taskListingBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
//        self.localisation = Localisation()
//        if self.del.selectedLanguage == 1{
//            self.localisation!.setPreferred("en", fallback: "ar")
//        }
//        else {
//            self.localisation!.setPreferred("ar", fallback: "en")
//        }
//        
//
//        
        
        formater.dateFormat = "MMM dd yyyy  hh:mm a"

        self.localisation = Localisation()
        if self.del.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        self.taskCountlbl.text = "\(self.del.taskCount)"
       
        
        // Do any additional setup after loading the view.
    }
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        let lastElement = dataSource.count - 1
//        if indexPath.row == lastElement {
//            // handle your logic here to get more items, add it to dataSource and reload tableview
//        }
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.poolArray.count - 1
        if indexPath.row == lastElement && processing == 0 && self.poolArray.count < self.totalRecords {
        self.startCounter = self.startCounter + 20
         self.setupPoolDownloader()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_pooldetail") as! PoolTasksTableViewCell
        
        
        
       
        
        cell.priorityLbl.text = localisation.localizedString(key: "tasks.priority")
        cell.licenseNolbl.text = localisation.localizedString(key: "company.licenseno")
        
        
            cell.expiryDatelbl.text = localisation.localizedString(key: "tasks.duedate")
           cell.taskTypeLbl.text = localisation.localizedString(key: "tasks.type")
           let tasksDao : TaskDao = self.poolArray.object(at: indexPath.row) as! TaskDao
        if tasksDao.totalRecords != nil {
        self.totalRecords = Int(tasksDao.totalRecords!)!
            
        }
        
        
        if tasksDao.task_notes == nil  || tasksDao.task_notes == ""{
            cell.taskNotesBtn.isHidden = true
            cell.taskNotesBtn.tag = indexPath.row
            // cell.notesBtn.taskDao = tas
            cell.taskNotesBtn.addTarget(self, action:  "showNotes:", for: UIControlEvents.touchUpInside)
            
        }
        else {
            cell.taskNotesBtn.tag = indexPath.row
            cell.taskNotesBtn.addTarget(self, action: "showNotes:", for: UIControlEvents.touchUpInside)
            cell.taskNotesBtn.isHidden = false
            
        }
       
        
        if tasksDao.due_date != nil {
            let date : Date? = formater.date(from: tasksDao.due_date)
            // print("Date \(date) \(tasksDao.due_date)")
            if date != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let cal = Calendar.current
                
                
                let unit:NSCalendar.Unit = NSCalendar.Unit.day
                
                
                //let components = cal.components(unit, fromDate: NSDate(), toDate: date!, options: NSCalendarOptions.SearchBackwards)
                
                // print(components.day)
            }
        }
        
        cell.licenseNoValue.text = tasksDao.license_no!
        print(tasksDao.ins_type_name_arb)
        
        if self.del.selectedLanguage == 1 && tasksDao.ins_type_name != nil {
            cell.taskTypeValue.text = tasksDao.ins_type_name!
        }
        else if self.del.selectedLanguage == 2 && tasksDao.ins_type_name != nil {
            cell.taskTypeValue.text = tasksDao.ins_type_name_arb!
        }
        else {
            cell.taskTypeValue.text = ""
            
        }
        
        
        cell.grabBtn.setTitle(localisation.localizedString(key: "pool.book"), for: UIControlState())
        
        cell.companyNameBtn.setTitle(tasksDao.company_name, for: UIControlState())
        cell.companyNameBtn.setTitleColor(UIColor(red: 101/255, green: 174/255, blue: 223/255, alpha: 1), for: UIControlState())
        cell.companyNameBtn.tag = indexPath.row
        cell.expiryDateValue.text = tasksDao.due_date
        
        cell.grabBtn.addTarget(self, action: #selector(PoolViewController.grabTheTask(_:)), for: UIControlEvents.touchUpInside)
        cell.grabBtn.taskDao = tasksDao
        
        cell.companyNameBtn.addTarget(self, action: #selector(PoolViewController.showCompanyDetail(_:)), for: UIControlEvents.touchUpInside)
        
        
        
        
        if tasksDao.priority != nil {
            //    cell.contentView.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
            
            if tasksDao.priority == "1" {
                cell.priorityLbl.text = localisation.localizedString(key: "tasks.low")
                //  cell.contentView.backgroundColor = UIColor.whiteColor()
                cell.priorityBar.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
                cell.priorityLbl.textColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
                
                
                
            }
            if tasksDao.priority == "2" {
                cell.priorityLbl.text = localisation.localizedString(key: "tasks.medium")
                //cell.contentView.backgroundColor = UIColor.whiteColor()
                cell.priorityBar.backgroundColor = UIColor(red: 246/255, green: 142/255, blue: 90/255, alpha: 1.0)
                cell.priorityLbl.textColor = UIColor(red: 246/255, green: 142/255, blue: 90/255, alpha: 1.0)
                
                
                
                
            }
            if tasksDao.priority == "3" {
                cell.priorityBar.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                
                cell.priorityLbl.text = localisation.localizedString(key: "tasks.high")
                
                cell.priorityLbl.textColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
                
                
            }
            
        }
        else {
            cell.priorityLbl.text = ""
        }
        
        
        return cell
    }
    
    @objc func grabTheTask(_ sender : ADButton) {
        if sender.taskDao.task_id != nil  {
            if Reachability.connectedToNetwork() {
                let poolURL = Constants.baseURL + "saveInspectorGrabbedTask?inspector_id=\(self.del.user.user_id!)&task_id=\(sender.taskDao.task_id!)"
                //let poolURL = Constants.baseURL + "getPoolTasksByActivityCode?activity_id=" + self.del.selectedActivityCode!.id!
                
                print(poolURL)
                
                let downloader : DataDownloader = DataDownloader()
                downloader.delegate = self
                downloader.startDownloader(poolURL, idn: "grab")
                
                
                
            } // end of the Reachability

        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.poolArray.count
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
    
        return 95
    }
    else
    {
    return 105
    }
    
    }
    
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell_pooldetail") as! PoolTasksTableViewCell
//        return cell
//    }
    
    
    
    @IBAction func showFilters(_ sender: AnyObject) {
    
        //let cnt = self.storyboard?.instantiateViewControllerWithIdentifier("cnt_showfilter")
        //cnt.
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "cnt_showfilter") as! PoolFilterViewController
        //vc.finishDel = self
       // vc.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        //self.presentViewController(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPoolDownloader(){
        self.del.showIndicator = 1
        if self.del.selectedPoolOption == 2 {  // 2 is for activity
            if self.del.selectedActivityCode != nil {
                if Reachability.connectedToNetwork() {
                  
                    let poolURL = Constants.baseURL + "getPoolTasksByActivityCode?activity_id=\(self.del.selectedActivityCode!.id!)&start=\(self.startCounter)&limit=20&priority=\(self.del.selectedUrgency)&inspectorID=\(self.del.user.user_id!)"
                    //let poolURL = Constants.baseURL + "getPoolTasksByActivityCode?activity_id=" + self.del.selectedActivityCode!.id!
                    self.processing = 1
                    print(poolURL)
//                    if self.del.selectedLanguage == 1 {
//                    self.title = "\(self.del.selectedActivityCode!.activity_code!)(\(self.del.selectedActivityCode!.activity_name!))"
//                    }
//                    else {
//                        self.title = "\(self.del.selectedActivityCode!.activity_code!)(\(self.del.selectedActivityCode!.activity_name_arabic!))"
//                        
//                    }
                     self.title = "\(self.del.selectedActivityCode!.activity_code!)"
                    
                     let downloader : DataDownloader = DataDownloader()
                    downloader.delegate = self
                    downloader.startDownloader(poolURL, idn: "pool")
                    
                    
                    
                } // end of the Reachability
            } // end of the selectedActivity
            else {
            print("Activity code is nil")
            }
            
            
        } // end of the selectedPoolOption
        else if self.del.selectedPoolOption == SEARCH_BY_LICENSE {
            if self.del.selectedLicense != nil {
                if Reachability.connectedToNetwork() {
                    var searchStr : NSString = self.del.selectedLicense! as NSString
                    
                    searchStr  = searchStr.replacingOccurrences(of: "١", with: "1") as NSString
                    searchStr = searchStr.replacingOccurrences(of: "٢", with: "2") as NSString
                    searchStr = searchStr.replacingOccurrences(of: "٣", with: "3") as NSString
                    searchStr = searchStr.replacingOccurrences(of: "٤", with: "4") as NSString
                    searchStr = searchStr.replacingOccurrences(of: "٥", with: "5") as NSString
                    searchStr = searchStr.replacingOccurrences(of: "٦", with: "6") as NSString
                    searchStr = searchStr.replacingOccurrences(of: "٧", with: "7") as NSString
                    searchStr = searchStr.replacingOccurrences(of: "٨", with: "8") as NSString
                    searchStr = searchStr.replacingOccurrences(of: "٩", with: "9") as NSString
                    searchStr = searchStr.replacingOccurrences(of: "٠", with: "0") as NSString
                    
                    
                    let poolURL = Constants.baseURL + "searchPoolTaskByCompany?query=\(searchStr)&start=\(self.startCounter)&limit=20&type=license_no&inspectorID=\(self.del.user.user_id!)"
                    
                    //let poolURL = Constants.baseURL + "getPoolTasksByActivityCode?activity_id=" + self.del.selectedActivityCode!.id!
                    self.processing = 1
                    self.poolArray = NSMutableArray()
                    self.title = self.del.selectedLicense!
                    print(poolURL)
                    
                    let downloader : DataDownloader = DataDownloader()
                    downloader.delegate = self
                    downloader.startDownloader(poolURL, idn: "pool")
                    
                }
            }
        } //
        else if self.del.selectedPoolOption ==  SEARCH_BY_ADDRESS {
            if self.del.selectedAddress != nil {
                if Reachability.connectedToNetwork() {
                    let poolURL = Constants.baseURL + "searchPoolTaskByCompany?query=\(self.del.selectedAddress!)&start=\(self.startCounter)&limit=20&type=address&priority=\(self.del.selectedUrgency)&inspectorID=\(self.del.user.user_id!)"
                    
                    //let poolURL = Constants.baseURL + "getPoolTasksByActivityCode?activity_id=" + self.del.selectedActivityCode!.id!
                    self.processing = 1
                    self.poolArray = NSMutableArray()
                    self.title = self.del.selectedAddress!
                    print(poolURL)
                    
                    let downloader : DataDownloader = DataDownloader()
                    downloader.delegate = self
                    downloader.startDownloader(poolURL, idn: "pool")
                    
                }
            }
        }
    }
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "pool" {
        let parser = JsonParser()
            
         self.poolArray.addObjects(from: parser.poolParseTasks(data) as [AnyObject])
         self.poolTableView.reloadData()
        self.processing = 0
        }
        else if identity == "grab" {
            self.startCounter = 0
            self.poolArray = NSMutableArray()
             self.del.taskCount += 1
            UIView.animate(withDuration: 0.5 ,
                                       animations: {
                                        self.taskCountlbl.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
                                        self.reddot.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
                                        
                                        
                                        
                                        
                },
                                       completion: { finish in
                                        UIView.animate(withDuration: 0.3, animations: {
                                            self.taskCountlbl.transform = CGAffineTransform.identity
                                            
                                            self.reddot.transform = CGAffineTransform.identity
                                            
                                        })
            })
            self.taskCountlbl.text = "\(self.del.taskCount)"
            self.setupPoolDownloader()
            SessionDataDownloader().setupPermitURL()
            
            
            
            
            

        }
        else {
        self.setupPoolDownloader()
        
        }
    }
    
    @IBOutlet weak var poolTableView: UITableView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
