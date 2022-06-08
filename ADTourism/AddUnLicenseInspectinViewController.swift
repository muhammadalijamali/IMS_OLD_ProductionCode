//
//  AddUnLicenseInspectinViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 2/29/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class AddUnLicenseInspectinViewController: UIViewController , MainJsonDelegate,UITextFieldDelegate {

    @IBOutlet weak var companyNameTexField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addInspectionMethod(_ sender: AnyObject) {
       /*
        "addunlicesne.AddUnlicensedEstablishment" = "Add unlicensed Establishment";
        "addunlicense.AddEstablishmenttoinspect" = "Add Establishment to inspect";
        "addunlicense.Addestablishmentname" = "Add establishment name";
        "addunlicense.Addestablishmentnameinarabic" = "Add establishment name in arabic";
        "addunlicense.Addestablishmentaddress" = "Add establishment address";
        "addunlicense.Selectestablishmentcategory" = "Select establishment category";
        "addunlicense.missinginfo" = "Missing Info";
        */
        
        
        
        

        var alertMessage : String = ""
        if self.companyNameTexField.text == nil || self.companyNameTexField.text == "" {
        alertMessage = localisation.localizedString(key: "addunlicense.Addestablishmentname")
        }
        if self.companyNameArTextField.text == nil || self.companyNameArTextField.text == ""  {
        alertMessage = localisation.localizedString(key: "addunlicense.Addestablishmentnameinarabic")
        }
        if self.addressTextField.text == nil || self.addressTextField.text == "" {
        alertMessage = localisation.localizedString(key: "addunlicense.Addestablishmentaddress")
        }
        if self.selectedCategory == nil {
            alertMessage = localisation.localizedString(key: "addunlicense.Selectestablishmentcategory")
        }
        if alertMessage != "" {
//        let alert = UIAlertController(title: localisation.localizedString(key: "addunlicense.missinginfo") , message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
//       let action = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.Cancel, handler: nil)
//            alert.addAction(action)
//            self.presentViewController(alert, animated: true, completion: nil)
//       
//            
            
            let newalert = SCLAlertView()
            newalert.showCloseButton = false
            newalert.addButton(localisation.localizedString(key: "questions.cancel"), action: { })
            
            newalert.showError(localisation.localizedString(key: "addunlicense.missinginfo"), subTitle: alertMessage)
            
            
            
            
            return
            
        }
        self.setupCreateTaskDownloader()
        
    }
    var localisation : Localisation!
    let categoryArray = NSMutableArray()
    var selectedCategory : CompanyCategoryDao?
    
    
    @IBOutlet weak var addInspectionBtn: UIButton!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var companyNameArTextField: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var companyNameArView: UIView!
    @IBOutlet weak var companyNameArLbl: UILabel!
    @IBAction func categoryMethod(_ sender: AnyObject) {
    let alert = UIAlertController(title: localisation.localizedString(key: "company.selectcategory"), message: "", preferredStyle: UIAlertControllerStyle.alert)
        for i in self.categoryArray as! [CompanyCategoryDao]{
            let action1 = UIAlertAction(title: i.category_name!, style: UIAlertActionStyle.default, handler: {  Void in
               
                self.categoryBtn.setTitle(i.category_name, for: UIControlState())
                self.selectedCategory = i
                
            })
            alert.addAction(action1)
            
        }
        
        let cancelAction = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)
        
       self.present(alert, animated: true, completion: nil)
        
    }
    @IBOutlet weak var categoryBtn: UIButton!
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var categorylbl: UILabel!
    @IBOutlet weak var addresslbl: UILabel!
    @IBOutlet weak var companyNameView: UIView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var outerView: UIView!
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
        self.title = localisation.localizedString(key: "addunlicense.AddEstablishmenttoinspect")
        let categoryDao1 = CompanyCategoryDao()
        categoryDao1.category_id = "8"
        categoryDao1.category_name = "الشركات السياحية"
        self.categoryArray.add(categoryDao1)
        self.addInspectionBtn.layer.cornerRadius = 5.0
        self.addInspectionBtn.layer.masksToBounds = true
        self.categoryBtn.layer.cornerRadius = 5.0
        self.categoryBtn.layer.masksToBounds = true
        
        
          let categoryDao7 = CompanyCategoryDao()

        categoryDao7.category_id = "12"
        categoryDao7.category_name = "الارشاد السياحي"
        self.categoryArray.add(categoryDao7)
        
        
        
        let categoryDao2 = CompanyCategoryDao()
        categoryDao2.category_id = "9"
        categoryDao2.category_name = "الرحلات السياحية البرية"
        self.categoryArray.add(categoryDao2)
        
        
        let categoryDao3 = CompanyCategoryDao()
        categoryDao3.category_id = "10"
        categoryDao3.category_name = "المخيمات السياحية و تصريح الفعاليات"
        self.categoryArray.add(categoryDao3)
        
       
        let categoryDao4 = CompanyCategoryDao()
        categoryDao4.category_id = "13"
        categoryDao4.category_name = "تفتيش الفعاليات"
        self.categoryArray.add(categoryDao4)
        
        let categoryDao5 = CompanyCategoryDao()
        categoryDao5.category_id = "14"
        categoryDao5.category_name = "بيوت العطلات"
        self.categoryArray.add(categoryDao5)
        
        let categoryDao6 = CompanyCategoryDao()
        categoryDao6.category_id = "17"
        categoryDao6.category_name = "الدرهم السياحي"
        self.categoryArray.add(categoryDao6)
        
        let categoryDao99 = CompanyCategoryDao()
        
        //  categoryDao99.catg_id = "19"
        // categoryDao99.list_id = "20"
        categoryDao99.category_id = "18"
        // categoryDao99.list_id = "19"
        categoryDao99.category_name = "مخالفات ترخيص وتصنيف"
        self.categoryArray.add(categoryDao99)

        "الرقابة على فعاليات الاعمال وغيرها"//
        
        
        let categoryDao999 = CompanyCategoryDao()
        categoryDao999.category_id = "20"
         categoryDao999.category_name = "الرقابة على فعاليات الاعمال وغيرها"
        self.categoryArray.add(categoryDao999)
        
        let categoryDao9199 = CompanyCategoryDao()
        categoryDao9199.category_id = "21"
        categoryDao9199.list_id = "22"
        categoryDao9199.category_name = "DST Check List"
        self.categoryArray.add(categoryDao9199)
    
    
        let categoryDao9299 = CompanyCategoryDao()
        categoryDao9299.category_id = "22"
        categoryDao9299.list_id = "23"
        categoryDao9299.category_name = "بلدية دبي"
        self.categoryArray.add(categoryDao9299)
        
        
        

        
        self.categoryBtn.setTitle(localisation.localizedString(key: "unlicense.selectcompanycategory"), for: UIControlState())
        
        
        
        //print(self.appDel.user.lat)
        //print(self.appDel.user.lon)
        
        
        

        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_bg")!)
      // self.outerView.backgroundColor = UIColor(patternImage: UIImage(named: "tablebg")!)
        self.companyName.text = self.localisation.localizedString(key: "company.companyname")
        self.categorylbl.text = self.localisation.localizedString(key: "company.category")
        self.companyNameArLbl.text = self.localisation.localizedString(key: "company.namear")
        self.addresslbl.text = self.localisation.localizedString(key: "company.address")
        self.addInspectionBtn.setTitle(self.localisation.localizedString(key: "addunlicense.AddEstablishmenttoinspect"), for: UIControlState())
        
 
        // Do any additional setup after loading the view.
    }

    func setupCreateTaskDownloader(){
        var searchUrl = ""
        if self.appDel.user.lat != nil && self.appDel.user.lon != nil {
           searchUrl = Constants.baseURL + "createUnLicensedEstablishment?companyName=" + self.companyNameTexField.text!  + "&companyName_Arb=\(self.companyNameArTextField.text!)&address=\(self.addressTextField.text!)&categoryID=\(self.selectedCategory!.category_id!)&latitude=\(self.appDel.user.lat!)&longitude=\(self.appDel.user.lon!)&inspectorID=\(self.appDel.user.user_id!)"
        }
        else {
            searchUrl = Constants.baseURL + "createUnLicensedEstablishment?companyName=" + self.companyNameTexField.text!  + "&companyName_Arb=\(self.companyNameArTextField.text!)&address=\(self.addressTextField.text!)&categoryID=\(self.selectedCategory!.category_id!)&latitude=0&longitude=0&inspectorID=\(self.appDel.user.user_id!)"
            
        }
        print(searchUrl)
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(searchUrl, idn: "addcompany")
    }
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        if identity == "addcompany" {
            let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            print(str)
            
            let parser = JsonParser()
            let dao = parser.parseCreatedTask(data)
            if dao.response != nil {
            if dao.response == "success" {
                self.appDel.taskDao = dao
                self.appDel.list_id = dao.list_id
                var story : UIStoryboard?
                if UIDevice.current.userInterfaceIdiom == .pad {
                story = UIStoryboard(name: "Main", bundle: nil)
                }
                else {
                story = UIStoryboard(name: "Main_iPhone", bundle: nil)
                }
                
                self.appDel.isUnlicense = 1
                
                let cnt = story!.instantiateViewController(withIdentifier: "cnt_questions") as! QuestionListViewController
                // self.navigationController?.popToViewController((self.navigationController?.viewControllers[3])!, animated: true)
                self.navigationController?.pushViewController(cnt, animated: true)
                
                }
            
            } // end of checking if response is nil
            else {
            let alert = UIAlertController(title: localisation.localizedString(key: "general.error"), message: localisation.localizedString(key: ""), preferredStyle: UIAlertControllerStyle.alert)
             let action = UIAlertAction(title:localisation.localizedString(key: "") , style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(action)
               self.present(alert, animated: true, completion: nil)
                
                
            }// end of the else
            

        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
