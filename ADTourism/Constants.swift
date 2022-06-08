//
//  Constants.swift
//  ADTourism
//
//  Created by Administrator on 8/22/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class Constants: NSObject {
    static let mode = 3
    // 0 for PRODUCTION 1 for uat // 3 for QA
    class var baseURL: String{
        // return  "http://softsource-001-site1.smarterasp.net/api/"
         if mode == 0{
            // DON'T MESS PRODUCTION VERSION URL
           return  "https://ims.dtcm.gov.ae/DTCMServiceAPI/InspectionApi/"
            
        }  // end of development mode
        else if mode == 1 {
            
            // return  "http://dev.einspection.net/api/"http://172.16.80.33:9099/DTCMServiceAPI
            //UAT
            return  "https://imsuat.dtcmdomain.com/DTCMServiceAPI/InspectionApi/"
        } // end of the else
        else {
            // Development/QA
            return  "https://imsqa.dtcmdomain.com/DTCMServiceAPI/InspectionApi/"

        }
        }
    
    
    class var DTCMAPIKEY : String {
        if mode == 0 {  // Production API Key
        return "818nUH0167xzV9RlUKQ1IFbaXT945hd6"
            
        }
        else if mode == 1 { // UAT API KEY
            
        return "818nUH0167xzV9RlUKQ1IFbaXT945hd6"
        }
        else { // QA/DEV API KEY
            return "818nUH0167xzV9RlUKQ1IFbaXT945hd6"
       //return "1234AdxfM3b25X48VT9c4cfr21xx1234"
        //    return "818nUH0167xzV9RlUKQ1IFbaXT945hd6"
            

        }
    }
    class var saveServay : String{
      
        
        return baseURL + "saveSurveyTaskQuestions"
        
        
        
        
        
    }
    
    
    class var saveOfflinePassedInspections : String {
        return baseURL + "saveOfflinePassedInspections"
        
    }
    
    
    class var saveIndServay : String {
    return baseURL + "saveFreelanceDriverTaskQuestions"
        
    }
    
    class var saveOfflineCloseTasks : String {
        return baseURL + "setTaskClosedNotesForOffline"
        
    }
    class var kUploadMedia : String {


         return baseURL + "saveMedia"
        
    }
    
    class var DEFAULT_TASK_DURATION : String {
        return "1"
        
    }
    
    class var kMediaBaseUrl : String {

        
        return baseURL + "saveMedia"
    }
    class var locationUploadDuration : Int {
        return 10
    }
    class var saveOfflineMedia : String{

        
    
     return  baseURL + "saveOfflineMedia?media_id="
    }
    class var downloadUrl : String {
        if mode == 1 {
          return "https://imsuat.dtcmdomain.com/DTCMServiceAPI/uploads/"
         }
        else if mode == 0 {
            //DON'T MESS PRODUCTION VERSION URL
            return "https://ims.dtcm.gov.ae/DTCMServiceAPI/uploads/"
            }
        else {
               return "https://imsqa.dtcmdomain.com/DTCMServiceAPI/uploads/"
        } // end of the QA
    }
    
    class var versionNumber : String {
        return "1.9.8.91"
    
    } // 
    
    
    
    class var SafariDict :  NSDictionary{
        return  NSDictionary(dictionary:["catg_id" : "9" ,"listId" :"10","name":"الرحلات السياحية البرية"])
        
    }
    
    class var CampDict :  NSDictionary{
        return  NSDictionary(dictionary:["catg_id" : "10" ,"listId" :"11","name":"المخيمات السياحية و تصريح الفعاليات"])
        
    }
    class var no_Task_Found : String {
        return "1001"
        
    }
    
    class var not_Owner_Of_Task : String {
        return "1003"
        
    }
    
    class var task_Is_Closed : String {
        return "1006"
        
    }
    
    class var task_Is_Already_Submitted : String {
        return "1005"
        
    }
    
    
}
