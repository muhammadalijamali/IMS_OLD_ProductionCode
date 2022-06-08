//
//  SearchSubvenueController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 7/26/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit
@objc protocol SearchSubVenueDelegate{
    @objc optional func subVenueSearched(_ subvenue : SubVenueDao)
}

class SearchSubvenueController: UIViewController , MainJsonDelegate , UITableViewDelegate,UITableViewDataSource{
var subvenueArray : NSMutableArray = NSMutableArray()
let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
var is_searching : Int = 0
var licenseNo : String?
 var del : SearchSubVenueDelegate?
var searchArray : NSMutableArray = NSMutableArray()
var localisation : Localisation!
   
    @IBOutlet weak var subvenueTable: UITableView!
    @IBOutlet weak var searchSubvenueField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }

        self.searchSubvenueField.placeholder = localisation.localizedString(key: "company.searchSubVenue")
        self.downloadAllSubvenues()
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        let observer = notificationCenter.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.searchSubvenueField, queue: mainQueue) { _ in
            // print("observer " + self.searchTextField.text!)
            
            self.searchInspectors()
            
            //let timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "lazyTasksDownloader", userInfo: nil, repeats: true)
            
            
            
            // self.dataTable.reloadData()
        }

        
        
        
        // Do any additional setup after loading the view.
    }

    func downloadAllSubvenues(){
        if Reachability.connectedToNetwork()  {
            if self.licenseNo != nil {
            let loginUrl = Constants.baseURL + "getSubVenueListingByLicenseNumber?license_no=" + self.licenseNo!
            print(loginUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(loginUrl, idn: "subvenue")
            }
        }//
    }
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "subvenue" {
        let parser = JsonParser()
        self.subvenueArray = parser.parseSubVenues(data)
        self.subvenueTable.reloadData()
        }// end of the identity
        
        
    }
    
    func searchInspectors(){
        if self.searchSubvenueField.text == "" {
            self.is_searching = 0
            self.searchArray = NSMutableArray()
            self.subvenueTable.reloadData()
        } // end of the if
        else {
            
            
            self.is_searching = 1
            self.searchArray = NSMutableArray()
            
            for a in 0  ..< self.subvenueArray.count  {
                
                let inspector = self.subvenueArray.object(at: a) as! SubVenueDao
                // print("searching for \(self.newSearchField.text!)in\(task.company.company_name)")
                
                
                if inspector.subVenue!.lowercased().range(of: self.searchSubvenueField.text!.lowercased()) != nil{
                    self.searchArray.add(inspector)
                    print("adding inspector")
                }// end of the for loop
                
                
                
                
            } // end of the else
            self.subvenueTable.reloadData()
        }
        
        
    }

    
    
       
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    @IBAction func dismissMethod(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.is_searching == 1 {
            return  self.searchArray.count
        }
        else {
            return self.subvenueArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_subvenue") as! InspectorTableViewCell
        var subVenue : SubVenueDao?
        if self.is_searching == 1 {
            subVenue = self.searchArray.object(at: indexPath.row) as! SubVenueDao
        }
        else {
            subVenue = self.subvenueArray.object(at: indexPath.row) as! SubVenueDao
        }
        
        cell.inspectorNameLbl.text = subVenue!.subVenue
        //print(inspector!.id)
                if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
            
        }
        else {
            UIColor.white
        }
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subvenue = self.subvenueArray.object(at: indexPath.row) as? SubVenueDao
        del?.subVenueSearched!(subvenue!)
        self.dismiss(animated: true, completion: nil)
    }
    func adaptivePresentationStyleForPresentationController(_ controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
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
