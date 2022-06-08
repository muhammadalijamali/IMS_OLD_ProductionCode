//
//  SearchViewController.swift
//  ADTourism
//
//  Created by Administrator on 2/1/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController , UITextFieldDelegate , UITableViewDataSource , UITableViewDelegate , MainJsonDelegate,AddIndividualDelegate{
    var tableArray : NSMutableArray = NSMutableArray()
    var searchType : Int = 0  // Not from permit , 1 from permit
    var searchText : String = ""
    
    @IBOutlet weak var dtcm_allToggle: UISwitch!
    var  rightActivity : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
   
    @IBAction func dtcm_allMethod(_ sender: UISwitch) {
        if Reachability.connectedToNetwork() && (self.licenseNoSearch.text != "" || self.searchTextField.text != ""){
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
            
            
            
            
            self.setupSearchDownloader(self.searchTextField.text!, licenseNo: searchStr as String)
        }
    }
    
    
   
    

    
    @IBOutlet weak var individuallbl: UILabel!
    
    @IBAction func typeMethod(_ sender: UISwitch) {
        if sender.isOn == false {
       // self.licenseNoSearch.hidden = true
        self.licenseNoSearch.placeholder = "License No./Passport No./Emirates Id"
        self.searchTextField.placeholder = "Search by Driver's Name"
        self.noDataLabel.isHidden = true
        self.tapToAddUnlicense.isHidden = true
            
            
            
        self.searchTextField.text = ""
        self.licenseNoSearch.text = ""
        self.tableArray = NSMutableArray()
        self.searchTable.reloadData()
        }
        else {
        self.licenseNoSearch.isHidden = false
        self.searchTextField.isHidden = false
        self.noDataLabel.isHidden = true
        self.tapToAddUnlicense.isHidden = true

            
            self.searchTextField.placeholder = localisation.localizedString(key: "searchcompany.searchbycompanyname")
            self.licenseNoSearch.placeholder = localisation.localizedString(key: "searchcompany.searchbylicenseno")

        //self.searchTextField.placeholder = "Search by Company Name"
        self.searchTextField.text = ""
        self.licenseNoSearch.text = ""
        self.tableArray = NSMutableArray()
        self.searchTable.reloadData()
            
            
        }
    }
    @IBOutlet weak var companylbl: UILabel!
    var localisation = Localisation()
    var timerSecond : Int = 0
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var secondsTimer : Timer?
    let database = DatabaseManager()
    
    @IBOutlet weak var typeSwitch: UISwitch!
    
    
    @IBOutlet weak var tapToAddUnlicense: UIButton!
    @IBOutlet weak var timeSpentlbl: UILabel!
    @IBOutlet weak var timerlbl: UILabel!
   
    
    @IBAction func tapToAddMethod(_ sender: AnyObject) {
        if self.typeSwitch.isOn == false {
            
            var storyStr : String?
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                storyStr = "Main"
            }
            else {
                storyStr = "Main_iPhone"
                
            }
            
            let storyboard = UIStoryboard(name: storyStr!, bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "cnt_addindividual") as! AddIndividualViewController
        
            
            //vc.finishDel = self
            vc.del = self
            
            self.appDel.selectedIndividual = nil
            
            
            vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
            self.present(vc, animated: true, completion: nil)
            
        }
        else {
        self.performSegue(withIdentifier: "sw_addnewestablishment", sender: nil)
        }
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
    func individualAdded(_ ind: IndividualDao) {
        print("Ind Name \(ind.fullName_ar)")
        let cnt = storyboard?.instantiateViewController(withIdentifier: "cnt_questions") as? QuestionListViewController
        //self.presentViewController(cnt!, animated: true, completion: nil)
        self.navigationController?.pushViewController(cnt!, animated: true)
    }
    
    // MARK:- TABLEVIEWDELEGATE AND DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.typeSwitch.isOn == true {
        let cell : SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_searchCompany") as! SearchTableViewCell
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
     
        
        return cell
        }
        else {
            let cell : IndividualTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_individual") as! IndividualTableViewCell
            
            let dao = self.tableArray.object(at: indexPath.row) as? IndividualDao
            cell.individualArName.text = dao?.fullName_ar
            cell.invidualEngName.text = dao?.fullName_en
            cell.emiratesIdValue.text = dao?.emirates_id
            cell.passportValue.text = dao?.passport
            cell.rtaLicenseValue.text = dao?.rtaLicense
            
        return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.typeSwitch.isOn == false {
        self.appDel.fromSearch =  1
            self.appDel.selectedIndividual = self.tableArray.object(at: indexPath.row) as? IndividualDao
            var storyStr : String?
            if UIDevice.current.userInterfaceIdiom == .pad {
            storyStr = "Main"
            }
            else {
                storyStr = "Main_iPhone"
                
            }
            
            let storyboard = UIStoryboard(name: storyStr!, bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "cnt_addindividual") as! AddIndividualViewController
            vc.del = self
            
            //vc.finishDel = self
            vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
            self.present(vc, animated: true, completion: nil)
            
            //self.performSegueWithIdentifier("sw_addIndividual", sender: nil)
        }
        else {
        let dao : CompanyDao = self.tableArray.object(at: indexPath.row) as! CompanyDao
         print("Company License No \(dao.license_info)")
            
        self.appDel.searchedCompany = dao
        
        print(self.appDel.searchedCompany?.company_name)
        self.appDel.fromSearch =  1
        self.performSegue(withIdentifier: "sw_createtasks", sender: nil)
        }
        
        
        
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
        if companyName == "" && licenseNo == "" {
            self.tableArray = NSMutableArray()
            self.searchTable.reloadData()
            return
        }

        var searchDtcm : Int = 1
        if self.dtcm_allToggle.isOn {
            searchDtcm = 1
        }
        else {
            
            
            searchDtcm = 0

        }
            if searchType != 1 &&  self.typeSwitch.isOn == true {
               let tempArray = self.database.fetchAllCompaniesByLicenseNoAndCompanyName(self.licenseNoSearch.text!,company_name: self.searchTextField.text!)
               // self.tableArray = self.database.fetchAllCompaniesByLicenseNoAndCompanyName(self.licenseNoSearch.text!,company_name: self.searchTextField.text!)
                if tempArray.count > 0 {
                self.noDataLabel.isHidden = true
                self.tapToAddUnlicense.isHidden = true
                self.tableArray = tempArray
                self.searchTable.reloadData()
                
                 return
                }
                else {
                    if searchDtcm == 1 {
                        self.tableArray = tempArray
                        self.searchTable.reloadData()
                        
                        self.noDataLabel.isHidden = false
                        if self.typeSwitch.isOn {
                            
                            self.tapToAddUnlicense.isHidden = false
                            
                            self.tapToAddUnlicense.setTitle(localisation.localizedString(key: "searchcompany.taptopadd"), for: UIControlState())
                            
                            
                            
                            self.searchView.bringSubview(toFront: self.tapToAddUnlicense)
                        }
                        else {
                        self.tapToAddUnlicense.setTitle(localisation.localizedString(key: "searchcompany.taptopaddInvidual"), for: UIControlState())
                        self.tapToAddUnlicense.isHidden = false
                        self.searchView.bringSubview(toFront: self.noDataLabel)
                        self.searchView.bringSubview(toFront: self.tapToAddUnlicense)
                        }
                        return
                    }
                    else {
                    
                    }
                }
               // self.searchTable.reloadData()
//                if tempArray.count <= 0 && searchDtcm == 1{
//                    self.noDataLabel.hidden = false
//                    self.tapToAddUnlicense.setTitle(localisation.localizedString(key: "searchcompany.taptopaddInvidual"), forState: UIControlState.Normal)
//                    self.tapToAddUnlicense.hidden = false
//                    self.searchView.bringSubviewToFront(self.noDataLabel)
//                    self.searchView.bringSubviewToFront(self.tapToAddUnlicense)
//             
//                    
//                    
//                }
//                else {
//                    
//                 self.noDataLabel.hidden = true
//                 self.tapToAddUnlicense.hidden = true
//                  
//                }
//                
//                if searchDtcm == 1 {
//                return
//                }
//                else if searchDtcm == 0 && self.tableArray.count > 0{
//                 return
//                
//                    
//                }
                
            }
        
        
    
        
        if self.typeSwitch.isOn == true {
            self.appDel.showIndicator = 0
            
            
            if self.searchType == 1 {
                self.rightActivity.startAnimating()
                
                let searchUrl = Constants.baseURL + "searchCompaniesByLicenseOrName?company_name=" + companyName + "&license_no="+licenseNo
                
                // let searchUrl = Constants.baseURL + "searchCompanies?company_name=" + companyName + "&license_no="+licenseNo
                
                print(searchUrl)
                let downloader : DataDownloader = DataDownloader()
                downloader.delegate = self
                downloader.startDownloader(searchUrl, idn: "searchCompany")
            }
            else {
                let searchUrl = Constants.baseURL + "searchCompanies?company_name=" + companyName + "&license_no="+licenseNo
                self.rightActivity.startAnimating()

                print(searchUrl)
                let downloader : DataDownloader = DataDownloader()
                downloader.delegate = self
                downloader.startDownloader(searchUrl, idn: "searchCompany")
            }
        }
        else {
            self.appDel.showIndicator = 0
            
            self.rightActivity.startAnimating()
            
            
            let searchUrl = Constants.baseURL + "searchFreelanceDriverByName?driverName=" + companyName + "&driverNumber=\(licenseNo)"
            
            print(searchUrl)
            let downloader : DataDownloader = DataDownloader()
            downloader.delegate = self
            downloader.startDownloader(searchUrl, idn: "searchInd")
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = localisation.localizedString(key: "searchcompany.addinspection")
       
        self.secondsTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SearchViewController.countSeconds), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       self.secondsTimer?.invalidate()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.title = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyPad(){
    self.licenseNoSearch.resignFirstResponder()
    self.searchTextField.resignFirstResponder()
    }
    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        let view = UIView(frame:CGRectMake(0, 0, 50, tableView.frame.width))
//        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
//        return view
//        
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.searchType == 1 {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.licenseNoSearch.text = self.searchText
        //self.setupSearchDownloader("", licenseNo: self.searchText)
        
            if Reachability.connectedToNetwork() && self.licenseNoSearch.text!.trimmingCharacters(in: CharacterSet.whitespaces) != "" 
                {
            self.setupSearchDownloader("", licenseNo: self.searchText)
        }
        else {
           // if self.licenseNoSearch.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" {
            self.tableArray = self.database.fetchAllCompaniesByLicenseNoAndCompanyName(self.licenseNoSearch.text!,company_name: self.searchTextField.text!)
           // self.searchTable.reloadData()
           // }
        }
        }
        
        
        
         rightActivity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        rightActivity.hidesWhenStopped = true
      //  rightActivity.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightActivity)

        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.hideKeyPad))
        //self.searchView.addGestureRecognizer(tap)
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
        
        
        
        self.typeSwitch.onTintColor =  UIColor(red: 34/255, green: 167/255, blue: 240/255, alpha: 1)
        self.dtcm_allToggle.onTintColor =  UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        
        
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }

        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        self.individuallbl.text = localisation.localizedString(key: "searchcompany.individual")
        self.companylbl.text = localisation.localizedString(key: "tasks.company")
        
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
                
   
                
                
            self.setupSearchDownloader(self.searchTextField.text!, licenseNo: searchStr as String)
            }
            else {
            //self.tableArray = self.database.fetchAllCompanies(self.searchTextField.text!)
               if self.typeSwitch.isOn == true {
                self.tableArray = self.database.fetchAllCompaniesByLicenseNoAndCompanyName(self.licenseNoSearch.text!,company_name: self.searchTextField.text!)
                
                self.searchTable.reloadData()
               
                
                }
               else {
                self.noDataLabel.isHidden = false
                self.searchView.bringSubview(toFront: self.noDataLabel)
                self.tapToAddUnlicense.isHidden = false
                
                self.tapToAddUnlicense.setTitle(self.localisation.localizedString(key: "Add New Individual"), for: UIControlState())
                
                
                self.searchView.bringSubview(toFront: self.tapToAddUnlicense)

                
                }
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
                self.appDel.showIndicator = 0
                
                self.setupSearchDownloader(self.searchTextField.text!,licenseNo: searchStr as String)

            }
            else {
                //self.tableArray = self.database.fetchAllCompaniesByLicenseNo(self.licenseNoSearch.text!)
                 if self.typeSwitch.isOn == true {
                self.tableArray = self.database.fetchAllCompaniesByLicenseNoAndCompanyName(self.licenseNoSearch.text!,company_name: self.searchTextField.text!)
                
                self.searchTable.reloadData()
                }
                 else {
                    self.noDataLabel.isHidden = false
                    self.searchView.bringSubview(toFront: self.noDataLabel)
                    self.tapToAddUnlicense.isHidden = false
                    
                    self.tapToAddUnlicense.setTitle(self.localisation.localizedString(key: "Add New Individual"), for: UIControlState())
                    
                    
                    self.searchView.bringSubview(toFront: self.tapToAddUnlicense)

                }
                
            }
                
                            
        }
        

        
        self.searchTextField.placeholder = localisation.localizedString(key: "searchcompany.searchbycompanyname")
        self.licenseNoSearch.placeholder = localisation.localizedString(key: "searchcompany.searchbylicenseno")
       // self.clearBtn.setTitle(localisation.localizedString(key: "searchcompany.clear"), forState: UIControlState.Normal)
        self.title = localisation.localizedString(key: "searchcompany.addinspection")
        self.noDataLabel.text = localisation.localizedString(key: "searchcompany.emptymessage")
        
        //"searchcompany.addinspection" = "Add Inspection" ;
        //"searchcompany.emptymessage" = "No Data available , Please check provided info" ;

        
        
    //   self.searchView.backgroundColor = UIColor(patternImage: UIImage(named: "tablebg")!)
        
    //    self.searchCompanyView.backgroundColor = UIColor(patternImage: UIImage(named: "tablebg")!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func countSeconds(){
        //self.timerSecond = timerSecond + 1
        print(self.appDel.totalSpendSecond)
        
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
        
        
        self.noDataLabel.isHidden = true
        self.searchTextField.resignFirstResponder()
        self.licenseNoSearch.resignFirstResponder()
       self.tableArray = NSMutableArray()
       self.searchTable.reloadData()
    }
    
    
    @IBOutlet weak var clearBtn: UIButton!
    
    //MARK:- TextFieldsDelegate
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        self.rightActivity.stopAnimating()
        
        if identity == "searchInd" {
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            print(str)
            if str!.contains("Web Authentication Redirect") {
                self.noDataLabel.text = self.localisation.localizedString(key: "searchcompany.pleasecheckinternetconnection")
                self.noDataLabel.isHidden = false
                self.tapToAddUnlicense.setTitle(localisation.localizedString(key: "searchcompany.taptopaddInvidual"), for: UIControlState())
                self.tapToAddUnlicense.isHidden = false
                self.searchView.bringSubview(toFront: self.noDataLabel)
                self.searchView.bringSubview(toFront: self.tapToAddUnlicense)
                
                return
                
            } // this conditionis when there is any error
                
            else {
                
                self.noDataLabel.text = localisation.localizedString(key: "general.norecordsfound")
                
                self.noDataLabel.isHidden = true
                // self.tapToAddUnlicense.hidden = true
                
                
            }
            
            let parser = JsonParser()
            
            self.tableArray = parser.parseIndividuals(data)
            self.searchTable.reloadData()
            if tableArray.count > 0 {
                self.tapToAddUnlicense.isHidden = true
                self.noDataLabel.isHidden = true
                
            }
            else {
                
                self.noDataLabel.isHidden = false
                self.searchView.bringSubview(toFront: self.noDataLabel)
                self.tapToAddUnlicense.isHidden = false
               
                    self.tapToAddUnlicense.setTitle(localisation.localizedString(key: "addIndividual.addIndividualToInspect"), for: UIControlState())
                    
                                   
                self.searchView.bringSubview(toFront: self.tapToAddUnlicense)
                
                
            }
        
        }
        if identity == "searchCompany" {
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            if str!.contains("Web Authentication Redirect") {
                self.noDataLabel.text = self.localisation.localizedString(key: "searchcompany.pleasecheckinternetconnection")
                
                self.noDataLabel.isHidden = false
                self.tapToAddUnlicense.setTitle(localisation.localizedString(key: "searchcompany.taptopadd"), for: UIControlState())
                self.tapToAddUnlicense.isHidden = false
                
               
                
                 self.searchView.bringSubview(toFront: self.noDataLabel)
                 self.searchView.bringSubview(toFront: self.tapToAddUnlicense)
                
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
                if self.licenseNoSearch.text == "" && self.searchTextField.text == "" {
                self.tableArray = NSMutableArray()
                  self.searchTable.reloadData()   
                }
                
                
            }
            else {
            self.noDataLabel.isHidden = false
                self.searchView.bringSubview(toFront: self.noDataLabel)
                self.tapToAddUnlicense.isHidden = false
                
                    self.tapToAddUnlicense.setTitle(localisation.localizedString(key: "searchcompany.taptopadd"), for: UIControlState())
                    
                
                
                self.searchView.bringSubview(toFront: self.tapToAddUnlicense)
                
                
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
