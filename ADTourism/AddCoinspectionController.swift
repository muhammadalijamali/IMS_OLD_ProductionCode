//
//  AddCoinspectionController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 5/4/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol InspectorSelectedDelegate{
    @objc optional func inspectorsSelected(_ allInspector : NSMutableDictionary)
}

class AddCoinspectionController: UIViewController,UITableViewDataSource,UITableViewDelegate ,UITextFieldDelegate ,MainJsonDelegate {
    var inspectorsArray : NSMutableArray = NSMutableArray()
    var localisation : Localisation!
    var del : InspectorSelectedDelegate?
    @IBOutlet weak var saveBtn: UIButton!
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedDictionary : NSMutableDictionary = NSMutableDictionary()
    var is_searching : Int = 0
    var searchArray : NSMutableArray = NSMutableArray()
    var previousDict : NSMutableDictionary?
    let database = DatabaseManager()
    
    
    
    @IBOutlet weak var inspectorSearchField: UITextField!
    @IBAction func dismissMethod(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func saveMethod(_ sender: AnyObject) {
//        if self.selectedDictionary.count == 0 {
//            SCLAlertView().showError(localisation.localizedString(key: "tasks.addInspector"), subTitle:localisation.localizedString(key: "tasks.addInspector"), closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
//            
//
//            return
//        }
        
        print(selectedDictionary)
        self.del?.inspectorsSelected!(selectedDictionary)
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
        let mainQueue = OperationQueue.main
        self.saveBtn.setTitle(localisation.localizedString(key: "tasks.addInspector"), for: UIControlState())
        self.inspectorSearchField.placeholder = localisation.localizedString(key: "tasks.searchInspector")
        if self.previousDict != nil  {
            print("Previous Dict \(self.previousDict)")
        self.selectedDictionary = self.previousDict!
            
        }
        let observer = notificationCenter.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.inspectorSearchField, queue: mainQueue) { _ in
            // print("observer " + self.searchTextField.text!)
            
            self.searchInspectors()
            
            //let timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "lazyTasksDownloader", userInfo: nil, repeats: true)
            
            
            
           // self.dataTable.reloadData()
        }
        
        self.addInspectorLbl.text = localisation.localizedString(key: "tasks.addInspector")
        
//        self.inspectorsArray.addObject("")
//        self.inspectorsArray.addObject("")
//        self.inspectorsArray.addObject("")
//        self.inspectorsArray.addObject("")
//
        if Reachability.connectedToNetwork(){
        self.downloadAllInspectors()
        }
        else {
            self.inspectorsArray = database.fetchAllInspectors()
            self.inspectorsTable.reloadData()
        } // ne
        
        
        
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

            let inspector = self.inspectorsArray.object(at: a) as! InspectorDao
           // print("searching for \(self.newSearchField.text!)in\(task.company.company_name)")
            
            
            if inspector.name!.lowercased().range(of: self.inspectorSearchField.text!) != nil{
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
        var inspector : InspectorDao?
        if self.is_searching == 1 {
            inspector = self.searchArray.object(at: indexPath.row) as! InspectorDao
        }
        else {
        inspector = self.inspectorsArray.object(at: indexPath.row) as! InspectorDao
        }
        cell.inspectorNameLbl.text = inspector!.name
        //print(inspector!.id)
        cell.tickBtn.inspectorDao = nil
        
        cell.tickBtn.inspectorDao = inspector
        
        cell.tickBtn.tag = indexPath.row
        cell.tickBtn.addTarget(self, action: #selector(AddCoinspectionController.selectInspector(_:)), for: UIControlEvents.touchUpInside)
        
        if let selectedInspector = self.selectedDictionary.object(forKey: inspector!.id!) as? InspectorBtn {
            cell.tickBtn.setImage(UIImage(named:"toggle_on"), for: UIControlState())
            cell.tickBtn.isButtonSelected = 1
            // print("Inspector  found \(inspector!.name) id \(inspector!.id)")
            
//            if selectedInspector.isButtonSelected == 0 {
//                cell.tickBtn.setImage(UIImage(named:"toggle"), forState: UIControlState.Normal)
//                cell.tickBtn.isButtonSelected = 0
//                 print("Button is not selected for \(inspector!.name)")
//                
//            }
//            else {
//                cell.tickBtn.setImage(UIImage(named:"toggle_on"), forState: UIControlState.Normal)
//                cell.tickBtn.isButtonSelected = 1
//                print("Button is  selected for \(inspector!.name)")
//                
//            }
            
            
        }
        else {
            print("Inspector not found \(inspector!.name)")
        cell.tickBtn.setImage(UIImage(named:"toggle"), for: UIControlState())
        cell.tickBtn.isButtonSelected = 0
        }
        
        if indexPath.row % 2 == 0 {
        cell.contentView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
            
        }
        else {
        UIColor.white
        }
       
        
        return cell
    }
    @objc func selectInspector(_ sender : InspectorBtn){
        //print("Inspector Name in select is\(sender.inspectorDao!.name) id is \(sender.inspectorDao!.id)")
        let sender1 = InspectorBtn(frame: sender.frame)
        sender1.inspectorDao = sender.inspectorDao
        sender1.isButtonSelected = sender.isButtonSelected
        
        
        if sender.isButtonSelected == 0 {
        sender.isButtonSelected = 1
        sender1.isButtonSelected = 1
            
            sender.setImage(UIImage(named:"toggle_on"), for: UIControlState())
            sender1.setImage(UIImage(named:"toggle_on"), for: UIControlState())
            
            if (self.selectedDictionary.object(forKey: sender1.inspectorDao!.id!) as? InspectorBtn) != nil {
       // print("Already added")
            }
       else {
        // print("Saving id \(sender1.inspectorDao!.id) name \(sender1.inspectorDao!.name!)")
        self.selectedDictionary.setObject(sender1, forKey: sender.inspectorDao!.id! as NSCopying)
            }

        }
        else {
        sender.isButtonSelected = 0
            sender.setImage(UIImage(named:"toggle"), for: UIControlState())
            self.selectedDictionary.removeObject(forKey: sender.inspectorDao!.id!)

        }
        
    } // end of the selectInspector
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func downloadAllInspectors(){
        let loginUrl = Constants.baseURL + "getInspectorShiftInspectors?inspector_id=" + self.appDel.user.user_id
        print(loginUrl)
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "inspectors")
        
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "inspectors" {
        let parser = JsonParser()
            parser.user_id = self.appDel.user.user_id
            let str = String(data: data as Data, encoding: String.Encoding.utf8)
        print(str)
        self.inspectorsArray = parser.parseInspectors(data)
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
