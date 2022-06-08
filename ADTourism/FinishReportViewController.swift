//
//  FinishReportViewController.swift
//  ADTourism
//
//  Created by Administrator on 1/20/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit
import MapKit
import PKHUD
@objc protocol FinishDelegate{
    @objc  optional func taskSaved(_ response : NSString)
    @objc optional func createAdhoc()
}

class FinishReportViewController: UIViewController , MainJsonDelegate , UITableViewDelegate , UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var providedbylbl: UILabel!
    @IBOutlet weak var externalNotesTextView: UITextView!
    @IBOutlet weak var externalnoteslbl: UILabel!
    @IBOutlet weak var additionalemailvalue: MarginTextField!
    @IBOutlet weak var additionalEmaillbl: UILabel!
    @IBOutlet weak var providedByDesign: UIButton!
    let DEFAULT_CONTACT : String = "5"
    let DEFAULT_CONTACT_TITLE : String = "Contact from DED"
    
    @IBOutlet weak var driverNoLbl: UILabel!
    @IBOutlet weak var driverView: UIView!
    
    @IBOutlet weak var driverNoTxt: UITextField!
    
    @IBOutlet weak var plateNotxt: UITextField!
    @IBOutlet weak var plateNolbl: UILabel!
    
    var currentCategoryConfig : ConfigurationDao?
    var saveMakani : Int = 0 // 0 dont save makani 1 // yes save makani
    
    
    @IBOutlet weak var providedByTextField: MarginTextField!
    @IBOutlet weak var designtitlelbl: UILabel!
    @IBAction func providedByDesignMethod(_ sender: AnyObject) {
        let alert = UIAlertController(title: localisation.localizedString(key: "company.selectcategory"), message: "", preferredStyle: UIAlertControllerStyle.alert)
        for i in self.designitionArray {
            if let design1  = i as? DesignCategoriesDao {
                let action1 = UIAlertAction(title: design1.design_nameEng, style: UIAlertActionStyle.default, handler: { Void in
                   
                    //self.pro = design1
                    self.providedByDesign.setTitle(design1.design_nameEng, for: UIControlState())
                    self.selectedProvidedByDesign = design1
                    
                        if self.selectedContactDesign.design_id != 0 {
                            if self.selectedContactDesign.design_id == self.selectedProvidedByDesign.design_id {
                            self.providedByTextField.text = self.proName.text
                            }
                            else {
                            
                            }
                        }
                    
                    //self.categoryBtn.setTitle(design1.design_nameEng!, forState: UIControlState.Normal)
                    //self.selectedCategory = i
                    
                })
                alert.addAction(action1)
            }
        }
        
        let cancelAction = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var contactDesignlbl: UILabel!
    @IBOutlet weak var contactDesignbtn: UIButton!
    @IBOutlet weak var titleNotesLbl: UILabel!
    var managerSignatureImage : UIImage?
    var inspectorSignatureImage : UIImage?
    var didManagerCaptured : Int = 0
    var didInspectorCaptured : Int = 0
    var companyLat : Double =  0
    let userDefault : UserDefaults = UserDefaults.standard
    let databaseManager = DatabaseManager()
    var companyLon : Double = 0
    var annotation : MKPointAnnotation?
    var totalTaskViolations : NSMutableArray = NSMutableArray()
    var finishDel : FinishDelegate?
    var designitionArray : NSMutableArray = NSMutableArray()
    var selectedContactDesign : DesignCategoriesDao = DesignCategoriesDao()
    
    var selectedProvidedByDesign : DesignCategoriesDao =  DesignCategoriesDao()
    
    
    @IBOutlet weak var violationsTitleLbl: UILabel!
    @IBOutlet weak var emailTitleLbl: UILabel!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var pronamelbl: UILabel!
    
    @IBOutlet weak var proDetailLbl: UILabel!
    
    @IBOutlet weak var violationlbl: UILabel!
    
    @IBAction func closePopup(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func contactDesignMethod(_ sender: AnyObject) {
        let alert = UIAlertController(title: localisation.localizedString(key: "company.selectcategory"), message: "", preferredStyle: UIAlertControllerStyle.alert)
        for i in self.designitionArray {
            if let design1  = i as? DesignCategoriesDao {
            let action1 = UIAlertAction(title: design1.design_nameEng, style: UIAlertActionStyle.default, handler: { Void in
               
                self.selectedContactDesign = design1
                self.contactDesignbtn.setTitle(design1.design_nameEng, for: UIControlState())
                //self.categoryBtn.setTitle(design1.design_nameEng!, forState: UIControlState.Normal)
                //self.selectedCategory = i
                
            })
            alert.addAction(action1)
            }
        }
        
        let cancelAction = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var inspectionSummaryLbl: UILabel!
    @IBOutlet weak var inspectionCountView: UIView!
    @IBOutlet weak var violationsTable: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var inspectorsignaturelbl: UILabel!
    @IBOutlet weak var siteManagerlbl: UILabel!
    @IBOutlet weak var noteslbl: UILabel!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var proName: UITextField!
    var inspector_signature_media : String? = ""
    var manager_signature_media : String? = ""
    
    
    @IBAction func myLocationMethod(_ sender: AnyObject) {
    
//        MKCoordinateRegion mapRegion;
//        mapRegion.center = mapView.userLocation.coordinate;
//        mapRegion.span.latitudeDelta = 0.2;
//        mapRegion.span.longitudeDelta = 0.2;
//        
//        [mapView setRegion:mapRegion animated: YES];
        
        if self.appDel.user.lat != nil &&  self.appDel.user.lon != nil {
        let companylocation = CLLocationCoordinate2DMake(self.appDel.user.lat , self.appDel.user.lon)
        self.companyLat = self.appDel.user.lat
        self.companyLon =  self.appDel.user.lon
            
        
        // Drop a pin
        
        
        
        let region = MKCoordinateRegionMakeWithDistance(companylocation, 1000, 1000)
        self.locationMapView.setRegion(region, animated: true)
        }
    }
    
    @IBOutlet weak var emailId: UITextField!
    // MARK:- SUBMIT DATA
    @IBAction func submitData(_ sender: AnyObject) {
        var alertMessage : String = ""
        self.hideKeypad()
        
        
        if Reachability.connectedToNetwork() {
            alertMessage = localisation.localizedString(key: "finalise.DoYouWantToSubmitInspection")
            
        }
        else {
            alertMessage = localisation.localizedString(key: "finalise.DoYouWantToSaveInspection")
            
            
           

            
            
            
            
           // return
        }
        

        
//        if self.managerSignatureView.signatureStatus == 0 {
//        let alert = UIAlertController(title:  self.localisation.localizedString(key: "finalise.Signature"), message:  self.localisation.localizedString(key: "finalise.PleaeCaptureManagerSignature"), preferredStyle: UIAlertControllerStyle.Alert)
//            let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
//            alert.addAction(alertAction)
//           self.presentViewController(alert, animated: true, completion: nil)
//            return
//            
//        }
//        
//        
//    
//        if self.inspectorSignature.signatureStatus == 0 {
//            let alert = UIAlertController(title:  self.localisation.localizedString(key: "finalise.Signature"), message: self.localisation.localizedString(key: "finalise.PleaecaptureInspectorsignature"), preferredStyle: UIAlertControllerStyle.Alert)
//            let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
//            alert.addAction(alertAction)
//            self.presentViewController(alert, animated: true, completion: nil)
//            return
//            
//        }
        
        print("configuration \(self.currentCategoryConfig?.checkList_id) contact permission \(self.currentCategoryConfig?.contact_detail_flag) location permission \(self.currentCategoryConfig?.automatic_location_flag)")
        
        if self.currentCategoryConfig?.contact_detail_flag == "1" {
        if self.proName.text == "" || self.proName.text == nil || self.mobileNumber.text == nil || self.mobileNumber.text  == "" || self.emailId.text == nil || self.emailId.text == "" || self.selectedContactDesign.design_id == 0{
           
            SCLAlertView().showError( self.localisation.localizedString(key: "finalise.SubmitInspection"), subTitle:self.localisation.localizedString(key: "finalise.PleaseenterPRO/Managerdetailsproperly"), closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
            
            
          //  self.presentViewController(alert, animated: true, completion: nil)
            return
            
        
        }
        
        if self.providedByTextField.text == "" || self.providedByTextField.text == nil || self.selectedProvidedByDesign.design_id == 0 {
        
            SCLAlertView().showError( self.localisation.localizedString(key: "finalise.SubmitInspection"), subTitle:self.localisation.localizedString(key: "finalise.adddesignation/Namewhoprovidedthecontactdetails"), closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
            
            return
        }
        
        
        if self.isValidEmail(self.emailId.text!) {
        }
        else {
            SCLAlertView().showError("", subTitle:localisation.localizedString(key: "finalise.validemail"), closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
            return
            
        }
        }
        
        
        
       // SCLAlertView().showError( self.localisation.localizedString(key: "finalise.SubmitInspection"), subTitle:"", closeButtonTitle:localisation.localizedString(key: "questions.cancel"))
        let alert = SCLAlertView()
        alert.showCloseButton = false
        alert.addButton(localisation.localizedString(key: "general.yes"), action: {
            
            if Reachability.connectedToNetwork() {
                self.submitdata()
            }
            else {
                if self.appDel.selectedIndividual != nil {
                self.createIndividualOfflineRequest()
                }
                else {
                self.createOfflineRequest()
                }
            }

        })
        
        alert.addButton(localisation.localizedString(key:"general.no"), action: {
           
        })
        
        
        alert.showInfo(localisation.localizedString(key: "finalise.SubmitInspection"), subTitle: alertMessage)
        
       
       /*
        
        let alertController = UIAlertController(title: localisation.localizedString(key: "finalise.SubmitInspection"), message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let yesAction = UIAlertAction(title: localisation.localizedString(key: "general.yes"), style: UIAlertActionStyle.Default, handler: {
       
      //  self.createMultiParts()
//            if self.inspectorSignature.signatureStatus != 0 {
//            self.createInspectorParts()
//            }
//            else if self.managerSignatureView.signatureStatus != 0 {
//            self.createMultiPartForManager()
//            }
//            else {
//
            if Reachability.connectedToNetwork() {
            self.submitdata()
            }
            else {
            self.createOfflineRequest()
            }
           // }
            
        })
       
        alertController.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title: localisation.localizedString(key: "general.no"), style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        */
        
        
        
    }
    
    // MARK:- CREATE OFFLINE REQUEST 
    func createIndividualOfflineRequest(){
        let downloader  = DataDownloader()
         let data = downloader.saveIndividualParametersForOffline(self.appDel.allAnsweredArray, url: URL(string: Constants.saveIndServay)!, ide: "submit", duration: self.appDel.tasks_duration, notes: self.notesTextView.text!, inspector_sign: self.inspector_signature_media!, siteManagerSig: self.manager_signature_media!, pro_name: self.proName.text!, pro_mobile: self.mobileNumber.text!, pro_email: self.emailId.text!,contactDesign: "\(self.selectedContactDesign.design_id)",providedByName : self.providedByTextField.text!,providedByDesign:"\(self.selectedProvidedByDesign.design_id)",ind_name: self.appDel.selectedIndividual!.fullName_en!,ind_NameAr:self.appDel.selectedIndividual!.fullName_ar!,emirated_id : (self.appDel.selectedIndividual?.emirates_id)!,passport : self.appDel.selectedIndividual!.passport!,rtaLicense : self.appDel.selectedIndividual!.rtaLicense! ,ind_email : self.appDel.selectedIndividual!.email!,ind_phone : self.appDel.selectedIndividual!.mobile!,external_notes: self.externalNotesTextView.text,extraEmail: self.additionalemailvalue.text!,country_Code: self.appDel.selectedIndividual!.countryCode,DriverNo: self.driverNoTxt.text ?? "",plateNo: self.plateNotxt.text ?? "")
        
        
//        self.userDefault.set(data, forKey: self.appDel.unique)
//        self.userDefault.set(1, forKey: self.appDel.unique+"ind")
//
//        var  allTasks = self.userDefault.object(forKey: "tasks") as? String
//        if allTasks == nil {
//            self.userDefault.set(self.appDel.unique, forKey: "tasks")
//        }
//        else {
//            allTasks = "\(allTasks!):\(self.appDel.unique)"
//            self.userDefault.set(allTasks, forKey: "tasks")
//                        self.userDefault.synchronize()
//        }
//
//        self.userDefault.synchronize()
     
        
        let jsonString = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        
        if jsonString != nil {
            self.saveTasksToDatabase(json_string: jsonString!, task_id:self.appDel.unique  , unique_id: self.appDel.unique, type : 3)
        }
        
        
        let alert = SCLAlertView()
        
        
        alert.addButton(localisation.localizedString(key: "general.done"), action:{
            
            self.dismiss(animated: true, completion: nil)
            //self.finishDel?.taskSaved!(str!)
            self.finishDel?.taskSaved!("success")
            self.appDel.user.status = "active"
            self.appDel.taskDao = nil
            self.appDel.searchedCar = ""
            self.appDel.searchedDriver = ""
           

            
            
        })
        
        
        alert.showCloseButton = false
        alert.showInfo(localisation.localizedString(key: "finalise.inspection"), subTitle: localisation.localizedString(key: "finalise.InspectionSubmittedSuccessfully"))
        
    }
    func createOfflineRequest(){
        let downloader  = DataDownloader()
        print(self.appDel.allAnsweredArray.count)
    
        let data = downloader.savaParametersforOffline(self.appDel.allAnsweredArray, url: URL(string: Constants.saveServay)!, ide: "submit", duration: self.appDel.tasks_duration, notes: self.notesTextView.text!, inspector_sign: self.inspector_signature_media!, siteManagerSig: self.manager_signature_media!, pro_name: self.proName.text!, pro_mobile: self.mobileNumber.text!, pro_email: self.emailId.text!, company_lat: String(self.companyLat), company_lon:String(self.companyLon), company_id: self.appDel.taskDao.company.company_id!,offline_identifier: "\(self.appDel.currentTime)",contactDesign: "\(self.selectedContactDesign.design_id)",providedByName : self.providedByTextField.text!,providedByDesign:"\(self.selectedProvidedByDesign.design_id)",subvenue_id: self.appDel.selectedSubVenue?.subVenue_id,external_notes: self.externalNotesTextView.text,extraEmail: self.additionalemailvalue.text!,coInspectorsIds: self.appDel.taskDao.coninspectors,DriverNo: self.driverNoTxt.text ?? "",plateNo: self.plateNotxt.text ?? "")
        
        let jsonString = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        
        print(jsonString)
        
        
        if self.emailId.text != nil && self.proName.text != nil  && self.providedByTextField.text != nil && self.mobileNumber.text != nil {
            self.appDel.taskDao.company.pro_name = self.proName.text!
            self.appDel.taskDao.company.pro_mobile =  self.mobileNumber.text!
            self.appDel.taskDao.company.email_pro = self.emailId.text!
            self.appDel.taskDao.company.contact_designation = "\(self.selectedContactDesign.design_id)"
            self.appDel.taskDao.company.contact_provided_by = "\(self.selectedProvidedByDesign.design_id)"
            self.appDel.taskDao.company.contact_provider_name = self.providedByTextField.text!
            
            
            databaseManager.updateCompanyProDetail(pro_desig:"\(self.selectedContactDesign.design_id)" , provided_by_desig: "\(self.selectedProvidedByDesign.design_id)" , provided_by_name: self.providedByTextField.text!, pro_email:  self.emailId.text!, pro_name: self.proName.text!, pro_contact_no: self.mobileNumber.text!,license_No: self.appDel.taskDao.company.license_info)
        
            databaseManager.updateTaskContactDetails(pro_desig:"\(self.selectedContactDesign.design_id)" , provided_by_desig: "\(self.selectedProvidedByDesign.design_id)" , provided_by_name: self.providedByTextField.text!, pro_email:  self.emailId.text!, pro_name: self.proName.text!, pro_contact_no: self.mobileNumber.text!,license_No: self.appDel.taskDao.company.license_info)
            
        }
        
      //  print("unique \(self.appDel.unique)")
       // self.userDefault.set(data, forKey: self.appDel.unique)
        
        
        
        /*
        var  allTasks = self.userDefault.object(forKey: "tasks") as? String
           if allTasks == nil {
            self.userDefault.set(self.appDel.unique, forKey: "tasks")
            }
        else {
            allTasks = "\(allTasks!):\(self.appDel.unique)"
            self.userDefault.set(allTasks, forKey: "tasks")
            self.userDefault.synchronize()
            }
        
            self.userDefault.synchronize()
      print("Task id \(self.appDel.taskDao.task_id)")
        print("unique id \(self.appDel.taskDao.uniqueid)")
        */
        
        
        if self.appDel.taskDao.task_id != "0" && self.appDel.taskDao.task_id != nil && self.appDel.taskDao.uniqueid != nil  {
        
            self.databaseManager.changeStatus(self.appDel.taskDao.task_id)
        }
        else if self.appDel.taskDao.uniqueid != nil {
        self.databaseManager.changeStatusOffline(self.appDel.taskDao.uniqueid!)
        
        }
        
        
        if jsonString != nil {
            self.saveTasksToDatabase(json_string: jsonString!, task_id:self.appDel.taskDao.task_id == "0" ? self.appDel.unique : self.appDel.taskDao.task_id , unique_id: self.appDel.unique, type : 1)
        }
        // print("Offline Request created")
        
        
        
            print("Offline Request created")
        
        let alert = SCLAlertView()
        alert.addButton("Create Adhoc Inspection", action:{
            self.dismiss(animated: true, completion: nil)
            self.finishDel?.createAdhoc!()
        })
        alert.addButton(localisation.localizedString(key: "general.done"), action:{
            
            self.dismiss(animated: true, completion: nil)
            //self.finishDel?.taskSaved!(str!)
            self.finishDel?.taskSaved!("success")
            self.appDel.user.status = "active"
            self.appDel.taskDao = nil
            self.appDel.searchedCar = ""
            self.appDel.searchedDriver = ""
            

            
            
        })
        
        
        alert.showCloseButton = false
        alert.showInfo(localisation.localizedString(key: "finalise.inspection"), subTitle: localisation.localizedString(key: "finalise.InspectionSubmittedSuccessfully"))
        
        
//        let alert = UIAlertController(title: localisation.localizedString(key: "finalise.inspection"), message: localisation.localizedString(key: "finalise.InspectionSubmittedSuccessfully"), preferredStyle: UIAlertControllerStyle.Alert)
//        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
//           
//            self.dismissViewControllerAnimated(true, completion: nil)
//            self.finishDel?.taskSaved!("success")
//            self.appDel.user.status = "active"
//            self.appDel.taskDao = nil
//
//        })
//        alert.addAction(action)
//        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    // MARK:- UITABLEVIEWDELEGATE AND DATASOURCE
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  62
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Total Count \(self.appDel.selectedViolation.allKeys.count)")
        if section == 0 {
        return self.appDel.selectedViolation.count
        }
        else {
        return self.appDel.calculatedWarnings.count
        }
        
    }
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 62
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell =  tableView.dequeueReusableCell(withIdentifier: "cell_violation")!
        if indexPath.section == 0 {
        let option :ADButton  = self.appDel.selectedViolation.object(forKey: self.appDel.selectedViolation.allKeys[indexPath.row]) as! ADButton
        

        cell.backgroundColor =  UIColor(patternImage: UIImage(named: "bigbg")!)
        cell.contentView.backgroundColor  =  UIColor(patternImage: UIImage(named: "bigbg")!)
            
            let lbl = cell.contentView.viewWithTag(100) as! UILabel
            //lbl.textColor = UIColor.redColor()
            print("\(option.question.question_desc) (\(option.question.violation_code!))")
            
            lbl.text = "\(option.question.question_desc!) (\(option.question.violation_code!))"
            
            let btn = cell.contentView.viewWithTag(200) as! UIButton
            btn.setTitle("\(indexPath.row + 1)" , for: UIControlState())
            
            
            
            
            if indexPath.row % 2 == 0 {
        cell.contentView.backgroundColor =  UIColor.white
        }
        else {
        cell.contentView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        }
        return cell
        }
        else {
        
            let option :ADButton  = self.appDel.calculatedWarnings.object(forKey: self.appDel.calculatedWarnings.allKeys[indexPath.row]) as! ADButton
            
            
            cell.backgroundColor =  UIColor(patternImage: UIImage(named: "bigbg")!)
            cell.contentView.backgroundColor  =  UIColor(patternImage: UIImage(named: "bigbg")!)
            let lbl = cell.contentView.viewWithTag(100) as! UILabel
            lbl.text = "\(option.question.question_desc)"
            let btn = cell.contentView.viewWithTag(200) as! UIButton
            btn.setTitle("\(indexPath.row + 1)" , for: UIControlState())
            
            lbl.textColor = UIColor(red: 184/255, green: 134/255, blue: 11/255, alpha: 1)
            
            if indexPath.row % 2 == 0 {
                cell.contentView.backgroundColor =  UIColor.white
            }
            else {
                cell.contentView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
            }
            return cell
        }
        
        
    }

    
    func createInspectorParts(){
        self.createMultipart("inspector-\(self.appDel.taskDao.task_id).jpeg", imageData: UIImageJPEGRepresentation(self.inspectorSignature.getSignature(), 50),type: 1)
        
        
    
    }
    
    // MARK:- Create multi part request to upload signatures
    func createMultiPartForManager(){
        self.createMultipart("manager-\(self.appDel.taskDao.task_id).jpeg", imageData: UIImageJPEGRepresentation(self.managerSignatureView.getSignature(), 50),type: 2)
        
    }
    func createMultipart(_ filename : String , imageData : Data? , type : Int){
        // use SwiftyJSON to convert a dictionary to JSON
        // type = 1 means inspector 
        // type = 2 means manager
        
        // let myUrl = NSURL(string: "http://einspection.net/api/saveMedia");
        let myUrl = URL(string: Constants.kUploadMedia);
        
        if imageData != nil{
            let request = NSMutableURLRequest(url: myUrl!)
            
           // let session = NSURLSession.sharedSession()
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            PKHUD.sharedHUD.show()
            
            
            
            
            request.httpMethod = "POST"
            
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            //  println("Content Type \(contentType)")
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            let body = NSMutableData()
            
            
            // Title
            body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"media\"; filename=\"\(filename)\"\\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(imageData!)
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            
            
            
            request.httpBody = body as Data
            
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler:{(response:URLResponse?, responseData:Data?, error: NSError?)  in
                PKHUD.sharedHUD.hide(animated: true)
                
                if error != nil
                {
                    print(error!.description)
                }
                else
                {
                    //Converting data to String
                    let responseStr:NSString = NSString(data:responseData!, encoding:String.Encoding.utf8.rawValue)!
                    print("Returning url \(responseStr) for type \(type)")
                    let parser =  JsonParser()
                    let str = parser.parseMedia(responseData!)
                    if type == 1 {
                    self.inspector_signature_media = str
                        //self.createMultipart("manager-\(self.appDel.taskDao.task_id).jpeg", imageData: UIImageJPEGRepresentation(self.managerSignatureView.getSignature(), 50),type: 2)
                        if self.managerSignatureView.signatureStatus != 0 {
                        //let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "createMultiPartForManager", userInfo: nil, repeats: false)
                        self.createMultiPartForManager()
                            
                        }
                        else {
                        self.submitdata()
                        }
                        
                    }
                    else {
                        self.manager_signature_media = str
                        print("submit result after 2 seconds")
                       // let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "submitdata", userInfo: nil, repeats: false)
                        //if self.inspectorSignature.signatureStatus != 0 {
                        self.submitdata()
                        //}
                        
                    }
                    if self.manager_signature_media != nil && self.inspector_signature_media != nil {
                   // self.submitdata()
                   // let timer = NSTimer(timeInterval: 2.0, target: self, selector: "submitdata", userInfo: nil, repeats: false)
                    }
                   
                }
            } as! (URLResponse?, Data?, Error?) -> Void)
            
        }
    }
    
    func submitDataToServer(){
        
        // This method will take questions data array from app delegate 
        // this method will upload data to the server 
        //
    print("manager signature id \(self.manager_signature_media!) inspector signature id \(self.inspector_signature_media)")
    }

    
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var notesTextView: UITextView!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func clearManagerSig(_ sender: AnyObject) {
       
        self.managerSignatureView.clearSignature()
    }
    @IBOutlet weak var emailLbl: UILabel!
    @IBAction func clearInspectorSig(_ sender: AnyObject) {
    self.inspectorSignature.clearSignature()
    }
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var proLbl: UILabel!
    @IBOutlet weak var finaliseLbl: UILabel!
    @IBOutlet weak var managerSignatureView: DrawSignatureView!
    @IBOutlet weak var inspectorSignature: DrawSignatureView!
    @IBOutlet weak var proView: UIView!
    @IBOutlet weak var titleView: UIView!
    var localisation : Localisation!
    
    @IBOutlet weak var providedByName: UILabel!
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.notesTextView.resignFirstResponder()
        self.proName.resignFirstResponder()
        self.mobileNumber.resignFirstResponder()
        self.emailId.resignFirstResponder()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.appDel.selectedIndividual == nil {
            if self.appDel.taskDao.company.makani.count <= 0 {
                if self.appDel.selectedMakani != nil {
                    if self.appDel.selectedMakani != "" {
                        let alert = SCLAlertView()
                        
                        
                        alert.addButton("Yes", action:{
                            self.saveMakani = 1
                            self.appDel.saveMakani = 1
                            
                        })
                        
                        alert.addButton(localisation.localizedString(key: "No"), action:{
                            self.saveMakani = 0
                                 self.appDel.saveMakani = 0
                        })
                        
                        
                        alert.showCloseButton = false
                        alert.showInfo(localisation.localizedString(key: "Makani"), subTitle: localisation.localizedString(key: "You want to save Makani"))
                        
                        
                        
                    } // end of the makani empty check
                } // end of the makani nil chekc
            } // end of the makani count check
            
        } // check if tsk is not individual task
        

        
        
        //self.view.superview!.layer.cornerRadius = 0;
    }
   
    func setupDesignitions(){
        if self.appDel.taskDao == nil {
        return 
        }
        for i in self.designitionArray {
            if let design1  = i as? DesignCategoriesDao {
                if self.appDel.taskDao.company.contact_designation != nil {
                   // print("\(design1.design_id) and  \(self.appDel.taskDao.company.contact_designation!)")
                    if "\(design1.design_id)" == self.appDel.taskDao.company.contact_designation! {
                    
                    self.selectedContactDesign = design1
                    self.contactDesignbtn.setTitle(self.selectedContactDesign.design_nameEng, for: UIControlState())
                    }
            }
            }//nil check
        } // end of the for loop
        
        //print("Provided by")
        //print(self.appDel.taskDao.company.contact_provided_by)
    //print(self.appDel.taskDao.company.contact_provider_name!)
        
        for i in self.designitionArray {
            if let design1  = i as? DesignCategoriesDao {
                if self.appDel.taskDao.company.contact_provided_by != nil {
                    
                    //print("\(design1.design_id) = \(self.appDel.taskDao.company.contact_provided_by! )")
                    
                    //print(self.appDel.taskDao.company.contact_provided_by! )
                    if "\(design1.design_id)" == self.appDel.taskDao.company.contact_provided_by! {
                        self.selectedProvidedByDesign = design1
                        self.providedByDesign.setTitle(self.selectedProvidedByDesign.design_nameEng, for: UIControlState())
                        if self.appDel.taskDao.company.contact_provider_name != nil {
                        self.providedByTextField.text = self.appDel.taskDao.company.contact_provider_name!
                        }
                    }
                }
            }//nil check
        } // end of the for loop
        
    
    
    }
    
    
    @objc func hideKeypad(){
    self.notesTextView.resignFirstResponder()
    self.providedByTextField.resignFirstResponder()
    self.mobileNumber.resignFirstResponder()
    self.proName.resignFirstResponder()
    self.externalNotesTextView.resignFirstResponder()
    self.plateNotxt.resignFirstResponder()
    self.driverNoTxt.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alert = UIAlertController(title: "Condition", message: "Taking Category in 0", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
        //self.violationsTitleLbl.text = "Hello"
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "taskbg")!)
      //  self.titleView.backgroundColor =  UIColor(patternImage: UIImage(named: "bigbg")!)
//        "finalise.violations" = "Violations";
//        "finalise.warnings" = "Warnings";
//        "finalise.inspectionSummary" = "Inspection Summary";
//
//       
        self.proName.text = ""
        self.providedByTextField.text = ""
        self.mobileNumber.text = ""
        self.emailId.text = ""
        
        notesTextView.layer.borderWidth = 1.0
        notesTextView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        self.proView.layer.borderWidth = 1.0
        proView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        self.violationsTable.layer.borderWidth = 1.0
        self.violationsTable.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(FinishReportViewController.hideKeypad))
        self.view.addGestureRecognizer(gesture)
        self.providesPresentationContextTransitionStyle = true;
        self.definesPresentationContext = true;
        //self.modalPresentationStyle = UIModalPre
        self.modalPresentationStyle = UIModalPresentationStyle.currentContext
        self.submitBtn.layer.cornerRadius = 4.0
        
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        if self.appDel.taskDao != nil {
        for config in self.appDel.user.configArray {
            if let conf = config as? ConfigurationDao {
               // print(self.appDel.taskDao.list_id)
              //  print(conf.checkList_id)
            
                if conf.checkList_id == self.appDel.taskDao.list_id {
                    
                self.currentCategoryConfig = conf
               // print("Configuration Found \(self.currentCategoryConfig?.automatic_location_flag)")
                }
            }
        }
        }
        self.violationsTable.estimatedRowHeight = 62
        
        self.violationsTable.rowHeight = UITableViewAutomaticDimension
        
     //   self.inspectionSummaryLbl.text = "\(localisation.localizedString(key:"finalise.inspectionSummary"))(\(self.appDel.selectedViolation.count) \(localisation.localizedString(key: "finalise.violations")))"
        
        
        
        //self.inspectionCountView.backgroundColor =  UIColor(patternImage: UIImage(named: "bigbg")!)
        //self.violationsTable.backgroundView?.backgroundColor =  UIColor(patternImage: UIImage(named: "bigbg")!)
        
//        if Reachability.connectedToNetwork() {
//        
//            if ((self.appDel.taskDao.company.lat) as NSString).rangeOfString("0.0").location == NSNotFound && ((self.appDel.taskDao.company.lon) as NSString).rangeOfString("0.0").location == NSNotFound {
//               
//                if self.appDel.taskDao.category_id != nil {
//                if self.appDel.taskDao.category_id != "12" {
//                
//                }
//                else {
//                    self.companyLat = Double(self.appDel.taskDao.company.lat)!
//                    self.companyLon = Double(self.appDel.taskDao.company.lon)!
//                    
//                }
//            }
//            else {
//                self.companyLat = Double(self.appDel.taskDao.company.lat)!
//                self.companyLon = Double(self.appDel.taskDao.company.lon)!
//                
//            }
//            
//        }
//        } // end of the offline condition
//        "finalise.pro" = "PRO";
//        "finalise.owner" = "Owner";
//        "finalise.manager" = "Manager";
//        "finalise.secretary" = "Secretary";
//        "finalise.others" = "Others";

        if self.appDel.taskDao != nil {
            
            
            
        if Reachability.connectedToNetwork() {
            // check if company lat/lon are not nill and not empty
                       if self.appDel.taskDao.company.lat != "" && self.appDel.taskDao.company.lat != nil && self.appDel.taskDao.company.lon != nil && self.appDel.taskDao.company.lon != "" {
                // check if company lat/lon are proper decimals
                // print(<#T##items: Any...##Any#>)
                        
//                         latDao = Double(self.appDel.taskDao.company.lat)
//                            if latDao > 0 {
//                            print("Location is valid \(latDao)")
//                            }
//                            else {
//                            print("Location outside is not valid \(latDao)")
//                            }
//                        
                        
                //if ((self.appDel.taskDao.company.lat) as NSString).rangeOfString("0.0").location == NSNotFound && ((self.appDel.taskDao.company.lon) as NSString).rangeOfString("0.0").location == NSNotFound  && ((self.appDel.taskDao.company.lat) as NSString).rangeOfString("0").location ==  NSNotFound && ((self.appDel.taskDao.company.lat) as NSString).rangeOfString(".000").location ==  NSNotFound {
                
                    if Util.validateCoordinates(self.appDel.taskDao.company.lat, lon: self.appDel.taskDao.company.lon) {
                    print("Location is valid in main condition")
                        
                   //     self.violationsTitleLbl.text = "Taking \(self.appDel.taskDao.company.lat) and \(self.appDel.taskDao.company.lon)"
                    self.companyLat = Double(self.appDel.taskDao.company.lat)!
                    self.companyLon = Double(self.appDel.taskDao.company.lon)!
                    }
                    // otherwise assign user location to company lat/lon
                else {
                    // check if user lat/lon are not nill
                    
                        if self.currentCategoryConfig != nil {
                            if self.currentCategoryConfig?.automatic_location_flag == "0" {
                                
                                
                           //     self.violationsTitleLbl.text = "Taking Category in 0"
                                print("Not Loggin Location")
                            }
                            else {
                              //  self.violationsTitleLbl.text = "Taking User location"
                                
                                let touple = Util.returnUserLocation()
                                self.companyLat = touple.lat
                                self.companyLon =  touple.lon

                            }
                        }
                       // self.companyLat = self.appDel.user.lat
                       // self.companyLon =  self.appDel.user.lon
                    
                        
                        }
                
                
            }
            else {
                
                    //let companylocation = CLLocationCoordinate2DMake(self.appDel.user.lat , self.appDel.user.lon)
                    
                    if self.currentCategoryConfig != nil {
                        if self.currentCategoryConfig?.automatic_location_flag == "0"  {
                           
                          //  self.violationsTitleLbl.text = "Taking Category in 0 outside"
                            
                            
                        }
                        else {
                            
                          //  self.violationsTitleLbl.text = "Taking User location outside"
                            
                            let touple = Util.returnUserLocation()
                            self.companyLat = touple.lat
                            self.companyLon =  touple.lon
                            
                        }
                    }

                    //self.companyLat = self.appDel.user.lat
                    //self.companyLon =  self.appDel.user.lon
                    
                    
                    // Drop a pin
                    
                    
                    
                    // let region = MKCoordinateRegionMakeWithDistance(companylocation, 1000, 1000)
                    // self.locationMapView.setRegion(region, animated: true)
                            }
        } // end of the offline condition
        else {
          //  self.violationsTitleLbl.text = "No Internet"
            }
        }
        else {
          //  self.violationsTitleLbl.text = "Task dao nil"
            
        }
       // print(self.companyLat)
       // print(self.companyLon)
       // print("Editable flag \(currentCategoryConfig?.contact_edit_flag) \(currentCategoryConfig?.category_id)")
        
        if currentCategoryConfig != nil {
            if currentCategoryConfig?.contact_edit_flag == "0" {
            self.providedByTextField.isEnabled = false
            self.emailId.isEnabled = false
            self.proName.isEnabled = false
            self.mobileNumber.isEnabled = false
            self.contactDesignbtn.isEnabled = false
            self.providedByDesign.isEnabled = false
            
                
           
            }
            else {
                self.providedByTextField.isEnabled = true
                self.emailId.isEnabled = true
                self.proName.isEnabled = true
                self.mobileNumber.isEnabled = true
                self.contactDesignbtn.isEnabled = true
                self.providedByDesign.isEnabled = true
                

            }
            
            
        }
        let d = DesignCategoriesDao()
        d.design_nameEng = localisation.localizedString(key: "finalise.owner")
        d.design_id = 2
        self.designitionArray.add(d)
        
        let d1 = DesignCategoriesDao()
        d1.design_nameEng = localisation.localizedString(key: "finalise.manager")
        d1.design_id = 1
        self.designitionArray.add(d1)
        
        let d2 = DesignCategoriesDao()
        d2.design_nameEng = localisation.localizedString(key: "finalise.pro")
        d2.design_id = 3
        self.designitionArray.add(d2)
        
        
        let d3 = DesignCategoriesDao()
        d3.design_nameEng = localisation.localizedString(key: "finalise.secretary")
        d3.design_id = 4
        self.designitionArray.add(d3)
        
        
        let d4 = DesignCategoriesDao()
        d4.design_nameEng = localisation.localizedString(key: "finalise.others")
        d4.design_id = 5
        self.designitionArray.add(d4)
        
        
        self.view.layer.cornerRadius = 0.0
        
        if self.appDel.selectedIndividual != nil {
            self.selectedContactDesign = self.designitionArray.object(at: 4) as! DesignCategoriesDao
            self.selectedProvidedByDesign = self.designitionArray.object(at: 4) as! DesignCategoriesDao
            self.contactDesignbtn.setTitle(self.selectedProvidedByDesign.design_nameEng, for: UIControlState())
            self.providedByDesign.setTitle(self.selectedContactDesign.design_nameEng, for: UIControlState())
            self.providedByTextField.text = self.appDel.selectedIndividual!.fullName_en
            self.providedByTextField.isEnabled = false
            self.proName.isEnabled = false
            self.proName.text = self.appDel.selectedIndividual!.fullName_en
            self.mobileNumber.text = self.appDel.selectedIndividual!.mobile
            self.emailId.text = self.appDel.selectedIndividual!.email
            self.emailId.isEnabled = false
            self.mobileNumber.isEnabled = false
            self.contactDesignbtn.isEnabled = false
            self.providedByDesign.isEnabled = false
            
            
        }
        
        
        // self.violationlbl.text = self.localisation.localizedString(key: "finalise.violations")
        
        
        if self.appDel.taskDao != nil {
        if (self.appDel.taskDao.company.pro_name == nil  && self.appDel.taskDao.company.pro_mobile == nil) || (self.appDel.taskDao.company.pro_name == "NULL" && self.appDel.taskDao.company.pro_mobile == "NULL")  {
        self.appDel.taskDao.company.pro_name = DEFAULT_CONTACT_TITLE
        self.appDel.taskDao.company.email_pro = self.appDel.taskDao.company.email
        self.appDel.taskDao.company.pro_mobile =  self.appDel.taskDao.company.phone_no
        self.appDel.taskDao.company.contact_designation = DEFAULT_CONTACT
        self.appDel.taskDao.company.contact_provided_by = DEFAULT_CONTACT
        self.appDel.taskDao.company.contact_provider_name = DEFAULT_CONTACT_TITLE
        }
        
        
        if self.appDel.taskDao.company.pro_mobile != nil &&  self.appDel.taskDao.company.pro_mobile != "NULL" {
            self.mobileNumber.text = self.appDel.taskDao.company.pro_mobile
        }
        
        if self.appDel.taskDao.company.email_pro != nil  && self.appDel.taskDao.company.email_pro != "NULL" {
            self.emailId.text = self.appDel.taskDao.company.email_pro
        }
        
        if self.appDel.taskDao.company.pro_name != nil && self.appDel.taskDao.company.pro_name != "NULL" {
            self.proName.text = self.appDel.taskDao.company.pro_name!
        }
        
            
        }
        self.setupDesignitions()
        
        
        self.pronamelbl.text = self.localisation.localizedString(key: "finalise.name")
        
        self.providedByName.text = self.localisation.localizedString(key: "finalise.name")
        
        
        self.mobileNumberLbl.text = self.localisation.localizedString(key: "finalise.mobilenumber")
        self.emailTitleLbl.text = self.localisation.localizedString(key: "finalise.email")
        self.proDetailLbl.text = self.localisation.localizedString(key: "finalise.contactdetails")
        self.violationsTitleLbl.text = self.localisation.localizedString(key: "finalise.violations")
        self.titleNotesLbl.text = self.localisation.localizedString(key: "finalise.notes")
        self.providedbylbl.text = self.localisation.localizedString(key: "general.providedby")
        /*
         "general.providedby" = "Provided By";
         "general.designation" = "Designation";
         "general.addiotionalemail" = "Additional Email";
         "general.externalnotes" = "External Notes";

         */
        
        self.contactDesignlbl.text = self.localisation.localizedString(key: "general.designation")
        self.additionalEmaillbl.text = self.localisation.localizedString(key: "general.additionalemail")
        self.externalnoteslbl.text = self.localisation.localizedString(key: "general.externalnotes")
        
        self.designtitlelbl.text = self.localisation.localizedString(key: "general.designation")
        self.driverNoLbl.text = self.localisation.localizedString(key: "searchcompany.rtalicenseno")
        self.plateNolbl.text = self.localisation.localizedString(key: "permit.plateno")
     // let notificationCenter = NSNotificationCenter.defaultCenter()
      //  let mainQueue = NSOperationQueue.mainQueue()
//        
    // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FinishReportViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
 //       NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FinishReportViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);

        
//        let observer = notificationCenter.addObserverForName(UIKeyboardWillChangeFrameNotification, object: self.notesTextView, queue: mainQueue) { _ in
//            print("Keyboard will show")
//            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
//                print("Keyboard will show")
//                if self.inspectionCountView.frame.origin.y == 0 {
//                    
//                    self.inspectionCountView.frame.origin.y = -300
//                }
//            }
//
//        }
        
//
//        let observer1 = notificationCenter.addObserverForName(UIKeyboardWillShowNotification, object: self.notesTextView, queue: mainQueue) { _ in
//            self.inspectionCountView.frame.origin.y =  self.inspectionCountView.frame.origin.y - 300
//            print("-300")
//
//        }
//        
        
        
        
       // self.notesTextView.addt
        
       // self.inspectorsignaturelbl.text = self.localisation.localizedString(key: "finalise.inspectorssignature")
       // self.siteManagerlbl.text = self.localisation.localizedString(key: "finalise.siteManagerssignature")
        //self.finaliseLbl.text = self.localisation.localizedString(key: "finalise.finalise")
      //  self.proLbl.text = self.localisation.localizedString(key: "finalise.contactdetails")
        self.submitBtn.setTitle(self.localisation.localizedString(key: "finalise.submit"), for: UIControlState())
       
        
        

        //self.proView.backgroundColor =  UIColor(patternImage: UIImage(named: "bigbg")!)
        
       // self.managerSignatureView.backgroundColor =  UIColor(patternImage: UIImage(named: "bigbg")!)
        
      //  self.inspectorSignature.backgroundColor =  UIColor(patternImage: UIImage(named: "bigbg")!)
        
       // self.notesTextView.backgroundColor =  UIColor(patternImage: UIImage(named: "bigbg")!)
        
        //if self.appDel.user.lat != nil && self.appDel.user.lon != nil{
        //[mapView setCenterCoordinate:myCoord zoomLevel:13 animated:YES];
        //self.locationMapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: self.appDel.user.lat, longitude: appDel.user.lon), animated: true)
        //self.locationMapView.se
        //let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: self.appDel.user.lat, longitude: appDel.user.lon), 500, 500)
         
            //self.locationMapView.setRegion(region, animated: true)
            
      //  }
        
       // if self.appDel.taskDao.company.lat != nil {
//        let companylocation = CLLocationCoordinate2DMake((self.appDel.taskDao.company.lat as NSString).doubleValue, (self.appDel.taskDao.company.lon as NSString).doubleValue)
//        // Drop a pin
//        let dropPin = MKPointAnnotation()
//        dropPin.coordinate = companylocation
//        dropPin.title = self.appDel.taskDao.company.company_name
//       // self.locationMapView.addAnnotation(dropPin)
//            if( companylocation.latitude > -89 && companylocation.latitude < 89 && companylocation.longitude > -179 && companylocation.longitude < 179 ){
//
//            let region = MKCoordinateRegionMakeWithDistance(companylocation, 500, 500)
//            
//     //        self.locationMapView.setRegion(region, animated: true)
//            }
//        }
//       
//        //self.title = "Finalise Inspection"
//        
//        // Do any additional setup after loading the view.
//    
   //     }
       
        /*   These lines of code are removed beccause now inspection will be submitted as single inspection for drivers and cars
        print("Number of selected drivers\(self.appDel.selectedDrivers.count)")
        print("Number of selected Vehicles\(self.appDel.selectedVehicles.count)")
        
        
        var notesStr : String = "التفتيش على المركبات:"
        if self.appDel.selectedVehicles.count > 0 {
            notesStr = "\(notesStr) \(self.appDel.selectedVehicles.componentsJoinedByString(","))"
        }
        if self.appDel.selectedDrivers.count > 0 {
            if notesStr != "التفتيش على المركبات:"{
                notesStr = notesStr + "\n"
            notesStr = notesStr + "التفتيش على السائقين:"
            }
            else {
            notesStr = "التفتيش على السائقين:"
            }
            notesStr = "\(notesStr) \(self.appDel.selectedDrivers.componentsJoinedByString(","))"
        }
        if self.appDel.selectedDrivers.count <= 0 && self.appDel.selectedVehicles.count <= 0 {
        notesStr = ""
        }
         // end of driver and cars
        */
        
        
//        if self.appDel.searchedDriver != nil && self.appDel.searchedDriver != "" {
//        self.externalNotesTextView.text = " التفتيش على سائق رقم \(self.appDel.searchedDriver!)"
//        print("Inspection on Plate No. \'\(self.appDel.searchedDriver!)\'")
//        }
//        else if self.appDel.searchedCar != nil && self.appDel.searchedCar != "" {
//        self.externalNotesTextView.text = "التفتيش على سيارة رقم لوحتها \(self.appDel.searchedCar!)"
//        print("Inspection on Driver No. \'\(self.appDel.searchedCar!)\'")
//        }

        
        if self.appDel.taskDao != nil {
        if self.appDel.taskDao.external_notes != nil {
            if self.appDel.taskDao.external_notes != "" {
        self.externalNotesTextView.text = self.appDel.taskDao.external_notes
            }
        }
        }
        
        if self.appDel.taskDao != nil {
        if self.appDel.taskDao.isSubVenue == "1" && self.appDel.taskDao.subVenueName != nil {
            self.externalNotesTextView.text = "التفتيش \(self.appDel.taskDao.subVenueName!) "
        
        }
    }
        if self.appDel.taskDao != nil {
        if self.appDel.taskDao.inspection_type != nil && self.appDel.taskDao.waiting_for_audit != nil {
            if self.appDel.taskDao.inspection_type == "co-inspection" && self.appDel.taskDao.waiting_for_audit == "1" {
            
                if self.appDel.taskDao.external_notes != nil {
                if self.appDel.taskDao.external_notes != "" {
                self.externalNotesTextView.text = self.appDel.taskDao.external_notes!
                
            }
                }
        
            if self.appDel.taskDao.additiona_email != nil {
                if self.appDel.taskDao.additiona_email != "" {
            
              self.additionalemailvalue.text = self.appDel.taskDao.additiona_email!
                
            }
        
        }
            
            
            }
            
        
        } // this condition is applied to check if
        }// task dao nil check
        
        
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Start editing")
        if UIDevice.current.userInterfaceIdiom == .pad {
            print("Keyboard will show")
            if self.inspectionCountView.frame.origin.y == 0 {
                
                self.inspectionCountView.frame.origin.y = -300
            }
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if self.inspectionCountView.frame.origin.y == -300 {
                print("+300 \(self.inspectionCountView.frame.origin.y)")
                self.inspectionCountView.frame.origin.y = 0
            }
            
        }
    }
    
    

    
    func keyboardWillShow(_ sender : AnyObject){
         print("Keyboard will show")
        
        if UIDevice.current.userInterfaceIdiom == .pad {
        print("Keyboard will show")
        if self.inspectionCountView.frame.origin.y == 0 {

        self.inspectionCountView.frame.origin.y = -300
        }
        }
    }
    func keyboardWillHide(_ sender : AnyObject){
        print("Keyboard will Hide")
         if UIDevice.current.userInterfaceIdiom == .pad {
        if self.inspectionCountView.frame.origin.y == -300 {
                        print("+300 \(self.inspectionCountView.frame.origin.y)")
                        self.inspectionCountView.frame.origin.y = 0
                                          }

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func isValidEmail(_ testStr:String) -> Bool {
         print("validate Email:\(testStr)")
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func submitdata(){
       
        
    let downloader  = DataDownloader()
        self.appDel.showIndicator = 1
        
        if self.appDel.selectedIndividual != nil {
            downloader.startSendingPostForIndividual(self.appDel.allAnsweredArray, url: URL(string: Constants.saveIndServay)!, ide: "submit", duration: self.appDel.tasks_duration, notes: self.notesTextView.text!, inspector_sign: self.inspector_signature_media!, siteManagerSig: self.manager_signature_media!, pro_name: self.proName.text!, pro_mobile: self.mobileNumber.text!, pro_email: self.emailId.text!,contactDesign: "\(self.selectedContactDesign.design_id)",providedByName : self.providedByTextField.text!,providedByDesign:"\(self.selectedProvidedByDesign.design_id)",ind_name: self.appDel.selectedIndividual!.fullName_en!,ind_NameAr:self.appDel.selectedIndividual!.fullName_ar!,emirated_id : (self.appDel.selectedIndividual?.emirates_id)!,passport : self.appDel.selectedIndividual!.passport!,rtaLicense : self.appDel.selectedIndividual!.rtaLicense! ,ind_email : self.appDel.selectedIndividual!.email!,ind_phone : self.appDel.selectedIndividual!.mobile!,external_notes: self.externalNotesTextView.text,extraEmail: self.additionalemailvalue.text!,country_code: self.appDel.selectedIndividual?.countryCode,DriverNo: self.driverNoTxt.text ?? "",plateNo: self.plateNotxt.text ?? "")

        }
        else {
            if self.saveMakani == 1 {
                downloader.startSendingPostForSignature(self.appDel.allAnsweredArray, url: URL(string: Constants.saveServay)!, ide: "submit", duration: self.appDel.tasks_duration, notes: self.notesTextView.text!, inspector_sign: self.inspector_signature_media!, siteManagerSig: self.manager_signature_media!, pro_name: self.proName.text!, pro_mobile: self.mobileNumber.text!, pro_email: self.emailId.text!, company_lat: String(self.companyLat), company_lon:String(self.companyLon), company_id: self.appDel.taskDao.company.company_id!,contactDesign: "\(self.selectedContactDesign.design_id)",providedByName : self.providedByTextField.text!,providedByDesign:"\(self.selectedProvidedByDesign.design_id)",extraEmail: self.additionalemailvalue.text!,additional_Notes: self.externalNotesTextView.text,makani: self.appDel.selectedMakani,DriverNo: self.driverNoTxt.text ?? "",plateNo: self.plateNotxt.text ?? "")
                
                
            }
            else {
            
            
                downloader.startSendingPostForSignature(self.appDel.allAnsweredArray, url: URL(string: Constants.saveServay)!, ide: "submit", duration: self.appDel.tasks_duration, notes: self.notesTextView.text!, inspector_sign: self.inspector_signature_media!, siteManagerSig: self.manager_signature_media!, pro_name: self.proName.text!, pro_mobile: self.mobileNumber.text!, pro_email: self.emailId.text!, company_lat: String(self.companyLat), company_lon:String(self.companyLon), company_id: self.appDel.taskDao.company.company_id!,contactDesign: "\(self.selectedContactDesign.design_id)",providedByName : self.providedByTextField.text!,providedByDesign:"\(self.selectedProvidedByDesign.design_id)",extraEmail: self.additionalemailvalue.text!,additional_Notes: self.externalNotesTextView.text,makani: self.appDel.selectedMakani,DriverNo: self.driverNoTxt.text ?? "",plateNo: self.plateNotxt.text ?? "")
            
            
            }
        
        }
        
        
        downloader.delegate = self
        //self.TaskSubmitted()
        
       // downloader.startSendingPost(self.appDel.allAnsweredArray,url: NSURL(string: Constants.saveServay)!, ide: "submit", duration: self.appDel.tasks_duration)
        
        
    } // end of the submit data
    
    
//    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//        print("-300 \(self.inspectionCountView.frame.origin.y)")
//
//        self.inspectionCountView.frame.origin.y = -300
//        
//        return true
//    }
//   
//    func textViewShouldEndEditing(textView: UITextView) -> Bool {
//        if self.inspectionCountView.frame.origin.y == -300 {
//            print("+300 \(self.inspectionCountView.frame.origin.y)")
//            self.inspectionCountView.frame.origin.y = 0
//          //  self.inspectionCountView.frame.origin.y =  self.inspectionCountView.frame.origin.y + 300
//        }
//
//        return true
//    }
    
    
    
    func dataDownloaded(_ data: NSMutableData, identity: String) {
    let str = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
     //  print(str)
        
        if identity == "submit" && str!.contains("success") {
            self.appDel.searchedDriver = ""
            self.appDel.searchedCar = ""
                self.hideKeypad()
            self.appDel.user.status = "active"
            if self.finishDel == nil {
            print("Delegate is nill")
            }
            
//                let alert = SCLAlertView()
//            if self.appDel.selectedIndividual == nil {
//
//                alert.addButton("Create Adhoc Inspection", action:{
//                self.dismiss(animated: true, completion: nil)
//                self.finishDel?.createAdhoc!()
//            })
//            }
//            alert.addButton(localisation.localizedString(key: "general.done"), action:{
//                self.finishDel?.taskSaved!("")
//                self.dismiss(animated: true, completion: nil)
//            })
//
//
//            alert.showCloseButton = false
//            alert.showInfo(localisation.localizedString(key: "finalise.inspection"), subTitle: localisation.localizedString(key: "finalise.InspectionSubmittedSuccessfully"))
//
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToRoot), userInfo: nil, repeats: false).fire()
            
        //self.finishDel!.taskSaved!("")
        }
        
        
    self.appDel.selectedIndividual = nil
    self.appDel.inspectionByIndividual = 0
    }
    @objc func moveToRoot(){
         self.dismiss(animated: true, completion: nil)
         self.finishDel!.taskSaved!("")
    }
    
    func TaskSubmitted(){
            self.appDel.searchedDriver = ""
            self.appDel.searchedCar = ""
            self.hideKeypad()
            self.appDel.user.status = "active"
            if self.finishDel == nil {
                print("Delegate is nill")
            }
            let alert = SCLAlertView()
            if self.appDel.selectedIndividual == nil {
                
                alert.addButton("Create Adhoc Inspection", action:{
                    self.dismiss(animated: true, completion: nil)
                    self.finishDel?.createAdhoc!()
                })
            }
            alert.addButton(localisation.localizedString(key: "general.done"), action:{
            self.finishDel?.taskSaved!("")
                self.dismiss(animated: true, completion: nil)
            })
            
            
            alert.showCloseButton = false
            alert.showInfo(localisation.localizedString(key: "finalise.inspection"), subTitle: localisation.localizedString(key: "finalise.InspectionSubmittedSuccessfully"))
        self.appDel.selectedIndividual = nil
        self.appDel.inspectionByIndividual = 0

    }
    
    
    // MARK: - TEXTFIELD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        textField.resignFirstResponder()
        return true
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
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
