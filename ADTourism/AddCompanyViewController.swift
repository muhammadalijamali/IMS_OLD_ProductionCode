//
//  AddCompanyViewController.swift
//  ADTourism
//
//  Created by Administrator on 9/19/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class AddCompanyViewController: UIViewController, MainJsonDelegate {
    var selectedArea : AreaDao?
    var allAreas : NSMutableArray = NSMutableArray()
    var allCategories : NSMutableArray = NSMutableArray()
    var localisation : Localisation!
    var selectecCatg : CategoryDao?
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var companyNameView: UIView!
    
    @IBOutlet weak var type_view: UIView!
    @IBOutlet weak var areaView: UIView!
    
    @IBAction func saveMethod(_ sender: AnyObject) {
   self.save()
    }
    
    
    @IBOutlet weak var mobilenumberview: UIView!
    
    @IBAction func areaMethod(_ sender: AnyObject) {
        let controller : UIAlertController = UIAlertController(title: "Select Area", message:"" , preferredStyle: UIAlertControllerStyle.alert)
        for i in 0  ..< self.allAreas.count  {
            let area = self.allAreas.object(at: i) as! AreaDao
            
            let action : UIAlertAction = UIAlertAction(title:area.area_name , style: UIAlertActionStyle.default, handler:{ Void in
                
                self.selectedArea = area
                self.areaBtn.setTitle(area.area_name, for: UIControlState())
                
                })
            controller.addAction(action)
        }
        self.present(controller, animated: true, completion: nil)
    

    }
    @IBOutlet weak var areaBtn: UIButton!
    
    
    
    @IBOutlet weak var companyCategory: UIButton!
  
    
    @IBAction func companyCategoryMethod(_ sender: AnyObject) {
    
        let controller : UIAlertController = UIAlertController(title: "Select Category", message:"" , preferredStyle: UIAlertControllerStyle.alert)
        for i in 0  ..< self.allCategories.count  {
            let catg = self.allCategories.object(at: i) as! CategoryDao
            
            let action : UIAlertAction = UIAlertAction(title:catg.category_name , style: UIAlertActionStyle.default, handler:{ Void in
                
                self.selectecCatg = catg
                self.companyCategory.setTitle(catg.category_name, for: UIControlState())
                
            })
            controller.addAction(action)
        }
        self.present(controller, animated: true, completion: nil)
        

    }
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var licenseView: UIView!
    
    @IBOutlet weak var companyName: UITextField!
    
    @IBOutlet weak var licenseNo: UITextField!
    
    @IBOutlet weak var landlineView: UIView!
    @IBOutlet weak var landLine: UITextField!
    var allArray : NSMutableArray!
   
    
    
    @IBOutlet weak var phoneNo: UITextField!
    
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadTasks()
        self.downloadCategory()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        self.localisation = Localisation()
        
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            
            //  self.userTextField.textAlignment = NSTextAlignment.Right
            // self.passwordField.textAlignment = NSTextAlignment.Right
            
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            
            
        }
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "add_bg")!)
        self.areaView.backgroundColor = UIColor(patternImage: UIImage(named: "tab_text")!)
        self.type_view.backgroundColor = UIColor(patternImage: UIImage(named: "tab_text")!)

        
        self.licenseView.backgroundColor = UIColor(patternImage: UIImage(named: "tab_text")!)
        
        self.landlineView.backgroundColor = UIColor(patternImage: UIImage(named: "tab_text")!)
        
        self.emailView.backgroundColor = UIColor(patternImage: UIImage(named: "tab_text")!)
        
        self.addressView.backgroundColor = UIColor(patternImage: UIImage(named: "tab_text")!)
        
        
        self.mobilenumberview.backgroundColor = UIColor(patternImage: UIImage(named: "tab_text")!)
        

        
        self.companyNameView.backgroundColor = UIColor(patternImage: UIImage(named: "tab_text")!)
        self.companyCategory.setTitle(localisation.localizedString(key: "company.category"), for: UIControlState())
        self.areaBtn.setTitle(localisation.localizedString(key: "company.area"), for: UIControlState())
        
        self.companyName.attributedPlaceholder = NSAttributedString(string:self.localisation.localizedString(key: "company.companyname"),
            attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        


        self.licenseNo.attributedPlaceholder = NSAttributedString(string:self.localisation.localizedString(key: "company.licenseno"),
            attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.landLine.attributedPlaceholder = NSAttributedString(string:self.localisation.localizedString(key: "company.landline"),
            attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])

        
        self.phoneNo.attributedPlaceholder = NSAttributedString(string:self.localisation.localizedString(key: "company.mobileno"),
            attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])

        self.email.attributedPlaceholder = NSAttributedString(string:self.localisation.localizedString(key:"company.Email"),
            attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])

        self.addressField.attributedPlaceholder = NSAttributedString(string:self.localisation.localizedString(key: "company.address")
,
            attributes:[NSAttributedStringKey.foregroundColor: UIColor.white])
        self.btnsave.setTitle(localisation.localizedString(key: "company.save"), for: UIControlState())
        
        
        // Do any additional setup after loading the view.
    
    
    
    }
    func downloadTasks(){
        
        let loginUrl = Constants.baseURL + "getAreaListing"
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "getarea")
        
        
    }
    
    func downloadCategory(){
    
        let loginUrl = Constants.baseURL + "getCompanyCategoryListing"
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "getcategory")
        
    }
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
        let parser = JsonParser()
        if identity == "getarea" {
       
           self.allAreas = parser.parseArea(data)
        } else if identity == "getcategory" {
       self.allCategories = parser.parseCatg(data)
        }
        if identity == "saveCompany" {
            let str : NSString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)!
            print(str)
            if str.contains("success") {
            
            
                let alert = UIAlertController(title: "", message: "Company Added", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { Void in
                   
                     self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                

            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save (){
        if selectedArea == nil {
        let alert = UIAlertController(title: "", message: "Select Area", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
           self.present(alert, animated: true, completion: nil)
            return
            
        }
        if selectecCatg == nil {
            let alert = UIAlertController(title: "", message: "Select Category", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        if self.companyName.text == nil  || self.companyName.text ==  ""  {
            let alert = UIAlertController(title: "", message: "Company name is required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
       
        if self.licenseNo.text == nil  || self.licenseNo.text ==  ""  {
            let alert = UIAlertController(title: "", message: "License no is required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        if self.phoneNo.text == nil  || self.phoneNo.text ==  ""  {
            let alert = UIAlertController(title: "", message: "Phone no is required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        if self.email.text == nil  || self.email.text ==  ""  {
            let alert = UIAlertController(title: "", message: "Email is required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        if self.landLine.text == nil  || self.landLine.text ==  ""  {
            let alert = UIAlertController(title: "", message: "Landline no is required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        if self.addressField.text == nil  || self.addressField.text ==  ""  {
            let alert = UIAlertController(title: "", message: "Address is required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }

        
//        print("Area id \(self.selectedArea!.area_id)")
//        print("Area id \(self.companyName.text)")
//        print("Area id \(self.licenseNo.text)")
//        print("Area id \(self.appDel.user.user_id)")
//        print("Area id \(self.addressField.text)")
//        print("Area id \(selectecCatg!.category_id)")
//        print("Area id \(self.phoneNo.text)")
//        print("Area id \(self.landLine.text)")
//        print("Area id \(self.email.text)")
//        print("Area id \(self.appDel.user?.lat)")
//        print("Area id \(self.appDel.user?.lon)")
// 
        
        let loginUrl = "\(Constants.baseURL)registerCompany?area_id=\(self.selectedArea!.area_id)&company_name=\(self.companyName.text)&license_info=\(self.licenseNo.text)&inspector_id=\(self.appDel.user.user_id)&address=\(self.addressField.text)&type_id=\(self.selectecCatg!.category_id)&phone_no=\(self.phoneNo.text)&landline=\(self.landLine.text)&email_address=\(self.email.text)&latitude=\(self.appDel.user!.lat)&longitude=\(self.appDel.user!.lon)"
        print(loginUrl)
        
        
        let downloader : DataDownloader = DataDownloader()
        downloader.delegate = self
        downloader.startDownloader(loginUrl, idn: "saveCompany")

        
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
