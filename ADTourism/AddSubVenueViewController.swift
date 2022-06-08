//
//  AddSubVenueViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 5/29/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit



@objc protocol SubVenueSelectedDelegate{
    @objc optional func subVenueSelected(_ allSubvenues : NSMutableDictionary)
}

class AddSubVenueViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,MainJsonDelegate , UITextFieldDelegate {
    var inspectorsArray : NSMutableArray = NSMutableArray()
    var localisation : Localisation!
    var del : SubVenueSelectedDelegate?
    var selectedAllSelected : Int = 0
    var otherSelected : NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet weak var selectAllbtn: InspectorBtn!
    @IBOutlet weak var selectAlllbl: UILabel!
    
    @IBOutlet weak var saveBtn: UIButton!
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedDictionary : NSMutableDictionary = NSMutableDictionary()
    var is_searching : Int = 0
    var searchArray : NSMutableArray = NSMutableArray()
    var previousDict : NSMutableDictionary?
    
    
    
    
    @IBAction func selectAllSubVenue(_ sender: UIButton) {
        if self.selectedAllSelected == 0 {
            sender.setImage(UIImage(named:"toggle_on"), for: UIControlState())
        self.selectedAllSelected = 1
            for  a in self.inspectorsArray {
                if let sub = a as? SubVenueDao {
                    let tick = InspectorBtn()
                    tick.subVenue = sub
                    tick.isButtonSelected = 1
                    self.selectedDictionary.setValue(tick, forKey: sub.subVenue_id!)
                    
                }
            }
    
        }
        else {
        self.selectedDictionary.removeAllObjects()
            sender.setImage(UIImage(named:"toggle"), for: UIControlState())
        self.selectedAllSelected = 0
        }
        
                self.inspectorsTable.reloadData()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    @IBOutlet weak var inspectorSearchField: UITextField!
    @IBAction func dismissMethod(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func saveMethod(_ sender: AnyObject) {
        //        if self.selectedDictionary.count == 0 {
        //            SCLAlertView().showError(localisation.localizedString(key: "tasks.addInspector"), subTitle:localisation.localizedString(key: "tasks.addInspector"), closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
        //
        //
        //            return
        //        }
        
        self.del?.subVenueSelected!(selectedDictionary)
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var addInspectorLbl: UILabel!
    @IBOutlet weak var inspectorsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        
        let notificationCenter = NotificationCenter.default
        self.selectAlllbl.text = localisation.localizedString(key: "history.selectall")
        
        let mainQueue = OperationQueue.main
        //"company.searchSubVenue" = "Search Sub Venue";
        //"company.addsubvenue" = "Add Sub Venue";

        
        self.saveBtn.setTitle(localisation.localizedString(key: "company.addsubvenue"), for: UIControlState())
        self.inspectorSearchField.placeholder = localisation.localizedString(key: "company.searchSubVenue")
        if self.previousDict != nil  {
            self.selectedDictionary = self.previousDict!
            
        }
        let observer = notificationCenter.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.inspectorSearchField, queue: mainQueue) { _ in
            // print("observer " + self.searchTextField.text!)
            
            self.searchInspectors()
            
            //let timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "lazyTasksDownloader", userInfo: nil, repeats: true)
            
            
            
            // self.dataTable.reloadData()
        }
        
        self.addInspectorLbl.text = localisation.localizedString(key: "company.addsubvenue")
        
        //        self.inspectorsArray.addObject("")
        //        self.inspectorsArray.addObject("")
        //        self.inspectorsArray.addObject("")
        //        self.inspectorsArray.addObject("")
        //
        self.downloadAllInspectors()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    func searchInspectors(){
        if self.inspectorSearchField.text == "" {
            self.is_searching = 0
            self.searchArray = NSMutableArray()
            self.inspectorsTable.reloadData()
        } // end of the if
        else {
            
            
            self.is_searching = 1
            self.searchArray = NSMutableArray()
            
            for a in 0  ..< self.inspectorsArray.count  {
                
                let inspector = self.inspectorsArray.object(at: a) as! SubVenueDao
                // print("searching for \(self.newSearchField.text!)in\(task.company.company_name)")
                
                
                if inspector.subVenue!.lowercased().range(of: self.inspectorSearchField.text!) != nil{
                    self.searchArray.add(inspector)
                    print("adding inspector")
                }// end of the for loop
                
                
                
                
            } // end of the else
            self.inspectorsTable.reloadData()
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TABLEVIEW DATASOURCE AND DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.is_searching == 1 {
            return  self.searchArray.count
        }
        else {
            return self.inspectorsArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_inspector") as! InspectorTableViewCell
        var subVenue : SubVenueDao?
        if self.is_searching == 1 {
            subVenue = self.searchArray.object(at: indexPath.row) as! SubVenueDao
        }
        else {
            subVenue = self.inspectorsArray.object(at: indexPath.row) as! SubVenueDao
        }
        
        cell.inspectorNameLbl.text = subVenue!.subVenue
        //print(inspector!.id)
        cell.tickBtn.subVenue = subVenue
        
        cell.tickBtn.tag = indexPath.row
        cell.tickBtn.addTarget(self, action: #selector(AddSubVenueViewController.selectInspector(_:)), for: UIControlEvents.touchUpInside)
        
        if let selectedInspector = self.selectedDictionary.object(forKey: subVenue!.subVenue_id!) as? InspectorBtn {
            if selectedInspector.isButtonSelected == 0 {
                cell.tickBtn.setImage(UIImage(named:"toggle"), for: UIControlState())
                cell.tickBtn.isButtonSelected = 0
                
                
            }
            else {
                cell.tickBtn.setImage(UIImage(named:"toggle_on"), for: UIControlState())
                cell.tickBtn.isButtonSelected = 1
                
            }
        }
        else {
            cell.tickBtn.setImage(UIImage(named:"toggle"), for: UIControlState())
             cell.tickBtn.isButtonSelected = 0
        }
        
//        if self.selectedAllSelected == 1 {
//            cell.tickBtn.setImage(UIImage(named:"toggle_on"), forState: UIControlState.Normal)
//            cell.tickBtn.isButtonSelected = 1
//            self.selectedDictionary.setObject(cell.tickBtn, forKey: cell.tickBtn.subVenue!.subVenue_id!)
//            
// 
//            
//        }
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
            
        }
        else {
            UIColor.white
        }
        
        
        return cell
    }
    @objc func selectInspector(_ sender : InspectorBtn){
        let sender1  = InspectorBtn(frame: sender.frame)
        sender1.isButtonSelected = sender.isButtonSelected
        sender1.subVenue = sender.subVenue
        
        
        if sender.isButtonSelected == 0 {
             if Reachability.connectedToNetwork() {
            
            }
            else {
            self.selectedDictionary.removeAllObjects()
            
            }
            
            
            sender.isButtonSelected = 1
            sender1.isButtonSelected = 1
            
            sender.setImage(UIImage(named:"toggle_on"), for: UIControlState())
            sender1.setImage(UIImage(named:"toggle_on"), for: UIControlState())
            
            self.selectedDictionary.setObject(sender1, forKey: sender1.subVenue!.subVenue_id! as NSCopying)
            
        }
        else {
            sender.isButtonSelected = 0
            sender1.isButtonSelected = 0
            
            sender.setImage(UIImage(named:"toggle"), for: UIControlState())
            sender1.setImage(UIImage(named:"toggle"), for: UIControlState())
            
            self.selectedDictionary.removeObject(forKey: sender1.subVenue!.subVenue_id!)
            
        }
        self.inspectorsTable.reloadData()
        print("Selected Users \(self.selectedDictionary)")
        
        
    } // end of the selectInspector
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func downloadAllInspectors(){
       if Reachability.connectedToNetwork()  {
        let loginUrl = Constants.baseURL + "getSubVenueListingByLicenseNumber?license_no=" + (self.appDel.searchedCompany?.license_info)!
        print(loginUrl)
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "subvenue")
        }
        else {
        let data = DatabaseManager()
        self.inspectorsArray = NSMutableArray()
        self.selectAlllbl.isHidden = true
        self.selectAllbtn.isHidden = true
        let array = data.searchSubvenuesByLicenseNo((self.appDel.searchedCompany?.license_info)!)
        print("array count \(array.count)")
        for a in 0 ..< array.count {
        let subDao = SubVenueDao()
        let subVenueDao = array.object(at: a) as? Subvenues
          subDao.subVenue_id = subVenueDao?.id
          subDao.subVenue = subVenueDao?.subVenue
          subDao.latitude = subVenueDao?.latitude
          subDao.longitude = subVenueDao?.longitude
          print("License No \(subVenueDao?.licenseNumber)")
          self.inspectorsArray.add(subDao)
        } // end of the for loop
        self.inspectorsTable.reloadData()
        }
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "subvenue" {
            let parser = JsonParser()
            self.inspectorsArray = parser.parseSubVenues(data)
            self.inspectorsTable.reloadData()
            
        } // end of the inspectors
        
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
