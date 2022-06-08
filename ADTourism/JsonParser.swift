//
//  JsonParser.swift
//  ADTourism
//
//  Created by Administrator on 8/22/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class JsonParser: NSObject {
   // let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var show_results : Int = 0
    var user_id : String?
    
    func parseLoginData(_ rawData : NSMutableData) -> UserDao
    {
    
    var error : NSError?
    let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let userDao : UserDao = UserDao()
    
    if let dict = json as? NSDictionary{
        //println("Register json \(dict)")
        
        userDao.response = dict.object(forKey: "response") as? String
        
        if userDao.response == nil {
            userDao.response = "error"
            return userDao
        }

        
        if userDao.response == "error"{
                       return userDao
        }
        
        let dataDict : NSDictionary = dict.object(forKey: "data") as! NSDictionary
        print(dataDict)
        userDao.user_id = dataDict.object(forKey: "id") as? String
        print(userDao.user_id)
        userDao.firstname = dataDict.object(forKey: "full_name") as? String
        print(userDao.firstname)
        userDao.role_id = dataDict.object(forKey: "role_id") as? String
        userDao.contactno = dataDict.object(forKey: "contact_no") as? String
        userDao.lastname = dataDict.object(forKey: "last_name") as? String
        userDao.username = dataDict.object(forKey: "username") as? String
        userDao.status = dataDict.object(forKey: "status") as? String
        userDao.categories = dataDict.object(forKey: "assigned_categories") as? String
        userDao.employee_id = dataDict.object(forKey: "employee_id") as? String
        userDao.hosMobileNo = dataDict.object(forKey: "hos_contact_no") as? String
        userDao.hosName = dataDict.object(forKey: "hos_name") as? String
        userDao.job_title = dataDict.object(forKey: "job") as? String
        userDao.email = dataDict.object(forKey: "email") as? String
        userDao.shift = dataDict.object(forKey: "shift") as? String
        userDao.inactive_start = dataDict.object(forKey: "inactive_sdate") as? String
        userDao.inactive_end = dataDict.object(forKey: "inactive_edate") as? String
        userDao.inactive_notes = dataDict.object(forKey: "inactive_note") as? String
        userDao.task_radius = dataDict.object(forKey: "task_radius") as? String
        
        if let configDict = dataDict.object(forKey: "checklist_configuration") as? NSDictionary{
        userDao.configDao = ConfigurationDao()
            
         userDao.configDao?.checkList_id = configDict.object(forKey: "id") as? String
         userDao.configDao?.category_id = configDict.object(forKey: "category_id") as? String
         userDao.configDao?.config_id = configDict.object(forKey: "config_id") as? String
         userDao.configDao?.automatic_location_flag = configDict.object(forKey: "automatic_location_flag") as? String
         userDao.configDao?.contact_detail_flag = configDict.object(forKey: "contact_detail_flag") as? String
            
            
            
            
            
        }
        
        /*
         "id": "9",
         "category_id": "8",
         "config_id": "1",
         "automatic_location_flag": "1",
         "contact_detail_flag": "1"
 
 
 */
        
    }
        return userDao
        
    }
    
    func parseEditInspectorsResponse(_ rawData : NSMutableData) -> EditInspectorResponseDao{
        let edit = EditInspectorResponseDao()
        let str = String(data: rawData as Data, encoding: .utf8)
         print(str)
      let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        
        if let dict = json as? NSDictionary {
            if let response = dict.object(forKey: "response") as? String {
                if response == "success" {
                    
                   edit.resposeType = "success"
                edit.respose = dict.object(forKey: "alreadySubmittedTasksInspectorIDs") as? String
                }
                else {
                    edit.resposeType = "error"
                    edit.error_code = dict.object(forKey: "error_code") as? String
                }
                
            }
            
        }
        return edit
        
    }
    
    func parseSubvenues(_ rawData : NSMutableData) ->NSMutableArray{
        let subvenuesArray = NSMutableArray()
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let dict = json as? NSDictionary {
            if let rawArray = dict.object(forKey: "data") as? NSArray {
                for c in 0  ..< rawArray.count  {
                     if let c1 = rawArray.object(at: c) as? NSDictionary {
                let sub = SubVenueDao()
                sub.subVenue_id = c1.object(forKey: "id") as? String
                sub.subVenue = c1.object(forKey: "subVenue") as? String
                sub.licenseNumber = c1.object(forKey: "licenseNumber") as? String
                sub.latitude = c1.object(forKey: "latitude") as? String
                sub.longitude = c1.object(forKey: "longitude") as? String
                subvenuesArray.add(sub)
                        
                        
                    } // end of the
                    } // end of the for loop
            }
        }// end of the dict
        
        return subvenuesArray
    }
    
    
    func parseZone(_ rawData : NSMutableData) -> NSMutableArray {
        let permitArray = NSMutableArray()
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let dict = json as? NSDictionary {
            if let rawArray = dict.object(forKey: "data") as? NSArray {
                for c in 0  ..< rawArray.count  {
                    if let c1 = rawArray.object(at: c) as? NSDictionary {
                    let zone = ZoneDao()
                    zone.zone_id = c1.object(forKey: "id") as? String
                    zone.zone_assignment_id = c1.object(forKey: "id") as? String
                    zone.zone_name = c1.object(forKey: "zone_name") as? String
                    zone.zone_name_ar = c1.object(forKey: "zone_name_arabic") as? String
                        
                    zone.startDate = c1.object(forKey: "start_date") as? String
                    zone.expiryDate = c1.object(forKey: "start_date") as? String
                    zone.zone_status =  c1.object(forKey: "zone_status") as? String
                        
                    permitArray.add(zone)
                        
                    
                    
                    } // end of the rawDictionary
                    
                
                
                }
                
            } // end of the dataDict
            
        } // end of the dictionary
        
        
        return permitArray
        
        
    }// end of the parseZone
    
    
    
    
    func parsePermits(_ rawData : NSMutableData) -> NSMutableArray{
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let permitArray = NSMutableArray()
        if let dict = json as? NSDictionary {
            
            if let rawArray = dict.object(forKey: "data") as? NSArray {
                for c in 0  ..< rawArray.count  {
                    if let c1 = rawArray.object(at: c) as? NSDictionary {
                    
                    
                   let permit = PermitDao()
                    permit.permitID = c1.object(forKey: "PermitNumber") as? String
                    permit.permit_type = c1.object(forKey: "PermitCategory") as? String
                    permit.url = c1.object(forKey: "permit_url") as? String
                    permit.issue_date = c1.object(forKey: "StartDate") as? String
                    permit.expire_date = c1.object(forKey: "EndDate") as? String
                    permit.company_name = c1.object(forKey: "BusinessName") as? String
                    permit.company_name_arabic = c1.object(forKey: "BusinessName") as? String
                    permit.license_info = c1.object(forKey: "BusinessLicense") as? String
                    permit.alternativeNumber = c1.object(forKey: "alternativeNumber") as? String
                    permit.ReportID = c1.object(forKey: "ReportID") as? String
                    permit.sub_venue = c1.object(forKey: "SubVenue") as? String
                        
                    permitArray.add(permit)
                        
                    } // end
                    } // end of the for loop
                
            } // end of the arry
        
        }// end if the outer if
        
    return permitArray
    }
    
    
    func perseAllPermits(_ rawData : NSMutableData) ->  NSMutableArray{
    
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let permitArray = NSMutableArray()
        if let dict = json as? NSDictionary {
            
            if let rawArray = dict.object(forKey: "data") as? NSArray {
                for c in 0  ..< rawArray.count  {
                    if let c1 = rawArray.object(at: c) as? NSDictionary {
                        
                        
                        let permit = MainPermitDao()
                        permit.permitID = c1.object(forKey: "PermitNumber") as? String
                        permit.businessLicense = c1.object(forKey: "BusinessLicense") as? String
                        permit.organizerName = c1.object(forKey: "OrganizerName") as? String
                        permit.issuedDate = c1.object(forKey: "IssuedDate") as? String
                        permit.expiryDate = c1.object(forKey: "ExpiryDate") as? String
                        permit.startDate = c1.object(forKey: "StartDate") as? String
                        permit.endDate = c1.object(forKey: "EndDate") as? String
                       permit.subVenue = c1.object(forKey: "Location") as? String
                        permit.campArea = c1.object(forKey: "CampArea") as? String
                        permit.permitType = c1.object(forKey: "PermitType") as? String
                        
                        
                        
                        permit.coordinatorName = c1.object(forKey: "CoordinatorName") as? String
                        permit.contactNumber = c1.object(forKey: "ContactNumber") as? String
                        permit.appComment = c1.object(forKey: "AppComment") as? String
                        if let rawDriver = c1.object(forKey: "permit_driver_info") as? NSArray {
                            for d in 0 ..< rawDriver.count {
                                if let d1 = rawDriver.object(at: d) as? NSDictionary {
                                   let driver = DriversDao()
                                    driver.permitID = permit.permitID
                                    driver.driver_name = d1.object(forKey: "Driver") as? String
                                    driver.nationality = d1.object(forKey: "Nationality") as? String
                                    driver.drLicNo = d1.object(forKey: "DrLicNo") as? String
                                    driver.drLicIssue = d1.object(forKey: "DrLicIssue") as? String
                                    driver.drLicExpiry = d1.object(forKey: "DrLicExpiry") as? String
                                    driver.drComment = d1.object(forKey: "DrComment") as? String
                                    driver.isFirstAid = d1.object(forKey: "IsFirstAid") as? String
                                    permit.drivers.add(driver)
                                    
                                    
                                } // end of the if
                                
                            } // drivers loop
                        } // end of the drivers array
                        
                        if let rawVehicle = c1.object(forKey: "permit_vehicle_info") as? NSArray {
                            for v in 0 ..< rawVehicle.count {
                                if let v1 = rawVehicle.object(at: v) as? NSDictionary {
                                   let vehicle = VehicleDao()
                                    vehicle.tradeMarkname = v1.object(forKey: "TradeMarkname") as? String
                                    vehicle.ownerName = v1.object(forKey: "OwnerName") as? String
                                    vehicle.plateNo = v1.object(forKey: "PlateNo") as? String
                                    vehicle.licIssue = v1.object(forKey: "LicIssue") as? String
                                    vehicle.licExpiry = v1.object(forKey: "LicExpiry") as? String
                                    vehicle.busLicExpiryDate = v1.object(forKey: "BusLicExpiryDate") as? String
                                    vehicle.vehComment = v1.object(forKey: "VehComment") as? String
                                    vehicle.modelYear = v1.object(forKey: "ModelYear") as? String
                                    vehicle.placeofIssue = v1.object(forKey: "PlaceofIssue") as? String
                                    vehicle.vehicleType = v1.object(forKey: "VehicleType") as? String
                                    vehicle.permitExpiry = v1.object(forKey: "PermitExpiry") as? String
                                    vehicle.permitID = permit.permitID
                                    
                                    permit.vehicles.add(vehicle)
                                    
                                    
                                    
                                    
                                }// end of the if
                                
                            } // end if the raw Vehicle loop
                        }// end of the rawVehicle if
                        
                        //print("Parser : Permit \(permit.permitID) has \(permit.vehicles.count) vehicles")
                        permitArray.add(permit)
                        
                    } // end
                } // end of the for loop
                
            } // end of the arry
            
        }// end if the outer if
     return permitArray
    }
    
    
    
    func parseDetailPermits(_ rawData : NSMutableData) -> NSMutableArray{
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let permitArray = NSMutableArray()
        if let dict = json as? NSDictionary {
            
            if let rawArray = dict.object(forKey: "data") as? NSArray {
                for c in 0  ..< rawArray.count  {
                    if let c1 = rawArray.object(at: c) as? NSDictionary {
                        
                        
                        let permit = PermitDao()
                        permit.permitID = c1.object(forKey: "permitID") as? String
                        permit.permit_type = c1.object(forKey: "permit_type") as? String
                        permit.url = c1.object(forKey: "permit_url") as? String
                        permit.issue_date = c1.object(forKey: "issue_date") as? String
                        permit.expire_date = c1.object(forKey: "expire_date") as? String
                       // permit.company_name = c1.objectForKey("BusinessName") as? String
                       // permit.company_name_arabic = c1.objectForKey("BusinessName") as? String
                        //permit.license_info = c1.objectForKey("BusinessLicense") as? String
                        permit.alternativeNumber = c1.object(forKey: "alternativeNumber") as? String
                        permit.ReportID = c1.object(forKey: "reportID") as? String
                        permit.sub_venue = c1.object(forKey: "subVenue") as? String
                        
                        permitArray.add(permit)
                        
                    } // end
                } // end of the for loop
                
            } // end of the arry
            
        }// end if the outer if
        
        return permitArray
    }

    
    func parseProfileData(_ rawData : NSMutableData) -> UserDao
    {
        
        var error : NSError?
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let userDao : UserDao = UserDao()
        
        if let dict = json as? NSDictionary{
            //println("Register json \(dict)")
            
            userDao.response = dict.object(forKey: "response") as? String
            if userDao.response == "error"{
                return userDao
            }
            if userDao.response == nil {
                userDao.response = "error"
                return userDao
            }
            
           
            
            let dataDict : NSDictionary = dict.object(forKey: "data") as! NSDictionary
            //print(dataDict)
            userDao.user_id = dataDict.object(forKey: "id") as? String
            if userDao.user_id == nil && userDao.response == "success" {
                userDao.response = "logout"
                return userDao
            }

            
            
            if userDao.user_id == nil {
                userDao.response = "error"
                return userDao

            }
            
            
           // print(userDao.user_id)
            userDao.firstname = dataDict.object(forKey: "full_name") as? String
            print(userDao.firstname)
            userDao.role_id = dataDict.object(forKey: "role_id") as? String
            userDao.contactno = dataDict.object(forKey: "contact_no") as? String
            userDao.lastname = dataDict.object(forKey: "last_name") as? String
            userDao.username = dataDict.object(forKey: "username") as? String
            userDao.status = dataDict.object(forKey: "status") as? String
            userDao.categories = dataDict.object(forKey: "assigned_categories") as? String
            userDao.employee_id = dataDict.object(forKey: "employee_id") as? String
            userDao.hosMobileNo = dataDict.object(forKey: "hos_contact_no") as? String
            userDao.hosName = dataDict.object(forKey: "hos_name") as? String
            userDao.job_title = dataDict.object(forKey: "job") as? String
            userDao.email = dataDict.object(forKey: "email") as? String
            userDao.shift = dataDict.object(forKey: "shift") as? String
            userDao.inactive_start = dataDict.object(forKey: "inactive_sdate") as? String
            userDao.inactive_end = dataDict.object(forKey: "inactive_edate") as? String
            userDao.inactive_notes = dataDict.object(forKey: "inactive_note") as? String
            userDao.task_radius = dataDict.object(forKey: "task_radius") as? String
            
 
            if let configArray = dataDict.object(forKey: "checklist_configuration") as? NSArray{
                
                
                
               
                for c in 0  ..< configArray.count  {
                    if let configDict = configArray.object(at: c) as? NSMutableDictionary {
                    let configDao = ConfigurationDao()
                        
                    configDao.checkList_id = configDict.object(forKey: "id") as? String
                    configDao.category_id = configDict.object(forKey: "category_id") as? String
                    configDao.config_id = configDict.object(forKey: "config_id") as? String
                    configDao.automatic_location_flag = configDict.object(forKey: "automatic_location_flag") as? String
                    configDao.contact_detail_flag = configDict.object(forKey: "contact_detail_flag") as? String
                    configDao.contact_edit_flag = configDict.object(forKey: "contact_edit_flag") as? String
                    
                        configDao.location_check = configDict.object(forKey: "task_starting_loc_flag") as? String
                     // print("task_starting_loc_flag \(configDao.location_check)")
                        
                    userDao.configArray.add(configDao)
                        
                } // end of the configDao
                
                
                
                
                
                
            } // end of the loop

            
        } // end of config condition
        }
            return userDao
        
    }

    
    func parseQuestionsCategories(_ rawData : NSMutableData) -> NSMutableArray {
        var error : NSError?
        let allCategories : NSMutableArray = NSMutableArray()
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let dict = json as? NSDictionary{
            
        
        if dict.object(forKey: "questions_categories") != nil {
            
            let categoryArray : NSArray = dict.object(forKey: "questions_categories") as! NSArray
            for i in categoryArray as! [NSDictionary] {
                let catgDao = QuestionCategoryDao()
                catgDao.catg_id = i.object(forKey: "id") as? String
                catgDao.catg_name = i.object(forKey: "name") as? String
                catgDao.catg_name_ar = i.object(forKey: "name_arabic") as? String
                allCategories.add(catgDao)
                
                
                
            }
            
            
            
        }
        }
        return allCategories
        
    }
    
    func parseQuestions(_ rawData : NSMutableData) -> (NSMutableArray , NSMutableArray){
        var error : NSError?
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allQuestions : NSMutableArray = NSMutableArray()
        let allCategories : NSMutableArray = NSMutableArray()
        if let dict = json as? NSDictionary{
            if dict.object(forKey: "data") == nil {
                print("parseQuestions data is nil")
            return (allQuestions , allCategories)
            }
             let dataArray : NSArray = dict.object(forKey: "data") as! NSArray
            
            if dict.object(forKey: "categories") != nil {
                
                let categoryArray : NSArray = dict.object(forKey: "categories") as! NSArray
                for i in categoryArray as! [NSDictionary] {
                    let catgDao = QuestionCategoryDao()
                    catgDao.catg_id = i.object(forKey: "id") as? String
                    catgDao.catg_name = i.object(forKey: "name") as? String
                    catgDao.catg_name_ar = i.object(forKey: "name_arabic") as? String
                    allCategories.add(catgDao)
                    
                    
                    
                }
                
                
                
            }
            
            
            if self.show_results == 1 {
            return (self.fetchQuestion(dataArray),allCategories)
            
            }
            
            
            
           
            //for (var i = 0 ; i < dataArray.count ; i += 1) {
                for  i in 0 ..< dataArray.count  {
                    
                let questionDic : NSDictionary = dataArray.object(at: i) as! NSDictionary
                
                let question : QuestionDao = QuestionDao()
                question.question_id = questionDic.object(forKey: "id") as? String
                question.list_id = questionDic.object(forKey: "list_id") as? String
                question.question_desc = questionDic.object(forKey: "question_desc") as? String
                question.question_desc_en = questionDic.object(forKey: "question_desc_en") as? String
                    
                question.violation_code = questionDic.object(forKey: "violation_code") as? String
                question.catg_id = questionDic.object(forKey: "category_id") as? String
                question.entry_datetime = questionDic.object(forKey: "entry_datetime") as? String
                let allOption : NSMutableArray = NSMutableArray()
                
                
                let optionsArray : NSArray = questionDic.object(forKey: "options") as! NSArray
                //for (var i1 = 0 ; i1 < optionsArray.count ; i1 += 1) {
                    for i1 in 0 ..< optionsArray.count  {
                        
                    let optionDict : NSDictionary = optionsArray.object(at: i1) as! NSDictionary
                    let option : OptionDao = OptionDao()
                    option.option_id = optionDict.object(forKey: "id") as? String
                    // print("Option Id \(option.option_id)")
                    option.question_id =  question.question_id
                    option.option_label = optionDict.object(forKey: "option_label") as? String
                    option.option_type = optionDict.object(forKey: "option_type") as? String  // RADIO
                    option.option_description = optionDict.object(forKey: "description") as? String
                    option.is_required = optionDict.object(forKey: "is_required") as? String
                    option.violation_code = optionDict.object(forKey: "valication_code") as? String
                    if optionDict.object(forKey: "extra_options") == nil{
                        allOption.add(option)

                        continue
                    }
                    let extraOption : NSArray = optionDict.object(forKey: "extra_options") as! NSArray
                   // println("Extra Option \(extraOption.count)")
                    let allExtraOption : NSMutableArray = NSMutableArray()
                    
                    for  i2 in 0  ..< extraOption.count  {
                        let extraOptionDic : NSDictionary = extraOption.object(at: i2) as! NSDictionary
                        let eOption : ExtraOption = ExtraOption()
                        eOption.extra_optionId =  extraOptionDic.object(forKey: "id") as? String
                        eOption.option_id = extraOptionDic.object(forKey: "option_id") as? String
                         //print("Extra Option Id \(eOption.extra_optionId)")
                        eOption.label = extraOptionDic.object(forKey: "label") as? String
                        eOption.value = extraOptionDic.object(forKey: "value") as? String
                        eOption.is_media = extraOptionDic.object(forKey: "is_media") as? String
                        eOption.is_selected = extraOptionDic.object(forKey: "is_selected") as? NSNumber
                        //print("QQQQQQQQQ  selected\(eOption.is_selected) \(question.question_id)")
                        question.is_selected = eOption.is_selected
                        if question.is_selected == nil {
                        question.is_selected = 0
                         
                        }
                        
                        
                        //print("In Parser  selected\(eOption.is_selected) \(question.is_selected)")
                        
                        eOption.violation_id = extraOptionDic.object(forKey: "violation_id") as? String
                        if let vv = extraOptionDic.object(forKey: "violation_id") as? String {
                          //  println("vvv\(vv)")
                            eOption.violation_id = vv
                            
                            
                        }

                        
                        eOption.entry_datetime = extraOptionDic.object(forKey: "entry_datetime") as? String
                        eOption.valication_code = extraOptionDic.object(forKey: "violation_code") as? String
                        allExtraOption.add(eOption)
                        
                    }
                    option.allExraOptions = allExtraOption
                    allOption.add(option)
                    
                }
               
                question.allOptions = allOption
                 allQuestions.add(question)
                
            }
        
        }
        
        return (allQuestions,allCategories)
        
    }
    
    func parseMainDashbaord(_ rawData : NSMutableData) -> MainDashbaordDao
    {
    let mainDao = MainDashbaordDao()
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let dict = json as? NSDictionary{
            if let taskDict = dict.object(forKey: "tasks") as? NSDictionary {
             let tasks = DashbaordTask()
             tasks.notstarted = taskDict.object(forKey: "notstarted") as? String
             tasks.closed = taskDict.object(forKey: "closed") as? String
             tasks.completed = taskDict.object(forKey: "completed") as? String
             tasks.active = taskDict.object(forKey: "active") as? String
             mainDao.dashbaordTask = tasks
                
                
            }
            if let categories = dict.object(forKey: "categories") as? NSMutableArray{
                let catgArray  = NSMutableArray()
                for a in 0 ..< categories.count {
                
                    if let categoryDict = categories.object(at: a) as? NSDictionary {
                     let category = DashbaordCategories()
                      category.task_count = categoryDict.object(forKey: "task_count") as? String
                      category.type_name = categoryDict.object(forKey: "type_name") as? String
                      catgArray.add(category)
                    }
                    
                    
                    
                }// end of the for loop
            mainDao.categories = catgArray
                
                
            }
            if let hoursDict = dict.object(forKey: "hours") as? NSDictionary {
              let hour = DashbaordHours ()
              hour.active = hoursDict.object(forKey: "active") as? String
              hour.inactive = hoursDict.object(forKey: "inactive") as? String
             mainDao.dashbaordHours = hour
                
            } // end of the 
            
            if let avg_timeDict = dict.object(forKey: "avg_time") as? NSDictionary {
            let avgTime = DashbaordAverageTime()
                avgTime.avg_on_way_duration = avg_timeDict.object(forKey: "avg_on_way_duration") as? String
                avgTime.avg_task_duration = avg_timeDict.object(forKey: "avg_task_duration") as? String
                mainDao.avg_time = avgTime
                
                
                
                
            }
            
            
            
            
            if let avg_active_inactive_array = dict.object(forKey: "avg_daily_active_inactive") as? NSMutableArray {
                for c in 0 ..< avg_active_inactive_array.count {
                    if let avg_active_inactive_dict = avg_active_inactive_array.object(at: c) as? NSDictionary {
             let active_inactive = DashbaordAverageActiveInActive()
             active_inactive.active = avg_active_inactive_dict.object(forKey: "active") as? String
             active_inactive.inactive = avg_active_inactive_dict.object(forKey: "inactive") as? String
             active_inactive.date = avg_active_inactive_dict.object(forKey: "date") as? String
             mainDao.avg_active_inactiveTime = active_inactive
             mainDao.avg_daily_active_inactiveArray.add(active_inactive)
                        
                        
                    }
                    }
            }
            
            if let avg = dict.object(forKey: "avg_active_inactive") as? NSDictionary {
            let avgDashbaord = DashbaordAverageActiveInActive()
                avgDashbaord.active = avg.object(forKey: "active") as? String
                avgDashbaord.inactive = avg.object(forKey: "inactive") as? String
                
            mainDao.total_average_activeInActvie = avgDashbaord
                
                
            }
            
            if let task_report = dict.object(forKey: "task_report") as? NSMutableArray {
                let task_array = NSMutableArray()
                for b in 0 ..< task_report.count {
                if let singleTaskReport = task_report.object(at: b) as? NSDictionary {
              let task = DashbaordTask_Report()
              task.company_name = singleTaskReport.object(forKey: "company_name") as? String
              task.company_name_arabic = singleTaskReport.object(forKey: "company_name_arabic") as? String
              task.started_time = singleTaskReport.object(forKey: "started_time") as? String
              task.completed_date = singleTaskReport.object(forKey: "completed_date") as? String
              task.taskDuration = singleTaskReport.object(forKey: "taskDuration") as? String
              task.onWayDuration = singleTaskReport.object(forKey: "onWayDuration") as? String
              task_array.add(task)
                        
                                      
                    } // end of the if 
                } // end of the for loop
                mainDao.task_report_array = task_array
                
                
            } // end of the array condition
            
            
            
            
            
        }// end of the dixt
        
    
        return mainDao
    }
    
    
    
    func parseQuestionsForOffline(_ rawData : NSMutableData) -> NSMutableArray{
        
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allQuestions : NSMutableArray = NSMutableArray()
      //  let str = NSString(data: rawData, encoding: NSUTF8StringEncoding)
      // print(str)
        
        if let dict = json as? NSDictionary{
            if dict.object(forKey: "questionCheckList") == nil {
                return allQuestions
            }
            let dataArray : NSArray = dict.object(forKey: "questionCheckList") as! NSArray
            print("count is \(dataArray.count)")
            for   i in 0 ..< dataArray.count  {
                
            
           // for (var i = 0 ; i < dataArray.count ; i += 1) {
                let questionArray  = dataArray.object(at: i) as! NSArray
               // for (var a = 0 ; a < questionArray.count ; a += 1) {
                    for  a in 0 ..< questionArray.count  {
                        
                if let questionDic = questionArray.object(at: a) as? NSDictionary{
                
                let question : QuestionDao = QuestionDao()
                question.question_id = questionDic.object(forKey: "id") as? String
                question.list_id = questionDic.object(forKey: "list_id") as? String
                question.violation_code = questionDic.object(forKey: "violation_code") as? String
                 //print("Offline Violation Code \(question.violation_code)")
                 //   print("List id \(question.list_id)")
                question.question_desc = questionDic.object(forKey: "question_desc") as? String
                question.catg_id = questionDic.object(forKey: "category_id") as? String
                    
                question.entry_datetime = questionDic.object(forKey: "entry_datetime") as? String
                let allOption : NSMutableArray = NSMutableArray()
                
                
                let optionsArray : NSArray = questionDic.object(forKey: "options") as! NSArray
                //for (var i1 = 0 ; i1 < optionsArray.count ; i1++) {
                    for  i1 in 0 ..< optionsArray.count  {
                        
                    let optionDict : NSDictionary = optionsArray.object(at: i1) as! NSDictionary
                    let option : OptionDao = OptionDao()
                    option.option_id = optionDict.object(forKey: "id") as? String
                    // print("Option Id \(option.option_id)")
                    option.question_id =  question.question_id
                    option.option_label = optionDict.object(forKey: "option_label") as? String
                    option.option_type = optionDict.object(forKey: "option_type") as? String  // RADIO
                    option.option_description = optionDict.object(forKey: "description") as? String
                    option.is_required = optionDict.object(forKey: "is_required") as? String
                    option.violation_code = optionDict.object(forKey: "violation_code") as? String
                    
                    if optionDict.object(forKey: "extra_options") == nil{
                        allOption.add(option)
                        
                        continue
                    }
                    let extraOption : NSArray = optionDict.object(forKey: "extra_options") as! NSArray
                    // println("Extra Option \(extraOption.count)")
                    let allExtraOption : NSMutableArray = NSMutableArray()
                    
                   // for  var i2 = 0 ; i2 < extraOption.count ; i2 += 1 {
                        for   i2 in 0 ..< extraOption.count  {
                            
                        let extraOptionDic : NSDictionary = extraOption.object(at: i2) as! NSDictionary
                        let eOption : ExtraOption = ExtraOption()
                        eOption.extra_optionId =  extraOptionDic.object(forKey: "id") as? String
                        eOption.option_id = extraOptionDic.object(forKey: "option_id") as? String
                        //print("Extra Option Id \(eOption.extra_optionId)")
                        eOption.is_media = extraOptionDic.object(forKey: "is_media") as? String
                        eOption.label = extraOptionDic.object(forKey: "label") as? String
                        eOption.value = extraOptionDic.object(forKey: "value") as? String
                        
                        let selected = extraOptionDic.object(forKey: "is_selected") as? String
                        //print("Option selected  \(selected)")
                        if selected != nil {
                            eOption.is_selected = NSNumber(value: Int(selected!)! as Int)
                            // print("Option selected  \(eOption.is_selected)")
                        }
                        eOption.violation_id = extraOptionDic.object(forKey: "violation_id") as? String
                        if let vv = extraOptionDic.object(forKey: "violation_id") as? String {
                            //  println("vvv\(vv)")
                            eOption.violation_id = vv
                            
                            
                        }
                        
                        
                        eOption.entry_datetime = extraOptionDic.object(forKey: "entry_datetime") as? String
                        eOption.valication_code = extraOptionDic.object(forKey: "valication_code") as? String
                        allExtraOption.add(eOption)
                        
                    }
                    option.allExraOptions = allExtraOption
                    allOption.add(option)
                    
                }
                
                question.allOptions = allOption
                   // print("adding question with \(i)")
                allQuestions.add(question)
                }
                }
            }
            
        }
        
        return allQuestions
        
    }

    
    
    
    
    func parseMedia(_ rawData : Data) -> String{
        var error : NSError?
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let dict : NSDictionary = json as? NSDictionary {
            if dict.object(forKey: "response") as? String == nil {
            return "error"
            }
            
        let resposne = dict.object(forKey: "response") as! String
            if resposne == "success" {
            return (dict.object(forKey: "media_id") as! NSNumber).stringValue
                
                
            }
            return "error"
        }
        
        return "error"
    }
    
    func parseZones(_ rawData : NSMutableData)-> NSMutableArray {
    
    var allZones = NSMutableArray()
    let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
    if let dict = json as? NSDictionary {
    
        if let rawArray = dict.object(forKey: "data") as? NSArray {
            for c in 0  ..< rawArray.count  {
                if let c1 = rawArray.object(at: c) as? NSDictionary {
                    let zone = ZoneDao()
                    zone.zone_id = c1.object(forKey: "id") as? String
                   // print("Zone Id in parser \(zone.zone_id)")
                   // zone.zone_assignment_id = c1.objectForKey("id") as? String
                    zone.zone_name = c1.object(forKey: "zone_name") as? String
                    zone.zone_name_ar = c1.object(forKey: "zone_name_arabic") as? String
                    allZones.add(zone)
                    
                }
        } // end of the dict
        }
        }
        
    return allZones
        
    }
    
    func parseCompanies(_ rawData : NSMutableData) ->  NSMutableArray {
        
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allCompanies : NSMutableArray = NSMutableArray()
        if let dict : NSDictionary = json as? NSDictionary {
            if let companyArray = dict.object(forKey: "companies") as? NSMutableArray {
                for a in 0  ..< companyArray.count  {
                    if let company = companyArray.object(at: a) as? NSDictionary {
                         let companyDao = CompanyDao()
                        companyDao.company_id = company.object(forKey: "id") as? String
                        companyDao.company_name =  company.object(forKey: "company_name") as? String
                        companyDao.activity_code = company.object(forKey: "activity_code") as? String
                        companyDao.company_name_arabic = company.object(forKey: "company_name_arabic") as? String
                        companyDao.license_info = company.object(forKey: "license_info") as? String
                        companyDao.license_issue_date = company.object(forKey: "license_issue_date") as? String
                        companyDao.license_expire_date = company.object(forKey: "license_expire_date") as? String
                        companyDao.landline = company.object(forKey: "landline") as? String
                        companyDao.phone_no = company.object(forKey: "phone_no") as? String
                        companyDao.email = company.object(forKey: "email_address") as? String
                        companyDao.pro_name = company.object(forKey: "pro_name") as? String
                        companyDao.email_pro = company.object(forKey: "pro_email") as? String
                        
                       // print(company.objectForKey("pro_contact_no"))
                        
                        companyDao.pro_mobile = company.object(forKey: "pro_contact_no") as? String
                        companyDao.lat = company.object(forKey: "latitude") as? String
                        companyDao.lon = company.object(forKey: "longitude") as? String
                        companyDao.category_name = company.object(forKey: "category_name") as? String
                        companyDao.category_name_ar = company.object(forKey: "category_name_arb") as? String
                        companyDao.alternativeNumber = company.object(forKey: "alternativeNumber") as? String
                        companyDao.activityType = company.object(forKey: "activityType") as? String
                        companyDao.activityType_ar = company.object(forKey: "activityType_Arb") as? String
                        companyDao.created_date = company.object(forKey: "created_date") as? String
                        companyDao.address_note = company.object(forKey: "address_note") as? String
                        companyDao.company_note = company.object(forKey: "company_note") as? String
                        companyDao.type_name = company.object(forKey: "type_name") as? String
                        if let makaniArray = company.object(forKey: "makani") as? NSArray {
                            for a in 0 ..< makaniArray.count  {
                                if let singleMakani = makaniArray.object(at: a) as? NSDictionary {
                                    let makaniDao = MakaniDao()
                                    makaniDao.companyId = singleMakani.object(forKey: "companyID") as? String
                                    makaniDao.makani = singleMakani.object(forKey: "makani_no") as? String
                                    companyDao.makani.add(makaniDao)
                                    
                                    
                                }
                                
                            }
                        }

                        
                        /*
                        tasks.company.company_id = companyDict.objectForKey("id") as? String
                        tasks.company.company_name = companyDict.objectForKey("company_name") as? String
                        //println("Company name \(tasks.company.company_name)")
                        tasks.company.license_info = companyDict.objectForKey("license_info") as? String
                        tasks.company.cg_id = companyDict.objectForKey("cg_id") as? String
                        tasks.company.earned_rating = companyDict.objectForKey("earned_rating") as? String
                        tasks.company.area_name = companyDict.objectForKey("area_name") as? String
                        tasks.company.type_name = companyDict.objectForKey("type_name") as? String
                        tasks.company.group_name = companyDict.objectForKey("group_name") as? String
                        tasks.company.star =  companyDict.objectForKey("classification") as? String
                        print("Company Star \(tasks.company.star )")
                        
                        tasks.company.landline = companyDict.objectForKey("landline") as? String
                        tasks.company.email = companyDict.objectForKey("email_address") as? String
                        
                        tasks.company.phone_no = companyDict.objectForKey("phone_no") as? String
                        tasks.company.lat = companyDict.objectForKey("latitude") as? String
                        tasks.company.address = companyDict.objectForKey("address") as? String
                        
                        tasks.company.lon = companyDict.objectForKey("longitude") as? String
                        tasks.company.license_issue_date = companyDict.objectForKey("license_issue_date") as? String
                        tasks.company.contact_designation = companyDict.objectForKey("contact_designation") as? String
                        tasks.company.contact_provider_name = companyDict.objectForKey("contact_provider_name") as? String
                        tasks.company.contact_provided_by = companyDict.objectForKey("contact_provided_by") as? String
                        
                        
                        tasks.company.license_expire_date = companyDict.objectForKey("license_expire_date") as? String
                        tasks.company.company_name_arabic = companyDict.objectForKey("company_name_arabic") as? String
                        tasks.company.pro_name = companyDict.objectForKey("pro_name") as? String
                        tasks.company.pro_mobile = companyDict.objectForKey("pro_contact_no") as? String
                        tasks.company.email_pro = companyDict.objectForKey("pro_email") as? String
                        tasks.company.address = companyDict.objectForKey("address") as? String
                        tasks.company.company_note = companyDict.objectForKey("company_note") as? String
                        tasks.company.address_note = companyDict.objectForKey("address_note") as? String
                        
                        tasks.company.activity_code = companyDict.objectForKey("activity_code") as? String
                        */
                        
                        
                        allCompanies.add(companyDao)
                

                        
                    }
                    
                }// end of the
                
            }  // end of the companyArry
            
            
            
            
        }//
        
        return allCompanies
        
    }
    
    func parseCatg(_ rawData : NSMutableData) -> NSMutableArray {
    
        var error : NSError?
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allAreas : NSMutableArray = NSMutableArray()
        
        if let dict = json as? NSDictionary{
            let dataArray : NSArray = dict.object(forKey: "data") as! NSArray
            //for var a = 0 ; a < dataArray.count ; a++ {
                for  a in 0 ..< dataArray.count  {
                    
                let catg = CategoryDao()
                
                let optionDict : NSDictionary = dataArray.object(at: a) as! NSDictionary
                catg.category_id =  optionDict.object(forKey: "id") as? String
                catg.category_name = optionDict.object(forKey: "type_name") as? String
                //catg.category_name_ar = optionDict.objectForKey("category_name_arb") as? String
                allAreas.add(catg)
                
                
            }// end of the for loop
            
            
        }
        return allAreas
        
    }
    
    
    func parseArea(_ rawData : NSMutableData) -> NSMutableArray {
        var error : NSError?
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allAreas : NSMutableArray = NSMutableArray()
        
        if let dict = json as? NSDictionary{
            if dict.object(forKey: "data") != nil {
        let dataArray : NSArray = dict.object(forKey: "data") as! NSArray
           // for var a = 0 ; a < dataArray.count ; a++ {
                for  a in 0 ..< dataArray.count {
                    
                
                let area = AreaDao()
                
                let optionDict : NSDictionary = dataArray.object(at: a) as! NSDictionary
    area.area_id =  optionDict.object(forKey: "id") as? String
    area.area_name = optionDict.object(forKey: "area_name") as? String
                area.area_name_ar = optionDict.object(forKey: "area_name_arabic") as? String
                
       allAreas.add(area)
                
            }// end of the for loop
            
            }
        }
  return allAreas
        
    }
    func poolParseTasks(_ rawData : NSMutableData) -> NSMutableArray{
      
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allTasks : NSMutableArray = NSMutableArray()
        
        if let dict = json as? NSDictionary{
            
            if dict.object(forKey: "response") as? String == nil {
                return allTasks
            }
            if let dataArray : NSArray =  dict.object(forKey: "data") as? NSArray {
            for i in 0  ..< dataArray.count  {
                let dataDic : NSDictionary = dataArray.object(at: i) as! NSDictionary
                let tasks : TaskDao = TaskDao()
                
                tasks.response = dict.object(forKey: "response") as? String
                
                
                
                tasks.list_title = dataDic.object(forKey: "list_title") as? String
                if tasks.list_title == nil {
                    print("returning null")
                    return NSMutableArray()
                    
                    
                }
                
                tasks.totalRecords = dict.object(forKey: "total_records") as? String
                tasks.message = dataDic.object(forKey: "msg") as? String
                tasks.task_id =  dataDic.object(forKey: "task_id") as? String
                
                tasks.list_id = dataDic.object(forKey: "list_id") as? String
                
                tasks.task_name = dataDic.object(forKey: "task_name") as? String
                //tasks.company.
                
                tasks.due_date = dataDic.object(forKey: "due_date") as? String
                tasks.auditor_Id = dataDic.object(forKey: "auditor_id") as? String
                
                tasks.inspection_type  = dataDic.object(forKey: "inspection_type") as? String
                // print("Task type in parser \(tasks.inspection_type)")
                tasks.waiting_for_audit = dataDic.object(forKey: "waiting_for_audit") as? String
                
                tasks.priority = dataDic.object(forKey: "priority") as? String
                tasks.ins_type_name = dataDic.object(forKey: "ins_type_name") as? String
                tasks.ins_type_name_arb = dataDic.object(forKey: "ins_type_name_arb") as? String
                tasks.task_notes = dataDic.object(forKey: "task_notes") as? String
                tasks.company_name = dataDic.object(forKey: "company_name") as? String
                tasks.company_name_ar = dataDic.object(forKey: "company_name_arabic") as? String
                tasks.license_no = dataDic.object(forKey: "license_info") as? String
                
                tasks.category_id = dataDic.object(forKey: "category_id") as? String

                tasks.group_name = dataDic.object(forKey: "group_name") as? String
                tasks.company_lat = dataDic.object(forKey: "latitude") as? String
                tasks.company_lon = dataDic.object(forKey: "longitude") as? String
                tasks.company_id = dataDic.object(forKey: "company_id") as? String
                tasks.area_id = dataDic.object(forKey: "area_id") as? String
                tasks.areaName = dataDic.object(forKey: "area_name") as? String
                tasks.areaNameAr = dataDic.object(forKey: "area_name_arabic") as? String
                
                
                allTasks.add(tasks)
            }
            }
            }
        print(allTasks.count)
        return allTasks
        

        
    }
    
    
    func parsePoolActivityCodes(_ rawData : NSMutableData) -> NSMutableArray{
    
        
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allCodes : NSMutableArray = NSMutableArray()
        
        if let dict = json as? NSDictionary{
            if dict.object(forKey: "response") as! String == "error" {
            return allCodes
            }// end of the if
            
            let dataArray : NSArray =  dict.object(forKey: "data") as! NSArray
            for i in 0  ..< dataArray.count {
                let dataDic : NSDictionary = dataArray.object(at: i) as! NSDictionary
                let activityCode : ActivityCodeDao = ActivityCodeDao()
                
                activityCode.response = dataDic.object(forKey: "response") as? String
                activityCode.id = dataDic.object(forKey: "id") as? String
                activityCode.activity_code = dataDic.object(forKey: "activity_code") as? String
                activityCode.activity_name = dataDic.object(forKey: "activity_name") as? String
                activityCode.activity_name_arabic = dataDic.object(forKey: "activity_name_arabic") as? String
                allCodes.add(activityCode)
                
                
                
            } // end of the for loop
            
            
            
        } // end of the NSDictionary
        
        return allCodes
        
        
    }
    
    func parseReports(_ rawData : NSMutableData) -> ReportDao {
    let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let reportDao : ReportDao = ReportDao()
        reportDao.result = "error"
        if let dict = json as? NSDictionary{
             reportDao.avg_active_duration = dict.object(forKey: "avg_active_duration") as? String
             reportDao.avg_inactive_duration = dict.object(forKey: "avg_inactive_duration") as? String
             reportDao.avg_on_my_way_duration = dict.object(forKey: "avg_on_my_way_duration") as? String
             reportDao.avg_task_duration = dict.object(forKey: "avg_task_duration") as? String
             reportDao.result = "ok"
            if let taskDic = dict.object(forKey: "tasks") as? NSDictionary {
              reportDao.notstarted = taskDic.object(forKey: "notstarted") as? String
              reportDao.closed = taskDic.object(forKey: "closed") as? String
              reportDao.completed = taskDic.object(forKey: "completed") as? String
              reportDao.active = taskDic.object(forKey: "active") as? String
            }
            
            
        
        } // end of the condition
        
 
        
 return reportDao
        
    }
    func parsePermitUrl(_ rawData : NSMutableData) -> String? {
        var urlStr : String? = "error"
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let dict = json as? NSDictionary{
         urlStr = dict.object(forKey: "permit_url") as? String
        
        } // end of the dictionary
        return urlStr
    }
    
    func parseTasks(_ rawData : NSMutableData) -> NSMutableArray
    {

        var error : NSError?
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allTasks : NSMutableArray = NSMutableArray()
        let str = NSString(data: rawData as Data, encoding: String.Encoding.utf8.rawValue)
        //print("str:")
        //print(str)
        
        if let dict = json as? NSDictionary{
            
            if dict.object(forKey: "response") as! String == "error" {
            return allTasks
            }
            
            if let assignementArray = dict.object(forKey: "zone_assignment") as? NSArray {
                for  i in 0  ..< assignementArray.count  {
                    let dataDic : NSDictionary = assignementArray.object(at: i) as! NSDictionary
                    let task : TaskDao = TaskDao()
                    task.zone_id = dataDic.object(forKey: "zone_id") as? String
                    task.task_id =  dataDic.object(forKey: "id") as? String
                    task.zone_name = dataDic.object(forKey: "zone_name") as? String
                    task.zone_startDate = dataDic.object(forKey: "start_date") as? String
                    task.parent_zone_status = dataDic.object(forKey: "parent_zone_status") as? String
                    print("Parent Status in parser \(task.parent_zone_status)")
                    
                    task.zone_expiryDate = dataDic.object(forKey: "due_date") as? String
                    task.zoneStatus = dataDic.object(forKey: "zone_status") as? String
                    task.task_status = task.zoneStatus
                    
                    task.isZoneTask = 1
                    
                    task.company = CompanyDao()
                    allTasks.add(task)
                    
                }// end of zoneAssignement loop
            }/// end of the NSArray
            if dict.object(forKey: "data") as? NSArray == nil {
                return allTasks
            }
            
            
            let dataArray : NSArray =  dict.object(forKey: "data") as! NSArray
           // for (var i = 0 ; i < dataArray.count ; i += 1) {
                for  i in 0 ..< dataArray.count  {
                    
                let dataDic : NSDictionary = dataArray.object(at: i) as! NSDictionary
                let tasks : TaskDao = TaskDao()
    
            tasks.response = dict.object(forKey: "response") as! String
            tasks.company = CompanyDao()
                
                
            tasks.list_title = dataDic.object(forKey: "list_title") as? String
            if tasks.list_title == nil {
                print("returning null")
            return NSMutableArray()
                
                
            }
                
            tasks.message = dataDic.object(forKey: "msg") as? String
            tasks.task_id =  dataDic.object(forKey: "task_id") as? String
            tasks.additiona_email = dataDic.object(forKey: "extra_email") as? String
            //print("Additional Email \(tasks.additiona_email)")
                tasks.external_notes = dataDic.object(forKey: "externalNotes") as? String
                
            tasks.list_id = dataDic.object(forKey: "list_id") as? String

            tasks.task_name = dataDic.object(forKey: "task_name") as? String
            //tasks.company.
                
            tasks.due_date = dataDic.object(forKey: "due_date") as? String
                tasks.auditor_Id = dataDic.object(forKey: "auditor_id") as? String

            tasks.inspection_type  = dataDic.object(forKey: "inspection_type") as? String
           // print("Task type in parser \(tasks.inspection_type)")
            tasks.waiting_for_audit = dataDic.object(forKey: "waiting_for_audit") as? String
           // print("waiting for audit in parser \(dataDic.objectForKey("waiting_for_audit") as? String)")
                
                
//                if taskDao.priority != nil {
//                    task.priority = taskDao.priority
//                }
//                
//                if  taskDao.ins_type_name != nil {
//                    task.ins_type_name = taskDao.ins_type_name
//                }
//                
//                if  taskDao.ins_type_name_arb != nil {
//                    task.ins_type_name_arb = taskDao.ins_type_name_arb
//                }
//                
//                if taskDao.task_notes != nil {
//                    
//                    task.task_notes = taskDao.task_notes
//                    
//                }
                
                
// 
                
            tasks.priority = dataDic.object(forKey: "priority") as? String
            tasks.ins_type_name = dataDic.object(forKey: "ins_type_name") as? String
            tasks.ins_type_name_arb = dataDic.object(forKey: "ins_type_name_arb") as? String
            tasks.task_notes = dataDic.object(forKey: "task_notes") as? String
            tasks.category_id = dataDic.object(forKey: "category_id") as? String
            tasks.isSubVenue = dataDic.object(forKey: "is_subvenue_task") as? String
            tasks.subVenueName = dataDic.object(forKey: "subVenueName") as? String
            tasks.area_id = dataDic.object(forKey: "area_id") as? String
            tasks.areaName = dataDic.object(forKey: "area_name") as? String
            tasks.areaNameAr = dataDic.object(forKey: "area_name_arabic") as? String
            tasks.is_submitted = dataDic.object(forKey: "is_submitted") as? String
                    if let inspectors = dataDic.object(forKey: "taskInspectorIDs") as? String {
                    tasks.coninspectors = inspectors
                    }
            tasks.taskOwner = dataDic.object(forKey: "taskOwnerID") as? String
                    
            tasks.group_name = dataDic.object(forKey: "group_name") as? String
                if let incidentNotes = dataDic.object(forKey: "incident_notes") as? String{
                
                tasks.incidentDao = IncidentMediaDao()
                    tasks.incidentDao?.urgency = dataDic.object(forKey: "urgency") as? String
                tasks.incidentDao?.notes = incidentNotes
                
                    if let incidentArray =  dataDic.object(forKey: "incident_media") as? NSArray{
                        for a in 0 ..< incidentArray.count  {
                            if var dict = incidentArray.object(at: a) as? NSDictionary {
//                            let str =  dict.objectForKey("media_type") as? String
//                                if str == "image" {
//                                tasks.incidentDao?.image = dict.objectForKey("media_path") as? String
//                                
//                                }
//                                else {
//                                    tasks.incidentDao?.audio = dict.objectForKey("media_path") as? String
//                                    
//                                }
                                
                                
                                
                                let str =  dict.object(forKey: "media_type") as? String
                                if str == "image" {
                                    let mediaDao = IncidentMediaDao()
                                    mediaDao.image = dict.object(forKey: "media_path") as? String
                                    mediaDao.image_id = dict.object(forKey: "id") as? String
                                    mediaDao.media_type = 1
                                    
                                    //incident.incidentMedia!.image = dict.objectForKey("media_path") as? String
                                    //incident.incidentMedia!.image_id =  dict.objectForKey("id") as? String
                                    
                                    tasks.incidentMediaArray.add(mediaDao)
                                    
                                }
                                else {
                                    let mediaDao = IncidentMediaDao()
                                    mediaDao.audio = dict.object(forKey: "media_path") as? String
                                    mediaDao.audio_id = dict.object(forKey: "id") as? String
                                    
                                    
                                    //incident.incidentMedia!.audio = dict.objectForKey("media_path") as? String
                                    //incident.incidentMedia!.audio_id =  dict.objectForKey("id") as? String
                                    
                                    tasks.incidentMediaArray.add(mediaDao)
                                    mediaDao.media_type = 2
                                    
                                }

                            print("Incident Media Task \( tasks.incidentMediaArray.count)")
                            
                            } // end of the dict
                        }
                        
                    }// end of the incidentDict
                }// end of the
                
                
            ///tasks.incidentDao?.notes = dataDic.objectForKey("incident_notes") as? String
                
            tasks.company_name = dataDic.object(forKey: "company_name") as? String
            tasks.is_pool = dataDic.object(forKey: "is_pool_task") as? String
            tasks.task_status = dataDic.object(forKey: "task_status") as? String
                tasks.creator = dataDic.object(forKey: "created_by") as? String
                
               // tasks.task_type = dataDic.objectForKey("created_by") as? String
                
                tasks.priority = dataDic.object(forKey: "priority") as? String
                tasks.task_type = dataDic.object(forKey: "ins_type_name") as? String
                tasks.task_type_ar = dataDic.object(forKey: "ins_type_name_arb") as? String

                tasks.task_notes  = dataDic.object(forKey: "task_notes") as? String
            // print("tasks notes using parsing : \(tasks.task_notes)")
                
                tasks.total_earned_points = dataDic.object(forKey: "total_earned_points") as? String
                tasks.parent_task_id = dataDic.object(forKey: "parent_task_id") as? String

                tasks.total_earned_points = dataDic.object(forKey: "total_task_points") as? String
                if let permitDict = dataDic.object(forKey: "permit_details") as? NSDictionary {
                    let permitDao = PermitDao()
                permitDao.permitID =  permitDict.object(forKey: "permitID") as? String
                permitDao.permit_type = permitDict.object(forKey: "permit_type") as? String
                permitDao.url = permitDict.object(forKey: "permit_url") as? String
                permitDao.sub_venue = permitDict.object(forKey: "subVenue") as? String
                     
    
                permitDao.issue_date = permitDict.object(forKey: "issue_date") as? String
                permitDao.expire_date = permitDict.object(forKey: "expire_date") as? String
                permitDao.ReportID = permitDict.object(forKey: "reportID") as? String
                permitDao.lat = permitDict.object(forKey: "latitude") as? String
                permitDao.lon = permitDict.object(forKey: "longitude") as? String
                    
                permitDao.license_info = tasks.license_no
                
                permitDao.id = permitDict.object(forKey: "id") as? String
                tasks.permitDao = permitDao
                    
                    
                }
                
                
                
                let companyDict : NSDictionary = dataDic.object(forKey: "company") as! NSDictionary
                tasks.company.company_id = companyDict.object(forKey: "id") as? String
                tasks.additiona_email = companyDict.object(forKey: "extra_email") as? String
                tasks.company.company_name = companyDict.object(forKey: "company_name") as? String
                //println("Company name \(tasks.company.company_name)")
                tasks.company.license_info = companyDict.object(forKey: "license_info") as? String
                tasks.company.cg_id = companyDict.object(forKey: "cg_id") as? String
                tasks.company.earned_rating = companyDict.object(forKey: "earned_rating") as? String
                tasks.company.area_name = companyDict.object(forKey: "area_name") as? String
                tasks.company.area_id = companyDict.object(forKey: "area_id") as? String
                tasks.company.type_name = companyDict.object(forKey: "type_name") as? String
                tasks.company.group_name = companyDict.object(forKey: "group_name") as? String
                tasks.company.star =  companyDict.object(forKey: "classification") as? String
               // print("Company Star \(tasks.company.star )")
                
                tasks.company.landline = companyDict.object(forKey: "landline") as? String
                tasks.company.email = companyDict.object(forKey: "email_address") as? String
                
                tasks.company.phone_no = companyDict.object(forKey: "phone_no") as? String
                tasks.company.lat = companyDict.object(forKey: "latitude") as? String
                tasks.company.address = companyDict.object(forKey: "address") as? String

                tasks.company.lon = companyDict.object(forKey: "longitude") as? String
                tasks.company.license_issue_date = companyDict.object(forKey: "license_issue_date") as? String
                tasks.company.contact_designation = companyDict.object(forKey: "contact_designation") as? String
                tasks.company.contact_provider_name = companyDict.object(forKey: "contact_provider_name") as? String
                tasks.company.contact_provided_by = companyDict.object(forKey: "contact_provided_by") as? String
                
                
                tasks.company.license_expire_date = companyDict.object(forKey: "license_expire_date") as? String
                tasks.company.company_name_arabic = companyDict.object(forKey: "company_name_arabic") as? String
                tasks.company.pro_name = companyDict.object(forKey: "pro_name") as? String
                tasks.company.pro_mobile = companyDict.object(forKey: "pro_contact_no") as? String
                tasks.company.email_pro = companyDict.object(forKey: "pro_email") as? String
                tasks.company.address = companyDict.object(forKey: "address") as? String
                tasks.company.company_note = companyDict.object(forKey: "company_note") as? String
                tasks.company.address_note = companyDict.object(forKey: "address_note") as? String
               // tasks.company.makani = (companyDict.objectForKey("makani") as? NSArray)
                if let makaniArray = companyDict.object(forKey: "makani") as? NSArray {
                    for a in 0 ..< makaniArray.count  {
                       if let singleMakani = makaniArray.object(at: a) as? NSDictionary {
                        let makaniDao = MakaniDao()
                        makaniDao.companyId = singleMakani.object(forKey: "companyID") as? String
                        makaniDao.makani = singleMakani.object(forKey: "makani_no") as? String
                        tasks.company.makani.add(makaniDao)
                        
                        
                        }
                    
                    }
                }
                
                
                tasks.company.activity_code = companyDict.object(forKey: "activity_code") as? String
                
                if let permitsArray = companyDict.object(forKey: "permits") as? NSArray {
                
                    for a in 0  ..< permitsArray.count  {
                        if let permitDict = permitsArray.object(at: a) as? NSDictionary {
                           
                            let permitDao = PermitDao()
                            permitDao.permitID =  permitDict.object(forKey: "permitID") as? String
                            permitDao.permit_type = permitDict.object(forKey: "permit_type") as? String
                            permitDao.url = permitDict.object(forKey: "permit_url") as? String
                            permitDao.issue_date = permitDict.object(forKey: "issue_date") as? String
                            permitDao.expire_date = permitDict.object(forKey: "expire_date") as? String
                            permitDao.id = permitDict.object(forKey: "id") as? String
                            permitDao.ReportID = permitDict.object(forKey: "reportID") as? String
                            permitDao.sub_venue = permitDict.object(forKey: "subVenue") as? String
                           // print("SUB VENUE \(permitDao.sub_venue)")
                            
                            
                            permitDao.license_info = tasks.company.license_info
                            tasks.company.companyPermits.add(permitDao)
                            
                            

                            
                        } // end of the permitDict
                    } // end of the for loop
                   
                } // end of the
                
                
                
                if let catgArray = companyDict.object(forKey: "categories") as? NSArray {
                    
                    for a in 0  ..< catgArray.count  {
                        if let d = catgArray.object(at: a) as? NSDictionary {
                            let catg = CategoriesDao()
                            catg.catg_id = d.object(forKey: "id") as? String
                            catg.catg_name = d.object(forKey: "category_name") as? String
                            catg.list_id = d.object(forKey: "list_id") as? String
                            
                            tasks.company.categories.add(catg)
                            
                            
                            
                        }
                    }// end of the for loop
                    tasks.company.categoryCount = tasks.company.categories.count as NSNumber
                    
                    
                    
                }
                
            allTasks.add(tasks)
            }
        }
        print(allTasks.count)
        print("Parsing done \(Date())")
return allTasks
        
}
    
    
    
    
    func parseNotif(_ rawData : NSMutableData) -> NSMutableArray
    {
        
        var error : NSError?
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allTasks : NSMutableArray = NSMutableArray()
        
        if let dict = json as? NSDictionary{
            
            if dict.object(forKey: "response") as! String == "error" {
                return allTasks
            }
            let dataArray : NSArray =  dict.object(forKey: "data") as! NSArray
            for i in 0  ..< dataArray.count  {
                let outerDic : NSDictionary = dataArray.object(at: i) as! NSDictionary
                var type = outerDic.object(forKey: "type") as? String
                if type != nil {
                    if type == "task" {
                    
                    }
                    else if type == "incident" {
                    
                    }
                }
                else {
                type = "task"
                }
                
                print("Type \(type)")
                
                if type == "task" {
                let tasks : TaskDao = TaskDao()
                
                if let dataDic = outerDic.object(forKey: "task") as? NSDictionary {
                tasks.response = dict.object(forKey: "response") as! String
                tasks.company = CompanyDao()
                tasks.message = outerDic.object(forKey: "msg") as? String
                tasks.msg_ar = outerDic.object(forKey: "msg_ar") as? String
                tasks.notif_id = outerDic.object(forKey: "id") as? String

                
                tasks.list_title = dataDic.object(forKey: "list_title") as? String
                
                
                                tasks.task_id =  dataDic.object(forKey: "task_id") as? String
                
                tasks.list_id = dataDic.object(forKey: "list_id") as? String
                
                tasks.task_name = dataDic.object(forKey: "task_name") as? String
                //tasks.company.
                
                tasks.due_date = dataDic.object(forKey: "due_date") as? String
                tasks.auditor_Id = dataDic.object(forKey: "auditor_id") as? String
                
                tasks.inspection_type  = dataDic.object(forKey: "inspection_type") as? String
                // print("Task type in parser \(tasks.inspection_type)")
                tasks.waiting_for_audit = dataDic.object(forKey: "waiting_for_audit") as? String
                
                
                tasks.priority = dataDic.object(forKey: "priority") as? String
                tasks.ins_type_name = dataDic.object(forKey: "ins_type_name") as? String
                tasks.ins_type_name_arb = dataDic.object(forKey: "ins_type_name_arb") as? String
                tasks.task_notes = dataDic.object(forKey: "task_notes") as? String
                
                
                tasks.group_name = dataDic.object(forKey: "group_name") as? String
                
                tasks.company_name = dataDic.object(forKey: "company_name") as? String
                
                tasks.task_status = dataDic.object(forKey: "task_status") as? String
                print("Task status \(tasks.task_status)")
                
                tasks.creator = dataDic.object(forKey: "created_by") as? String
                
                // tasks.task_type = dataDic.objectForKey("created_by") as? String
                
                tasks.priority = dataDic.object(forKey: "priority") as? String
                tasks.task_type = dataDic.object(forKey: "ins_type_name") as? String
                tasks.task_type_ar = dataDic.object(forKey: "ins_type_name_arb") as? String
                
                tasks.task_notes  = dataDic.object(forKey: "task_notes") as? String
                // print("tasks notes using parsing : \(dataDic.objectForKey("task_notes"))")
                
                tasks.total_earned_points = dataDic.object(forKey: "total_earned_points") as? String
                tasks.parent_task_id = dataDic.object(forKey: "parent_task_id") as? String
                
                tasks.total_earned_points = dataDic.object(forKey: "total_task_points") as? String
                if let dd = dataDic.object(forKey: "company") as? NSDictionary {
                let companyDict : NSDictionary = dataDic.object(forKey: "company") as! NSDictionary
                tasks.company.company_id = companyDict.object(forKey: "id") as? String
                tasks.company.company_name = companyDict.object(forKey: "company_name") as? String
                //println("Company name \(tasks.company.company_name)")
                tasks.company.license_info = companyDict.object(forKey: "license_info") as? String
                tasks.company.cg_id = companyDict.object(forKey: "cg_id") as? String
                tasks.company.earned_rating = companyDict.object(forKey: "earned_rating") as? String
                tasks.company.area_name = companyDict.object(forKey: "area_name") as? String
                tasks.company.type_name = companyDict.object(forKey: "type_name") as? String
                tasks.company.group_name = companyDict.object(forKey: "group_name") as? String
                
                tasks.company.landline = companyDict.object(forKey: "landline") as? String
                tasks.company.email = companyDict.object(forKey: "email_address") as? String
                
                tasks.company.phone_no = companyDict.object(forKey: "phone_no") as? String
                tasks.company.lat = companyDict.object(forKey: "latitude") as? String
                tasks.company.address = companyDict.object(forKey: "address") as? String
                
                tasks.company.lon = companyDict.object(forKey: "longitude") as? String
                tasks.company.license_issue_date = companyDict.object(forKey: "license_issue_date") as? String
                tasks.company.license_expire_date = companyDict.object(forKey: "license_expire_date") as? String
                tasks.company.company_name_arabic = companyDict.object(forKey: "company_name_arabic") as? String
                tasks.company.pro_name = companyDict.object(forKey: "pro_name") as? String
                tasks.company.pro_mobile = companyDict.object(forKey: "pro_contact_no") as? String
                tasks.company.email_pro = companyDict.object(forKey: "pro_email") as? String
                tasks.company.address = companyDict.object(forKey: "address") as? String
                tasks.company.company_note = companyDict.object(forKey: "company_note") as? String
                tasks.company.address_note = companyDict.object(forKey: "address_note") as? String
                
                tasks.company.activity_code = companyDict.object(forKey: "activity_code") as? String
                }
                allTasks.add(tasks)
                }
                }
                else if type == "incident" {
                    if let dataDic = outerDic.object(forKey: "incident") as? NSDictionary {
                   
                        let notifDao = NotifDao()
                        notifDao.notif_id =  outerDic.object(forKey: "id") as? String
                        notifDao.msg = outerDic.object(forKey: "msg") as? String
                        notifDao.msg_ar = outerDic.object(forKey: "msg_ar") as? String
                        if let incidentDict = outerDic.object(forKey: "incident") as? NSDictionary {
                        let incident = IncidentDao()
                            incident.incident_id = incidentDict.object(forKey: "id") as? String
                            incident.inspectorID = incidentDict.object(forKey: "inspectorID") as? String
                            incident.establishmentID = incidentDict.object(forKey: "establishmentID") as? String
                            incident.establishmentName = incidentDict.object(forKey: "establishmentName") as? String
                            incident.establishmentNameArb = incidentDict.object(forKey: "establishmentNameArb") as? String
                            incident.extEstablishmentName = incidentDict.object(forKey: "extEstablishmentName") as? String
                            incident.extEstablishmentNameArb = incidentDict.object(forKey: "extEstablishmentNameArb") as? String
                            incident.category = incidentDict.object(forKey: "category") as? String
                            incident.notes =  incidentDict.object(forKey: "notes") as? String
                            incident.urgency = incidentDict.object(forKey: "urgency") as? String
                            incident.incident_comments = incidentDict.object(forKey: "comments") as? String
                            
                            /*
                            if let incidentArray =  incidentDict.objectForKey("incident_media") as? NSArray{
                                    incident.incidentMedia = IncidentMediaDao()
                                    for a in 0 ..< incidentArray.count  {
                                        if let dict = incidentArray.objectAtIndex(a) as? NSDictionary {
                                            let str =  dict.objectForKey("media_type") as? String
                                            if str == "image" {
                                                incident.incidentMedia!.image = dict.objectForKey("media_path") as? String
                                                incident.incidentMedia!.image_id =  dict.objectForKey("id") as? String
                                                
                                                
                                            }
                                            else {
                                                incident.incidentMedia!.audio = dict.objectForKey("media_path") as? String
                                                incident.incidentMedia!.audio_id =  dict.objectForKey("id") as? String
                                                
                                            }
                                        
                                        } // end of the dict
                                    }
                                    
                                }// end of the incidentDict
                                */
                            
                            if let incidentArray =  incidentDict.object(forKey: "incident_media") as? NSArray{
                                incident.incidentMedia = IncidentMediaDao()
                                for a in 0 ..< incidentArray.count  {
                                    if let dict = incidentArray.object(at: a) as? NSDictionary {
                                        let str =  dict.object(forKey: "media_type") as? String
                                        if str == "image" {
                                            let mediaDao = IncidentMediaDao()
                                            mediaDao.image = dict.object(forKey: "media_path") as? String
                                            mediaDao.image_id = dict.object(forKey: "id") as? String
                                            mediaDao.media_type = 1
                                            
                                            //incident.incidentMedia!.image = dict.objectForKey("media_path") as? String
                                            //incident.incidentMedia!.image_id =  dict.objectForKey("id") as? String
                                            
                                            incident.incidentMediaArray.add(mediaDao)
                                            
                                        }
                                        else {
                                            let mediaDao = IncidentMediaDao()
                                            mediaDao.audio = dict.object(forKey: "media_path") as? String
                                            mediaDao.audio_id = dict.object(forKey: "id") as? String

                                            
                                            //incident.incidentMedia!.audio = dict.objectForKey("media_path") as? String
                                            //incident.incidentMedia!.audio_id =  dict.objectForKey("id") as? String
                                            
                                            incident.incidentMediaArray.add(mediaDao)
                                            mediaDao.media_type = 2
                                            
                                        }
                                        
                                        
                                    } // end of the dict
                                                              }
                                
                            }// end of the incidentDict
                            
                            print("Incident Array \(incident.incidentMediaArray.count)")

                            
                            
                            
                            notifDao.incidentDao = incident
                        }// end of the
                            
                            
                        
                            
                        allTasks.add(notifDao)
    
                        
                    } // end of the dataDic
                    
                    
                }
            
            }// end of the tasks
            
                
        }
        print(allTasks.count)
        return allTasks
        
    }
    
    
    
    
    func fetchQuestion(_ dataArray : NSArray) -> NSMutableArray{
             let allQuestions =  NSMutableArray()
        
              for i in 0  ..< dataArray.count  {
            let questionDic : NSDictionary = dataArray.object(at: i) as! NSDictionary
            
            let question : QuestionDao = QuestionDao()
            question.question_id = questionDic.object(forKey: "id") as? String
            question.list_id = questionDic.object(forKey: "list_id") as? String
            question.notes = questionDic.object(forKey: "notes") as? String
            question.violation_code = questionDic.object(forKey: "violation_code") as? String
            question.catg_id = questionDic.object(forKey: "category_id") as? String
                
            question.question_desc = questionDic.object(forKey: "question_desc") as? String
                question.question_desc_en = questionDic.object(forKey: "question_desc_en") as? String
            question.entry_datetime = questionDic.object(forKey: "entry_datetime") as? String
            let allOption : NSMutableArray = NSMutableArray()
               if let media : NSArray = questionDic.object(forKey: "media") as? NSArray {
                for ii in 0  ..< media.count{
                    if let mediaDic : NSDictionary =  media.object(at: ii) as? NSDictionary {
                    let mediaDao = MediaDao()
                    mediaDao.media_id = mediaDic.object(forKey: "id") as! String
                    mediaDao.media_Path = mediaDic.object(forKey: "media_path") as! String
                    mediaDao.media_type = mediaDic.object(forKey: "media_type") as! String
                       // print(mediaDao.media_Path)
                    question.media.add(mediaDao)
                    }
                }
                }
            
            let optionsArray : NSArray = questionDic.object(forKey: "options") as! NSArray
            for  i1 in 0  ..< optionsArray.count  {
                
                let optionDict : NSDictionary = optionsArray.object(at: i1) as! NSDictionary
                let option : OptionDao = OptionDao()
                option.option_id = optionDict.object(forKey: "id") as? String
                option.option_label = optionDict.object(forKey: "option_label") as? String
                option.is_selected = optionDict.object(forKey: "is_selected") as? Int
               // print(" outer selected\(option.is_selected) \(option.option_label)")

                option.option_type = optionDict.object(forKey: "option_type") as? String  // RADIO
                option.entry_Datetime = optionDict.object(forKey: "entry_Datetime") as? String

                if option.option_type != nil {
                    if option.option_type! == "request_to_attend" {
                        option.entry_Datetime = optionDict.object(forKey: "date") as? String

                    }
                    else {
                    option.entry_Datetime = optionDict.object(forKey: "entry_Datetime") as? String
                    }
                }
                option.option_description = optionDict.object(forKey: "description") as? String
               // option.entry_Datetime = optionDict.objectForKey("date") as? String
                option.is_required = optionDict.object(forKey: "is_required") as? String
                option.warning_duration = optionDict.object(forKey: "warning_duration") as? String

                option.violation_code = optionDict.object(forKey: "violation_code") as? String
                if optionDict.object(forKey: "extra_options") == nil{
                    allOption.add(option)
                    
                    continue
                }
                let extraOption : NSArray = optionDict.object(forKey: "extra_options") as! NSArray
                //println("Extra Option \(extraOption.count)")
                let allExtraOption : NSMutableArray = NSMutableArray()
                
                for  i2 in 0  ..< extraOption.count   {
                    let extraOptionDic : NSDictionary = extraOption.object(at: i2) as! NSDictionary
                    let eOption : ExtraOption = ExtraOption()
                    eOption.extra_optionId =  extraOptionDic.object(forKey: "id") as? String
                    eOption.option_id = extraOptionDic.object(forKey: "option_id") as? String
                 //  print("Inspector id \(extraOptionDic.objectForKey("inspector_id") as? String)")
                    eOption.inspector_id = extraOptionDic.object(forKey: "inspector_id") as? String
                    eOption.label = extraOptionDic.object(forKey: "label") as? String
                    eOption.is_media = extraOptionDic.object(forKey: "is_media") as? String
                    eOption.value = extraOptionDic.object(forKey: "value") as? String
                    eOption.is_selected = extraOptionDic.object(forKey: "is_selected") as? NSNumber
                    //print("QQQQQQQQQ  selected\(eOption.is_selected) \(question.question_id)")
                     question.is_selected = eOption.is_selected
                    if question.is_selected == nil {
                        question.is_selected = 0
                        
                    }
                    
                    
                    
                    
                    eOption.entry_datetime = extraOptionDic.object(forKey: "entry_datetime") as? String
                    eOption.valication_code = extraOptionDic.object(forKey: "violation_code") as? String
                    eOption.violation_name = extraOptionDic.object(forKey: "violation_name") as? String
                   // println("violation id")
                  // println( eOption.violation_id )
                  // println( extraOptionDic.objectForKey("violation_id") )
                    if let vv = extraOptionDic.object(forKey: "violation_id") as? String {
                  //  println("vvv\(vv)")
                      eOption.violation_id = vv
                        
                
                    }
                    
                    allExtraOption.add(eOption)
                    
                }
                option.allExraOptions = allExtraOption
                allOption.add(option)
                
            }
            
            question.allOptions = allOption
            allQuestions.add(question)
            
        }
        
return allQuestions
        
    }
    
    
    func parseSubVenues(_ rawData : NSMutableData) -> NSMutableArray {
    
        var error : NSError?
        
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        
        let allSubVenues : NSMutableArray = NSMutableArray()
        
        if let dict = json as? NSDictionary{
            
            if let dictArray = dict.object(forKey: "data") as? NSArray{
                for a in 0  ..< dictArray.count  {
                    
                    let dict = dictArray.object(at: a) as! NSDictionary
                    let subVenueDao = SubVenueDao()
                    subVenueDao.subVenue_id = dict.object(forKey: "id") as? String
                    subVenueDao.subVenue = dict.object(forKey: "subVenue") as? String
                    subVenueDao.latitude = dict.object(forKey: "latitude") as? String
                    subVenueDao.longitude = dict.object(forKey: "longitude") as? String
                    subVenueDao.licenseNumber = dict.object(forKey: "licenseNumber") as? String
                    
                    allSubVenues.add(subVenueDao)
                    //print("\(inspectorDao.id) == \(self.appDel.user.user_id)")
                    
                    
                } // end of the for loop
                
                
            } // end of the dictionary
            
        }
        return allSubVenues
    }
    
    func parseInspectors(_ rawData : NSMutableData) -> NSMutableArray {
    
        var error : NSError?
        
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        
        let allInspectors : NSMutableArray = NSMutableArray()

        if let dict = json as? NSDictionary{
            
            if let dictArray = dict.object(forKey: "data") as? NSArray{
                for a in 0  ..< dictArray.count  {
                
                    let dict = dictArray.object(at: a) as! NSDictionary
                    let inspectorDao = InspectorDao()
                    inspectorDao.id = dict.object(forKey: "id") as? String
                    inspectorDao.name = dict.object(forKey: "name") as? String
                    //print("\(inspectorDao.id) == \(self.appDel.user.user_id)")
                    if inspectorDao.id == self.user_id {
                    }
                    else {
                    allInspectors.add(inspectorDao)
                    }
                } // end of the for loop
                
                
            } // end of the dictionary
            
        }
        return allInspectors
    }
    
    func parseQuestionsForHistory(_ rawData : NSMutableData) -> (NSMutableArray,NSMutableArray){
        var error : NSError?
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        var allQuestions : NSMutableArray = NSMutableArray()
        var allCategories = NSMutableArray()
        
        if let dict = json as? NSDictionary{
            
            if let dictArray = dict.object(forKey: "data") as? NSArray{
                if dict.object(forKey: "categories") != nil {
                    
                    let categoryArray : NSArray = dict.object(forKey: "categories") as! NSArray
                    for i in categoryArray as! [NSDictionary] {
                        let catgDao = QuestionCategoryDao()
                        catgDao.catg_id = i.object(forKey: "id") as? String
                        catgDao.catg_name = i.object(forKey: "name") as? String
                        catgDao.catg_name_ar = i.object(forKey: "name_arabic") as? String
                        allCategories.add(catgDao)
                        
                        
                        
                    }
                    
                    
                    
                }
                
            allQuestions  =  self.fetchQuestion(dictArray)
                
            } // end of the check
        
        
        } // end of the dictionary check
    return (allQuestions,allCategories)
    }
    
    
    
    
    func parseHistory(_ rawData : NSMutableData) -> NSMutableArray{
        var error : NSError?
        
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allTasks : NSMutableArray = NSMutableArray()

        if let dict = json as? NSDictionary{
            var totalRecords :Int = 0
            
            if let records = dict.object(forKey: "total_records") as? String {
            totalRecords = Int(records)!
            
            }
            
            if let assignementArray = dict.object(forKey: "zone_assignment") as? NSArray {
                for i in 0  ..< assignementArray.count  {
                    let dataDic : NSDictionary = assignementArray.object(at: i) as! NSDictionary
                    let task : TaskHistoryDao = TaskHistoryDao()
                    task.zone_id = dataDic.object(forKey: "zone_id") as? String
                    task.id =  dataDic.object(forKey: "id") as? String
                    
                    task.zone_name = dataDic.object(forKey: "zone_name") as? String
                    task.zone_name_ar = dataDic.object(forKey: "zone_name_arabic") as? String
                    task.zone_startDate = dataDic.object(forKey: "start_date") as? String
                   // print("Zons Start Date \(task.zone_startDate)")
                   // print("Zons end Date \(task.zone_expiryDate)")
                    
                    
                    
                    task.zone_expiryDate = dataDic.object(forKey: "completed_datetime") as? String
                    task.zoneStatus = dataDic.object(forKey: "zone_status") as? String
                    task.task_status = task.zoneStatus
                    
                    task.isZoneTask = 1
                    
                    
                    allTasks.add(task)
                    
                }// end of zoneAssignement loop
            }/// end of the NSArray
            
            
            
                if let dictArray = dict.object(forKey: "data") as? NSArray{
        
            for a in 0  ..< dictArray.count  {
              let dict = dictArray.object(at: a) as! NSDictionary
             let historyDao = TaskHistoryDao()
                historyDao.total_count = totalRecords
                historyDao.id = dict.object(forKey: "id") as? String
                historyDao.inspector_id = dict.object(forKey: "inspector_id") as? String
                historyDao.company_id = dict.object(forKey: "company_id") as? String
                historyDao.company_name = dict.object(forKey: "company_name") as? String
                historyDao.list_id = dict.object(forKey: "list_id") as? String
                historyDao.taskOwnerID = dict.object(forKey: "taskOwnerID") as? String
                historyDao.coInspectors = dict.object(forKey: "taskInspectorIDs") as? String
                historyDao.company_name_arabic = dict.object(forKey: "company_name_arabic") as? String
                historyDao.priority = dict.object(forKey: "priority") as? String
                historyDao.subVenueName = dict.object(forKey: "subVenueName") as? String
                historyDao.inspection_type = dict.object(forKey: "inspection_type") as? String
                historyDao.area_id = dict.object(forKey: "area_id") as? String
                historyDao.area_name = dict.object(forKey: "area_name") as? String
                historyDao.area_nameAr = dict.object(forKey: "area_name_arabic") as? String
                historyDao.external_notes = dict.object(forKey: "externalNotes") as? String
                

                
                
                
                
//                var driver_id : String?
//                var driver_name : String?
//                var passprot : String?
//                var drivingLicenseNo : String?
//                var emiratesID : String?
//                var taskType : String
//                
                
                historyDao.driver_id = dict.object(forKey: "driver_id") as? String
                historyDao.driver_name = dict.object(forKey: "driverName_Arabic") as? String
                historyDao.driver_name_en = dict.object(forKey: "driver_name_en") as? String
                
                historyDao.passprot = dict.object(forKey: "passportNumber") as? String
                historyDao.drivingLicenseNo = dict.object(forKey: "drivingLicenseNo") as? String
                historyDao.emiratesID = dict.object(forKey: "emiratesID") as? String
                historyDao.taskType = dict.object(forKey: "taskType") as? Int
                
                
                
                historyDao.task_name = dict.object(forKey: "task_name") as? String
                historyDao.list_title = dict.object(forKey: "list_title") as? String
                historyDao.due_date = dict.object(forKey: "due_date") as? String
                historyDao.creator = dict.object(forKey: "created_by") as? String
                historyDao.completed_date = dict.object(forKey: "completed_date") as? String
                historyDao.task_notes = dict.object(forKey: "inspector_task_notes") as? String
                historyDao.violations_count = dict.object(forKey: "violation_count") as? String
                historyDao.task_status = dict.object(forKey: "task_status") as? String
                historyDao.visited_date = dict.object(forKey: "visited_date") as? String
                historyDao.unfinished_note = dict.object(forKey: "unfinished_note") as? String
                historyDao.unfinished_reason = dict.object(forKey: "unfinished_reason") as? String
                if let permitDict = dict.object(forKey: "permit_details") as? NSDictionary {
                    let permitDao = PermitDao()
                    permitDao.permitID =  permitDict.object(forKey: "permitID") as? String
                    permitDao.permit_type = permitDict.object(forKey: "permit_type") as? String
                    permitDao.url = permitDict.object(forKey: "permit_url") as? String
                    permitDao.sub_venue = permitDict.object(forKey: "subVenue") as? String
                    
                    
                    permitDao.issue_date = permitDict.object(forKey: "issue_date") as? String
                    permitDao.expire_date = permitDict.object(forKey: "expire_date") as? String
                    permitDao.ReportID = permitDict.object(forKey: "reportID") as? String
                    permitDao.lat = permitDict.object(forKey: "latitude") as? String
                    permitDao.lon = permitDict.object(forKey: "longitude") as? String
                    
                   // permitDao.license_info = historyDao.
                    
                    permitDao.id = permitDict.object(forKey: "id") as? String
                    historyDao.permitDao = permitDao
                    
                    
                }
                
                
                //  var  unfinished_note : String?
              //  var  unfinished_reason : String?
                
                
                
                //print("Violation History \(dict.objectForKey("vioaltion_count") as? String)")
                
               // let dataArray : NSArray =  dict.objectForKey("questions") as! NSArray
                //historyDao.questions = self.fetchQuestion(dataArray)
                //println(historyDao.task_name)
                allTasks.add(historyDao)
                
        
                
                
            
            
        
        }
            
    
    }
        
        }
  return allTasks
        
}
    
    // MARK:- PARSE CHAT
    func parseChat(_ rawData : NSMutableData) -> NSMutableArray {
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allChats : NSMutableArray = NSMutableArray()
        if let dict = json as? NSDictionary {
            let totalRecords = dict.object(forKey: "total_records") as? String
            if let dictArray  = dict.object(forKey: "data") as? NSArray {
                for a in 0 ..< dictArray.count {
                 let chatDict = dictArray.object(at: a) as! NSDictionary
                  let chatDao = ChatDao()
                    chatDao.chat_id = chatDict.object(forKey: "id") as? String
                    chatDao.senderID = chatDict.object(forKey: "senderID") as? String
                    chatDao.receiverID = chatDict.object(forKey: "receiverID") as? String
                    chatDao.message = chatDict.object(forKey: "message") as? String
                    chatDao.senderType = chatDict.object(forKey: "senderType") as? String
                    chatDao.isRead = chatDict.object(forKey: "isRead") as? String
                    chatDao.messageDateTime = chatDict.object(forKey: "messageDateTime") as? String
                    chatDao.senderName = chatDict.object(forKey: "senderName") as? String
                    
                    chatDao.total_records = totalRecords
                   // print("Parse Total Records \(chatDao.total_records)")
                    allChats.add(chatDao)
                    
                    
                } // end of the for loop
            } // end of the dictArray
        } // end of the dict
        
     return allChats
    }
    
    // MARK:- PARSE EXTERNAL ORGANISATIONS
    func parserCountries(_ rawData : NSMutableData) -> NSMutableArray{
        let countryArray = NSMutableArray()
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let dict = json as? NSDictionary {
            if let rawArray = dict.object(forKey: "data") as? NSArray {
                for c in 0  ..< rawArray.count  {
                    if let c1 = rawArray.object(at: c) as? NSDictionary {
                        let country = CountryDao()
                        country.country_id = c1.object(forKey:"Id") as? String
                        country.country_code = c1.object(forKey: "Code") as? String
                        country.country_name = c1.object(forKey: "Name_EN") as? String
                        
                        country.country_name_ar = c1.object(forKey: "Name_AR") as? String
                        country.country_dndrd_code = c1.object(forKey: "CodeDNRD") as? String
                        print("Adding country with \(country.country_name)")
                        countryArray.add(country)
                        
                        
                        
                    } // end of the rawDictionary
                    
                    
                    
                }
                
            } // end of the dataDict
            
        } // end of the dictionary
        print("returning with \(countryArray.count)")
        
        return countryArray
        
        
    }
    
    
    
    func parseSearchedExternalOrg(_ rawData : NSMutableData) -> NSMutableArray{
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allOrg : NSMutableArray = NSMutableArray()
        
        if let dict = json as? NSDictionary{
        if let dictArray = dict.object(forKey: "data") as? NSArray{
            for a in 0  ..< dictArray.count  {
            let orgDict = dictArray.object(at: a) as! NSDictionary
            let searchedOrg = ExternalOrgDao()
                searchedOrg.ID = orgDict.object(forKey: "ID") as? String
                
            searchedOrg.e_email = orgDict.object(forKey: "org_email") as? String
            searchedOrg.e_establihsmentName = orgDict.object(forKey: "org_name") as? String
            searchedOrg.e_establishmentArabicName = orgDict.object(forKey: "org_name_arabic") as? String
            allOrg.add(searchedOrg)
                
            }
        }
        }
    return allOrg
    }
    
    
    func parseIndividuals(_ rawData : NSMutableData) -> NSMutableArray {
    let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
    let allIndividuals : NSMutableArray = NSMutableArray()
        if let dict = json as? NSDictionary{
        
            if let dictArray = dict.object(forKey: "data") as? NSArray{
                for a in 0  ..< dictArray.count  {
                      let dict = dictArray.object(at: a) as! NSDictionary
                    let individualDao = IndividualDao()
                    //individualDao.id = dict.objectForKey("") as? String
                    individualDao.fullName_ar = dict.object(forKey: "fullName_Arabic") as? String
                    individualDao.fullName_en = dict.object(forKey: "fullName") as? String
                    individualDao.emirates_id = dict.object(forKey: "emiratesID") as? String
                    individualDao.passport = dict.object(forKey: "passportNumber") as? String
                    individualDao.rtaLicense = dict.object(forKey: "drivingLicenseNo") as? String
                    individualDao.mobile = dict.object(forKey: "contactNumber") as? String
                    individualDao.email = dict.object(forKey: "email") as? String
                    individualDao.countryCode = dict.object(forKey: "countryCode") as? String
                    allIndividuals.add(individualDao)
                    
                    
                    
                
                } // end of the for loop
            } // end of the dictArray
            
        }
     return allIndividuals
        
    }
    
    //MARK:- PARSE SEARCHED COMPANIES
    func parseSearchdCompanies(_ rawData : NSMutableData) -> NSMutableArray{
        
               let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let allCompanies : NSMutableArray = NSMutableArray()
        
        if let dict = json as? NSDictionary{
            if let dictArray = dict.object(forKey: "data") as? NSArray{
            
                for a in 0  ..< dictArray.count  {
                    let dict = dictArray.object(at: a) as! NSDictionary
                    let searchCompanyDao = CompanyDao()
                    
                    searchCompanyDao.company_id = dict.object(forKey: "id") as? String
                    searchCompanyDao.company_name = dict.object(forKey: "company_name") as? String
                    searchCompanyDao.license_info = dict.object(forKey: "license_info") as? String
                    searchCompanyDao.company_name_arabic = dict.object(forKey: "company_name_arabic") as? String
                    
                    allCompanies.add(searchCompanyDao)
                    
                } // end of the for loop
                
            } // end of the dictArray
            
            
        }// end of the dict
        return allCompanies
    }
    func parseTaskType(_ rawData : NSMutableData) -> NSMutableArray
    {
    let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let taskTypes : NSMutableArray = NSMutableArray()
        
        if let dict = json as? NSDictionary{
            if let dictArray = dict.object(forKey: "data") as? NSArray{
                for a in 0  ..< dictArray.count  {
                    let dict = dictArray.object(at: a) as! NSDictionary
                    let typeDao = TaskTypeDao()
                    typeDao.id = dict.object(forKey: "id") as? String
                    typeDao.ins_type_name = dict.object(forKey: "ins_type_name") as? String
                    typeDao.ins_type_name_arb = dict.object(forKey: "ins_type_name_arb") as? String
                    taskTypes.add(typeDao)
                }
                
            }
        }
 
 return taskTypes
        
    }
    func parseCreatedTask(_ rawData : NSMutableData) -> TaskDao {
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let tasks = TaskDao()
        if let dict = json as? NSDictionary{
        
            if let dataDic = dict.object(forKey: "data") as? NSDictionary{
            
                
                tasks.response = dict.object(forKey: "response") as? String
                tasks.company = CompanyDao()
                
                
                tasks.list_title = dataDic.object(forKey: "list_title") as? String
                if tasks.list_title == nil {
                    print("returning null")
                    return tasks
                    
                }
                tasks.task_id =  dataDic.object(forKey: "task_id") as? String
                
                tasks.list_id = dataDic.object(forKey: "list_id") as? String
                print("List iddddd \(tasks.list_id)")
                
                
                tasks.task_name = dataDic.object(forKey: "task_name") as? String
                let catgid = dataDic.object(forKey: "category_id") as? String
                if catgid != nil {
                tasks.category_id = catgid
                }
                
                
                tasks.due_date = dataDic.object(forKey: "due_date") as? String
                tasks.auditor_Id = dataDic.object(forKey: "auditor_id") as? String
                tasks.is_pool = dataDic.object(forKey: "is_pool_task") as? String
                
                tasks.group_name = dataDic.object(forKey: "group_name") as? String
                
                tasks.company_name = dataDic.object(forKey: "company_name") as? String
                
                tasks.task_status = dataDic.object(forKey: "task_status") as? String
                tasks.creator = dataDic.object(forKey: "created_by") as? String
                
                tasks.priority = dataDic.object(forKey: "priority") as? String
                tasks.task_notes  = dataDic.object(forKey: "task_notes") as? String
                tasks.parent_task_id = dataDic.object(forKey: "parent_task_id") as? String
                tasks.task_type_ar = dataDic.object(forKey: "ins_type_name_arb") as? String
                tasks.total_earned_points = dataDic.object(forKey: "total_earned_points") as? String
                
                tasks.total_earned_points = dataDic.object(forKey: "total_task_points") as? String
                let companyDict : NSDictionary = dataDic.object(forKey: "company") as! NSDictionary
                tasks.company.company_id = companyDict.object(forKey: "id") as? String
                tasks.company.company_name = companyDict.object(forKey: "company_name") as? String
                //println("Company name \(tasks.company.company_name)")
                tasks.company.license_info = companyDict.object(forKey: "license_info") as? String
                tasks.company.cg_id = companyDict.object(forKey: "cg_id") as? String
                tasks.company.earned_rating = companyDict.object(forKey: "earned_rating") as? String
                tasks.company.area_name = companyDict.object(forKey: "area_name") as? String
                tasks.company.area_id = companyDict.object(forKey: "area_id") as? String

                tasks.company.type_name = companyDict.object(forKey: "type_name") as? String
                tasks.company.group_name = companyDict.object(forKey: "group_name") as? String
                tasks.company.landline = companyDict.object(forKey: "landline") as? String
                tasks.company.phone_no = companyDict.object(forKey: "phone_no") as? String
                tasks.company.email = companyDict.object(forKey: "email_address") as? String
                tasks.company.address = companyDict.object(forKey: "address") as? String
                tasks.company.activity_code = companyDict.object(forKey: "activity_code") as? String
                tasks.company.address_note = companyDict.object(forKey: "address_note") as? String
                tasks.company.company_note = companyDict.object(forKey: "company_note") as? String
                
                tasks.company.lat = companyDict.object(forKey: "latitude") as? String
                tasks.company.lon = companyDict.object(forKey: "longitude") as? String
                tasks.company.contact_designation = companyDict.object(forKey: "contact_designation") as? String
                tasks.company.contact_provider_name = companyDict.object(forKey: "contact_provider_name") as? String
                tasks.company.contact_provided_by = companyDict.object(forKey: "contact_provided_by") as? String
                
                
                tasks.company.license_issue_date = companyDict.object(forKey: "license_issue_date") as? String
                tasks.company.license_expire_date = companyDict.object(forKey: "license_expire_date") as? String
                tasks.company.company_name_arabic = companyDict.object(forKey: "company_name_arabic") as? String
                tasks.company.pro_name = companyDict.object(forKey: "pro_name") as? String
                tasks.company.pro_mobile = companyDict.object(forKey: "pro_contact_no") as? String
                tasks.company.email_pro = companyDict.object(forKey: "pro_email") as? String
                tasks.company.star =  companyDict.object(forKey: "classification") as? String
                
            
            } // end of the data dictionary
        } // end of the outer dictionalry
        return tasks
        
        
    
    }
    func parseMakaniData(_ rawData : NSMutableData) -> String? {
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        var result : String? = "error"
        if let dict = json as? NSDictionary {
            if let response = dict.object(forKey: "response") as? String {
                if response == "success" {
                    
                  if let data = dict.object(forKey: "data") as? NSDictionary
                  {
                    result = data.object(forKey: "LATLNG") as? String
                    
                    }// end of the if
                }
                else {
                result = "error"
                }
            }
        } // end of the dic
        return result
    } // end of t
    func parseDetailCompany(_ rawData : NSMutableData) -> CompanyDao {
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let dao = CompanyDao()
        
        if let dict = json as? NSDictionary{
            if let dictArray = dict.object(forKey: "data") as? NSDictionary{
                dao.company_id = dictArray.object(forKey: "id") as? String
                
                dao.company_name = dictArray.object(forKey: "company_name") as? String
                print(dao.company_name)
                
                dao.license_info = dictArray.object(forKey: "license_info") as? String
                dao.company_name_arabic = dictArray.object(forKey: "company_name_arabic") as? String
                dao.lat =  dictArray.object(forKey: "latitude") as? String
                dao.lon = dictArray.object(forKey: "longitude") as? String
                dao.license_issue_date = dictArray.object(forKey: "license_issue_date") as? String
                dao.license_expire_date = dictArray.object(forKey: "license_expire_date") as? String
                dao.address = dictArray.object(forKey: "address") as? String
                dao.landline = dictArray.object(forKey: "phone_no") as? String
                dao.pro_mobile = dictArray.object(forKey: "landline") as? String
                dao.activity_code = dictArray.object(forKey: "activity_code") as? String
                dao.address_note = dictArray.object(forKey: "address_note") as? String
                dao.contact_designation = dictArray.object(forKey: "contact_designation") as? String
                dao.contact_provider_name = dictArray.object(forKey: "contact_provider_name") as? String
                dao.contact_provided_by = dictArray.object(forKey: "contact_provided_by") as? String
                dao.star = dictArray.object(forKey: "classification") as? String
                dao.area_id = dictArray.object(forKey: "area_id") as? String
                
   //             dao.makani = (dictArray.objectForKey("makani") as? NSArray)!

                dao.company_note = dictArray.object(forKey: "company_note") as? String
               // print("Categories in parser \(dictArray.objectForKey("categories") as? NSArray)")
                
                
                if let makaniArray = dictArray.object(forKey: "makani") as? NSArray {
                    for a in 0 ..< makaniArray.count  {
                        if let singleMakani = makaniArray.object(at: a) as? NSDictionary {
                            let makaniDao = MakaniDao()
                            makaniDao.companyId = singleMakani.object(forKey: "companyID") as? String
                            makaniDao.makani = singleMakani.object(forKey: "makani_no") as? String
                            dao.makani.add(makaniDao)
                            
                            
                        }
                        
                    }
                }
                

                
                
                if let catgArray = dictArray.object(forKey: "categories") as? NSArray {
                    
                    for a in 0  ..< catgArray.count  {
                        if let d = catgArray.object(at: a) as? NSDictionary {
                           let catg = CategoriesDao()
                            catg.catg_id = d.object(forKey: "id") as? String
                            catg.catg_name = d.object(forKey: "category_name") as? String
                            dao.categories.add(catg)
                            
                            
                        
                        }
                    }// end of the for loop
                    
                    
                    
                }
                
                if let permitsArray = dictArray.object(forKey: "permits") as? NSArray {
                    
                    for a in 0  ..< permitsArray.count  {
                        if let permitDict = permitsArray.object(at: a) as? NSDictionary {
                            
                            let permitDao = PermitDao()
                            permitDao.permitID =  permitDict.object(forKey: "permitID") as? String
                            permitDao.permit_type = permitDict.object(forKey: "permit_type") as? String
                            permitDao.url = permitDict.object(forKey: "permit_url") as? String
                            permitDao.issue_date = permitDict.object(forKey: "issue_date") as? String
                            permitDao.expire_date = permitDict.object(forKey: "expire_date") as? String
                            permitDao.id = permitDict.object(forKey: "id") as? String
                            permitDao.sub_venue = permitDict.object(forKey: "subVenue") as? String
                            permitDao.license_info = dao.license_info
                            dao.companyPermits.add(permitDao)
                            
                            
                            
                            
                        } // end of the permitDict
                    } // end of the for loop
                    
                } // end of the
               
                
            } //.
        }
        
    return dao
        
    }
    
    
    
  
        func parserOldViolations(_ rawData : NSMutableData) -> NSMutableArray {
            let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            let violations : NSMutableArray = NSMutableArray()
            if let dict = json as? NSDictionary{
                if let dictArray = dict.object(forKey: "data") as? NSArray{
                    for a in 0  ..< dictArray.count  {
                        if let dataDict = dictArray.object(at: a) as? NSDictionary {
                            let dao  = ViolationHistoryDao()
                            dao.violation_id = dataDict.object(forKey: "ViolationId") as? String
                            dao.violation_name = dataDict.object(forKey: "OffenceCodeDescription") as? String
                            dao.violation_date = dataDict.object(forKey: "InspectionDate") as? String
                            dao.violation_name_ar = dataDict.object(forKey: "OffenceCodeDescription_Arb") as? String
                            dao.violationpaystatusName = dataDict.object(forKey: "ViolationPayStatusName") as? String
                            dao.violationpaystatusName_ar = dataDict.object(forKey: "ViolationPayStatusName_Arb") as? String
                            dao.InspectionHOSStatusName = dataDict.object(forKey: "InspectionHOSStatusName") as? String
                            dao.InspectionHOSStatusName_Arb = dataDict.object(forKey: "InspectionHOSStatusName_Arb") as? String
                            dao.Remarks = dataDict.object(forKey: "Remarks") as? String
                            dao.Remarks_Arb = dataDict.object(forKey: "Remarks_Arb") as? String
                            
                            
                            
                            
                            violations.add(dao)
                            
                            
                        }// end of the dao
                        
                        
                        
                        
                    } // end of the for loop
                    
                    
                } // end of the array
            } // end of the dictionary 
            return violations
            
            
            
        }
        
        
        
    

    

    func parseActivityCodes(_ rawData : NSMutableData) -> NSMutableArray{
        let allActivityCodes = NSMutableArray()
        
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let dict = json as? NSDictionary{
            if let dataArray = dict.object(forKey: "activityCodes") as? NSMutableArray {
                for a in 0  ..< dataArray.count  {
                    if let activityDict = dataArray.object(at: a) as? NSMutableDictionary {
                    let activity = ActivityCode()
                    activity.activity_code = activityDict.object(forKey: "activity_code") as? String
                    activity.activity_name = activityDict.object(forKey: "activity_name") as? String
                    activity.activity_name_arabic = activityDict.object(forKey: "activity_name_arabic") as? String
                    activity.id = activityDict.object(forKey: "id") as? String
                    allActivityCodes.add(activity)
                        
                    } // end of the activityDict
                    
                }
            } // end of the dataArsy
            
        } // end of the json dict
        
   return allActivityCodes
        
    
    }
    func parseCategories(_ rawData : NSMutableData) -> NSMutableArray {
    let allCategories = NSMutableArray()
    let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let dict = json as? NSDictionary{
        
            if let dictArray = dict.object(forKey: "categories") as? NSArray{
                for a in 0  ..< dictArray.count  {
                    if let singleDict = dictArray.object(at: a) as? NSDictionary {
                    let dao = CategoryDao()
                        dao.category_id = singleDict.object(forKey: "id") as? String
                        dao.category_name = singleDict.object(forKey: "type_name") as? String
                        allCategories.add(dao)
                        
                        
                    }// end of the dao
                
                } //
                
            }// end of if
            
        } // end of the dict
        
     return allCategories
    }
    
    
    func parseCatActCodes(_ rawData : NSMutableData) ->  NSMutableArray {
    let allCatActCodes = NSMutableArray()
    let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let dict = json as? NSDictionary{
            
        if let dictArray = dict.object(forKey: "catActCodes") as? NSArray{
            for a in 0  ..< dictArray.count  {
                if let singleDict = dictArray.object(at: a) as? NSDictionary {
                    
                let dao = CatActCodesDao ()
                dao.id = singleDict.object(forKey: "id") as? String
                dao.category_id = singleDict.object(forKey: "category_id") as? String
                dao.activity_id = singleDict.object(forKey: "activity_id") as? String
                allCatActCodes.add(dao)
                } // end of the singleDict
                
                
            } // end of the loop
            
            
            } // end of the dictArray
        } // end of the dict 
        
        return allCatActCodes
        
    }
    
    func parseCompanyActCodes(_ rawData : NSMutableData) -> NSMutableArray {
    let allCompanyCatg = NSMutableArray()
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let dict = json as? NSDictionary{
            if let dictArray = dict.object(forKey: "companyActCodes") as? NSArray{
                for a in 0  ..< dictArray.count  {
                    if let singleDict = dictArray.object(at: a) as? NSDictionary {
                    let dao = CompanyCatDao()
                        dao.id = singleDict.object(forKey: "ID") as? String
                        dao.company_id = singleDict.object(forKey: "company_id") as? String
                        dao.activity_id = singleDict.object(forKey: "activity_id") as? String
                        allCompanyCatg.add(dao)
                        
                    }
                } // end of the
                
        
        }
        }
        return allCompanyCatg
    }
    
    func parserWarnings(_ rawData : NSMutableData) -> NSMutableArray {
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let warnings : NSMutableArray = NSMutableArray()
        if let dict = json as? NSDictionary{
            if let dictArray = dict.object(forKey: "data") as? NSArray{
                for a in 0  ..< dictArray.count  {
                    if let dataDict = dictArray.object(at: a) as? NSDictionary {

                let warningData : WarningsDao = WarningsDao()
                warningData.question_desc = dataDict.object(forKey: "question_desc") as? String
                warningData.warning_duration = dataDict.object(forKey: "warning_duration") as? String
                warningData.entry_datetime = dataDict.object(forKey: "entry_datetime") as? String
               warnings.add(warningData)
                    }
            } // end if the dictArray
        }// end of outer dictionary
        
        
    
    }
 return warnings
}
    
    func parseVersionNumber(_ rawData : NSMutableData) -> String?{
        var versionStr : String? = "N/A"
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let outerDict = json as? NSDictionary{
          versionStr = outerDict.object(forKey: "version") as? String
            
        }
        return versionStr
        
    }
    func chatUserParser(_ rawData : NSMutableData) -> NSMutableArray{
    let users = NSMutableArray()
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let outerDict = json as? NSDictionary{
            if let dataDict = outerDict.object(forKey: "data") as? NSDictionary {
            if let dictArray = dataDict.object(forKey: "admin") as? NSArray{
                for a in 0  ..< dictArray.count  {
                      if let dataDict = dictArray.object(at: a) as? NSDictionary {
                let user = ChatUsers()
                    user.user_id = dataDict.object(forKey: "id") as? String
                    user.user_name = dataDict.object(forKey: "name") as? String
                    user.type = "admin"
                    users.add(user)
                    } // end of the if
                }
            }// end of the NSArray
                if let hosDict = dataDict.object(forKey: "hos") as? NSDictionary {
                    let user = ChatUsers()
                    user.user_id = hosDict.object(forKey: "id") as? String
                    user.user_name = hosDict.object(forKey: "name") as? String
                    user.type = "hos"
                    users.add(user)
                }
                
        }
        }
        /// end of the NSDoctionary
     return users
        
    }
    
    func parseMainInspectionList(_ rawData : NSMutableData) -> NSMutableArray {
        let json : AnyObject! = try? JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        let lists : NSMutableArray = NSMutableArray()
        if let outerDict = json as? NSDictionary{
            if let dictArray = outerDict.object(forKey: "questionList") as? NSArray{
                for a in 0  ..< dictArray.count  {
                    if let dataDict = dictArray.object(at: a) as? NSDictionary {
                      let listDao = InspectionMainListDao()
                        listDao.list_title = dataDict.object(forKey: "list_title") as? String
                        listDao.id = dataDict.object(forKey: "id") as? String
                        listDao.category_id = dataDict.object(forKey: "category_id") as? String
                        listDao.entry_datetime = dataDict.object(forKey: "entry_datetime") as? String
                        lists.add(listDao)
                        
                    }// end of the
                } // end of the for loop
                
                
                
            } // end of the if
            
            
        } // end of the if
        
       return lists
        
    } // end of the parseMainInspectionList
}
