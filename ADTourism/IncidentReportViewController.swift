//
//  IncidentReportViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 6/1/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class IncidentReportViewController: UIViewController , UITextFieldDelegate , UITableViewDataSource , UITableViewDelegate , MainJsonDelegate{
    var tableArray : NSMutableArray = NSMutableArray()
    var localisation = Localisation()
    var timerSecond : Int = 0
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var secondsTimer : Timer?
    let database = DatabaseManager()
    var report_type : Int = 1
    
    @IBOutlet weak var sept1: UIImageView!
    
    @IBOutlet weak var incidentTypeBtn: UIButton!
    @IBOutlet weak var sept2: UIImageView!
    
    @IBOutlet weak var sept3: UIImageView!
    @IBOutlet weak var selectIncidentlbl: UILabel!
    
    
    @IBOutlet weak var withoutNameBtn: UIButton!
    func hideKey(){
    
    }
    
       
    @IBAction func withoutCompanyNameMethod(_ sender: UIButton) {
        self.appDel.reportType = self.report_type
        // print(self.appDel.searchedCompany?.company_name)
        let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "cnt_createincidentcnt"))!
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func showIncidentType(_ sender: AnyObject) {
        
        let alert = SCLAlertView()
        alert.showCloseButton = false
        
        alert.addButton("DTCM", action: {
           
            self.report_type = 1 // DTCM
            //self.typeLbl.text = "DTCM"
            self.incidentTypeBtn.setTitle("DTCM", for: UIControlState())
            self.licenseNoSearch.isHidden = false
           // self.tableArray = NSMutableArray()
         //   self.searchTable.reloadData()
            
        } )
        
        alert.addButton("EXTERNAL", action: {
           
            self.report_type = 2 // NON DTCM
            //self.typeLbl.text = "EXTERNAL"
            self.incidentTypeBtn.setTitle("EXTERNAL", for: UIControlState())
           // self.licenseNoSearch.hidden = true
           // self.tableArray = NSMutableArray()
           // self.searchTable.reloadData()
            
        } )
        
        
        
        
        
        

        
        
        alert.addButton(localisation.localizedString(key: "questions.cancel"), action: {
           
            
        })
        
        alert.showInfo(localisation.localizedString(key: "incidentreport.reporttitle"), subTitle: "")

    
    }
    
    
    @IBOutlet weak var incidentTypeView: UIView!
    @IBOutlet weak var tapToAddUnlicense: UIButton!
    @IBOutlet weak var timeSpentlbl: UILabel!
    @IBOutlet weak var timerlbl: UILabel!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func tapToAddMethod(_ sender: AnyObject) {
        //self.performSegueWithIdentifier("sw_unlicenseIncident", sender: nil)
        self.appDel.reportType = self.report_type

        let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "cnt_createincidentcnt_unlicensed"))!
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var searchTable: UITableView!
    var searchByLicenseNo : Int = 0 // 0  search by company name ,  1 search by license
    @IBOutlet weak var licenseNoSearch: UITextField!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var licenseNoToggle: UIButton!
    @IBAction func licenseToggleMethod(_ sender: AnyObject) {
        if self.searchByLicenseNo == 0 {
            self.searchByLicenseNo = 1
            self.licenseNoToggle.setImage(UIImage(named: "toggle_on"), for: UIControlState())
            //  self.searchTextField.placeholder = "Search by license number"
            self.searchTextField.attributedPlaceholder = NSAttributedString(string:"Search by license number",
                                                                            attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        }
        else {
            self.searchByLicenseNo = 0
            self.licenseNoToggle.setImage(UIImage(named: "toggle"), for: UIControlState())
            ///self.searchTextField.placeholder = "Search by Company Name"
            self.searchTextField.attributedPlaceholder = NSAttributedString(string:"Search by company name",
                                                                            attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
            
            
        }
    }
    
    // MARK:- TABLEVIEWDELEGATE AND DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_searchCompany") as! SearchTableViewCell
//        if report_type == 2 {
//        let dao = self.tableArray.objectAtIndex(indexPath.row) as? ExternalOrgDao
//            if dao != nil  {
//            cell.company_name_ar.text = dao?.e_establishmentArabicName
//            cell.companyNameLbl.text = dao?.e_establihsmentName
//            cell.licensenolbl.hidden = true
//            cell.licenseNumberLbl.hidden = true
//            }
//        }
//            
//        else {
        let dao = self.tableArray.object(at: indexPath.row) as! CompanyDao
        if dao.company_name != nil {
            cell.companyNameLbl.text = dao.company_name!
        }
        if dao.license_info != nil {
            cell.licenseNumberLbl.text = dao.license_info!
        }
        
        if dao.company_name_arabic != nil {
            cell.company_name_ar.text = dao.company_name_arabic!
        }
        cell.licensenolbl.text = localisation.localizedString(key: "searchcompany.licenseno")
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor =  UIColor.white
        }
        else {
            cell.contentView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        }
        
        //}
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.report_type == 2 {
//        self.appDel.reportType = 2
//            let dao : ExternalOrgDao? = self.tableArray.objectAtIndex(indexPath.row) as? ExternalOrgDao
//            self.appDel.externalOrg = dao
//            let vc : UIViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("cnt_createincidentcnt"))!
//            vc.modalPresentationStyle = UIModalPresentationStyle.FormSheet
//            
//            self.presentViewController(vc, animated: true, completion: nil)
//            
//        }
//        else {
        let dao : CompanyDao = self.tableArray.object(at: indexPath.row) as! CompanyDao
        self.appDel.searchedCompany = dao
        self.appDel.reportType = self.report_type
        print(self.appDel.searchedCompany?.company_name)
        let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "cnt_createincidentcnt"))!
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet

        self.present(vc, animated: true, completion: nil)
        //}
            //self.performSegueWithIdentifier("cnt_createincidentcnt", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count
    }
    
    @IBOutlet weak var searchCompanyView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    func setupSearchDownloader(_ companyName : String , licenseNo : String){
        
//        if self.report_type == 2 {
//            let searchUrl = Constants.baseURL + "searchExternalOrgByName?query=" + companyName
//            
//            
//            print(searchUrl)
//            let downloader : DataDownloader = DataDownloader()
//            downloader.delegate = self
//            downloader.startDownloader(searchUrl, idn: "searchOrg")
//            
//        }
//        else {
       let tempArray =  self.database.fetchAllCompaniesByLicenseNoAndCompanyName(self.licenseNoSearch.text!,company_name: self.searchTextField.text!)
        
        //self.tableArray = self.database.fetchAllCompaniesByLicenseNoAndCompanyName(self.licenseNoSearch.text!,company_name: self.searchTextField.text!)
        if tempArray.count > 0 {
            self.tapToAddUnlicense.isHidden = true
            self.noDataLabel.isHidden = true
            self.withoutNameBtn.isHidden = true
             self.tableArray = tempArray
             self.searchTable.reloadData()
            
        }
        else {
        
        
        
        //self.searchTable.reloadData()
        //self.noDataLabel.hidden = true
        //self.tapToAddUnlicense.hidden = true
        
        
        let searchUrl = Constants.baseURL + "searchCompanies?company_name=" + companyName + "&license_no="+licenseNo
        
        print(searchUrl)
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(searchUrl, idn: "searchCompany")
        }
       // }
        
    }
    
      
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.title = localisation.localizedString(key: "searchcompany.addinspection")
        self.appDel.incidentEnlargeImage = nil
        
       // self.secondsTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "countSeconds", userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.secondsTimer?.invalidate()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.title = ""
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDel.showIndicator = 0
        //UINavigationBar.appearance().shadowImage = UIImage()
     //  self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //       self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_bg")!)
        //        let dao1 = SearchCompanyDao()
        //
        //        dao1.company_id = "1"
        //        dao1.company_name = "SoftSource"
        //        dao1.license_no = "4534535"
        //        self.tableArray.addObject(dao1)
        
        //        self.searchTextField.attributedPlaceholder = NSAttributedString(string:"Search by company name",
        //            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        //
        
        /*
         "searchcompany.searchbycompanyname" = "Search by company name";
         "searchcompany.searchbylicenseno" = "Search by license no.";
         "searchcompany.clear" = "Clear";
         "searchcompany.licenseno" = "License No.";
         */
        
        
        
        //   self.secondsTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "countSeconds", userInfo: nil, repeats: true)
        
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        self.appDel.showIncidentMedia = 0
        
        
        let observer = notificationCenter.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.searchTextField, queue: mainQueue) { _ in
            // print("observer " + self.searchTextField.text!)
            
            
            if let intVal = Int(self.searchTextField.text!) {
                // Text field converted to an Int
                //button.enabled = true
                if (self.searchTextField.text! as NSString).length > 2 {
                    self.showAlert(self.localisation.localizedString(key: "searchcompany.establishmentnamefield"), text: self.localisation.localizedString(key: "searchcompany.pleaseenterestablishmentnameinsteadofnumber"))
                    
                }
            }
            
            
            
            //self.setupSearchDownloader(self.searchTextField.text!, licenseNo: self.licenseNoSearch.text!)
            if Reachability.connectedToNetwork() {
                self.setupSearchDownloader(self.searchTextField.text!, licenseNo: self.licenseNoSearch.text!)
            }
            else {
                //self.tableArray = self.database.fetchAllCompanies(self.searchTextField.text!)
               // self.tableArray = self.database.fetchAllCompaniesByLicenseNoAndCompanyName(self.licenseNoSearch.text!,company_name: self.searchTextField.text!)
                
                self.searchTable.reloadData()
            }
        }
        
        
        let observer2 = notificationCenter.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self.licenseNoSearch, queue: mainQueue) { _ in
            // print("observer " + self.searchTextField.text!)
            
            
            var searchStr : NSString = self.licenseNoSearch.text! as NSString
            
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
            
            
            //print(searchStr)
            
            if Reachability.connectedToNetwork() {
                self.setupSearchDownloader(self.searchTextField.text!,licenseNo: self.licenseNoSearch.text!)
                
            }
            else {
                //self.tableArray = self.database.fetchAllCompaniesByLicenseNo(self.licenseNoSearch.text!)
                self.tableArray = self.database.fetchAllCompaniesByLicenseNoAndCompanyName(self.licenseNoSearch.text!,company_name: self.searchTextField.text!)
                
                self.searchTable.reloadData()
                
                
            }
            
            
        }
        
       
        
        self.searchTextField.placeholder = localisation.localizedString(key: "company.companyname")
        self.licenseNoSearch.placeholder = localisation.localizedString(key: "company.licenseno")
       // self.clearBtn.setTitle(localisation.localizedString(key: "searchcompany.clear"), forState: UIControlState.Normal)
        self.title = localisation.localizedString(key: "incidentreport.title")
        self.noDataLabel.text = localisation.localizedString(key: "searchcompany.emptymessage")
        self.appDel.notifDao = nil
        self.appDel.showIncidentMedia = 0
        
        //"searchcompany.addinspection" = "Add Inspection" ;
        //"searchcompany.emptymessage" = "No Data available , Please check provided info" ;
        
        
        
      //  self.searchView.backgroundColor = UIColor(patternImage: UIImage(named: "tablebg")!)
        
       // self.searchCompanyView.backgroundColor = UIColor(patternImage: UIImage(named: "tablebg")!)
        
        self.searchView.bringSubview(toFront: self.sept1)
        self.searchView.bringSubview(toFront: self.sept2)
        if UIDevice.current.userInterfaceIdiom == .pad {
        self.searchView.bringSubview(toFront: self.sept3)
        }
        
        self.selectIncidentlbl.text = localisation.localizedString(key: "tasks.selectincidentreport")
        
        if Reachability.connectedToNetwork() {
        
        }
        else {
            let alert = UIAlertController(title: "", message: localisation.localizedString(key: "general.checkinternet"), preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
//self.navigationController!.navigationBar.clipsToBounds = true;
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func countSeconds(){
        //self.timerSecond = timerSecond + 1
        self.appDel.totalSpendSecond = self.appDel.totalSpendSecond + 1
        
        let minutes : Int = (self.appDel.totalSpendSecond / 60)
        let hours : Int = minutes / 60
        
        let second  = (self.appDel.totalSpendSecond % 60)
        
        //        print("Minutes \(minutes)")
        //        print("Hours \(hours)")
        //        print("all seconds\(timerSecond)")
        //
        // let hour = (self.timerSecond / 60)/60
        // let minute = (self.timerSecond/60)
        
        
        self.timerlbl.text = "\(hours):\(minutes):\(second)"
        
    }
    
    @IBAction func clearMethod(_ sender: AnyObject) {
        self.searchTextField.text = ""
        self.licenseNoSearch.text = ""
        self.tapToAddUnlicense.isHidden = true
        self.withoutNameBtn.isHidden = true
        
        
        self.noDataLabel.isHidden = true
        self.searchTextField.resignFirstResponder()
        self.licenseNoSearch.resignFirstResponder()
        self.tableArray = NSMutableArray()
        self.searchTable.reloadData()
    }
    
    
    @IBOutlet weak var clearBtn: UIButton!
    
    //MARK:- TextFieldsDelegate
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "searchCompany" {
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            if str!.contains("Web Authentication Redirect") {
                self.noDataLabel.text = self.localisation.localizedString(key: "searchcompany.pleasecheckinternetconnection")
                
                self.noDataLabel.isHidden = false
                
               // self.tapToAddUnlicense.setTitle(localisation.localizedString(key: "searchcompany.taptopadd"), forState: UIControlState.Normal)
                //self.tapToAddUnlicense.hidden = false
                
                
                
                self.searchView.bringSubview(toFront: self.noDataLabel)
              //  self.searchView.bringSubviewToFront(self.tapToAddUnlicense)
                
                return
                
            }
           else {
                
                self.noDataLabel.text = localisation.localizedString(key: "searchcompany.emptymessage")
                
                self.noDataLabel.isHidden = true
                // self.tapToAddUnlicense.hidden = true
                
                
            }
            
            
            let parser = JsonParser()
            
            self.tableArray = parser.parseSearchdCompanies(data)
            self.searchTable.reloadData()
            if tableArray.count > 0 {
                self.tapToAddUnlicense.isHidden = true
                self.noDataLabel.isHidden = true
                self.withoutNameBtn.isHidden = true
                
                
            }
            else {
                self.noDataLabel.isHidden = false
                self.withoutNameBtn.isHidden = false
                
                self.searchView.bringSubview(toFront: self.noDataLabel)
                self.tapToAddUnlicense.isHidden = false
                self.tapToAddUnlicense.setTitle(localisation.localizedString(key: "searchcompany.taptopadd"), for: UIControlState())
                
                self.searchView.bringSubview(toFront: self.tapToAddUnlicense)
                
                
            }
        }
        else if identity == "searchOrg" {
            let parser = JsonParser()
            
            self.tableArray = parser.parseSearchedExternalOrg(data)
            
            self.searchTable.reloadData()
            if tableArray.count > 0 {
                self.tapToAddUnlicense.isHidden = true
                self.noDataLabel.isHidden = true
                self.withoutNameBtn.isHidden = true
                
                
            }else {
                self.noDataLabel.isHidden = false
                self.withoutNameBtn.isHidden = false
                

            }
            
            
        }

        
    }
    
    func showAlert(_ title : String ,text : String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        if textField.text == "" {
        //        return true
        //
        //        }
        //        print("TextField" + textField.text!)
        //        print("String " + string)
        
        
        //        let searchStr = textField.text! + string
        //        print(searchStr)
        //        print(textField.text!)
        //
        //        if Reachability.connectedToNetwork() {
        //            self.noDataLabel.text = localisation.localizedString(key: "searchcompany.emptymessage")
        //
        //            self.noDataLabel.hidden = true
        //
        //        if textField == self.searchTextField {
        //            let text  = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        //
        //            if let intVal = Int(text) {
        //                // Text field converted to an Int
        //                //button.enabled = true
        //                if (text as NSString).length > 2 {
        //                self.showAlert(localisation.localizedString(key: "searchcompany.establishmentnamefield"), text: localisation.localizedString(key: "searchcompany.pleaseenterestablishmentnameinsteadofnumber"))
        //                }
        //                return true
        //
        //
        //            } else {
        //
        //
        //                // Text field is not an Int
        //               // button.enabled = false
        //            }
        //
        //        self.setupSearchDownloader(searchStr, licenseNo: self.licenseNoSearch.text!)
        //
        //        }
        //        else {
        //            var searchStr : NSString = textField.text! + string
        //
        //            searchStr  = searchStr.stringByReplacingOccurrencesOfString("١", withString: "1")
        //            searchStr = searchStr.stringByReplacingOccurrencesOfString("٢", withString: "2")
        //            searchStr = searchStr.stringByReplacingOccurrencesOfString("٣", withString: "3")
        //            searchStr = searchStr.stringByReplacingOccurrencesOfString("٤", withString: "4")
        //            searchStr = searchStr.stringByReplacingOccurrencesOfString("٥", withString: "5")
        //            searchStr = searchStr.stringByReplacingOccurrencesOfString("٦", withString: "6")
        //            searchStr = searchStr.stringByReplacingOccurrencesOfString("٧", withString: "7")
        //            searchStr = searchStr.stringByReplacingOccurrencesOfString("٨", withString: "8")
        //            searchStr = searchStr.stringByReplacingOccurrencesOfString("٩", withString: "9")
        //            searchStr = searchStr.stringByReplacingOccurrencesOfString("٠", withString: "0")
        //
        //
        //            print(searchStr)
        //
        //
        //
        //
        //            self.setupSearchDownloader(searchTextField.text!,licenseNo: searchStr as String)
        //
        //        }
        //        }
        //        else {
        //            self.tableArray = NSMutableArray()
        //            self.searchTable.reloadData()
        //            self.noDataLabel.text = self.localisation.localizedString(key: "searchcompany.pleasecheckinternetconnection")
        //
        //            self.noDataLabel.hidden = false
        //            self.searchView.bringSubviewToFront(self.noDataLabel)
        //
        //
        //        }
        return true
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //        if textField == searchTextField {
        //        self.licenseNoSearch.text = ""
        //        }
        //        else {
        //        self.searchTextField.text = ""
        //        }
        //
        return true
        
    }
    
    // MARK:- Main Data Downloader delegate 
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
