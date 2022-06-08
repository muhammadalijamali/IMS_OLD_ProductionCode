//
//  DataDownloader.swift
//  ADTourism
//
//  Created by Administrator on 8/22/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit
import PKHUD
@objc protocol MainJsonDelegate{
    @objc optional func dataDownloaded(_ data : NSMutableData ,  identity : String)
    @objc optional func failed(_ identity : String)
    @objc optional func submittedTask(_ task_id : String)
    
}
class DataDownloader: NSObject , NSURLConnectionDataDelegate {
    
    var xmlData:NSMutableData!
    var iden : String!
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var userDefault : UserDefaults = UserDefaults.standard
    var urlStr : String = ""
    var queue : Int = 1 // try for 3 times
    var task_id : String = ""
    
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?
    
    var delegate : MainJsonDelegate?
    
    func setOfflineGetRequest(_ urlstr : String , idn : String){
        self.xmlData = NSMutableData()
        self.iden = idn
        
        let urlstr1 =  urlstr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let ourl : URL =  URL(string: urlstr1 as! String)!
        var  urlRequest : URLRequest = URLRequest (url:ourl)
        urlRequest.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        
        
        let urlConnection : NSURLConnection = NSURLConnection(request: urlRequest,delegate : self , startImmediately: true)!
        urlConnection.start()
    
        
    }
    func createOfflineGetRequest(_ urlstr : String) -> NSMutableURLRequest{
        self.xmlData = NSMutableData()
        let urlstr1 =  urlstr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let ourl : URL =  URL(string: urlstr1 as! String)!
        let  urlRequest : NSMutableURLRequest = NSMutableURLRequest (url:ourl)
        return urlRequest
    }
    
    
    func startDownloader(_ urlstr : String , idn : String){
       // let url : NSURL = NSURL(string: urlstr)!
        self.xmlData = NSMutableData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.iden = idn
        print(urlstr)
        self.urlStr = urlstr
        let urlstr1 =  urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //let urlstr1 = urlstr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.)
        
        
       // print ("Download url \(urlstr1)")
        let ourl : URL =  URL(string: urlstr1 as! String)!
       // print ("Download url \(ourl)")
        self.showAppleProgressHUD()
        
        //let  urlRequest : NSMutableURLRequest = NSMutableURLRequest (URL:ourl)
        var urlRequest = URLRequest(url: ourl, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        
          urlRequest.timeoutInterval = 60
        
        urlRequest.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        //urlRequest.setValue(, forHTTPHeaderField: <#T##String#>)
        
        let urlConnection : NSURLConnection = NSURLConnection(request: urlRequest,delegate : self , startImmediately: true)!
        
      urlConnection.start()
        
        
        
//        dataTask = defaultSession.dataTask(with: urlRequest) { data, response, error in
//            defer { self.dataTask = nil }
//            // 5
//            if let error = error {
//               // self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
//             print("Error Message \(error)")
//            } else if let data = data,
//                let response = response as? HTTPURLResponse,
//                response.statusCode == 200 {
//                //self.updateSearchResults(data)
//               // let data1 = NSData(data:data)
//                self.xmlData = NSMutableData()
//                self.xmlData.setData(data)
//                 DispatchQueue.main.async {
//                self.datadownloaded()
//                }
//                    // 6
//
//
//            }
//        }
//        // 7
//        dataTask?.resume()
        
        
    }
    // MARK:- SIGNATURE METHOD 
    // This method was created when signature requirements came , so this method will send inspection notes , inspector signature id , sitemanager signature id , pro_name,mobile_number ,email , lat ,lon
    
    
    func loginPost(_ password : String,_username : String,url : String, ide : String){
        self.showAppleProgressHUD()
        let url1 = URL(string: url)
        
        self.xmlData = NSMutableData()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        
        self.iden = ide
        if url1 != nil {
        let request = NSMutableURLRequest(url: url1!)
        
        var session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        
        
        // request.HTTPMethod = "GET"
        let completeData : NSMutableDictionary = NSMutableDictionary()
        
        completeData.setObject(_username, forKey: "username" as NSCopying)
        completeData.setObject(password, forKey: "password" as NSCopying)
        
        
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print(string!)
        
        
        var err: NSError?
        request.httpBody = data!
        let string1 = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)
        
        print(string1!)
        // request.se
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //    println(request.HTTPBody)
        
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
        connection.start()
        }
    }
    
    
    func changePasswordPost(_ old_password : String,_ new_password : String,url : String, ide : String,user_id : String){
        self.showAppleProgressHUD()
        let url1 = URL(string: url)
        
        self.xmlData = NSMutableData()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        
        self.iden = ide
        if url1 != nil {
        let request = NSMutableURLRequest(url: url1!)
        
        var session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        
        
        // request.HTTPMethod = "GET"
        let completeData : NSMutableDictionary = NSMutableDictionary()
        
        completeData.setObject(old_password, forKey: "old_password" as NSCopying)
        completeData.setObject(new_password, forKey: "new_password" as NSCopying)
        completeData.setObject(user_id, forKey: "user_id" as NSCopying)
        
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print(string!)
        
        
        var err: NSError?
        request.httpBody = data!
        let string1 = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)
        
        print(string1!)
        // request.se
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //    println(request.HTTPBody)
        
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
        connection.start()
        }
    }
    
    
    
    func updateProfilePost(user_id : String, full_name : String,email : String, ide : String,contact_no : String,username : String, url : String){
       
     //   pdateProfile = Constants.baseURL + "updateInspectorProfile?user_id=" + self.appdel.user.user_id! + "&full_name=\(self.appdel.user.firstname!)&email=\(self.appdel.user.email!)&contact_no=\(self.appdel.user.contactno!)&username=\(self.usernameTextFi
        self.showAppleProgressHUD()
        let url1 = URL(string: url)
        
        self.xmlData = NSMutableData()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        
        self.iden = ide
        if url1 != nil {
        let request = NSMutableURLRequest(url: url1!)
        
        var session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        
        
        // request.HTTPMethod = "GET"
        let completeData : NSMutableDictionary = NSMutableDictionary()
        
        completeData.setObject(user_id, forKey: "user_id" as NSCopying)
        completeData.setObject(full_name, forKey: "full_name" as NSCopying)
        completeData.setObject(email, forKey: "email" as NSCopying)
        completeData.setObject(contact_no, forKey: "contact_no" as NSCopying)
        completeData.setObject(username, forKey: "username" as NSCopying)
              
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print(string!)
        
        
        var err: NSError?
        request.httpBody = data!
        let string1 = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)
        
        print(string1!)
        // request.se
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //    println(request.HTTPBody)
        
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
        connection.start()
        }
    }
    
    
    
    
    
    func offlineGetrequestPostSignature(_ params : NSMutableArray, ide : String , notes : String , inspector_sign : String , siteManagerSig : String , pro_name : String , pro_mobile : String , pro_email : String , company_lat : String, company_lon : String) -> Data{
        self.xmlData = NSMutableData()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        
        self.iden = ide
        
        let completeData : NSMutableDictionary = NSMutableDictionary()
        completeData.setObject(self.appDel.taskDao.task_id, forKey: "task_id" as NSCopying)
        completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
        
        completeData.setObject(params, forKey: "servey_questions" as NSCopying)
      //  print(self.appDel.taskDao.auditor_Id)
        if self.appDel.taskDao.auditor_Id != nil && self.appDel.taskDao.auditor_Id != "0" && self.appDel.show_result == 0  {
            completeData.setObject(self.appDel.taskDao.auditor_Id!, forKey: "audit_id" as NSCopying)
        }
        else if self.appDel.show_result == 1 {
            completeData.setObject("yes", forKey: "is_audit" as NSCopying)
            
        }
        
        //print("Final data \(completeData)")
        
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        
        
        
        return data!
    }

    
    func offlineGetrequestPost(_ params : NSMutableArray, url : URL , ide : String) -> Data{
        self.xmlData = NSMutableData()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        
        self.iden = ide
       
        let completeData : NSMutableDictionary = NSMutableDictionary()
        completeData.setObject(self.appDel.taskDao.task_id, forKey: "task_id" as NSCopying)
        completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
        completeData.setObject(params, forKey: "servey_questions" as NSCopying)
       // print(self.appDel.taskDao.auditor_Id)
        if self.appDel.taskDao.auditor_Id != nil && self.appDel.taskDao.auditor_Id != "0" && self.appDel.show_result == 0  {
            completeData.setObject(self.appDel.taskDao.auditor_Id!, forKey: "audit_id" as NSCopying)
        }
        else if self.appDel.show_result == 1 {
            completeData.setObject("yes", forKey: "is_audit" as NSCopying)
            
        }
        
        //print("Final data \(completeData)")
        
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
       
        
        
     return data!
    }
    
    
    func startSendingPostOffline(_ data : Data , url : URL ,ide : String , keyStr : String){
        self.xmlData = NSMutableData()
        var request = URLRequest(url: url)
        self.iden = ide
        var session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        
        // request.HTTPMethod = "GET"
        var err: NSError?
        request.httpBody = data
        let string1 = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)
        
        print(string1!)
        // request.se
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        //    println(request.HTTPBody)
        
        // let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
        //  connection.start()
        
        //        var response: URLResponse?
        //        var error: NSError?
        //
        //        do {
        //            let data : Data? = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
        //            if data != nil {
        //                let str = String(data: data!, encoding:  String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        //                print("Server response before saving \(str)")
        //                if str != nil {
        //                    self.updateTasksToDatabase(unique_id: keyStr, server_response: str!)
        //                }
        //                else {
        //                    print("str is nill and cant save data")
        //
        //                }
        //                if ((str?.contains("success")) != nil) {
        //                    self.userDefault.removeObject(forKey: keyStr)
        //
        //
        //                    self.delegate?.dataDownloaded!(NSMutableData(data: data!), identity: self.iden)
        //                    self.delegate?.submittedTask!(self.task_id)
        //                }
        //                else {
        //
        //                self.delegate?.failed!(self.iden)
        //                }
        //
        //
        //                //
        //             //   self.delegate?.dataDownloaded!(NSMutableData(data: data!), identity: self.iden)
        //            }
        //            else {
        //            self.delegate?.failed!(self.iden)
        //
        //            }
        //
        //        } catch (let e) {
        //            print(e)
        //            print("exception")
        //            self.delegate?.failed!(self.iden)
        //        }
        
        // Changing Code to
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let str = String(data: data, encoding:  String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    if str != nil {
                        self.updateTasksToDatabase(unique_id: keyStr, server_response: str!)
                    }
                    if ((str?.contains("success")) != nil) {
                        self.userDefault.removeObject(forKey: keyStr)
                        self.delegate?.dataDownloaded!(NSMutableData(data: data), identity: self.iden)
                        self.delegate?.submittedTask!(self.task_id)
                    }
                    else {
                        self.delegate?.failed!(self.iden)
                    }
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }catch {
                    self.delegate?.failed!(self.iden)
                    print(error)
                }
            }
            else {
                print("error and failed")
                self.delegate?.failed!(self.iden)
                
            }
            }.resume()
        
        
        
        
        //        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { response, data, error in
        //            // do stuff in background queue
        //
        //            // when ready to update model/UI dispatch that to main queue
        //            dispatch_async(dispatch_get_main_queue()) {
        //            //self.delegate?.dataDownloaded(data, identity: self.iden)
        //               print(data)
        //                if data != nil {
        //                let str = NSString(data: data!, encoding:  NSUTF8StringEncoding)
        //                print(str)
        //                if ((str?.containsString("success")) != nil) {
        //                self.userDefault.removeObjectForKey(keyStr)
        //                }
        //
        ////
        //                self.delegate?.dataDownloaded!(NSMutableData(data: data!), identity: self.iden)
        //                }
        //                else {
        //                   // let alert = UIAlertController(title: "Unexpected error", message: "Un expected error found , can't submit data", preferredStyle: UIAlertControllerStyle.)
        //
        //                }
        //            }
        //            }
        //
        
        
        
        
        
        
        
    }
    
    func saveIndividualParametersForOffline (_ params : NSMutableArray, url : URL , ide : String , duration : Int,notes : String , inspector_sign : String , siteManagerSig : String , pro_name : String , pro_mobile : String , pro_email : String ,contactDesign : String,providedByName : String, providedByDesign:String,ind_name : String,ind_NameAr : String,emirated_id : String ,passport : String , rtaLicense : String,ind_email : String,ind_phone : String,external_notes : String,extraEmail : String,country_Code : String?,DriverNo : String,plateNo : String) -> Data{
        
            self.xmlData = NSMutableData()
            self.appDel = UIApplication.shared.delegate as! AppDelegate
            
            self.iden = ide
        
        let completeData : NSMutableDictionary = NSMutableDictionary()
            
            completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
            completeData.setObject(duration, forKey: "task_duration" as NSCopying)
            completeData.setObject(notes, forKey: "inspector_comments" as NSCopying)
            completeData.setObject(inspector_sign, forKey: "inspector_signiture" as NSCopying)
            completeData.setObject(siteManagerSig, forKey: "manager_signiture" as NSCopying)
            completeData.setObject(pro_name, forKey: "pro_name" as NSCopying)
            completeData.setObject(pro_mobile, forKey: "pro_contact_no" as NSCopying)
            completeData.setObject(pro_email, forKey: "pro_email" as NSCopying)
        if country_Code != nil {
            completeData.setObject(country_Code!, forKey: "countryCode" as NSCopying)
            
        }
            completeData.setObject(contactDesign, forKey: "contact_designation" as NSCopying)
            completeData.setObject(providedByDesign, forKey: "contact_provided_by" as NSCopying)
            completeData.setObject(providedByName, forKey: "contact_provider_name" as NSCopying)
            completeData.setObject(emirated_id, forKey: "emiratesID" as NSCopying)
            completeData.setObject(passport, forKey: "passportNumber" as NSCopying)
            completeData.setObject(rtaLicense, forKey: "drivingLicenseNo" as NSCopying)
            completeData.setObject(ind_name, forKey: "fullName" as NSCopying)
            completeData.setObject(ind_NameAr, forKey: "fullName_Arabic" as NSCopying)
            completeData.setObject(ind_email, forKey: "email" as NSCopying)
            completeData.setObject(ind_phone, forKey: "contactNumber" as NSCopying)
            completeData.setObject(self.appDel.currentTime, forKey: "completed_datetime" as NSCopying)
        let array = (self.appDel.unique as NSString).components(separatedBy: ",")
        if array.count > 1 {
            completeData.setObject(array[1], forKey: "offline_identifier" as NSCopying)
            
        }
        
        if external_notes != "" {
           completeData.setObject(external_notes, forKey: "externalNotes" as NSCopying)
        }
        
        if extraEmail != "" {
            completeData.setObject(extraEmail, forKey: "extraEmail" as NSCopying)
            
        }
        if DriverNo != "" {
         
            completeData.setObject(DriverNo, forKey: "driver_license_number" as NSCopying)
        }
        if plateNo != "" {
            completeData.setObject(plateNo, forKey: "plate_number" as NSCopying)
        }
        
            
            if self.appDel.list_id != nil {
                completeData.setObject(self.appDel.list_id!, forKey: "list_id" as NSCopying)
            }
            
            
            
            completeData.setObject(params, forKey: "servey_questions" as NSCopying)
            
            
            
            print("Final data \(completeData)")
            
            let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
             return data!
        
    }
    
    func getOfflineCloseTasksForClosedTasks(offlineIdentifier : String ,coInspectorsIDs : String?,unfinishedNotes : String,unfinishedReason : String,is_closed : String) -> String {
        let date = Date()
        let completedTime = Int64(date.timeIntervalSince1970 * 1000)
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        let completeData : NSMutableDictionary = NSMutableDictionary()
        completeData.setObject(self.appDel.user.user_id, forKey: "inspectorID" as NSCopying)
        completeData.setObject(self.appDel.taskDao.company.company_id!, forKey: "companyID" as NSCopying)
        completeData.setObject("\(completedTime)", forKey: "completedDate" as NSCopying)
        completeData.setObject(self.appDel.taskDao.list_id, forKey: "listID" as NSCopying)
        print("CoInspectors \(coInspectorsIDs)")
        if coInspectorsIDs != "" {
            completeData.setObject(coInspectorsIDs!, forKey: "coInspectorsIDs" as NSCopying)
            
        }
        let currentTime = Int64(date.timeIntervalSince1970 * 1000)  +  Int64(self.appDel.user.user_id!)!
        completeData.setObject("\(currentTime)", forKey: "offlineIdentifier" as NSCopying)
        if self.appDel.currentZoneTask != nil {
            if self.appDel.currentZoneTask!.zoneStatus == "started" {
                completeData.setObject(self.appDel.currentZoneTask!.task_id!, forKey: "zone_id" as NSCopying)
            } // end of the zone started
        } // end of the
        completeData.setObject(unfinishedNotes, forKey: "unfinishedNotes" as NSCopying)
        completeData.setObject(unfinishedReason, forKey: "unfinishedReason" as NSCopying)
         completeData.setObject(is_closed, forKey: "is_closed" as NSCopying)
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        let str = String(data: data!, encoding: .utf8)
        return str!
        
    }
    
    func getOfflineTasksForPassed(companyId : String,list_id : String,offlineId : String,coinspectors : String?,externalNotes : String?) -> String {
         let date = Date()
         let completedTime = Int64(date.timeIntervalSince1970 * 1000)
         self.appDel = UIApplication.shared.delegate as! AppDelegate
         let completeData : NSMutableDictionary = NSMutableDictionary()
         completeData.setObject(self.appDel.user.user_id, forKey: "inspectorID" as NSCopying)
         completeData.setObject(companyId, forKey: "companyID" as NSCopying)
         completeData.setObject("\(completedTime)", forKey: "completedDate" as NSCopying)
         completeData.setObject(Constants.DEFAULT_TASK_DURATION, forKey: "taskDuration" as NSCopying)
         completeData.setObject(list_id, forKey: "listID" as NSCopying)
        completeData.setObject(offlineId, forKey: "offlineIdentifier" as NSCopying)
        
        if coinspectors != "" {
              completeData.setObject(coinspectors!, forKey: "coInspectorsIDs" as NSCopying)
            
        }
        if externalNotes != nil {
            completeData.setObject(externalNotes!, forKey: "externalNotes" as NSCopying)
            
            
        }
        
        
        if self.appDel.currentZoneTask != nil {
            if self.appDel.currentZoneTask!.zoneStatus == "started" {
                
              //  loginUrl = Constants.baseURL + "savePassedInspections?taskIDs=\(task.task_id!)&inspectorID=" + self.user.user_id + "&zone_id=\(self.appDel.currentZoneTask!.task_id!)"
                
                completeData.setObject(self.appDel.currentZoneTask!.task_id!, forKey: "zone_id" as NSCopying)
                
                
            } // end of the zone started
        } // end of the
        
        
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        let str = String(data: data!, encoding: .utf8)
        return str!
    }
    
    func savaParametersforOffline(_ params : NSMutableArray, url : URL , ide : String , duration : Int,notes : String , inspector_sign : String , siteManagerSig : String , pro_name : String , pro_mobile : String , pro_email : String , company_lat : String, company_lon : String , company_id : String, offline_identifier : String,contactDesign : String,providedByName : String, providedByDesign:String,subvenue_id : String?,external_notes : String,extraEmail : String , coInspectorsIds : String?,DriverNo : String,plateNo : String)-> Data{
    
        self.xmlData = NSMutableData()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        
    //    print("List Id \(self.appDel.list_id)")
        self.iden = ide
         let date = Date()
        let completedTime = Int64(date.timeIntervalSince1970 * 1000)
        
        let completeData : NSMutableDictionary = NSMutableDictionary()
        completeData.setObject(self.appDel.taskDao.task_id, forKey: "task_id" as NSCopying)
        completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
        completeData.setObject(duration, forKey: "task_duration" as NSCopying)
        completeData.setObject(notes, forKey: "inspector_comments" as NSCopying)
        completeData.setObject(inspector_sign, forKey: "inspector_signiture" as NSCopying)
        completeData.setObject(siteManagerSig, forKey: "manager_signiture" as NSCopying)
        completeData.setObject(pro_name, forKey: "pro_name" as NSCopying)
        completeData.setObject(pro_mobile, forKey: "pro_contact_no" as NSCopying)
        completeData.setObject(pro_email, forKey: "pro_email" as NSCopying)
        completeData.setObject(company_lat, forKey: "company_lat" as NSCopying)
        completeData.setObject(company_lon, forKey: "company_long" as NSCopying)
        completeData.setObject(company_id, forKey: "company_id" as NSCopying)
        completeData.setObject(self.appDel.list_id!, forKey: "list_id" as NSCopying)
        completeData.setObject(offline_identifier, forKey: "offline_identifier" as NSCopying)
        completeData.setObject(params, forKey: "servey_questions" as NSCopying)
        completeData.setObject("\(completedTime)", forKey: "completed_datetime" as NSCopying)
        completeData.setObject(contactDesign, forKey: "contact_designation" as NSCopying)
        completeData.setObject(providedByDesign, forKey: "contact_provided_by" as NSCopying)
        completeData.setObject(providedByName, forKey: "contact_provider_name" as NSCopying)
        if self.appDel.currentZoneTask != nil {
            if self.appDel.currentZoneTask!.zoneStatus == "started" {
                completeData.setObject(self.appDel.currentZoneTask!.task_id!, forKey: "zone_id" as NSCopying)
                
            } // end of the zone started
        } // end of the
        
        
        if self.appDel.saveMakani == 1 {
            if self.appDel.selectedMakani != nil  {
                if self.appDel.selectedMakani!  != "" {
                    completeData.setObject(self.appDel.selectedMakani!, forKey: "makani_no" as NSCopying)
                }
            }
        
        }
        
        if DriverNo != "" {
         
            completeData.setObject(DriverNo, forKey: "driver_license_number" as NSCopying)
        }
        if plateNo != "" {
            completeData.setObject(plateNo, forKey: "plate_number" as NSCopying)
        }
        if external_notes != "" {
        completeData.setObject(external_notes, forKey: "externalNotes" as NSCopying)
        }
        if subvenue_id !=  nil {
        completeData.setObject(subvenue_id!, forKey: "subvenue_id" as NSCopying)
        }
        if extraEmail != "" {
            completeData.setObject(extraEmail, forKey: "extraEmail" as NSCopying)
            
        }
        if coInspectorsIds != "" {
            completeData.setObject(coInspectorsIds!, forKey: "coInspectorIDs" as NSCopying)
            
        }
        
     //   print(self.appDel.taskDao.auditor_Id)
        if self.appDel.taskDao.auditor_Id != nil && self.appDel.taskDao.auditor_Id != "0" && self.appDel.show_result == 0  {
            completeData.setObject(self.appDel.taskDao.auditor_Id!, forKey: "audit_id" as NSCopying)
        }
        else if self.appDel.show_result == 1 {
            completeData.setObject("yes", forKey: "is_audit" as NSCopying)
            
        }
        
        print("Final data \(completeData)")
        
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print(string!)
        return data!

        
        
    }// end of the saveParameters
    
     func startSendingPostForIndividual(_ params : NSMutableArray, url : URL , ide : String , duration : Int,notes : String , inspector_sign : String , siteManagerSig : String , pro_name : String , pro_mobile : String , pro_email : String ,contactDesign : String,providedByName : String, providedByDesign:String,ind_name : String,ind_NameAr : String,emirated_id : String ,passport : String , rtaLicense : String,ind_email : String,ind_phone : String,external_notes : String,extraEmail : String,country_code : String?,DriverNo : String,plateNo : String){
        self.showAppleProgressHUD()
        
        self.xmlData = NSMutableData()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        
        self.iden = ide
        let request = NSMutableURLRequest(url: url)
        
        var session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        
        
        // request.HTTPMethod = "GET"
        let completeData : NSMutableDictionary = NSMutableDictionary()
        
        completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
        completeData.setObject(duration, forKey: "task_duration" as NSCopying)
        completeData.setObject(notes, forKey: "inspector_comments" as NSCopying)
        completeData.setObject(inspector_sign, forKey: "inspector_signiture" as NSCopying)
        completeData.setObject(siteManagerSig, forKey: "manager_signiture" as NSCopying)
        completeData.setObject(pro_name, forKey: "pro_name" as NSCopying)
        completeData.setObject(pro_mobile, forKey: "pro_contact_no" as NSCopying)
        completeData.setObject(pro_email, forKey: "pro_email" as NSCopying)
        if country_code != nil {
            completeData.setObject(country_code!, forKey: "countryCode" as NSCopying)
        }
        completeData.setObject(contactDesign, forKey: "contact_designation" as NSCopying)
        completeData.setObject(providedByDesign, forKey: "contact_provided_by" as NSCopying)
        completeData.setObject(providedByName, forKey: "contact_provider_name" as NSCopying)
        completeData.setObject(emirated_id, forKey: "emiratesID" as NSCopying)
        completeData.setObject(passport, forKey: "passportNumber" as NSCopying)
        completeData.setObject(rtaLicense, forKey: "drivingLicenseNo" as NSCopying)
        completeData.setObject(ind_name, forKey: "fullName" as NSCopying)
        completeData.setObject(ind_NameAr, forKey: "fullName_Arabic" as NSCopying)
        completeData.setObject(ind_email, forKey: "email" as NSCopying)
        completeData.setObject(ind_phone, forKey: "contactNumber" as NSCopying)
        if external_notes != "" {
        completeData.setObject(external_notes, forKey: "externalNotes" as NSCopying)
        }
        if extraEmail != "" {
            completeData.setObject(extraEmail, forKey: "extraEmails" as NSCopying)
        }
        
        if DriverNo != "" {
         
            completeData.setObject(DriverNo, forKey: "driver_license_number" as NSCopying)
        }
        if plateNo != "" {
            completeData.setObject(plateNo, forKey: "plate_number" as NSCopying)
        }
        
        if self.appDel.list_id != nil {
            completeData.setObject(self.appDel.list_id!, forKey: "list_id" as NSCopying)
        }
        
        
        
        completeData.setObject(params, forKey: "servey_questions" as NSCopying)
        
        
        
        print("Final data \(completeData)")
        
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print(string!)
        
        
        var err: NSError?
        request.httpBody = data!
        let string1 = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)
        
        print(string1!)
        // request.se
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //    println(request.HTTPBody)
        
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
        connection.start()
        
    }
    
    func sendPostQuestionChange(_ url : URL,inspector_id : String,task_id : String,question_id : String,extra_option_id : String,td_amount : String?
        ){
    
        self.xmlData = NSMutableData()
        let request = NSMutableURLRequest(url: url)
        
        var session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        let completeData : NSMutableDictionary = NSMutableDictionary()
        completeData.setObject(inspector_id, forKey: "inspector_id" as NSCopying)
        completeData.setObject(task_id, forKey: "task_id" as NSCopying)
        
        
        let questionDict  = NSMutableDictionary()
        questionDict.setObject(question_id, forKey: "question_id" as NSCopying)
        questionDict.setObject(extra_option_id, forKey: "extra_option_id" as NSCopying)
        if td_amount != nil {
        questionDict.setObject(td_amount!, forKey: "td_amount" as NSCopying)
        }
        let array = NSMutableArray()
        array.add(questionDict)
        completeData.setObject(array, forKey: "servey_questions" as NSCopying)
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print(string!)
        
        
        var err: NSError?
        request.httpBody = data!
        let string1 = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)
        
        print(string1!)
        // request.se
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //    println(request.HTTPBody)
        
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
        connection.start()

        
        
        
    
    }// end of the
    
    
    func startSendingPostForSignature(_ params : NSMutableArray, url : URL , ide : String , duration : Int,notes : String , inspector_sign : String , siteManagerSig : String , pro_name : String , pro_mobile : String , pro_email : String , company_lat : String, company_lon : String , company_id : String,contactDesign : String,providedByName : String, providedByDesign:String,extraEmail : String,additional_Notes : String , makani : String?, DriverNo : String,plateNo : String){
        self.showAppleProgressHUD()
        
        self.xmlData = NSMutableData()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        
        self.iden = ide
        let request = NSMutableURLRequest(url: url)
        
        var session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        request.timeoutInterval = 120
        
        
        // request.HTTPMethod = "GET"
        let completeData : NSMutableDictionary = NSMutableDictionary()
        completeData.setObject(self.appDel.taskDao.task_id, forKey: "task_id" as NSCopying)
        completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
        completeData.setObject(duration, forKey: "task_duration" as NSCopying)
        completeData.setObject(notes, forKey: "inspector_comments" as NSCopying)
        completeData.setObject(inspector_sign, forKey: "inspector_signiture" as NSCopying)
        completeData.setObject(siteManagerSig, forKey: "manager_signiture" as NSCopying)
        completeData.setObject(pro_name, forKey: "pro_name" as NSCopying)
        completeData.setObject(pro_mobile, forKey: "pro_contact_no" as NSCopying)
        completeData.setObject(pro_email, forKey: "pro_email" as NSCopying)
        completeData.setObject(company_lat, forKey: "company_lat" as NSCopying)
        completeData.setObject(company_lon, forKey: "company_long" as NSCopying)
        completeData.setObject(company_id, forKey: "company_id" as NSCopying)
        completeData.setObject(contactDesign, forKey: "contact_designation" as NSCopying)
        completeData.setObject(providedByDesign, forKey: "contact_provided_by" as NSCopying)
        completeData.setObject(providedByName, forKey: "contact_provider_name" as NSCopying)
        if self.appDel.currentZoneTask != nil {
            if self.appDel.currentZoneTask!.zoneStatus == "started" {
                completeData.setObject(self.appDel.currentZoneTask!.task_id!, forKey: "zone_id" as NSCopying)
                
            } // end of the zone started
        } // end of the 
        
        if DriverNo != "" {
         
            completeData.setObject(DriverNo, forKey: "driver_license_number" as NSCopying)
        }
        if plateNo != "" {
            completeData.setObject(plateNo, forKey: "plate_number" as NSCopying)
        }
        
        if extraEmail != "" {
        completeData.setObject(extraEmail, forKey: "extraEmails" as NSCopying)
        }
        
        if additional_Notes != "" {
        completeData.setObject(additional_Notes, forKey: "externalNotes" as NSCopying)
        }
        if self.appDel.list_id != nil {
        completeData.setObject(self.appDel.list_id!, forKey: "list_id" as NSCopying)
        }
        
        if self.appDel.taskDao.list_id != nil {
            completeData.setObject(self.appDel.taskDao.list_id, forKey: "list_id" as NSCopying)
            
        }
        
        if makani != nil  {
            if makani != "" {
            completeData.setObject(makani!, forKey: "makani_no" as NSCopying)
            }
        }
        completeData.setObject(params, forKey: "servey_questions" as NSCopying)
        print(self.appDel.taskDao.auditor_Id)
        if self.appDel.taskDao.auditor_Id != nil && self.appDel.taskDao.auditor_Id != "0" && self.appDel.show_result == 0  {
            completeData.setObject(self.appDel.taskDao.auditor_Id!, forKey: "audit_id" as NSCopying)
        }
        else if self.appDel.show_result == 1 {
            completeData.setObject("yes", forKey: "is_audit" as NSCopying)
            
        }
        
        print("Final data \(completeData)")
        
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print(string!)
        
        
        var err: NSError?
        request.httpBody = data!
        let string1 = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)
        
        print(string1!)
        // request.se
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //    println(request.HTTPBody)
        
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
        connection.start()
        
    }

    
    func setupCreateSafariInspectionsPost(_ ide : String,urlstr : String , coInspectorsIds : String?){
    self.xmlData = NSMutableData()
    self.iden = ide
    self.urlStr = urlstr
    let urlstr1 =  urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //let urlstr1 = urlstr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.)
        
        
        print ("Download url \(urlstr1)")
        let ourl : URL =  URL(string: urlstr1 as! String)!
        
        
    let request = NSMutableURLRequest(url: ourl)
    request.timeoutInterval = 1000
    var session = URLSession.shared
    let completeData : NSMutableDictionary = NSMutableDictionary()
    let finalArray = NSMutableArray()
    finalArray.addObjects(from: self.appDel.selectedVehicles as [AnyObject])
    finalArray.addObjects(from: self.appDel.selectedDrivers as [AnyObject])
    completeData.setValue(finalArray, forKey: "externalNotes")
    completeData.setValue(self.appDel.user.user_id, forKey: "inspectorID")
        
        print(coInspectorsIds)
        if coInspectorsIds != "" {
         
            completeData.setValue(coInspectorsIds!, forKey: "coInspectorIDs")
        }
   // completeData.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
    completeData.setValue(self.appDel.searchedCompany!.company_id, forKey: "companyID")
    completeData.setValue( self.appDel.searchedCompany?.selectedCatg!, forKey: "categoryID")
        
        
    request.httpMethod = "POST"
    request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
    let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
    request.httpBody = data!
    let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
    print(string!)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
    connection.start()
        
        
    }// end of the ide
    
    
    func sendPostIncidentReportNotes(_ ide : String , url : URL ,  completeData : NSMutableDictionary){
        self.showAppleProgressHUD()
        self.xmlData = NSMutableData()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        self.iden = ide
        let request = NSMutableURLRequest(url: url)
        request.timeoutInterval = 1000
        
        var session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        request.httpBody = data!
        
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //    println(request.HTTPBody)
        
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
        connection.start()
        
        
        
        
        
    } //
    
    // MARK:- SEND CHAT POST MESSAGE
    func sendPostMessage(_ ide : String, url : URL , message : String) {
         self.xmlData = NSMutableData()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        
        self.iden = ide
        let request = NSMutableURLRequest(url: url)
        request.timeoutInterval = 1000
        request.httpMethod = "POST"
        request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        let completeData : NSMutableDictionary = NSMutableDictionary()
        completeData.setObject(self.appDel.user.user_id, forKey: "inspectorID" as NSCopying)
        completeData.setObject(self.appDel.chatUser!.user_id!, forKey: "userID" as NSCopying)
      
        completeData.setObject(self.appDel.chatUser!.type!, forKey: "type" as NSCopying)
        completeData.setObject(message, forKey: "message" as NSCopying)
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        request.httpBody = data!
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
        connection.start()

        
        
    }
    
    
    // MARK:- 
    
    func sendPostHistoryNotes(_ ide : String , url : URL , notes : String , inspector_id : String,task_id : String ){
        self.showAppleProgressHUD()
        
        self.xmlData = NSMutableData()
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        
        self.iden = ide
        let request = NSMutableURLRequest(url: url)
        request.timeoutInterval = 1000
        
        var session = URLSession.shared
        request.httpMethod = "POST"
        request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        let completeData : NSMutableDictionary = NSMutableDictionary()
        completeData.setObject(task_id, forKey: "task_id" as NSCopying)
        completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
        completeData.setObject(notes, forKey: "task_notes" as NSCopying)
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        request.httpBody = data!

        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //    println(request.HTTPBody)
        
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
        connection.start()
        

        
        
        //let loginUrl = Constants.baseURL + "updateTaskNotes?inspector_id=" + self.appDel.user.user_id + "&task_notes=" + data + "&task_id=" + history_taskId
        
        
    }  // end of the sendPostHistoryNotes

    
    
    func startSendingPost(_ params : NSMutableArray, url : URL , ide : String , duration : Int){
        self.showAppleProgressHUD()
        
          self.xmlData = NSMutableData()
         self.appDel = UIApplication.shared.delegate as! AppDelegate
        
            self.iden = ide
            let request = NSMutableURLRequest(url: url)
        request.timeoutInterval = 1000
        
            var session = URLSession.shared
            request.httpMethod = "POST"
             request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
        
            // request.HTTPMethod = "GET"
        let completeData : NSMutableDictionary = NSMutableDictionary()
        completeData.setObject(self.appDel.taskDao.task_id, forKey: "task_id" as NSCopying
        )
        completeData.setObject(self.appDel.user.user_id, forKey: "inspector_id" as NSCopying)
        completeData.setObject(duration, forKey: "task_duration" as NSCopying)
        
        completeData.setObject(params, forKey: "servey_questions" as NSCopying)
      //  print(self.appDel.taskDao.auditor_Id)
        if self.appDel.taskDao.auditor_Id != nil && self.appDel.taskDao.auditor_Id != "0" && self.appDel.show_result == 0  {
            completeData.setObject(self.appDel.taskDao.auditor_Id!, forKey: "audit_id" as NSCopying)
        }
        else if self.appDel.show_result == 1 {
            completeData.setObject("yes", forKey: "is_audit" as NSCopying)
            
        }
        
         //print("Final data \(completeData)")
        
        let data = try? JSONSerialization.data(withJSONObject: completeData, options: [])
        let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print(string!)

        
            var err: NSError?
            request.httpBody = data!
        let string1 = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)
        
         print(string1!)
           // request.se
           request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
        //    println(request.HTTPBody)
            
            let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
            connection.start()

            }
    
    
    
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print(error)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
       // print(error.code)
        if  Reachability.isConnectedNetwork() && self.iden == "alltasks"  && self.queue < 3{
            print("Trying for \(self.queue)")
            self.startDownloader(self.urlStr, idn: self.iden)
         self.queue += 1
        }
           PKHUD.sharedHUD.hide(animated: false)
        self.delegate?.dataDownloaded!(xmlData, identity: self.iden)
    }
    
  
    
    func connection(_ connection: NSURLConnection, didReceive conData: Data) {
        // Append the recieved chunk of data to our data object
        self.xmlData.append(conData)
        //print("Appending data")

    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
     //   self.xmlData.appendData(data)
      //  println("Appending data")
       // if self.iden != "image" && self.iden != "audio" {
        // var str : NSString? = NSString(data: self.xmlData, encoding: NSUTF8StringEncoding)
        //println("Server \(str)")
        //}
        //print("Hide in task downloaded")
        //print(self.iden)
         self.datadownloaded()
    }
    
    
    func datadownloaded(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if self.iden != "uploadlocation"  {
            PKHUD.sharedHUD.hide(animated: false)
        }
        if xmlData != nil{
            
            self.delegate?.dataDownloaded!(xmlData, identity: self.iden)
        }
        
    }
    
    func showAppleProgressHUD() {
        if self.appDel.showIndicator == 1 {
                  
           // PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                    PKHUD.sharedHUD.show()
        }
    
}
}
