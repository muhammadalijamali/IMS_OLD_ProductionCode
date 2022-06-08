//
//  AddIndividualViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 3/28/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit
@objc protocol AddIndividualDelegate{
    @objc optional func individualAdded(_ ind : IndividualDao)
    
}


class AddIndividualViewController: UIViewController ,MainJsonDelegate,AddIndividualDelegate,UITextFieldDelegate,CountryDelegate {
//cnt_questions
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var drivingLicenseNoTextField: UITextField!
    @IBOutlet weak var passportNoTextfield: UITextField!
    @IBOutlet weak var emiratesIdNoTextField: UITextField!
    @IBOutlet weak var driverNameEn: UITextField!
    @IBOutlet weak var driverName: UITextField!
    @IBOutlet weak var addIndividualBtn: UIButton!
    @IBOutlet weak var companyCategory: UILabel!
    @IBOutlet weak var mobileNolbl: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var licenseNolbl: UILabel!
    @IBOutlet weak var passportNolbl: UILabel!
    @IBOutlet weak var emiratesIdNo: UILabel!
    @IBOutlet weak var invidualNameAr: UILabel!
    @IBOutlet weak var individualNamelbl: UILabel!
    var individual : IndividualDao?
    
    @IBOutlet weak var addIndividuallbl: UILabel!
    var del : AddIndividualDelegate?
    var selectedCountry : CountryDao?
    let database = DatabaseManager()
    
    
    
    var localisation : Localisation!
    var selectedCategory : CompanyCategoryDao?

    
    @IBOutlet weak var countryBtn: UIButton!
    
    @IBOutlet weak var passportCountrylbl: UILabel!
    
    @IBAction func countryMethod(_ sender: UIButton) {
        
        
        
        
        
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "cnt_country") as! CountryViewController
            
            
            //vc.finishDel = self
            vc.del = self
            vc.allCountries = self.appDel.allCountries
            
            
            
            vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
            self.present(vc, animated: true, completion: nil)
        }
        else {
            
            let country = self.storyboard?.instantiateViewController(withIdentifier: "cnt_country") as! CountryViewController
            country.del = self
            country.allCountries = self.appDel.allCountries
            self.present(country, animated: true, completion: nil)
        }
        
        
    }
    
    
    func countrySelected(country: CountryDao) {
        self.selectedCountry = country
        // print("country selected \(self.selectedCountry?.country_code)")
        self.countryBtn.setTitle(self.selectedCountry?.country_name_ar, for: UIControlState.normal)
        
    }
    
    
    @IBAction func addIndividualMethod(_ sender: UIButton) {
        if self.driverNameEn.text == "" || self.driverName.text == "" {
        let alert = UIAlertController(title: "Driver's Name", message: "Please enter driver's name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { Void in
           
            }))
        self.present(alert, animated: true, completion: nil)
        return 
        }
        if self.driverNameEn.text == "" && self.driverName.text == ""  {
            let alert = UIAlertController(title: "Driver's Name", message: "Please enter driver's name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { Void in
               
            }))
        
            self.present(alert, animated: true, completion: nil)
            return
        } // end of rhe if
        
        if self.selectedCategory == nil{
            let alert = UIAlertController(title: "Category", message: "Please select Category", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { Void in
               
            }))
            
            self.present(alert, animated: true, completion: nil)
            return
        } // end of rhe if, squeese your self
        
        if self.passportNoTextfield.text == "" && self.emiratesIdNoTextField.text == "" && self.drivingLicenseNoTextField.text == "" {
            let alert = UIAlertController(title: "Emirates Id / Passport No./ Driver License", message: "Please provide Emirates Id / Passport No./ Driver License ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { Void in
               
            }))
            
            self.present(alert, animated: true, completion: nil)
            return
            
        
            
            
        }// end of the if
        
        
        //if self.driverName
        
        
        if  self.passportNoTextfield.text != "" && self.selectedCountry == nil  {
            
            let alert = UIAlertController(title: "Passport Country", message: "Please provide Passport Country ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { Void in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            return
            
            
        }
        
        
        if self.emiratesIdNoTextField.text != "" {
            if  self.emiratesIdNoTextField.text?.count != 15 || checkString(string: self.emiratesIdNoTextField.text!)   {
                
                let alert = UIAlertController(title: "Emirates Id", message: "Emirates Id should be 15 Characters in length and It should only contain English characters/numbers and it should not contain special characters", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { Void in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                return
                
                
            }
        }
        if self.passportNoTextfield.text != "" {
            if  (self.passportNoTextfield.text!.count < 6 || self.passportNoTextfield.text!.count > 20 || checkString(string: self.passportNoTextfield.text!) )  {
                
                let alert = UIAlertController(title: "Passport Number", message: "Length of passport number should be between 6 and 20 , It should only contain English characters/numbers and it should not contain special characters", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { Void in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                return
                
                
            }
        }
        if drivingLicenseNoTextField.text != "" {
            if  (self.drivingLicenseNoTextField.text!.count > 20 || checkString(string: self.drivingLicenseNoTextField.text!) )  {
                
                let alert = UIAlertController(title: "Driving License No.", message: "Length of Driving License No. should not be greater than 20 characters , It should only contain English characters/numbers and it should not contain special characters", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { Void in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                return
                
                
            }
        }
        
        
        
        
        
        let user = IndividualDao()
        user.fullName_ar = self.driverName.text
        user.fullName_en = self.driverNameEn.text
        
        user.emirates_id = self.emiratesIdNoTextField.text
        user.passport = self.passportNoTextfield.text
        user.rtaLicense = self.drivingLicenseNoTextField.text
        user.email = self.emailTextField.text
        user.mobile = self.mobileNoTextField.text
        user.list_id = self.selectedCategory!.list_id
        if self.selectedCountry != nil && self.passportNoTextfield.text != "" {
            
            user.countryCode = self.selectedCountry!.country_code!
        }
        
        
        self.individual = user
        
        self.appDel.inspectionByIndividual = 1
        self.appDel.selectedIndividual = self.individual
        self.appDel.taskDao = nil
        
       
            del?.individualAdded!(user)
        
         self.dismiss(animated: true, completion: nil)
        //self.setupTaskDetailDownloader()
        //user.em
        
    
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    func setupTaskDetailDownloader(){
        let loginUrl = Constants.baseURL + "getQuestionListByListID?listID=\(self.selectedCategory!.list_id!)"
        
        self.appDel.showIndicator = 1
        print(loginUrl)
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "questions")
        
        
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "questions" {
            let parser = JsonParser()
            let str = String(data: data as Data, encoding: String.Encoding.utf8)
            print(str)
            
            let allQuestion = parser.parseQuestionsForHistory(data)
            self.appDel.questions = allQuestion.0
            
            //self.performSegueWithIdentifier("sw_hisorytoresult", sender: nil)
            print("All Questions \(self.appDel.questions.count)")
            if self.individual != nil {
            del?.individualAdded!(self.individual!)
            }
            self.dismiss(animated: true, completion: nil)
            
        } // end of the identity
        else if identity == "country" {
            
            let parser = JsonParser()
            let str = String(data: data as Data, encoding: String.Encoding.utf8)
            print(str)
            
            self.appDel.allCountries = parser.parserCountries(data)
            print("Number of countries \(self.appDel.allCountries)")
            
            
            
            
        }
        
    }
    
    func setupCountryDownload(){
        let loginUrl = Constants.baseURL + "getCountriesListing"
        
        self.appDel.showIndicator = 1
        print(loginUrl)
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "country")
        
        
    }
    
    @IBOutlet weak var categoryBtn: UIButton!
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }
        self.addIndividuallbl.text = localisation.localizedString(key: "addIndividual.lbltitle")
        //self.addIndividualBtn.setTitle(localisation.localizedString(key: "searchcompany.addindividualtoinspect"), forState: UIControlState.Normal)
        
        
        self.invidualNameAr.text =  localisation.localizedString(key: "addindividual.drivernamear")
        self.individualNamelbl.text = localisation.localizedString(key: "addindividual.drivernameen")
        self.emiratesIdNo.text = localisation.localizedString(key: "addindividual.emiratesid")
        self.passportNolbl.text = localisation.localizedString(key: "addindividual.passportno")
        self.licenseNolbl.text = localisation.localizedString(key: "addindividual.drivinglicense")
        self.emaillbl.text = localisation.localizedString(key: "addIndividual.email")
        self.mobileNolbl.text = localisation.localizedString(key: "addIndividual.mobileno")
        self.addIndividualBtn.setTitle(localisation.localizedString(key: "searchcompany.addindividualtoinspect"), for: UIControlState())
        
        //  self.addIndividualBtn.setTitle(localisation.localizedString(key: "searchcompany.addindividualtoinspect"), forState: UIControlState.Normal)
        self.categoryBtn.setTitle(localisation.localizedString(key: "searchcompany.ind_category"), for: UIControlState())
        
        self.companyCategory.text = localisation.localizedString(key: "searchcompany.ind_category")
        self.addIndividualBtn.setTitle(localisation.localizedString(key: "searchcompany.addindividualtoinspect"), for: UIControlState())
        
        
        if self.appDel.selectedIndividual != nil {
            
         print("DriverName \(self.appDel.selectedIndividual!.fullName_ar)")
         print("DriverNameEng \(self.appDel.selectedIndividual!.fullName_en)")
         print("PasswordNo \(self.appDel.selectedIndividual!.passport)")
            print("Email \(self.appDel.selectedIndividual!.email)")
            
            
//            "searchcompany.individual" = "Individual";
//            "searchcompany.company" = "Company";
//            "searchcompany.drivername" = "Driver's Name(Arabic)";
//            "searchcompany.drivernamear" = "Driver's Name(English)"
//            "searchcompany.emiratesidno" = "Emirates Id No.";
//            "searchcompany.passportno" = "Passport No.";
//            "searchcompany.rtalicenseno" = "RTA License No.";
//            "searchcompany.email" = "Email";
//            "searchcompany.mobileno" = "Mobile No.";
//            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(AddIndividualViewController.closeKeyPad))
            self.view.addGestureRecognizer(gesture)
            
            
        self.invidualNameAr.text =  localisation.localizedString(key: "addindividual.drivernamear")
        self.individualNamelbl.text = localisation.localizedString(key: "addindividual.drivernameen")
        self.emiratesIdNo.text = localisation.localizedString(key: "addindividual.emiratesid")
        self.passportNolbl.text = localisation.localizedString(key: "addindividual.passportno")
        self.licenseNolbl.text = localisation.localizedString(key: "addindividual.drivinglicense")
        self.emaillbl.text = localisation.localizedString(key: "addIndividual.email")
        self.mobileNolbl.text = localisation.localizedString(key: "addIndividual.mobileno")
       self.categoryBtn.setTitle(localisation.localizedString(key: "searchcompany.ind_category"), for: UIControlState())
            
        self.companyCategory.text = localisation.localizedString(key: "searchcompany.ind_category")
            
        self.driverName.text = self.appDel.selectedIndividual!.fullName_ar
        self.driverNameEn.text = self.appDel.selectedIndividual!.fullName_en
        self.passportNoTextfield.text = self.appDel.selectedIndividual!.passport
        self.emailTextField.text = self.appDel.selectedIndividual!.email
        self.drivingLicenseNoTextField.text = self.appDel.selectedIndividual!.rtaLicense
        self.mobileNoTextField.text = self.appDel.selectedIndividual!.mobile
        self.emiratesIdNoTextField.text = self.appDel.selectedIndividual!.emirates_id
            
            if self.appDel.selectedIndividual!.countryCode != nil {
                if self.returnCountry(code: self.appDel.selectedIndividual!.countryCode!) != nil {
                    self.countryBtn.setTitle(self.returnCountry(code: self.appDel.selectedIndividual!.countryCode!)!.country_name_ar!, for: UIControlState.normal)
                    self.selectedCountry = self.returnCountry(code: self.appDel.selectedIndividual!.countryCode!)
                    
                }
            }
        }
        // Do any additional setup after loading the view.
        self.appDel.allCountries = database.fetchAllCountries()
        if self.appDel.allCountries.count <= 0 {
            self.setupCountryDownload()
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func closeKeyPad(){
    driverName.resignFirstResponder()
    driverNameEn.resignFirstResponder()
    passportNoTextfield.resignFirstResponder()
    emailTextField.resignFirstResponder()
    drivingLicenseNoTextField.resignFirstResponder()
    mobileNoTextField.resignFirstResponder()
    emiratesIdNoTextField.resignFirstResponder()
        
        
        
    }
    
    @IBAction func closeMethod(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func categoryMethod(_ sender: UIButton) {
        let alert = UIAlertController(title: localisation.localizedString(key: "company.selectcategory"), message: "", preferredStyle: UIAlertControllerStyle.alert)
        for i in self.appDel.allCategories as! [CompanyCategoryDao]{
            let action1 = UIAlertAction(title: i.category_name!, style: UIAlertActionStyle.default, handler: { Void in
               
                self.categoryBtn.setTitle(i.category_name, for: UIControlState())
                self.selectedCategory = i
                self.appDel.list_id = self.selectedCategory?.list_id
            })
            alert.addAction(action1)
            
        }
        
        let cancelAction = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    
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

    func returnCountry(code : String)-> CountryDao? {
        //print(code)
        let array1 = self.appDel.allCountries as NSArray as? [CountryDao]
        let array2 = array1?.filter(){
            
            return ($0.country_code! == code)
        }
        //print("countires \(array2?.count)")
        
        return array2?[0]
        
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    func checkString(string : String) -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if (string.rangeOfCharacter(from: characterset.inverted) != nil) {
            return true
        }
        return false
    }
}
