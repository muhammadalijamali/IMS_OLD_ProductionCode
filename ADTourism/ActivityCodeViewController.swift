//
//  ActivityCodeViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 6/9/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class ActivityCodeViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , MainJsonDelegate {
    var allActivityCodes  : NSMutableArray = NSMutableArray()
    var del : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        
        let observer2 = notificationCenter.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.searchTextField, queue: mainQueue) { _ in
            // print("observer " + self.searchTextField.text!)
            
            
            var searchStr : String = self.searchTextField.text!
            searchStr = Util.removeSpecialCharsFromString(searchStr)
            
            
            searchStr  = (searchStr.replacingOccurrences(of: "١", with: "1") ) as String
            searchStr = (searchStr.replacingOccurrences(of: "٢", with: "2") as NSString) as String
            searchStr = (searchStr.replacingOccurrences(of: "٣", with: "3") as NSString) as String
            searchStr = (searchStr.replacingOccurrences(of: "٤", with: "4") as NSString) as String
            searchStr = (searchStr.replacingOccurrences(of: "٥", with: "5") as NSString) as String
            searchStr = (searchStr.replacingOccurrences(of: "٦", with: "6") as NSString) as String
            searchStr = (searchStr.replacingOccurrences(of: "٧", with: "7")as NSString) as String
            searchStr = (searchStr.replacingOccurrences(of: "٨", with: "8") as NSString) as String
            searchStr = (searchStr.replacingOccurrences(of: "٩", with: "9") as NSString) as String
            searchStr = (searchStr.replacingOccurrences(of: "٠", with: "0") as NSString) as String
            
            
         //   print(searchStr)
            
            if Reachability.connectedToNetwork() {
                self.setUpActivityCodeDownloader(self.searchTextField.text!)
                
            } // end of the network
            
            
            
        }

        
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.allActivityCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell_searchactivitycode")
      let dao  = self.allActivityCodes.object(at: indexPath.row) as! ActivityCodeDao
        if self.del.selectedLanguage == 1 {
        cell?.textLabel?.text  = dao.activity_code! + " (\(dao.activity_name!))"
        }
        if self.del.selectedLanguage == 2 {
            if dao.activity_code != nil  && dao.activity_name_arabic != nil {
            cell?.textLabel?.text  = dao.activity_code! + " (\(dao.activity_name_arabic!))"
            }
            else if dao.activity_code != nil && dao.activity_name != nil  {
            cell?.textLabel?.text  = dao.activity_code! + " (\(dao.activity_name!))"
            }
        }
        
        
        return cell!
        
    
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let activityCodeDao = self.allActivityCodes.object(at: indexPath.row) as! ActivityCodeDao
       self.del.selectedActivityCode = activityCodeDao
       print("Activity id \(activityCodeDao.id!)")
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpActivityCodeDownloader(_ activity_code : String){
        if Reachability.connectedToNetwork() {
            let activityCodeUrl = Constants.baseURL + "getActivityListByCode?activity_code=" + activity_code
            
            print(activityCodeUrl)
            
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(activityCodeUrl, idn: "profile")
            
            
            
        }
    }
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
     let parser = JsonParser()
        print("Parsing finished")
        self.allActivityCodes = parser.parsePoolActivityCodes(data)
        self.tableView.reloadData()
        
        
    }// end of the datadownloaded
    
    

    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityCodeSearchBar: UISearchBar!
    @IBAction func dissmiss(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeMethod(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
        
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
