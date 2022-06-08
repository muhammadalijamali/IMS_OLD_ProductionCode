//
//  DatabaseManager.swift
//  
//
//  Created by Administrator on 12/3/15.
//
//

import UIKit
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class DatabaseManager: NSObject , SessionDelegate {
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    func fetchAllCategoriesBasedonListid(list_id : String) -> NSMutableArray{
        let categories = NSMutableArray()
         var error : NSError?
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionList")
        taskRequest.returnsDistinctResults = true
        let predicate  = NSPredicate(format: "list_id = %@",list_id)
        print(predicate)
        
        taskRequest.predicate = predicate
        
        let array: [AnyObject]?
         do {
             array = try self.appDel.managedObjectContext?.fetch(taskRequest)
            for st in array as! [InspectionList] {
                print(st.catg_id)
                categories.add(st.catg_id)
                
            }
         } catch let error1 as NSError {
            error = error1
            array = nil
        }
        print("Total ids \(array?.count)")
        let finalcatg = self.fetchCategoriesByNamesUsingIds(ids: categories)
        print("returning \(finalcatg.count)")
        return finalcatg
    }
    
    func fetchAllCountries()-> NSMutableArray{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        request.returnsDistinctResults = true
        let sort = NSSortDescriptor(key: #keyPath(Country.countryName), ascending: true)
        request.sortDescriptors = [sort]
        
        let allCountires = NSMutableArray()
        
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
            //print(array)
            //for var a = 0 ; a < array?.count ; a += 1 {
            
            for  a in 0 ..< array!.count  {
                
                let managed = array![a] as! Country
                let cDao = CountryDao()
                cDao.country_code = managed.countryCode
                cDao.country_name = managed.countryName
                cDao.country_name_ar = managed.countryNameAr
                cDao.country_dndrd_code = managed.dnrdCode
                
                
                // allActivityCodes.addObject(managed.activity_id!)
                allCountires.add(cDao)
                
                
                
                
            } // End of the for loop
            
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        } // end of the catch
        return allCountires
        
        
        
    }
    
    func fetchInspectorsOnBehalfofIds(allIds : NSArray) -> NSMutableArray {
        let inspectors = NSMutableArray()
        
         var error : NSError?
        let inspectorRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Inspectors")
          inspectorRequest.returnsDistinctResults = true
        let predicate  = NSPredicate(format: "inspector_id IN %@",allIds)
        print(predicate)
        inspectorRequest.predicate = predicate
        
         let array: [AnyObject]?
         do {
              array = try self.appDel.managedObjectContext?.fetch(inspectorRequest)
            for st in array as! [Inspectors] {
              let inspector = InspectorDao()
                inspector.id = st.inspector_id
                inspector.name = st.inspector_Name
                //print(inspector.name)
                inspectors.add(inspector)
            }
         } catch let error1 as NSError {
            error = error1
            array = nil
        }// end of the catch
        return inspectors
    } // end of the fetchInspectorOnBeh
    
    
    
    func fetchCategoriesByNamesUsingIds(ids : NSMutableArray)-> NSMutableArray {
        let categories = NSMutableArray()
        let allIds : NSArray = ids.mutableCopy() as! NSArray
        var error : NSError?
        let categoryRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionCategories")
        categoryRequest.returnsDistinctResults = true
        let predicate  = NSPredicate(format: "catg_id IN %@",allIds)
        categoryRequest.predicate = predicate
        
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(categoryRequest)
            for st in array as! [QuestionCategories] {
                //categories.add(st.category_id)
                let catgDao = QuestionCategoryDao()
                catgDao.catg_id = st.catg_id
                catgDao.catg_name = st.catg_name_eng
                catgDao.catg_name_ar = st.catg_name_ar
                categories.add(catgDao)
            }
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        return categories
    }
        
        
    
    func fetchAllInspectionMainListAll()-> NSMutableArray {
        let inspectionListMain = NSMutableArray()
        var error : NSError?
        
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionMainList")
    
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(taskRequest)
            for st in array as! [InspectionMainList] {
                let list = InspectionMainListDao()
                list.list_title = st.list_title
                list.category_id = st.category_id
                list.entry_datetime = st.entry_datetime
                list.id = st.id
                inspectionListMain.add(list)
                
                
                
            } // end of the for loop
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        
        return inspectionListMain
        
        
    }
    
    
    
    func fetchQuestionCategories()-> NSMutableArray{
        
        var error : NSError?
        let questionsCategories = NSMutableArray()
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionCategories")
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(taskRequest)
            for st in array as! [QuestionCategories] {
            let catg = QuestionCategories()
                catg.catg_id = st.catg_id
                catg.catg_name_ar = st.catg_name_ar
                catg.catg_name_eng = st.catg_name_eng
                questionsCategories.add(catg)
            }
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        return questionsCategories
        
        
    }
    
    func fetchInspectionListMainByCategory(_ category_id : String) -> NSMutableArray{
        let inspectionListMain = NSMutableArray()
        var error : NSError?
        
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionMainList")
        let predicate  = NSPredicate(format: "category_id = %@", category_id)
        taskRequest.predicate = predicate
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(taskRequest)
            for st in array as! [InspectionMainList] {
            let list = InspectionMainListDao()
            list.list_title = st.list_title
            list.category_id = st.category_id
            list.entry_datetime = st.entry_datetime
            list.id = st.id
            inspectionListMain.add(list)
                
                
            /*
                var list_title : String?
                var category_id : String?
                var entry_datetime : String?
            */
                
            } // end of the for loop
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        
        
        return inspectionListMain
        
    
    }
    
    
    

    
    
    
    func fetchTasks()-> NSMutableArray{
                let allTasks = NSMutableArray()
               var error : NSError?
               print("Fetch tasks")
                let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
                let predicate  = NSPredicate(format: "is_completed = %@", "0")
                taskRequest.predicate = predicate
                let array: [AnyObject]?
                do {
                    array = try self.appDel.managedObjectContext?.fetch(taskRequest)
                } catch let error1 as NSError {
                    error = error1
                    array = nil
                }
                for st in array as! [Tasks] {
                let taskDao = TaskDao()
                    taskDao.company = CompanyDao()
                      taskDao.task_id = st.task_id
                     // taskDao.company.area_id =  st.area_id
                    if st.auditor_id != nil {
                    taskDao.auditor_Id! = st.auditor_id!
                    }
                    
                     taskDao.auditor_name! = st.auditor_name!
                    if st.company_id != nil {
                      taskDao.company.company_id = st.company_id
                    }
                    if st.ownerID != nil {
                        
                        taskDao.taskOwner = st.ownerID
                        
                    }
                       taskDao.company_name = st.company_name
                      taskDao.company.company_name_arabic = st.company_name_arabic
                    if st.created_by != nil {
                    taskDao.creator = st.created_by!
                    }
                    if st.uniqueid != nil {
                    taskDao.uniqueid = st.uniqueid
                    }
                    
                    if st.priority != nil {
                    taskDao.priority = st.priority
                    }
                    if st.pool != nil {
                    taskDao.is_pool = st.pool
                        
                    }
                    if st.coninspectors != nil {
                        taskDao.coninspectors = st.coninspectors!
                        
                    }
                    
                    
                    
//                    if taskDao.additiona_email != nil {
//                        task.additional_email = taskDao.additiona_email
//                    }
//                    if taskDao.external_notes != nil {
//                        task.external_notes = taskDao.external_notes
//                    }
                    
                    if st.additional_email != nil {
                    taskDao.additiona_email = st.additional_email
                    }
                    
                    if st.external_notes != nil {
                    taskDao.external_notes = st.external_notes
                    }
                    if st.isSubvenue != nil {
                    taskDao.isSubVenue = st.isSubvenue
                    }
                    if st.subvenue != nil {
                        
                    taskDao.subVenueName = st.subvenue
                    }
                    if st.ins_type_name != nil {
                    taskDao.ins_type_name = st.ins_type_name
                    }
                    if st.ins_type_name_arb != nil {
                    taskDao.ins_type_name_arb = st.ins_type_name_arb
                    }
                    if st.type_name != nil {
                    taskDao.company.type_name = st.type_name
                    }
                    taskDao.isZoneTask = Int(st.isZoneTask!)
                    
                    
                    if st.task_notes != nil {
                    taskDao.task_notes = st.task_notes
                    
                    }
                    if st.category_id != nil {
                        taskDao.category_id = st.category_id
                    }

                    
                    if st.waiting_for_audit != nil {
                    taskDao.waiting_for_audit = st.waiting_for_audit
                    }
                    
                    if st.is_Submitted != nil {
                        taskDao.is_submitted = st.is_Submitted
                    }

                    
                    if st.inspection_type != nil {
                    taskDao.inspection_type = st.inspection_type
                    //print("Inspection type in fetch \(taskDao.inspection_type)")
                    }
                    
//                    if taskDao.zone_id != nil {
//                        task.zone_id = taskDao.zone_id
//                    }
//                    
//                    if taskDao.zone_name != nil {
//                        task.zone_name = taskDao.zone_name
//                        
//                    }
//                    if taskDao.zoneStatus  != nil {
//                        task.zoneStatus = taskDao.zoneStatus
//                    }
//                    
//                    if taskDao.zone_startDate != nil {
//                        task.zone_startDate = taskDao.zone_startDate
//                        
//                    }
//                    
//                    if taskDao.zone_expiryDate != nil {
//                        task.zone_expiryDate = task.zone_expiryDate
//                    }
//                    
                    
                    
                    if st.zone_id != nil {
                    taskDao.zone_id = st.zone_id
                    }
                    if st.zone_name_ar != nil {
                    taskDao.zone_name_ar = st.zone_name_ar
                    }
                    
                    if st.zone_name_eng != nil {
                    taskDao.zone_name = st.zone_name_eng
                    }
                    if st.zone_status != nil {
                    taskDao.zoneStatus = st.zone_status
                    }
                    
                    if st.parent_zone_status != nil {
                        taskDao.parent_zone_status = st.parent_zone_status
                        
                    }
                    
                    if st.zone_startDate != nil {
                    
                    taskDao.zone_startDate = st.zone_startDate
                    }
                    
                    if st.zone_expiryDate != nil {
                    taskDao.zone_expiryDate = st.zone_expiryDate
                    }
                    
                    
                    
                    if st.permitID != nil {
                    let permit = PermitDao()
                    permit.permitID = st.permitID
                        if st.record_id != nil {
                        permit.id = st.record_id
                        }
                        
                        if st.issue_date != nil {
                        permit.issue_date = st.issue_date
                        }
                        if st.expire_date != nil {
                        permit.expire_date = st.expire_date
                        }
                        
                        if st.permit_type != nil {
                        permit.permit_type = st.permit_type
                        }
                        
                        if st.permit_url != nil {
                        permit.url = st.permit_url
                        }
                        if st.permit_lat != nil {
                        permit.lat = st.permit_lat
                        }
                        if st.permit_lon != nil {
                        permit.lon = st.permit_lon
                        }
                        if st.subvenue != nil {
                        permit.sub_venue = st.subvenue
                       
                        }
                        
                        
                        
                        taskDao.permitDao = permit
                        
                       
                  
                        
  
                    
                    
                    
                    }
                    
                    
                    

                    
                        taskDao.due_date =  st.due_date
                        taskDao.company.company_name = st.company_name
                        taskDao.company.email = st.email_address
                        taskDao.company.contact_provider_name = st.provided_by
                        taskDao.company.contact_provided_by = st.providedby_desig
                        taskDao.company.contact_designation = st.providedby_desig
                        taskDao.company.lat = st.latitude
                        taskDao.company.lon = st.longitude
                    
                        taskDao.company.activity_code = st.activity_code
                        taskDao.company.star = st.classification
                        taskDao.company.license_expire_date = st.license_expire_date
                        taskDao.company.license_info = st.license_info
                        taskDao.company.license_issue_date = st.license_issue_date
                         taskDao.list_id =  st.list_id
                         taskDao.list_title =  st.list_title
                         taskDao.company.phone_no = st.phone_no
                         taskDao.task_id = st.task_id
                         taskDao.task_name = st.task_name
                         taskDao.task_status = st.task_status
                         taskDao.priority = st.priority
                         taskDao.task_type = st.ins_type_name
                         taskDao.task_type_ar = st.ins_type_name_arb
                         taskDao.task_notes = st.task_notes
                         taskDao.parent_task_id = st.parent_task_id
                         taskDao.task_status = st.task_status
                         taskDao.company.address = st.address
                         taskDao.company.company_note = st.company_notes
                         taskDao.company.address_note = st.address_notes
                         taskDao.company.pro_name = st.pro_name
                         taskDao.company.pro_mobile = st.pro_contact
                         //print("Pro Mobile \(taskDao.company.pro_mobile)")
                         taskDao.company.email_pro = st.pro_email
                         taskDao.company.categoryCount = st.company_categoriesCount
                         taskDao.company.companyPermits = self.getPermits(taskDao.company.license_info)
                    
                    //print("Fetch Tasks ")
                    //print(taskDao.company.contact_designation)
                    //print("Provided name \(taskDao.company.contact_provider_name)")
                    //print("Provided By Desig \(taskDao.company.contact_provided_by)")
                    
                    
                    
                    
                       //  print("company address \(taskDao.company.address)")
                        // print("CompanyCategoryCount \(taskDao.company.categoryCount)")
                         //print("task status \(taskDao.task_status)")
                    
                         taskDao.task_name = st.task_name
                         allTasks.add(taskDao)
                     }

                    
        return allTasks
    }
    
    
    
    
    func fetchTasksByFilter(_ name : String , startDate : String , endDate : String, lang : String)-> NSMutableArray{
        let allTasks = NSMutableArray()
        var error : NSError?
        print("Fetch tasks")
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let predicate  = NSPredicate(format: "is_completed = %@", "0")
        taskRequest.predicate = predicate
        if name != "" && lang == "ar" {
        
        }
        else if name != "" && lang == "ar" {
        
        }
        if startDate != "" && endDate != "" {
        
        }
        
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(taskRequest)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for st in array as! [Tasks] {
            let taskDao = TaskDao()
            taskDao.company = CompanyDao()
            taskDao.task_id = st.task_id
            // taskDao.company.area_id =  st.area_id
            if st.auditor_id != nil {
                taskDao.auditor_Id! = st.auditor_id!
            }
            
            taskDao.auditor_name! = st.auditor_name!
            if st.company_id != nil {
                taskDao.company.company_id = st.company_id
            }
            taskDao.company_name = st.company_name
            taskDao.company.company_name_arabic = st.company_name_arabic
            if st.created_by != nil {
                taskDao.creator = st.created_by!
            }
            
            if st.priority != nil {
                taskDao.priority = st.priority
            }
            if st.pool != nil {
                taskDao.is_pool = st.pool
                
            }
            
            
            //                    if taskDao.additiona_email != nil {
            //                        task.additional_email = taskDao.additiona_email
            //                    }
            //                    if taskDao.external_notes != nil {
            //                        task.external_notes = taskDao.external_notes
            //                    }
            
            if st.additional_email != nil {
                taskDao.additiona_email = st.additional_email
            }
            
            if st.external_notes != nil {
                taskDao.external_notes = st.external_notes
            }
            
            if st.ins_type_name != nil {
                taskDao.ins_type_name = st.ins_type_name
            }
            if st.ins_type_name_arb != nil {
                taskDao.ins_type_name_arb = st.ins_type_name_arb
            }
            if st.type_name != nil {
                taskDao.company.type_name = st.type_name
            }
            
            if st.task_notes != nil {
                taskDao.task_notes = st.task_notes
                
            }
            if st.category_id != nil {
                taskDao.category_id = st.category_id
            }
            
            
            if st.waiting_for_audit != nil {
                taskDao.waiting_for_audit = st.waiting_for_audit
            }
            
            if st.inspection_type != nil {
                taskDao.inspection_type = st.inspection_type
                //print("Inspection type in fetch \(taskDao.inspection_type)")
            }
            
            if st.permitID != nil {
                let permit = PermitDao()
                permit.permitID = st.permitID
                if st.record_id != nil {
                    permit.id = st.record_id
                }
                
                if st.issue_date != nil {
                    permit.issue_date = st.issue_date
                }
                if st.expire_date != nil {
                    permit.expire_date = st.expire_date
                }
                
                if st.permit_type != nil {
                    permit.permit_type = st.permit_type
                }
                
                if st.permit_url != nil {
                    permit.url = st.permit_url
                }
                if st.permit_lat != nil {
                    permit.lat = st.permit_lat
                }
                if st.permit_lon != nil {
                    permit.lon = st.permit_lon
                }
                if st.subvenue != nil {
                    permit.sub_venue = st.subvenue
                    
                }
                
                
                
                taskDao.permitDao = permit
                
                
                
                
                
                
                
                
            }
            
            
            
            
            
            taskDao.due_date =  st.due_date
            taskDao.company.company_name = st.company_name
            taskDao.company.email = st.email_address
            taskDao.company.lat = st.latitude
            taskDao.company.lon = st.longitude
            taskDao.company.activity_code = st.activity_code
            taskDao.company.star = st.classification
            taskDao.company.license_expire_date = st.license_expire_date
            taskDao.company.license_info = st.license_info
            taskDao.company.license_issue_date = st.license_issue_date
            taskDao.list_id =  st.list_id
            taskDao.list_title =  st.list_title
            taskDao.company.phone_no = st.phone_no
            taskDao.task_id = st.task_id
            taskDao.task_name = st.task_name
            taskDao.task_status = st.task_status
            taskDao.priority = st.priority
            taskDao.task_type = st.ins_type_name
            taskDao.task_type_ar = st.ins_type_name_arb
            taskDao.task_notes = st.task_notes
            taskDao.parent_task_id = st.parent_task_id
            taskDao.task_status = st.task_status
            taskDao.company.address = st.address
            taskDao.company.company_note = st.company_notes
            taskDao.company.address_note = st.address_notes
            taskDao.company.pro_name = st.pro_name
            taskDao.company.pro_mobile = st.pro_contact
            taskDao.company.email_pro = st.pro_email
            taskDao.company.categoryCount = st.company_categoriesCount
            taskDao.company.companyPermits = self.getPermits(taskDao.company.license_info)
            
            
            print("company address \(taskDao.company.address)")
            print("CompanyCategoryCount \(taskDao.company.categoryCount)")
            print("task status \(taskDao.task_status)")
            
            taskDao.task_name = st.task_name
            allTasks.add(taskDao)
        }
        
        
        return allTasks
    }
    
    

    
    func fetchQuestionList(_ task_id : String) -> NSMutableArray
    {
    let questionList = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionList")
        let predicate = NSPredicate(format: "task_id = %@", task_id)
      request.predicate = predicate
      print(predicate, terminator: "")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(request)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        print("Questions  \(array!.count) on task \(task_id)")
        for list in array  as! [InspectionList] {
         
            let listDao = QuestionDao()
            if list.list_id != nil {
            listDao.list_id = list.list_id
                
            }
            if list.catg_id != nil {
                
                listDao.catg_id = list.catg_id
                
            }
            
            if list.audio != nil {
            listDao.audio = list.audio
            }
            if list.entry_Datetime != nil {
            listDao.entry_datetime = list.entry_Datetime
            }
            
            
            if list.image != nil {
            listDao.image = list.image
                
            }
            if list.violation_code != nil {
            listDao.violation_code = list.violation_code
            }
            
            
            if list.list_id != nil {
            listDao.list_id = list.list_id
            }
            
            if list.list_name != nil {
            listDao.list_name = list.list_name
            }
            
            if list.notes != nil {
            listDao.notes = list.notes
            }
            
            if list.q_id != nil {
            listDao.question_id = list.q_id
            }
            
            if list.question_desc != nil {
            listDao.question_desc = list.question_desc
            }
            if list.question_desc_en != nil {
             listDao.question_desc_en = list.question_desc_en
                
            }
            if list.task_id != nil {
            listDao.task_id = list.task_id
            }
            
            if list.violation_count != nil {
            listDao.violation_count = list.violation_count
            }
            if list.warning_count != nil {
            listDao.warning_count = list.warning_count
            }
            
            listDao.allOptions = self.fetchOptions(listDao.question_id)
            
            questionList.add(listDao)
            
            
            
            
            
        
            
        }
        
    return questionList
    }
    
    
    
    
    
    func fetchQuestionListByList_Id(_ list_id : String , task_id : String) -> NSMutableArray
    {
        let questionList = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionList")
        var predicate = NSPredicate(format: "list_id = %@ AND task_id = %@" , list_id,task_id)
        print(predicate)
        request.predicate = predicate
        print(predicate, terminator: "")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(request)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        print("Questions  \(array!.count) on list \(list_id)")
        for list in array  as! [InspectionList] {
            
            let listDao = QuestionDao()
            if list.list_id != nil {
                listDao.list_id = list.list_id
                
            }
            if list.audio != nil {
                listDao.audio = list.audio
            }
            if list.violation_code != nil {
                listDao.violation_code = list.violation_code
            }
            
            if list.catg_id != nil {
                
                listDao.catg_id = list.catg_id
                 print(list.catg_id)
                
            }
            else {
                print("catg id is nill")
                
            }

            if list.entry_Datetime != nil {
                listDao.entry_datetime = list.entry_Datetime
            }
            
            if list.image != nil {
                listDao.image = list.image
                
            }
            if list.list_id != nil {
                listDao.list_id = list.list_id
            }
            
            if list.list_name != nil {
                listDao.list_name = list.list_name
            }
            
            if list.notes != nil {
                listDao.notes = list.notes
            }
            
            if list.q_id != nil {
                listDao.question_id = list.q_id
            }
            
            if list.question_desc != nil {
                listDao.question_desc = list.question_desc
            }
            if list.question_desc_en != nil {
                listDao.question_desc_en = list.question_desc_en
            }
            if list.task_id != nil {
                listDao.task_id = list.task_id
            }
            
            if list.violation_count != nil {
                listDao.violation_count = list.violation_count
            }
            if list.warning_count != nil {
                listDao.warning_count = list.warning_count
            }
            
            listDao.allOptions = self.fetchOptions(listDao.question_id)
            
            questionList.add(listDao)
            
            
            
            
            
            
            
        }
        
        return questionList
    }

    
    
    func fetchQuestionListByQuestionListId(_ list_id : String) -> NSMutableArray
    {
        let questionList = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionList")
        let predicate = NSPredicate(format: "list_id = %@ AND task_id = 0" , list_id)
        request.predicate = predicate
        request.returnsDistinctResults = true;
        print(predicate, terminator: "")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(request)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        print("Questions  \(array!.count) on list \(list_id)")
        for list in array  as! [InspectionList] {
            
            let listDao = QuestionDao()
            if list.list_id != nil {
                listDao.list_id = list.list_id
                
            }
            if list.audio != nil {
                listDao.audio = list.audio
            }
            if list.entry_Datetime != nil {
                listDao.entry_datetime = list.entry_Datetime
            }
            
            
            if list.image != nil {
                listDao.image = list.image
                
            }
            if list.catg_id != nil {
                
               listDao.catg_id = list.catg_id
                
            }
            
            if list.violation_code != nil {
                listDao.violation_code = list.violation_code
            }
            if list.list_id != nil {
                listDao.list_id = list.list_id
            }
            
            if list.list_name != nil {
                listDao.list_name = list.list_name
            }
            
            if list.notes != nil {
                listDao.notes = list.notes
            }
            
            if list.q_id != nil {
                listDao.question_id = list.q_id
            }
            
            if list.question_desc != nil {
                listDao.question_desc = list.question_desc
            }
            if list.question_desc_en != nil {
                listDao.question_desc_en = list.question_desc_en
            }
            
            if list.violation_code != nil {
                listDao.violation_code = list.violation_code
                print("Getting Violation Code \(listDao.violation_code)")
            }
            

            if list.task_id != nil {
                listDao.task_id = list.task_id
            }
            
            if list.violation_count != nil {
                listDao.violation_count = list.violation_count
            }
            if list.warning_count != nil {
                listDao.warning_count = list.warning_count
            }
            
            listDao.allOptions = self.fetchOptions(listDao.question_id)
            
            questionList.add(listDao)
            
            
            
            
            
            
            
        }
        
        return questionList
    }
    

    
    
    
    func fetchOptions(_ questionId : String) -> NSMutableArray {
    let options = NSMutableArray()
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Options")
        request.returnsDistinctResults = true
        let sortDescriptor = NSSortDescriptor(key: "option_id", ascending: true)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors
        
    let predicate = NSPredicate(format: "q_id = %@", questionId)
        request.predicate = predicate
        
    var error : NSError?
    let array: [AnyObject]?
    do {
        array = try appDel.managedObjectContext?.fetch(request)
    } catch let error1 as NSError {
        error = error1
        array = nil
    }
      //  print("Optons on question \(questionId) are  \(array!.count)")

        for option in array as! [Options] {
          let optionDao = OptionDao()
            if option.description1 != nil {
            optionDao.option_description = option.description1
            }
            if option.entry_Datetime != nil {
            optionDao.entry_Datetime = option.entry_Datetime
                
            }
            
            if option.is_required != nil {
            optionDao.is_required = option.is_required
            }
            if option.option_id != nil {
            optionDao.option_id = option.option_id
                
            }
            
            if option.option_label != nil {
            
                optionDao.option_label = option.option_label
                
            }
            if option.option_type != nil {
            
                optionDao.option_type = option.option_type
            }
            
            if option.q_id != nil {
            
                optionDao.question_id = option.q_id
            }
            if option.violation_code != nil {
            
                optionDao.violation_code = option.violation_code
            }
            
            if option.is_selected != nil {
            optionDao.is_selected = (option.is_selected! as NSString).integerValue
            }
            
            if option.warning_duration != nil {
                optionDao.warning_duration = option.warning_duration
            
            }
            optionDao.allExraOptions = self.fetchExtraOptions(optionDao.option_id)
            
            options.add(optionDao)
            
        }// end of the for loop
        
        return options
        
        
    
    }
    func checkOptions(_ questionId : String) -> NSArray{
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Options")
      //  request.returnsDistinctResults = true
        
        let predicate = NSPredicate(format: "q_id = %@", questionId)
        request.predicate = predicate
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        return array! as NSArray
        
    }
    func checkExtraOptionsCount(_ optionId : String) -> NSArray{
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Extra_Options")
        let predicate =  NSPredicate(format: "option_id = %@", optionId)
        request.predicate = predicate
        request.returnsDistinctResults = true
        
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(request)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
       // print("options on option_id \(optionId) are \(array?.count)")

         return array! as NSArray
    }
    
    func fetchExtraOptions(_ optionId : String) -> NSMutableArray  {
    let extraOptions = NSMutableArray()
    let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Extra_Options")
    let predicate =  NSPredicate(format: "option_id = %@", optionId)
    request.predicate = predicate
    //request.returnsDistinctResults = true
        
    var error : NSError?
    let array: [AnyObject]?
    do {
        array = try self.appDel.managedObjectContext?.fetch(request)
    } catch let error1 as NSError {
        error = error1
        array = nil
    }
          //print("Exrra Optons on Option \(optionId) are  \(array!.count)")
              for eoption in array as! [Extra_Options] {
        let eOptionDao = ExtraOption()
            if eoption.e_option_id != nil {
            eOptionDao.extra_optionId = eoption.e_option_id
            
            }
                
            if eoption.entry_datetime != nil {
            eOptionDao.entry_datetime = eoption.entry_datetime
            }
            if eoption.is_selected != nil {
                eOptionDao.is_selected = NSNumber(value: (eoption.is_selected! as NSString).integerValue as Int)
                
               // print("Here you go with selected \(eOptionDao.is_selected)  \(eoption.is_selected!)")
                
           
            }
            
            if eoption.label != nil {
                eOptionDao.label = eoption.label
            }
            
            if eoption.value != nil {
            eOptionDao.value = eoption.value
            }
            if eoption.option_id != nil {
            eOptionDao.option_id = eoption.option_id
            }
            
            if eoption.valication_code != nil {
            eOptionDao.valication_code = eoption.valication_code
            }
            
            if eoption.violation_id != nil {
            eOptionDao.violation_id = eoption.violation_id
            }
            if eoption.violation_nam != nil {
            eOptionDao.violation_name = eoption.violation_nam
            }
            if eoption.entry_datetime != nil {
            eOptionDao.entry_datetime = eoption.entry_datetime
            }
            
            
            
            extraOptions.add(eOptionDao)
            
        }
        return extraOptions
        
    }
    
    
    func isCompaniesAddedAlready() -> Bool{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Companies")
        request.returnsDistinctResults = true
        //        let sortDescriptor = NSSortDescriptor(key: "option_id", ascending: true)
        //        let sortDescriptors = [sortDescriptor]
        //        request.sortDescriptors = sortDescriptors
        //
        //let predicate = NSPredicate(format: "task_id = %@", task_id)
       // request.predicate = predicate
        
        
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
            if array?.count > 0 {
                print("companies count \(array?.count)")
                return true
                
            }
            else {
                return false
                
            }
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        //  print("Optons on question \(questionId) are  \(array!.count)")
        
        
        return false
        
        
        
    }
    func isQuestionsAvailableOnTasks(_ task_id : String) -> Bool{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionList")
        request.returnsDistinctResults = true
//        let sortDescriptor = NSSortDescriptor(key: "option_id", ascending: true)
//        let sortDescriptors = [sortDescriptor]
//        request.sortDescriptors = sortDescriptors
//        
        let predicate = NSPredicate(format: "task_id = %@", task_id)
        request.predicate = predicate
        
        var error : NSError?
        let array: [AnyObject]?
        do {
            print(request)
            array = try appDel.managedObjectContext?.fetch(request)
            if array?.count > 0 {
            return true
                
            }
            else {
            return false
                
            }
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        //  print("Optons on question \(questionId) are  \(array!.count)")

        
        return false
        
        
    }
    
    func fetchAllInspectors() -> NSMutableArray{
        var error : NSError?
        var allInspectors = NSMutableArray()
        let inspectorsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Inspectors")
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(inspectorsRequest)
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for st in array as! [Inspectors]{
            let dao = InspectorDao()
            dao.id = st.inspector_id
            dao.name = st.inspector_Name
            allInspectors.add(dao)
            
        }// end of the for loop
        return allInspectors
        
        
    }
    func fetchAllOfflineTasks() -> NSMutableArray{
        var error : NSError?
        var allOfflineTask = NSMutableArray()
        let offlineRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineTasks")
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(offlineRequest)
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for st in array as! [OfflineTasks] {
        let oDao = OfflineDao()
          oDao.category_id = st.category_id
          oDao.company_id = st.company_id
          oDao.list_id = st.list_id
          oDao.taskdatetime = st.taskdatetime
          allOfflineTask.add(oDao)
            
            
        } // end of the for loop
        
        return allOfflineTask
        
    }
    
    func countAllPermits(){
        let permitsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllPermits")
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(permitsRequest)
            print(array?.count)
        } catch let error1 as NSError {
                       array = nil
        }
        print("There are \(array?.count) permits")
    }
    
    func countAllDrivers(){
        let permitsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PermitDrivers")
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(permitsRequest)
            print(array?.count)
        } catch let error1 as NSError {
            
            array = nil
        }
        print("There are \(array?.count) drivers")
    }
    
    
    func countAllVehicles(){
        let permitsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VehicleInfo")
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(permitsRequest)
            print(array?.count)
        } catch let error1 as NSError {
            
            array = nil
        }
        print("There are \(array?.count) vehicles")
    }
    

    func fetchAllPermitsByPermitId(_ permitID : String) -> NSMutableArray
    {
        var error : NSError?
        let allPermits = NSMutableArray()
        let permitsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllPermits")
        permitsRequest.fetchLimit = 10
        let predicate = NSPredicate(format:"permitID CONTAINS[cd] %@",permitID)
        print(predicate)
        permitsRequest.predicate = predicate
        
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(permitsRequest)
            print(array?.count)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for p in array as! [AllPermits] {
            let p1 = MainPermitDao()
            p1.permitID = p.permitID
            p1.appComment = p.appComment
            p1.businessLicense = p.businessLicense
            p1.contactNumber = p.contactNumber
            p1.coordinatorName = p.coordinatorName
            p1.endDate = p.endDate
            p1.expiryDate = p.expiryDate
            p1.issuedDate = p.issuedDate
            p1.startDate = p.startDate
            p1.organizerName = p.organizerName
            p1.subVenue = p.subvenue
            p1.campArea = p.campArea
            p1.permitType = p.permitType
            
            
            
            p1.drivers =  self.getDriversByPermitId(p.permitID!)
            p1.vehicles = self.getVehiclesByPermitId(p.permitID!)
            
            allPermits.add(p1)
            
            
            
        }// End of the for loop
        
        return allPermits
        
    } // end of the
    


    
    func fetchAllPermitsByLicenseNo(_ licenseNo : String) -> NSMutableArray
    {
        var error : NSError?
        let allPermits = NSMutableArray()
        let permitsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllPermits")
        permitsRequest.fetchLimit = 10
        let predicate = NSPredicate(format:"businessLicense CONTAINS[cd] %@",licenseNo)
        print(predicate)
        permitsRequest.predicate = predicate
        
        let array: [AnyObject]?
        do {
        array = try self.appDel.managedObjectContext?.fetch(permitsRequest)
         print(array?.count)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for p in array as! [AllPermits] {
        let p1 = MainPermitDao()
        p1.permitID = p.permitID
        p1.appComment = p.appComment
        p1.businessLicense = p.businessLicense
        p1.contactNumber = p.contactNumber
        p1.coordinatorName = p.coordinatorName
        p1.endDate = p.endDate
        p1.expiryDate = p.expiryDate
        p1.issuedDate = p.issuedDate
        p1.startDate = p.startDate
        p1.organizerName = p.organizerName
        p1.subVenue = p.subvenue
        p1.campArea = p.campArea
        p1.permitType = p.permitType

        p1.drivers =  self.getDriversByPermitId(p1.permitID!)
        p1.vehicles = self.getVehiclesByPermitId(p1.permitID!)
            
            
        allPermits.add(p1)
            
            
        
        }// End of the for loop
        
        return allPermits
    
    } // end of the
    
//    func getDriversByPermitId(permitId : String) -> NSMutableArray{
//        var error : NSError?
//        let allDrivers = NSMutableArray()
//        let driverRequest = NSFetchRequest(entityName: "PermitDrivers")
//         let predicate = NSPredicate(format:"permitID CONTAINS[cd] %@",permitId)
//         driverRequest.predicate = predicate
//        
//        let array: [AnyObject]?
//        do {
//            array = try self.appDel.managedObjectContext?.executeFetchRequest(driverRequest)
//        } catch let error1 as NSError {
//            error = error1
//            array = nil
//        }
//
//        
//        for d in array as! [PermitDrivers] {
//        let driver = DriversDao()
//           driver.permitID = d.permitID
//           driver.driver_name = d.driver_name
//           driver.drLicExpiry = d.drLicExpiry
//           driver.drLicIssue = d.drLicIssue
//           driver.drLicNo = d.drLicNo
//           driver.isFirstAid = d.isFirstAid
//           driver.drComment = d.drComment
//           driver.nationality = d.nationality
//           allDrivers.addObject(driver)
//           
//            
//        }// end of the for loop
//        
//    return allDrivers
//        
//    }// end of the fuction
//    
    
    func getDriversByPermitId(_ permitId : String) -> NSMutableArray{
        var error : NSError?
        let allDrivers = NSMutableArray()
        let driverRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PermitDrivers")
        let predicate = NSPredicate(format:"permitID CONTAINS[cd] %@",permitId)
        driverRequest.predicate = predicate
        
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(driverRequest)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        
        
        for d in array as! [PermitDrivers] {
            let driver = DriversDao()
            driver.permitID = d.permitID
            driver.driver_name = d.driver_name
            driver.drLicExpiry = d.drLicExpiry
            driver.drLicIssue = d.drLicIssue
            driver.drLicNo = d.drLicNo
            driver.isFirstAid = d.isFirstAid
            driver.drComment = d.drComment
            driver.nationality = d.nationality
            
            
            allDrivers.add(driver)
            
        }// end of the for loop
        print("Permit \(permitId) has \(allDrivers.count) drivers")
        return allDrivers
        
    }// end of the fuction
    

    func getVehiclesByPermitId(_ permitId : String) -> NSMutableArray{
        var error : NSError?
        let allVehicles = NSMutableArray()
        let permitRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VehicleInfo")
        let predicate = NSPredicate(format:"permitID CONTAINS[cd] %@",permitId)
        permitRequest.predicate = predicate
        
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(permitRequest)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        
        
        for v in array as! [VehicleInfo] {
            let vehicle = VehicleDao()
           vehicle.permitID = v.permitID
           vehicle.busLicExpiryDate = v.busLicExpiryDate
           vehicle.licExpiry = v.licExpiry
           vehicle.licIssue = v.licIssue
           vehicle.modelYear = v.modelYear
           vehicle.ownerName = v.ownerName
           vehicle.permitExpiry = v.permitExpiry
           vehicle.placeofIssue = v.placeofIssue
           vehicle.plateNo = v.plateNo
           vehicle.tradeMarkname = v.tradeMarkname
           vehicle.vehComment = v.vehComment
           vehicle.vehicleType = v.vehicleType
            
           allVehicles.add(vehicle)
           //print("Adding \(vehicle.vehicleType) vehicle to \(permitId)")
            
        }// end of the for loop
        
        return allVehicles
        
    }// end of the fuction
    

    
    
    
    
    
    func fetchViolations() -> NSMutableArray{
    
        let allViolations = NSMutableArray()
        var error : NSError?
        
        let violationsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Violations_History")
//        let predicate  = NSPredicate(format: "is_completed = %@", "0")
//        taskRequest.predicate = predicate
//     
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(violationsRequest)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for st in array as! [Violations_History] {
            let violationsDao = ViolationHistoryDao()
           
            
            if st.company_id != nil {
            violationsDao.company_id = st.company_id
            }
            
            if st.offencecode != nil {
            violationsDao.offencecode = st.offencecode
            }
            if st.offencecodedescription != nil {
            violationsDao.violation_name = st.offencecodedescription
            }
            if st.offencecodedescription_arb != nil {
            violationsDao.violation_name_ar = st.offencecodedescription_arb
            }
            
            if st.inspectiondate != nil {
            violationsDao.inspectiondate = st.inspectiondate
            }
            
            
            
//            
//            dbObject.company_id = singleViolations.company_id
//            dbObject.offencecode = singleViolations.offencecode
//            dbObject.offencecodedescription = singleViolations.violation_name
//            dbObject.offencecodedescription_arb = singleViolations.violation_name_ar
//            dbObject.inspectiondate = singleViolations.inspectiondate
//            
            
          allViolations.add(violationsDao)
            
        }
        
        
        return allViolations
        
    }
    
    
    func addOfflineTask(_ company_id : String, taskdate_time : String , list_id : String , catg_id : String) {
        let entity = NSEntityDescription.entity(forEntityName: "OfflineTasks", in: appDel.managedObjectContext!)
        let task = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! OfflineTasks
        task.company_id = company_id
        task.taskdatetime = taskdate_time
        task.list_id = list_id
        task.category_id = catg_id
        do {
            try self.appDel.managedObjectContext?.save()
        } catch let error1 as NSError {
            //error = error1
            print(error1)
            
        }
        

        
        
    } // end of the addOfflineTask
    
    
    
    
    func addOfflineTaskStatus(_offline : TaskResultsDao) {
        
        let entity = NSEntityDescription.entity(forEntityName: "OfflineTasksStatus", in: appDel.managedObjectContext!)
        let offlineTasks = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! OfflineTasksStatus
        if _offline.task_id != nil {
            offlineTasks.task_id = _offline.task_id
        }//
        
        if _offline.json_string != nil {
            offlineTasks.json_string = _offline.json_string
            
        }
        
        if _offline.unique_id != nil {
            offlineTasks.unique_id = _offline.unique_id
        }
        if _offline.entry_datetime != nil {
            
            offlineTasks.entry_date = _offline.entry_datetime
        }
        if _offline.date != nil {
            offlineTasks.date = _offline.date
            
            
        }
        
        if _offline.submit_datetime != nil {
            offlineTasks.submit_datetime = _offline.submit_datetime
            
        }
        if _offline.server_reponse != nil {
            offlineTasks.server_reponse = _offline.server_reponse
            
            
        }
        offlineTasks.isSubmitted = NSNumber(integerLiteral: 0)
        offlineTasks.type = NSNumber(integerLiteral: _offline.type!)
        
        
        do {
            try self.appDel.managedObjectContext?.save()
            print("data saved with offlince \(_offline.unique_id)")
        } catch let error1 as NSError {
            //error = error1
            print(error1)
            
        }
    }
    
    func updateOfflineTasks(task_id : String , server_reponse : String, submitted_time : String) {
        var error : NSError?
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineTasksStatus")
        //let arr = task_id.split(separator: ",")
        // print(unique_id)
        let predicate = NSPredicate(format: "task_id = %@", task_id)
        
        
        print(predicate)
        
        taskRequest.predicate = predicate
        let array = (try! self.appDel.managedObjectContext?.fetch(taskRequest)) as! [OfflineTasksStatus]
        print("Array Count \(array.count)")
        if array.count > 0 {
            for a in array as [OfflineTasksStatus] {
                let dbtask = a
                dbtask.server_reponse = server_reponse
                dbtask.submit_datetime = submitted_time
                dbtask.isSubmitted = 1
                
                
                do {
                    try self.appDel.managedObjectContext?.save()
                } catch let error1 as NSError {
                    error = error1
                }
                if error != nil {
                    print(error, terminator: "")
                }//
                else {
                    print("offfline task updated from the detail")
                    
                }// end of the else
            }// end of the for loop
            
            
            
        } // end of the count
        else {
            print("No Records found in databaase with predicate \(predicate)")
            
        }
    }// end of the
    
    
    
    func updateOfflineTasks(task_id : String , server_reponse : String, submitted_time : String , type : Int) {
        var error : NSError?
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineTasksStatus")
        //let arr = task_id.split(separator: ",")
        // print(unique_id)
        let predicate1 = NSPredicate(format: "task_id = %@", task_id)
        let predicate2 = NSPredicate(format: "type = %@",NSNumber(integerLiteral: type))
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicate1, predicate2])
        
        
        print(andPredicate)
        
        taskRequest.predicate = andPredicate
        let array = (try! self.appDel.managedObjectContext?.fetch(taskRequest)) as! [OfflineTasksStatus]
        if array.count > 0 {
            let dbtask = array[0]
            dbtask.server_reponse = server_reponse
            dbtask.submit_datetime = submitted_time
            dbtask.isSubmitted = 1
            
            
            do {
                try self.appDel.managedObjectContext?.save()
            } catch let error1 as NSError {
                error = error1
            }
            if error != nil {
                print(error, terminator: "")
            }
            else {
                print("offfline task updated from the detail")
                
            }
            
            
        } // end of the count
        else {
            print("No Records found in databaase with predicate \(andPredicate)")
            
        }
    }// end of the
    
    
    
    func getAllUnSubmittedTasks()-> NSMutableArray{
        let unSubmittedTasks = NSMutableArray()
        var error : NSError?
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineTasksStatus")
        let predicate = NSPredicate(format: "isSubmitted=0")
        taskRequest.predicate = predicate
        
        let array : [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(taskRequest)
            for st in array as! [OfflineTasksStatus] {
                var result = TaskResultsDao()
                result.unique_id = st.unique_id
                result.task_id = st.task_id
                // print("Task id \(result.task_id)")
                result.entry_datetime = st.entry_date
                result.json_string = st.json_string
                if st.type != nil {
                    result.type = st.type?.intValue
                }
                result.type = st.type as! Int
                result.submit_datetime = st.submit_datetime
                if st.isSubmitted != nil {
                    result.isSubmitted = Int(truncating: st.isSubmitted!)
                }
                unSubmittedTasks.add(result)
                
            }// end of the for loop
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        
        return unSubmittedTasks
        
        
    }// end of the method
    
    
    func fetchAllOfflineTasksStatus()-> NSMutableArray{
        let allOfflineTaskStatus = NSMutableArray()
        var error : NSError?
        
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineTasksStatus")
        let sectionSortDescriptor = NSSortDescriptor(key: "entry_date", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        taskRequest.sortDescriptors = sortDescriptors
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(taskRequest)
            for st in array as! [OfflineTasksStatus] {
                var result = TaskResultsDao()
                result.json_string = st.json_string
                //   print("Task id \(st.task_id ) \(st.json_string) entry date \(st.entry_date) server \(st.server_reponse) submit date \(st.submit_datetime) Server Response \(st.server_reponse) unique_id \(st.unique_id) isSubmitted \(st.isSubmitted) type \(st.type) DATE \(st.date)")
                //result.isSubmitted = st.isSubmitted as! Int
                result.server_reponse = st.server_reponse
                result.submit_datetime = st.submit_datetime
                result.unique_id = st.unique_id
                result.task_id = st.task_id
                if st.isSubmitted != nil {
                    result.isSubmitted = st.isSubmitted!.intValue
                }
                result.entry_datetime = st.entry_date
                
                allOfflineTaskStatus.add(result)
                
                
                
            } // end of the for loop
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        
        return allOfflineTaskStatus
        
    }
    
    
    
    
    func addOfflineTask(_offline : TaskResultsDao) {
        
        let entity = NSEntityDescription.entity(forEntityName: "OfflineTasksStatus", in: appDel.managedObjectContext!)
        let offlineTasks = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! OfflineTasksStatus
        if _offline.task_id != nil {
           offlineTasks.task_id = _offline.task_id
        }//
        if _offline.server_reponse != nil {
            offlineTasks.server_reponse = _offline.server_reponse
        }
        
        
    }// end of the addOfflineTasks
    
    func addTask(_ taskDao : TaskDao){
        let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: appDel.managedObjectContext!)
        let task = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! Tasks
        task.task_id = taskDao.task_id
        if taskDao.company.area_id != nil {
            task.area_id = taskDao.company.area_id
        }
        if taskDao.auditor_Id != nil {
        task.auditor_id = taskDao.auditor_Id!
        }
        if taskDao.auditor_name != nil {
            task.auditor_name = taskDao.auditor_name!
        }
        if taskDao.company.company_id != nil {
            task.company_id = taskDao.company.company_id!
        }
        if taskDao.company_name != nil {
            task.company_name = taskDao.company_name
        }
        if taskDao.company.company_name_arabic != nil {
            task.company_name_arabic = taskDao.company.company_name_arabic
        }
        if taskDao.creator != nil {
            task.created_by = taskDao.creator!
        }
        if taskDao.category_id != nil {
            task.category_id = taskDao.category_id
        }
        if taskDao.is_pool != nil {
            task.pool = taskDao.is_pool
        }
        if taskDao.taskOwner != nil {
            //task.owner = taskDao.taskOwner
            task.ownerID = taskDao.taskOwner
            
        }
        if taskDao.additiona_email != nil {
        task.additional_email = taskDao.additiona_email
        }
        if taskDao.uniqueid != nil {
        task.uniqueid = taskDao.uniqueid
        }
        
        if taskDao.is_submitted != nil {
            task.is_Submitted = taskDao.is_submitted
        }

        if taskDao.external_notes != nil {
        task.external_notes = taskDao.external_notes
        }
        
        if taskDao.due_date != nil {
            task.due_date = taskDao.due_date
        }
        if taskDao.company.email != nil {
            task.email_address = taskDao.company.email
        }
        if taskDao.waiting_for_audit != nil {
            task.waiting_for_audit = taskDao.waiting_for_audit
        }
        
        task.inspector_id = self.appDel.user.user_id
        if taskDao.company.lat != nil {
            task.latitude = taskDao.company.lat
        }
        if taskDao.company.lon != nil {
            task.longitude = taskDao.company.lon
        }
        if taskDao.company.license_expire_date != nil {
            task.license_expire_date = taskDao.company.license_expire_date
        }
        if taskDao.company.license_info != nil {
            task.license_info = taskDao.company.license_info
        }
        if taskDao.company.license_issue_date != nil {
            task.license_issue_date = taskDao.company.license_issue_date
        }
        if taskDao.list_id != nil {
            task.list_id = taskDao.list_id
        }
        if taskDao.list_title != nil {
            task.list_title = taskDao.list_title
        }
        if taskDao.company.phone_no != nil {
            task.phone_no = taskDao.company.phone_no
        }
        if taskDao.task_id != nil {
            task.task_id = taskDao.task_id
        }
        if taskDao.task_name != nil {
            task.task_name = taskDao.task_name
        }
        if taskDao.task_status != nil {
            task.task_status = taskDao.task_status
        }
        if taskDao.task_name != nil {
            
            task.task_name = taskDao.task_name
        }
        if taskDao.isSubVenue != nil {
            task.isSubvenue = taskDao.isSubVenue
        }
        
        if taskDao.parent_task_id != nil {
            
            task.parent_task_id = taskDao.parent_task_id
        }
        
      //  print("Co-Inspectors in addTask \(taskDao.coninspectors)")
        
        if taskDao.coninspectors != nil {
            task.coninspectors = taskDao.coninspectors
            
        }
        if taskDao.company.company_name != nil {
            task.company_name = taskDao.company.company_name
        }
        if taskDao.company.address != nil {
        task.address = taskDao.company.address
        }
        
        
        if taskDao.priority != nil {
        task.priority = taskDao.priority
        }
        if taskDao.inspection_type != nil {
            task.inspection_type = taskDao.inspection_type
        }
        
        if taskDao.company.pro_mobile != nil {
        task.pro_contact = taskDao.company.pro_mobile
        }
        if taskDao.company.pro_name != nil {
        task.pro_name = taskDao.company.pro_name
        }
        
        if taskDao.company.email_pro != nil {
        task.pro_email = taskDao.company.email_pro
        }
        
        //print(taskD.company.contact_designation)
        //print(taskD.company.contact_provider_name)
        //
        //print(taskD.company.contact_provided_by)
        if taskDao.company.contact_designation != nil {
            task.pro_designition = taskDao.company.contact_designation
            
        }
        if taskDao.company.contact_provided_by != nil {
            
            task.providedby_desig = taskDao.company.contact_provided_by
            
            
            
            
        }
        if taskDao.company.contact_provider_name != nil {
            
            task.provided_by = taskDao.company.contact_provider_name
        }
        
        
        
        
        if  taskDao.ins_type_name != nil {
        task.ins_type_name = taskDao.ins_type_name
        }
        
        
        if  taskDao.ins_type_name_arb != nil {
            task.ins_type_name_arb = taskDao.ins_type_name_arb
        }
        
        if taskDao.task_notes != nil {
        
            task.task_notes = taskDao.task_notes
        
        }
        
        if taskDao.permitDao != nil {
        
            if taskDao.permitDao?.id != nil {
               task.record_id = taskDao.permitDao?.id
            }
            
            if taskDao.permitDao?.permitID != nil {
            task.permitID = taskDao.permitDao?.permitID
            }
            
            if taskDao.permitDao?.issue_date != nil {
            task.issue_date = taskDao.permitDao?.issue_date
            }
            if taskDao.permitDao?.expire_date != nil {
            task.expire_date = taskDao.permitDao?.expire_date
            }
            
            if taskDao.permitDao?.permit_type != nil {
            task.permit_type = taskDao.permitDao?.permit_type
            }
            
            
            
        }  // end of the permitDao
       
        
        
//        @NSManaged var priority: String?
//        @NSManaged var ins_type_name: String?
//        @NSManaged var ins_type_name_arb: String?
//        @NSManaged var inspection_type: String?
//        @NSManaged var parent_task_id: String?
//        

        
        task.is_completed = "0"
        // var error : NSError?
        
        do {
            try self.appDel.managedObjectContext?.save()
        } catch let error1 as NSError {
            //error = error1
            print(error1)
            
        }
        
        
        
        
    }// end of the addTask
    func addSubvenues(_ allSubvenues : NSMutableArray){
    //let privateContext  = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
   // privateContext.parentContext = self.appDel.managedObjectContext
        
    //privateContext.performBlock {
        
        
        for a in 0 ..< allSubvenues.count {
        let subVenue = allSubvenues.object(at: a) as! SubVenueDao
            
        let entity = NSEntityDescription.entity(forEntityName: "Subvenues", in: self.appDel.managedObjectContext!)
           let managedList = NSManagedObject(entity: entity!, insertInto: self.appDel.managedObjectContext) as! Subvenues
           managedList.id = subVenue.subVenue_id
           managedList.subVenue = subVenue.subVenue
           managedList.latitude = subVenue.latitude
           managedList.longitude = subVenue.longitude
           managedList.licenseNumber = subVenue.licenseNumber
            print(managedList.subVenue)
            
        } // end of the for loop
        do {
            try self.appDel.managedObjectContext!.save()
            //print("SubVenues added \(allSubvenues.count)")
        } catch let error as NSError {
           print(error)
        }
        
       //
    //} // end of the perform block
        
    }
    
    
    func addInspectors(allInspectors : NSMutableArray){
       self.deleteAllInspector()
        for a in 0  ..< allInspectors.count  {
            let inspector = allInspectors.object(at: a) as! InspectorDao
            let entity = NSEntityDescription.entity(forEntityName: "Inspectors", in: self.appDel.managedObjectContext!)
            let managedList = NSManagedObject(entity: entity!, insertInto: self.appDel.managedObjectContext!) as! Inspectors
            managedList.inspector_id = inspector.id
            managedList.inspector_Name = inspector.name
            print("Adding \(inspector.name)")
            
        } // end of the for loop
        self.saveAllData()
        
    }
    
    func addInspectionListMain(_ allItems : NSMutableArray) {
//        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
//        
//        managedObjectContext.performBlock { // runs asynchronously
//
        
        for a in 0  ..< allItems.count  {
             
            let list = allItems.object(at: a) as! InspectionMainListDao
            let entity = NSEntityDescription.entity(forEntityName: "InspectionMainList", in: self.appDel.managedObjectContext!)
            let managedList = NSManagedObject(entity: entity!, insertInto: self.appDel.managedObjectContext!) as! InspectionMainList
            managedList.list_title = list.list_title
            managedList.id = list.id
            managedList.entry_datetime = list.entry_datetime
            managedList.category_id = list.category_id
            //}
            
            
            
        } // end of the loop
        
//        do {
//            try self.appDel.managedObjectContext?.save()
//        } catch let error1 as NSError {
//            //error = error1
//            print(error1)
//            
//        }

       // }
       // managedObjectContext.reset()
    }

    func setupFileDownload(_ permitDao : PermitDao){
        if permitDao.permitID != nil && permitDao.url != nil {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let folderPath =  documentDirectoryPath + "/permits"
        
        let fileManager = FileManager()
        
        
        var fileName : String = "\(permitDao.permitID!).pdf"
        let fullFilePath = documentDirectoryPath + "/permits/\(fileName)"
        
        
        
        if fileManager.fileExists(atPath: fullFilePath) {
            do {
           try fileManager.removeItem(atPath: fullFilePath)
            
            } catch let error1 as NSError {
            print(error1)
            }
         // FILE PRESENT CHANGE ///
            //print("Download file \(fullFilePath)")
            let fileSession = SessionFileDownLoader()
            fileSession.del = self
            fileSession.permitDao = permitDao
            if permitDao.url != nil {
                print(permitDao.url!)
                
                fileSession.setupSessionDownload(Constants.downloadUrl + permitDao.url!)
                
            
            //print("File present dont download \(fullFilePath)")
            }
            }
        else {
        //print("Download file \(fullFilePath)")
        let fileSession = SessionFileDownLoader()
        fileSession.del = self
        fileSession.permitDao = permitDao
        if permitDao.url != nil {
        print(permitDao.url!)
        
        fileSession.setupSessionDownload(Constants.downloadUrl + permitDao.url!)
        }
            
            }
            
            }// check nil if
        
    }
    
    func updateProgress(_ progress: Float, identity: String) {
        
        
    }
    func fileDownload(_ url: URL) {
        
    }
    
    func checkIfPermitAlreadyDownloaded(_ permitId : String) -> Bool{
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        
        var fileName : String = "\(permitId).pdf"
        let fullFilePath = documentDirectoryPath + "/permits/\(fileName)"
        let fileManager = FileManager()

        
        
        if fileManager.fileExists(atPath: fullFilePath) {
          //  print("File present 000 \(fullFilePath)")
            do {
            try fileManager.removeItem(atPath: fullFilePath)
                
            } catch let error as NSError {
            print(error)
            }
        return true
        }
        else {
            //print("file not found for \(permitId)")
        return false
        }
    }
    func checkIfPermitExists(_ permit_id : String)->Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Permits")
        let predicate = NSPredicate(format: "permitID = %@", permit_id)
       // print(predicate)
        request.predicate = predicate
        
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
        } catch let error1 as NSError {
            
            array = nil
            return false
        }
        if array?.count > 0 {
        return true
        }
        else {
        return false
        }

    }
    
    func addCountries(_ countries : NSMutableArray){
        var error : NSError?
        if self.fetchAllCountries().count > 0 {
            return
        }
        for a in 0  ..< countries.count  {
            let country = countries.object(at: a) as! CountryDao
            let entity = NSEntityDescription.entity(forEntityName: "Country", in: appDel.managedObjectContext!)
            let managed = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! Country
            managed.countryCode = country.country_code
            managed.countryName = country.country_name
            managed.countryNameAr = country.country_name_ar
            managed.dnrdCode = country.country_dndrd_code
            
            
            
        }// end of the for loop
        
        saveAllData()
        
        
        //        do {
        //            try self.appDel.managedObjectContext!.save()
        //        } catch let error1 as NSError {
        //            error = error1
        //        }
        
        
    }// end of the addCategories
    
    func addPermits(_ permits : NSMutableArray){
        for a in 0 ..< permits.count  {
        let permitDao = permits.object(at: a) as! PermitDao
            if self.checkIfPermitExists(permitDao.permitID!) {
//                if self.checkIfPermitAlreadyDownloaded(permitDao.permitID!) {
//                    
//                   // self.setupFileDownload(permitDao)
//                }
//                else {
//                   // self.setupFileDownload(permitDao)
//
//                }
            }
            else {
        let entity = NSEntityDescription.entity(forEntityName: "Permits", in: appDel.managedObjectContext!)
        let permit = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! Permits
         permit.permitID = permitDao.permitID
         permit.permit_type = permitDao.permit_type
         permit.issue_date = permitDao.issue_date
         permit.expire_date = permitDao.expire_date
         permit.license_info = permitDao.license_info
         permit.record_id = permitDao.id
         permit.permit_url = permitDao.url
         permit.lat = permitDao.lat
         permit.lon = permitDao.lon
                print("Permit added")
            self.setupFileDownload(permitDao)
                
                
         
            do {
                try self.appDel.managedObjectContext?.save()
            } catch let error1 as NSError {
                //error = error1
                print(error1)
                
            }
            
         print("Permit Added for company \(permitDao.license_info)")
            } // end for permit processing
            
            
            } // end of the for loop
        
        
    } // end of the addPermits
    
    
    func addCategories(questionCategories : NSMutableArray){
        if self.fetchQuestionCategories().count > 0 {
            return
        }
        for catg in questionCategories as! [QuestionCategoryDao]  {
            let entity = NSEntityDescription.entity(forEntityName: "QuestionCategories", in: appDel.managedObjectContext!)
            let questionCategory = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! QuestionCategories
            if catg.catg_id != nil {
                questionCategory.catg_id = catg.catg_id
            }
            if catg.catg_name != nil {
                questionCategory.catg_name_eng = catg.catg_name
                
                
            }
            if catg.catg_name_ar != nil {
                questionCategory.catg_name_ar = catg.catg_name_ar
                
            }
            
        
        
        do {
            try self.appDel.managedObjectContext?.save()
        } catch let error1 as NSError {
            //error = error1
            print(error1)
            
        }
            }// end of the for loop
        
    }
    func addTasks(_ tasksArray : NSMutableArray){
        for a in 0  ..< tasksArray.count  {
            let taskDao = tasksArray.object(at: a) as! TaskDao
            let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: appDel.managedObjectContext!)
            let task = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! Tasks
              task.task_id = taskDao.task_id
            if taskDao.company.area_id != nil {
            task.area_id = taskDao.company.area_id
            }
            if taskDao.auditor_Id != nil {
            task.auditor_id = taskDao.auditor_Id!
            }
            if taskDao.auditor_name != nil {
            task.auditor_name = taskDao.auditor_name!
            }
            if taskDao.company.company_id != nil {
              task.company_id = taskDao.company.company_id!
            }
            if taskDao.company_name != nil {
            task.company_name = taskDao.company_name
            }
            if taskDao.company.company_name_arabic != nil {
            task.company_name_arabic = taskDao.company.company_name_arabic
            }
            if taskDao.creator != nil {
            task.created_by = taskDao.creator!
            }
            if taskDao.parent_zone_status != nil {
              task.parent_zone_status = taskDao.parent_zone_status
                
            }
            
            if taskDao.due_date != nil {
            task.due_date = taskDao.due_date
              print("Due date is \(taskDao.due_date)")
            }
            if taskDao.company.email != nil {
            task.email_address = taskDao.company.email
            }
            if taskDao.additiona_email != nil {
                task.additional_email = taskDao.additiona_email
            }
            if taskDao.external_notes != nil {
                task.external_notes = taskDao.external_notes
            }
            if taskDao.isSubVenue != nil {
            task.isSubvenue = taskDao.isSubVenue
            }
            if taskDao.subVenueName != nil {
            task.subvenue = taskDao.subVenueName
            }
            if taskDao.is_pool != nil {
            task.pool = taskDao.is_pool
            }
            task.isZoneTask = taskDao.isZoneTask as NSNumber
            
            
//            var zone_id : String?
//            var zone_name : String?
//            var zone_startDate : String?
//            var zone_expiryDate : String?
//            var isZoneTask : Int =  0 // 0 means not a zone tasks // 1 means its zone task
//            var zoneStatus : String?
//            
//            
            
            if taskDao.zone_id != nil {
            task.zone_id = taskDao.zone_id
            }
            
            if taskDao.zone_name != nil {
            task.zone_name_eng = taskDao.zone_name
                
            }
            if taskDao.is_submitted != nil {
                task.is_Submitted = taskDao.is_submitted
            }

            
            if taskDao.zone_name_ar != nil {
            
            task.zone_name_ar = taskDao.zone_name_ar
            }
            
            
            if taskDao.zoneStatus  != nil {
            task.zone_status = taskDao.zoneStatus
            }
            
            if taskDao.zone_startDate != nil {
            task.zone_startDate = taskDao.zone_startDate
            
            }
            
            if taskDao.zone_expiryDate != nil {
            task.zone_expiryDate = taskDao.zone_expiryDate
            }
        
            
            
              task.inspector_id = self.appDel.user.user_id
            if taskDao.company.lat != nil {
            task.latitude = taskDao.company.lat
            }
            if taskDao.company.lon != nil {
            task.longitude = taskDao.company.lon
            }
            if taskDao.company.license_expire_date != nil {
            task.license_expire_date = taskDao.company.license_expire_date
            }
            task.company_categoriesCount = NSNumber(value: Int32(taskDao.company.categories.count) as Int32)
            
            if taskDao.company.license_info != nil {
            task.license_info = taskDao.company.license_info
            }
            if taskDao.waiting_for_audit != nil {
            task.waiting_for_audit = taskDao.waiting_for_audit
            }
            if taskDao.company.license_issue_date != nil {
              task.license_issue_date = taskDao.company.license_issue_date
            }
            if taskDao.list_id != nil {
            task.list_id = taskDao.list_id
            }
            if taskDao.list_title != nil {
            task.list_title = taskDao.list_title
            }
            if taskDao.company.phone_no != nil {
            task.phone_no = taskDao.company.phone_no
            }
            if taskDao.company.activity_code != nil {
            task.activity_code = taskDao.company.activity_code
            }
            if taskDao.company.star != nil {
            task.classification = taskDao.company.star
            }
            
            
            if taskDao.company.company_note != nil {
            task.company_notes = taskDao.company.company_note
            }
            if taskDao.company.address_note != nil {
            task.address_notes = taskDao.company.address_note
            }
            if taskDao.company.pro_name != nil {
            task.pro_name = taskDao.company.pro_name
            }
            if taskDao.company.pro_mobile != nil {
            task.pro_contact = taskDao.company.pro_mobile
            }
            if taskDao.company.email_pro != nil {
            task.pro_email = taskDao.company.email_pro
            }
            
            
            
            if taskDao.task_id != nil {
            task.task_id = taskDao.task_id
            }
            if taskDao.task_name != nil {
            task.task_name = taskDao.task_name
            }
            if taskDao.task_status != nil {
            task.task_status = taskDao.task_status
            }
            if taskDao.task_name != nil {

            task.task_name = taskDao.task_name
            }
            
            if taskDao.priority != nil {
                task.priority = taskDao.priority
            }
            
            if  taskDao.ins_type_name != nil {
                task.ins_type_name = taskDao.ins_type_name
            }
            
            if taskDao.parent_task_id != nil {
            
            task.parent_task_id = taskDao.parent_task_id
            }
            if  taskDao.ins_type_name_arb != nil {
                task.ins_type_name_arb = taskDao.ins_type_name_arb
            }
            
            if taskDao.task_notes != nil {
                
                task.task_notes = taskDao.task_notes
                
            }
            
    
            if taskDao.permitDao != nil {
                
                if taskDao.permitDao?.id != nil {
                    task.record_id = taskDao.permitDao?.id
                }
                
                if taskDao.permitDao?.permitID != nil {
                    task.permitID = taskDao.permitDao?.permitID
                }
                
                if taskDao.permitDao?.issue_date != nil {
                    task.issue_date = taskDao.permitDao?.issue_date
                }
                if taskDao.permitDao?.expire_date != nil {
                    task.expire_date = taskDao.permitDao?.expire_date
                }
                
                if taskDao.permitDao?.permit_type != nil {
                    task.permit_type = taskDao.permitDao?.permit_type
                }
                
                if taskDao.permitDao?.lat != nil {
                
                    task.permit_lat = taskDao.permitDao?.lat
                    
                }
                if taskDao.permitDao?.lon != nil {
                
                    task.permit_lon = taskDao.permitDao?.lon
                }
                if taskDao.permitDao?.sub_venue != nil {
                
                    task.subvenue = taskDao.permitDao?.sub_venue
                    
                }
                
                
                
            }  // end of the permitDao
            

            
            
            if taskDao.inspection_type != nil {
            task.inspection_type = taskDao.inspection_type
           //print("Inspection type in database \(task.inspection_type)")
            }
           
            
            
            
            if taskDao.company.company_name != nil {
            task.company_name = taskDao.company.company_name
            }
            if taskDao.company.address != nil {
            task.address = taskDao.company.address
            }
            if taskDao.company.type_name != nil {
            task.type_name = taskDao.company.type_name
            }
            //print("Add Permits \(taskDao.company.companyPermits)")
            
           self.addPermits(taskDao.company.companyPermits)
            
            
            task.is_completed = "0" 
           // var error : NSError?
            
            do {
                try self.appDel.managedObjectContext?.save()
            } catch let error1 as NSError {
                //error = error1
                print(error1)
                
            }
            
            
            
                   }
        
    }
    /*
    @NSManaged var address: String
    @NSManaged var area_id: String
    @NSManaged var area_name: String
    @NSManaged var attribute: String
    @NSManaged var auditor_id: String
    @NSManaged var auditor_name: String
    @NSManaged var company_id: String
    @NSManaged var company_name: String
    @NSManaged var company_name_arabic: String
    @NSManaged var created_by: String
    @NSManaged var due_date: String
    @NSManaged var email_address: String
    @NSManaged var inspector_id: String
    @NSManaged var landline: String
    @NSManaged var latitude: String
    @NSManaged var license_expire_date: String
    @NSManaged var license_info: String
    @NSManaged var license_issue_date: String
    @NSManaged var list_id: String
    @NSManaged var list_title: String
    @NSManaged var longitude: String
    @NSManaged var phone_no: String
    @NSManaged var task_id: String
    @NSManaged var task_name: String
    @NSManaged var task_status: String
    @NSManaged var type_id: String
    @NSManaged var type_name: String

    */
    
    
    
//    func fetchOffers() -> NSMutableArray{
//        let allOffers = NSMutableArray()
//        let fetch = NSFetchRequest(entityName: "Tasks")
//        do {
//        let array = try self.appDel.managedObjectContext.executeFetchRequest(fetch)
//        for offer in array as! [Offers] {
//        let offerDao = OfferDao()
//        offerDao.offer_id =  offer.offer_id
//        //offerDao.distance = (offer.distance as NSString).
//        offerDao.venue_id = offer.venue_id
//        offerDao.venue_title = offer.venue_title
//        offerDao.venue_shortdesc = offer.venue_shortdesc
//        //offer.venue_longdesc = offerDao.ven
//        offerDao.offerTitle = offer.offer_title
//        offerDao.image = offer.image
//        offerDao.currency = offer.currency_code
//        offerDao.price = offer.price
//        // offerDao.isFav = offer.isFav.
//        print("adding offer with title sd \(offerDao.offerTitle)")
//        allOffers.addObject(offerDao)
//        
//        }
//        
//        }catch let error as NSError {
//            print(error)
//            return allOffers
//            
//        }
//        return allOffers
//        
//    }
    
    func deleteAllMainInspectionList(){
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionMainList")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for a in 0  ..< array!.count  {
            //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
            if let object = array?[a] as? NSManagedObject {
                self.appDel.managedObjectContext?.delete(object)
            }
        }
        
//        do {
//            try self.appDel.managedObjectContext!.save()
//        } catch let error1 as NSError {
//            error = error1
//        }
//        if error != nil {
//            print(error)
//            
//        }
//        else {
//            print("Inspection Main List Deleted")
//        }
//
        
    }
    func deleteAllViolations(){
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Violations_History")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for a in 0  ..< array!.count  {
            //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
            if let object = array?[a] as? NSManagedObject {
                self.appDel.managedObjectContext?.delete(object)
            }
        }
        
        do {
            try self.appDel.managedObjectContext!.save()
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil {
            print(error)
            
        }
        else {
            print("Violations History Deleted")
        }
        
        
    } // end of the delete All Violations
    
    
    
    func deleteAllWarnings(){
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Warning_History")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for a in 0  ..< array!.count  {
            //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
            if let object = array?[a] as? NSManagedObject {
                self.appDel.managedObjectContext?.delete(object)
            }
        }
        
        do {
            try self.appDel.managedObjectContext!.save()
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil {
            print(error)
            
        }
        else {
            print("Warning History Deleted")
        }
        
        
    } // end of the delete All Violations
    
    func deleteAllInspector(){
        //Inspectors
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Inspectors")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        if array != nil {
            for a in 0  ..< array!.count  {
                //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
                if let object = array?[a] as? NSManagedObject {
                    self.appDel.managedObjectContext?.delete(object)
                }
            }
            
            do {
                try self.appDel.managedObjectContext!.save()
                //self.deleteAllPermits()
                
            } catch let error1 as NSError {
                error = error1
            }
        } // end of the arry
        
        
        
    }
    
    
    func deleteAllLogs(){
        //Inspectors
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Inspection_logs")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        if array != nil {
            for a in 0  ..< array!.count  {
                //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
                if let object = array?[a] as? NSManagedObject {
                    self.appDel.managedObjectContext?.delete(object)
                }
            }
            
            do {
                try self.appDel.managedObjectContext!.save()
                //self.deleteAllPermits()
                
            } catch let error1 as NSError {
                error = error1
            }
        } // end of the arry
        
        
        
    }
    
    func deleteAllCatAct(){
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CatActCodes")
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(deleteRequest)
                try  managedObjectContext.save()
                
            } catch let error as NSError {
                // TODO: handle the error
            }
        } else {
            // Fallback on earlier versions
            

        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CatActCodes")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for a in 0  ..< array!.count  {
            //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
            if let object = array?[a] as? NSManagedObject {
                self.appDel.managedObjectContext?.delete(object)
            }
        }
        }
        
//        do {
//            try self.appDel.managedObjectContext!.save()
//        } catch let error1 as NSError {
//            error = error1
//        }
//        if error != nil {
//            print(error)
//            
//        }
//        else {
//            print("Questions deleted")
//        }
        
        
        

    
    }
    
    
    func deleteAllCatCompany(){
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CompanyActCodes")
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(deleteRequest)
                try  managedObjectContext.save()
                
            } catch let error as NSError {
                // TODO: handle the error
            }
        } else {
            // Fallback on earlier versions
            

        
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CompanyActCodes")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for a in 0  ..< array!.count  {
            //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
            if let object = array?[a] as? NSManagedObject {
                self.appDel.managedObjectContext?.delete(object)
            }
        }
        
        
//        do {
//            try self.appDel.managedObjectContext!.save()
//        } catch let error1 as NSError {
//            error = error1
//        }
//        if error != nil {
//            print(error)
//            
//        }
//        else {
//            print("Questions deleted")
//        }
//        
        
        }
        
        
    }
    
    
    
    func deleteAllQuestion(){
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionList")
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(deleteRequest)
                try  managedObjectContext.save()
                
            } catch let error as NSError {
                // TODO: handle the error
            }
        } else {
            // Fallback on earlier versions
            
            
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionList")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for a in 0  ..< array!.count  {
            //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
            if let object = array?[a] as? NSManagedObject {
                self.appDel.managedObjectContext?.delete(object)
            }
        }
        }
        
        
//        do {
//            try self.appDel.managedObjectContext!.save()
//        } catch let error1 as NSError {
//            error = error1
//        }
//        if error != nil {
//            print(error)
//            
//        }
//        else {
//            print("Questions deleted")
//        }

        

        
        
        
        
        
        
        
    }
    func deleteAllExtraOptions(){
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Extra_Options")
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(deleteRequest)
                try  managedObjectContext.save()
                
            } catch let error as NSError {
                // TODO: handle the error
            }
        } else {
            // Fallback on earlier versions
            
      
        
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Extra_Options")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for a in 0  ..< array!.count  {
            //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
            if let object = array?[a] as? NSManagedObject {
                self.appDel.managedObjectContext?.delete(object)
            }
        }
        
//        do {
//            try self.appDel.managedObjectContext!.save()
//        } catch let error1 as NSError {
//            error = error1
//        }
//        if error != nil {
//        print(error)
//            
//        }
//        else {
//        print("extra options deleted")
//        }
        
        }
        
    }
    
    func deleteAllOptions(){
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Options")
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(deleteRequest)
                try  managedObjectContext.save()
                
            } catch let error as NSError {
                // TODO: handle the error
            }
        } else {
            // Fallback on earlier versions
            

        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Options")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for a in 0  ..< array!.count  {
            //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
            if let object = array?[a] as? NSManagedObject {
                self.appDel.managedObjectContext?.delete(object)
            }
        }
        
//        do {
//            try self.appDel.managedObjectContext!.save()
//        } catch let error1 as NSError {
//            error = error1
//        }
//        if error != nil {
//            print(error)
//            
//        }
//        else {
//            print("Options delted")
//        }

        }

        
        
        
    }
    
    func removeAllPermitFiles(){
        
        // Create a FileManager instance
        
        let fileManager = FileManager.default
        
        // Delete 'subfolder' folder
        
        do {
            
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentDirectoryPath:String = path[0]
            let folderPath =  documentDirectoryPath + "/permits"
            
            try fileManager.removeItem(atPath: folderPath)
            print("Permit Folder deleted")
            
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
    }
    
    func deleteAllQuestionCategories(){
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionCategories")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for a in 0  ..< array!.count  {
            //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
            if let object = array?[a] as? NSManagedObject {
                self.appDel.managedObjectContext?.delete(object)
            }
        }
        
        do {
            try self.appDel.managedObjectContext!.save()
           
        } catch let error1 as NSError {
            error = error1
        }
    }
        
        
        func deleteAllPermits(){
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Permits")
            var error : NSError?
            let array: [AnyObject]?
            do {
                array = try self.appDel.managedObjectContext?.fetch(fetch)
            } catch let error1 as NSError {
                error = error1
                array = nil
            }
            for a in 0  ..< array!.count  {
                //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
                if let object = array?[a] as? NSManagedObject {
                    self.appDel.managedObjectContext?.delete(object)
                }
            }
            
            do {
                try self.appDel.managedObjectContext!.save()
                self.removeAllPermitFiles()
            } catch let error1 as NSError {
                error = error1
            }
        
        
        
        
    }
    func deleteAllTasks(){
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        if array != nil {
            for a in 0  ..< array!.count  {
        //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
                if let object = array?[a] as? NSManagedObject {
                self.appDel.managedObjectContext?.delete(object)
                }
                }
       
            do {
                try self.appDel.managedObjectContext!.save()
                //self.deleteAllPermits()
            
            } catch let error1 as NSError {
                error = error1
            }
        } // end of the arry
        
            
        
    }
    
    func getAllList() -> NSArray
    {
        
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InspectionList")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(taskRequest)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        return array! as NSArray
        
    }
    func deleteAllActivityCodes(){
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activitycodes")
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(deleteRequest)
                try  managedObjectContext.save()
                
            } catch let error as NSError {
                // TODO: handle the error
            }
        } else {
            // Fallback on earlier versions
            

        
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Activitycodes")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for a in 0  ..< array!.count  {
            //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
            if let object = array?[a] as? NSManagedObject {
                self.appDel.managedObjectContext?.delete(object)
            }
        }
        
//        do {
//            try self.appDel.managedObjectContext!.save()
//        } catch let error1 as NSError {
//            error = error1
//        }
//        if error != nil {
//            print(error)
//            
//        }
//        else {
//            print("Activity Codes Deleted")
//        }
//        
        }
    }
    
    
    func deleteAllCategories(){
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for a in 0  ..< array!.count  {
            //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
            if let object = array?[a] as? NSManagedObject {
                self.appDel.managedObjectContext?.delete(object)
            }
        }
        
        do {
            try self.appDel.managedObjectContext!.save()
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil {
            print(error)
            
        }
        else {
            print("Categories Deleted")
        }
        
        
    }

    
    
    func deleteAllCompanies(){
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Companies")
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
            try managedObjectContext.execute(deleteRequest)
            try  managedObjectContext.save()
                
            } catch let error as NSError {
                // TODO: handle the error
            }
        } else {
            // Fallback on earlier versions
        
        
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Companies")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try managedObjectContext.fetch(fetch)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for a in 0  ..< array!.count  {
            //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
            if let object = array?[a] as? NSManagedObject {
                managedObjectContext.delete(object)
            }
        }
        
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
        }
        

        }
    }
    
    func fetchAllCategories()-> NSMutableArray{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        let allCategories = NSMutableArray()
        
       var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
            //print(array)
            //for var a = 0 ; a < array?.count ; a += 1 {
                
            for  a in 0 ..< array!.count  {
                
                let managed = array![a] as! Categories
                let cDao = CategoriesDao()
                cDao.catg_id = managed.id
                cDao.catg_name = managed.type_name
                print("type name \(cDao.catg_name)")
                
                // allActivityCodes.addObject(managed.activity_id!)
                allCategories.add(cDao)
                
                
                
                
            } // End of the for loop
            
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        } // end of the catch
        return allCategories
        
        
    
    }
    
    func fetchCategoriesIdsOnActivity(_ activity_ids : NSMutableArray) -> NSMutableArray{
        let allCategores = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CatActCodes")
        let allIds : NSArray = activity_ids.mutableCopy() as! NSArray
        
        let predicate = NSPredicate(format: "activity_id IN %@",allIds)
        
        request.predicate = predicate
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
            //print(array)
            //for var a = 0 ; a < array?.count ; a += 1 {
                for  a in 0 ..< array!.count {
                    
                
                let managed = array![a] as! CatActCodes
                
               // allActivityCodes.addObject(managed.activity_id!)
                print("category id \(managed.category_id)")
                allCategores.add(managed.category_id!)
                
            } // End of the for loop
            
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        } // end of the catch
        return allCategores
        
    
    }
    
    func categoriesOnIds(_ categoryIds : NSMutableArray) ->  NSMutableArray {
        let allCategores = NSMutableArray()
        print(categoryIds)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        let allIds : NSArray = categoryIds.mutableCopy() as! NSArray
        //print("All Ids \(allIds)")
        let predicate = NSPredicate(format: "id IN %@",allIds)
        
        request.predicate = predicate
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
            //print(array)
           // for var a = 0 ; a < array?.count ; a += 1 {
                for a in 0 ..< array!.count  {
                    
                let managed = array![a] as! Categories
                let cDao = CategoriesDao()
                cDao.catg_id = managed.id
                cDao.catg_name = managed.type_name
                print("type name \(cDao.catg_name)")
                
                // allActivityCodes.addObject(managed.activity_id!)
                allCategores.add(cDao)
                
                
                
                
            } // End of the for loop
            
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        } // end of the catch
        return allCategores
        
    }
    func fetchActivitiesFromCompany(_ company_id : String) -> NSMutableArray{
        let allActivityCodes = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CompanyActCodes")
        let predicate = NSPredicate(format: "company_id = %@",company_id)
        request.predicate = predicate
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
            //print(array)
          //  for var a = 0 ; a < array?.count ; a += 1 {
                for  a in 0 ..< array!.count {
                    
                let managed = array![a] as! CompanyActCodes
                
                allActivityCodes.add(managed.activity_id!)
                print("activity id \(managed.activity_id)")
                
                
            } // End of the for loop
            
    
         } catch let error1 as NSError {
        error = error1
         array = nil
         } // end of the catch
        return allActivityCodes
        
    }
    func fetchAllCompanies(_ companyName : String) -> NSMutableArray{
        let allCompanies = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Companies")
//       request.returnsDistinctResults = true
//        let sortDescriptor = NSSortDescriptor(key: "option_id", ascending: true)
//        let sortDescriptors = [sortDescriptor]
//        request.sortDescriptors = sortDescriptors
//        
//        let predicate = NSPredicate(format: "q_id = %@", questionId)
//        request.predicate = predicate
//      [NSPredicate predicateWithFormat:@"region=%@ && locality CONTAINS[cd] %@", self.region, query]
        let predicate = NSPredicate(format:"company_name CONTAINS[cd] %@",companyName)
        
        request.predicate = predicate
        print(predicate)
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
            //print(array)
           // for var a = 0 ; a < array?.count ; a += 1 {
                for a in 0 ..< array!.count  {
                    
                let managed = array![a] as! Companies
            let singleCompany = CompanyDao()
                
        singleCompany.company_id = managed.id
        singleCompany.company_name = managed.company_name
        singleCompany.company_name_arabic  =  managed.company_name_arabic
        singleCompany.license_info =  managed.license_info
        singleCompany.license_issue_date =  managed.license_issue_date
        singleCompany.license_expire_date = managed.license_expiry_date
        singleCompany.landline    =     managed.landline
        singleCompany.phone_no   =     managed.phone_no
        singleCompany.email =  managed.email_address
        singleCompany.pro_name =  managed.pro_name
        singleCompany.email_pro   =  managed.pro_email
        singleCompany.pro_mobile   =   managed.pro_contact_no
        singleCompany.lat =  managed.latitude
        singleCompany.lon = managed.longitude
        singleCompany.category_name  =  managed.category_name
        singleCompany.category_name_ar = managed.category_name_arb
        singleCompany.alternativeNumber  = managed.alternativeNumber
        singleCompany.activityType  =   managed.activityType
        singleCompany.activityType_ar = managed.activityType_Arb
        singleCompany.activity_code = managed.activity_code
        singleCompany.address_note = managed.address_notes
        singleCompany.company_note = managed.company_notes
                
                
                
                
                
                allCompanies.add(singleCompany)
                
            }
            
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
       return allCompanies
        
    }
    
    
    
    func fetchAllCompaniesByLicenseNo(_ license_info : String) -> NSMutableArray{
        let allCompanies = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Companies")
        //       request.returnsDistinctResults = true
        //        let sortDescriptor = NSSortDescriptor(key: "option_id", ascending: true)
        //        let sortDescriptors = [sortDescriptor]
        //        request.sortDescriptors = sortDescriptors
        //
        //        let predicate = NSPredicate(format: "q_id = %@", questionId)
        //        request.predicate = predicate
        //      [NSPredicate predicateWithFormat:@"region=%@ && locality CONTAINS[cd] %@", self.region, query]
        let predicate = NSPredicate(format:"license_info CONTAINS[cd] %@",license_info)
        request.predicate = predicate
        print(predicate)
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
            //print(array)
           // for var a = 0 ; a < array?.count ; a += 1 {
                for  a in 0 ..< array!.count{
                    
                let managed = array![a] as! Companies
                let singleCompany = CompanyDao()
                
                singleCompany.company_id = managed.id
                singleCompany.company_name = managed.company_name
                singleCompany.company_name_arabic  =  managed.company_name_arabic
                singleCompany.license_info =  managed.license_info
                singleCompany.license_issue_date =  managed.license_issue_date
                singleCompany.license_expire_date = managed.license_expiry_date
                singleCompany.landline    =     managed.landline
                singleCompany.phone_no   =     managed.phone_no
                singleCompany.email =  managed.email_address
                singleCompany.pro_name =  managed.pro_name
                singleCompany.email_pro   =  managed.pro_email
                singleCompany.pro_mobile   =   managed.pro_contact_no
                singleCompany.lat =  managed.latitude
                singleCompany.lon = managed.longitude
                singleCompany.category_name  =  managed.category_name
                singleCompany.category_name_ar = managed.category_name_arb
                singleCompany.alternativeNumber  = managed.alternativeNumber
                singleCompany.activityType  =   managed.activityType
                singleCompany.activityType_ar = managed.activityType_Arb
                singleCompany.activity_code = managed.activity_code
                singleCompany.address_note = managed.address_notes
                singleCompany.company_note = managed.company_notes
                
                allCompanies.add(singleCompany)
                
            }
            
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        return allCompanies
        
    }

    
    func fetchAllCompanies(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Companies")
        
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
            //print(array)
            //for var a = 0 ; a < array?.count ; a += 1 {
                for a in 0 ..< array!.count {
                    
                let managed = array![a] as! Companies
                let singleCompany = CompanyDao()
                
                singleCompany.company_id = managed.id
                singleCompany.company_name = managed.company_name
                singleCompany.company_name_arabic  =  managed.company_name_arabic
                singleCompany.license_info =  managed.license_info
                singleCompany.license_issue_date =  managed.license_issue_date
                singleCompany.license_expire_date = managed.license_expiry_date
                singleCompany.landline    =     managed.landline
                singleCompany.phone_no   =     managed.phone_no
                singleCompany.email =  managed.email_address
                singleCompany.pro_name =  managed.pro_name
                singleCompany.email_pro   =  managed.pro_email
                singleCompany.pro_mobile   =   managed.pro_contact_no
                
                
                // print("Pro mobile \(singleCompany.pro_mobile)")
                
                singleCompany.lat =  managed.latitude
                singleCompany.lon = managed.longitude
                singleCompany.category_name  =  managed.category_name
                singleCompany.category_name_ar = managed.category_name_arb
                singleCompany.alternativeNumber  = managed.alternativeNumber
                singleCompany.activityType  =   managed.activityType
                singleCompany.activityType_ar = managed.activityType_Arb
                singleCompany.activity_code = managed.activity_code
                singleCompany.address_note = managed.address_notes
                singleCompany.company_note = managed.company_notes
                singleCompany.contact_provider_name = managed.provided_by_name
                singleCompany.contact_provided_by = managed.provided_by_desig
                singleCompany.contact_designation = managed.pro_desig
                    
                
                self.appDel.globalCompanies.add(singleCompany)
                
                
            }
            
            
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        
        
        
    
        
    }
    
    
    func fetchAllCompaniesByLicenseNoAndCompanyName(_ license_info : String , company_name : String) -> NSMutableArray{
        let allCompanies = NSMutableArray()
        var licenseEng = Util.getEnglishNo(license_info)
        
        let tempCompanyName = company_name.replacingOccurrences(of: " ", with: "")
        if self.appDel.globalCompanies.count > 0 {
        
        }
        else {
        self.fetchAllCompanies()
        }
        
        
        for company in self.appDel.globalCompanies  {
            if let company1  = company as? CompanyDao {
               // print("\(company1.license_info) == \(license_info)" )
        let tempEngName = company1.company_name.replacingOccurrences(of: " ", with: "")
            //   print(tempEngName)
            //    print(tempCompanyName)
                
        let tempArName = company1.company_name_arabic.replacingOccurrences(of: " ", with: "")
        
        if license_info == "" {
        if tempEngName.lowercased().contains(tempCompanyName.lowercased()) || tempArName.lowercased().contains(tempCompanyName.lowercased()) {
        allCompanies.add(company1)
                        //print("Matches")
        }
        
        }  // end of the license
             
        else if licenseEng != "" && company_name != "" {
                if (tempEngName.lowercased().contains(tempCompanyName.lowercased()) || tempArName.lowercased().contains(tempCompanyName.lowercased())) && company1.license_info == licenseEng {
                        allCompanies.add(company1)
                        //print("Matches")
                    }
                    
                }
      else if company1.license_info.contains(license_info) {
        allCompanies.add(company1)
        }
            }  // end of the if 
            
        
                   } // end of the for loop
        
        
        return allCompanies

        
        // let tempCompanyName = company_name.stringByReplacingOccurrencesOfString(" ", withString: "")
     
//        let request = NSFetchRequest(entityName: "Companies")
//            var predicate : NSPredicate?
//        if license_info == "" {
//            predicate = NSPredicate(format:"company_name CONTAINS[cd]%@ or company_name_arabic CONTAINS[cd]%@",company_name,company_name)
//            
//        }
//        
//       else  if company_name == "" {
//            predicate = NSPredicate(format:"license_info CONTAINS[cd]%@",license_info)
//            
//        
//        }
//        else {
//            predicate = NSPredicate(format:"license_info CONTAINS[cd]%@ AND (company_name CONTAINS[cd]%@ or company_name_arabic CONTAINS[cd]%@)",license_info,company_name,company_name)
//            
//            
//        }
       // print(predicate)
       // request.predicate = predicate
      //  print(predicate)
//        var error : NSError?
//        let array: [AnyObject]?
//        do {
//            array = try appDel.managedObjectContext?.executeFetchRequest(request)
//            //print(array)
//            for var a = 0 ; a < array?.count ; a++ {
//                let managed = array![a] as! Companies
//                let singleCompany = CompanyDao()
//                
//                singleCompany.company_id = managed.id
//                singleCompany.company_name = managed.company_name
//                singleCompany.company_name_arabic  =  managed.company_name_arabic
//                singleCompany.license_info =  managed.license_info
//                singleCompany.license_issue_date =  managed.license_issue_date
//                singleCompany.license_expire_date = managed.license_expiry_date
//                singleCompany.landline    =     managed.landline
//                singleCompany.phone_no   =     managed.phone_no
//                singleCompany.email =  managed.email_address
//                singleCompany.pro_name =  managed.pro_name
//                singleCompany.email_pro   =  managed.pro_email
//                singleCompany.pro_mobile   =   managed.pro_contact_no
//                
//                
//               // print("Pro mobile \(singleCompany.pro_mobile)")
//                
//                singleCompany.lat =  managed.latitude
//                singleCompany.lon = managed.longitude
//                singleCompany.category_name  =  managed.category_name
//                singleCompany.category_name_ar = managed.category_name_arb
//                singleCompany.alternativeNumber  = managed.alternativeNumber
//                singleCompany.activityType  =   managed.activityType
//                singleCompany.activityType_ar = managed.activityType_Arb
//                singleCompany.activity_code = managed.activity_code
//                singleCompany.address_note = managed.address_notes
//                singleCompany.company_note = managed.company_notes
//                
//                
//                let tempEngName = singleCompany.company_name.stringByReplacingOccurrencesOfString(" ", withString: "")
//                let tempArName = singleCompany.company_name_arabic.stringByReplacingOccurrencesOfString(" ", withString: "")
//                if tempEngName.containsString(tempCompanyName) || tempArName.containsString(tempCompanyName) {
//                    allCompanies.addObject(singleCompany)
//                print("Matches")
//                }
//                else {
//                print("Does not matches \(tempCompanyName) \(tempArName) \(tempEngName)")
//                }
//                
//                
//            }
//            
//            
//        } catch let error1 as NSError {
//            error = error1
//            array = nil
//        }
//        return allCompanies
//        
// 
    
    
    }

    
    
    func addCategories(_ categories : NSMutableArray){
        var error : NSError?
        for a in 0  ..< categories.count  {
        let categoryDao = categories.object(at: a) as! CategoryDao
        let entity = NSEntityDescription.entity(forEntityName: "Categories", in: appDel.managedObjectContext!)
        let managed = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! Categories
        managed.id = categoryDao.category_id
        managed.type_name = categoryDao.category_name
        print("category added with id \(managed.type_name) \(managed.id)")
        }// end of the for loop
        
//        do {
//            try self.appDel.managedObjectContext!.save()
//        } catch let error1 as NSError {
//            error = error1
//        }
        
    
    }// end of the addCategories
    
    func addAddressNotes(_ addressNotes : String? ,company_notes : String?,pro_name : String? , pro_email : String? , pro_mobile:String? , company_id : String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Companies")
        fetchRequest.predicate = NSPredicate(format: "id = %@", company_id)
        
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        
        if array?.count > 0 {
            if let object = array![0] as? Companies {
            object.company_notes = company_notes
            object.address_notes = addressNotes
            object.pro_name = pro_name
            object.pro_email = pro_email
            object.pro_contact_no = pro_mobile
            }
        }
        
        do {
            try self.appDel.managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil {
            print(error, terminator: "")
        }
        else {
            print("company detail added for company ", terminator: "")
        }

        
        
//        
//        if let fetchResults = appDel.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [NSManagedObject] {
//            if fetchResults.count != 0{
//
//            
//            }

  //  }

//
//        let request = NSFetchRequest(entityName: "Companies")
//        var predicate : NSPredicate?
//        predicate = NSPredicate(format:"id CONTAINS[cd]%@",company_id)
//        request.predicate = predicate
//        let entity = NSEntityDescription.entityForName("Companies", inManagedObjectContext: appDel.managedObjectContext!)
//        let managed = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: appDel.managedObjectContext!) as! Companies
        
        

        
    
    } // end of the addAddressNotes
    
    func getPermits(_ license_info : String)-> NSMutableArray{
    let allPermits = NSMutableArray()
  
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Permits")
    let predicate = NSPredicate(format: "license_info = %@", license_info)
    print(predicate)
    request.predicate = predicate
        
    let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
         } catch let error1 as NSError {
      
        array = nil
        }
        for permit in array as! [Permits] {
        let permitDao = PermitDao()
            
            permitDao.permitID = permit.permitID
            permitDao.permit_type = permit.permit_type
            permitDao.issue_date = permit.issue_date
            permitDao.expire_date = permit.expire_date
            permitDao.id = permit.record_id
            permitDao.url = permit.permit_url
            permitDao.lat = permit.lat
            permitDao.lon = permit.lon
            allPermits.add(permitDao)
            
            print("#### NO OF PERMITS \(allPermits.count)")
        } // end of the for loop
        
        return allPermits
        
    } // end of the getPermits
    
    
    func getCategories() -> NSMutableArray{
        let allCategories = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        //  print("Optons on question \(questionId) are  \(array!.count)")
        
        for category in array as! [Categories] {
             let dao = CategoryDao()
              dao.category_id = category.id
              dao.category_name = category.type_name
            print("catg_id \(dao.category_id)")
            print("catg_name \(dao.category_name)")
            
            allCategories.add(dao)
        } // end of the for loop
        
        
    return allCategories
        
    }
    
    
    func addCatActCodes(_ allItems : NSMutableArray)
    {
        
        
        var error : NSError?
        for a in 0  ..< allItems.count  {
        let catAct = allItems.object(at: a) as! CatActCodesDao
        
        let entity = NSEntityDescription.entity(forEntityName: "CatActCodes", in: appDel.managedObjectContext!)
        let managed = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! CatActCodes
        managed.id = catAct.id
        managed.category_id = catAct.category_id
        managed.activity_id = catAct.activity_id
        
        } // end of the for loop
//        do {
//            try self.appDel.managedObjectContext!.save()
//        } catch let error1 as NSError {
//            error = error1
//        }
        
    
        
    }
    
    func addCatCompanyCodes(_ allItems : NSMutableArray){
    
        // changed tp add async data private NSMANAGED CONTEXT IS USED  // 17NOV 2016
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        managedObjectContext.perform { // runs asynchronously

        for a in 0  ..< allItems.count  {
            autoreleasepool {
            let catAct = allItems.object(at: a) as! CompanyCatDao
            
            let entity = NSEntityDescription.entity(forEntityName: "CompanyActCodes", in: managedObjectContext)
            let managed = NSManagedObject(entity: entity!, insertInto:managedObjectContext) as! CompanyActCodes
            managed.id = catAct.id
            managed.company_id = catAct.company_id
            managed.activity_id = catAct.activity_id
            }
        } // end of the for loop
            managedObjectContext.reset()
            
//        do {
//            try self.appDel.managedObjectContext!.save()
//        } catch let error1 as NSError {
//            error = error1
//        }
        }
    
    }
    
    
    func getCatCompanyCodes() -> NSMutableArray {
        let allCatActCodes = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CompanyActCodes")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        //  print("Optons on question \(questionId) are  \(array!.count)")
        
        for codes in array as! [CompanyActCodes] {
            let catActCodes = CompanyCatDao()
            catActCodes.id = codes.id
            catActCodes.company_id = codes.company_id
            catActCodes.activity_id = codes.activity_id
            allCatActCodes.add(catActCodes)
            
            
            
        } // end of the for loop
        
        return allCatActCodes
    }
    
    
    func getCatActCodes()-> NSMutableArray{
        
        let allCatActCodes = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CatActCodes")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        //  print("Optons on question \(questionId) are  \(array!.count)")
        
        for codes in array as! [CatActCodes] {
            let catActCodes = CatActCodesDao()
            catActCodes.id = codes.id
            catActCodes.category_id = codes.category_id
            catActCodes.activity_id = codes.activity_id
            allCatActCodes.add(catActCodes)
            


        } // end of the for loop
        
        return allCatActCodes
        
        
    }// end of the getCatActCodes
    
    
    func addActivityCode(_ activityCodes : NSMutableArray){
       //  var error : NSError?
        
        // UPDATE ON NOV 17 2016 , ADDED AUTORELEASE POOL AND ASYNC MANAGED CONTENT FOR MEMORY MANAGEMENT
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        managedObjectContext.perform { // runs asynchronously

        for a in 0  ..< activityCodes.count  {
            autoreleasepool {

          let activity = activityCodes.object(at: a) as! ActivityCode
            let entity = NSEntityDescription.entity(forEntityName: "Activitycodes", in: managedObjectContext)
            let managed = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Activitycodes
            managed.activity_code = activity.activity_code
            managed.activity_name = activity.activity_name
            managed.activity_name_arabic = activity.activity_name_arabic
            managed.id = activity.id
            
            }
            
        } // end of the for loop
        
//        do {
//            try self.appDel.managedObjectContext!.save()
//        } catch let error1 as NSError {
//            error = error1
//        }
        
            
        }
        do {
            try managedObjectContext.save()
            
        } catch let error as NSError {
            
        }
        managedObjectContext.reset()
        
    }// end of the addActivityCode
    
   
//    func getOfflinePermitsById(permitId : String) -> NSMutableArray{
//    let allPermits = NSMutableArray()
//     let request = NSFetchRequest(entityName: "AllPermits")
//        let array : [AnyObject]?
//        do {
//        
//        } // end of the do
//        
//    }
    
    func getActivityCodes() -> NSMutableArray{
        let allCodes = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Activitycodes")
        var error : NSError?
        let array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(request)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        //  print("Optons on question \(questionId) are  \(array!.count)")
        
        for codes in array as! [Activitycodes] {
            
         let codeDao = ActivityCode()
            codeDao.id = codes.id
            codeDao.activity_name = codes.activity_name
            codeDao.activity_name_arabic = codes.activity_name_arabic
            codeDao.activity_code = codes.activity_code
            allCodes.add(codeDao)
        
        } // end of the for loop
     
        return allCodes
        
    }
    
    
    func addAllPermits(_ allpermits : NSMutableArray){
    
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
      //  managedObjectContext.performBlock { // runs asynchronously
            for a in 0 ..< allpermits.count {
                autoreleasepool {
                let singlePermit = allpermits.object(at: a) as! MainPermitDao
                    let entity = NSEntityDescription.entity(forEntityName: "AllPermits", in: managedObjectContext)
                  // print("This permit has \(singlePermit.drivers.count) drivers")
                    
                let managed = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! AllPermits
                   managed.businessLicense = singlePermit.businessLicense
                   managed.organizerName = singlePermit.organizerName
                   managed.expiryDate = singlePermit.expiryDate
                   managed.permitID = singlePermit.permitID
                   managed.startDate = singlePermit.startDate
                   managed.endDate = singlePermit.endDate
                   managed.contactNumber = singlePermit.contactNumber
                   managed.appComment = singlePermit.appComment
                   managed.subvenue = singlePermit.subVenue
                   managed.coordinatorName = singlePermit.coordinatorName
                   managed.campArea = singlePermit.campArea
                   managed.permitType = singlePermit.permitType
                    
                    
                    
                   managed.issuedDate = singlePermit.issuedDate
                    self.addVehicles(singlePermit.vehicles)
                    self.addDrivers(singlePermit.drivers)
                }// end of the autorelease pool
                
            } // end of the for lop
            
            do {
                try managedObjectContext.save()
                
            } catch let error as NSError {
                
            }
            
            
            
            managedObjectContext.reset()
            

      //  }// end of the async
        
    
    }// end if the
    
    func addDrivers(_ drivers : NSMutableArray) {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
       // managedObjectContext.performBlock { // runs asynchronously
            for a in 0 ..< drivers.count {
                autoreleasepool {
                    let singleDriver = drivers.object(at: a) as! DriversDao
                    let entity = NSEntityDescription.entity(forEntityName: "PermitDrivers", in: managedObjectContext)
                    
                    let managed = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! PermitDrivers
                    managed.driver_name = singleDriver.driver_name
                    managed.nationality = singleDriver.nationality
                    managed.drLicNo = singleDriver.drLicNo
                    managed.drLicIssue = singleDriver.drLicIssue
                    managed.drLicExpiry = singleDriver.drLicExpiry
                    managed.drComment = singleDriver.drComment
                    managed.isFirstAid = singleDriver.isFirstAid
                    managed.permitID = singleDriver.permitID
                    
                    //print("driver added with name \(managed.driver_name)")
                }// end of the autorelease pool
            }//  end of the loop
             //print("Drivers added \(drivers.count)")
            do {
                try managedObjectContext.save()
                
            } catch let error as NSError {
                
            }
            
            
            
            managedObjectContext.reset()
            

        
       // } // end of the async
        
    
    
    }
    
    func searchPermitsWithPlateNoAndLicenseNo(_ plateNo : String,license_no : String,lic_no : String,permitId : String,type : String, code : String?) -> NSMutableArray {
    var permitsWithPlateNo = NSMutableArray()
    var permitsWtihLicenseNo = NSMutableArray()
    var allPermits = NSMutableArray()
        
        if plateNo !=  "" {
        permitsWithPlateNo = self.searchVehiclesByPlateNo(plateNo,lic_no: lic_no,permitId: permitId,type: type,code: code)
        }
        // print(license_no)
        // search for driving license
        if license_no != "" {
            print(license_no)
        permitsWtihLicenseNo = self.searchDriversByLicenseNo(license_no,lic_no: lic_no,permitId: permitId,type: type)
            
        }
        
        if plateNo == "" && license_no == "" {
        if lic_no != "" {
        allPermits = self.fetchAllPermitsByLicenseNo(lic_no)
        }
        
        if permitId != "" {
        
        allPermits = self.fetchAllPermitsByPermitId(permitId)
        }
        }
        if permitsWithPlateNo.count <= 0 && permitsWtihLicenseNo.count > 0 && plateNo == "" {
        return permitsWtihLicenseNo
        }
        
        if permitsWtihLicenseNo.count <= 0 && permitsWithPlateNo.count > 0 && license_no == "" {
        return permitsWithPlateNo
        }
        
        
        if permitsWithPlateNo.count > 0 && permitsWtihLicenseNo.count > 0
        {
            allPermits = NSMutableArray()
            
            for permit in permitsWtihLicenseNo {
                if let p = permit as? MainPermitDao {
                    for permitinner in permitsWithPlateNo {
                        if let p2 = permitinner as? MainPermitDao {
                            if p.permitID == p2.permitID {
                               //print("Permit id \(p.permitID ) and \(p2.permitID)")
                                
                            allPermits.add(p)
                             continue
                            }
                        }
                    }
                    
                }
            
            }// end of the for loop
            
         return allPermits
        
        }
        else if license_no != "" && plateNo != "" {
        return NSMutableArray()
        }
        else {
        return allPermits
        }
        
        
        
    
    }
    
    func searchSubvenuesByLicenseNo(_ license_No : String) -> NSMutableArray{
        var subvenues = NSMutableArray()
        print("Search for \(license_No)")
        
        let subvenueRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subvenues")
        let predicate = NSPredicate(format: "licenseNumber = %@", license_No)
        subvenueRequest.predicate = predicate
        print("Predicate \(predicate)")
        
        var array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(subvenueRequest) as! [Subvenues]
            //print(array)
            subvenues = NSMutableArray(array: array!)
            
            
                      print( "Number of  \(array?.count)")
            
        } catch let error as NSError {
            print("EXCEPTION IN searchSubVenuesByLicenseNo \(error)")
            
        }

        
        return subvenues
        
    }
    func searchDriversByLicenseNo(_ licenseNo : String,lic_no : String,permitId : String,type : String) -> NSMutableArray{
        let permitsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PermitDrivers")
        //let predicate = NSPredicate(format: "drLicNo CONTAINS[cd] %@", licenseNo)
        // let predicate = NSPredicate(format: "drLicNo CONTAINS[cd] %@", licenseNo)
        let predicate = NSPredicate(format: "drLicNo == [cd] %@", licenseNo)
        
        permitsRequest.predicate = predicate
        print(predicate)

        var permits = NSMutableArray()
        var driverPermits = NSMutableArray()
    
        
        var array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(permitsRequest)
            //print(array)
            for p in array as! [PermitDrivers] {
                driverPermits.add(p.permitID!)
            }
            print( "Number of  \(array?.count)")
            
        } catch let error as NSError {
            print("EXCEPTION IN searchDriversByLicenseNo(")
            
        }
        if array != nil {
            permits = fetchAllPermitsWithDrivers(driverPermits,lic_no: lic_no,permitId: permitId,type: type)
            
        }
        
        return permits
        
    } // END OF THE searchVehiclesByPlateNo
    

    
    func searchVehiclesWithPlateNo(_ plateNo : String) -> NSMutableArray {
        let permitsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VehicleInfo")
        //
         let predicate = NSPredicate(format: "plateNo CONTAINS[cd] %@", plateNo)
        //let predicate = NSPredicate(format: "plateNo == [cd] %@", plateNo)
        permitsRequest.predicate = predicate
        
        
        var permits = NSMutableArray()
        var vehiclePermits = NSMutableArray()
        
        
        
        
        var array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(permitsRequest)
            //print(array)
            for p in array as! [VehicleInfo] {
               // print(p.plateNo)
                vehiclePermits.add(p)
            }
            print( "Number of  search \(vehiclePermits.count)")
            
        } catch let error as NSError {
            print("EXCEPTION IN searchVehiclesByPlateNo(")
            
        }
        return vehiclePermits
        
        
    
    }
    
    
    
    
    
    func searchVehiclesByPlateNo(_ plateNo : String,lic_no : String,permitId : String, type : String, code : String?) -> NSMutableArray{
            let permitsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VehicleInfo")
            let predicate = NSPredicate(format: "plateNo CONTAINS[cd] %@", plateNo)
  //           permitsRequest.predicate = predicate
//        let predicate = NSPredicate(format: "plateNo == [cd] %@", plateNo)
        
        permitsRequest.predicate = predicate
        print("Predicate \(predicate)")

        
             var permits = NSMutableArray()
             var vehiclePermits = NSMutableArray()
        
        
        
        
             var array: [AnyObject]?
        do {
            array = try appDel.managedObjectContext?.fetch(permitsRequest)
            //print(array)
            for p in array as! [VehicleInfo] {
              var plate = Util.removeSpecialCharsFromString(p.plateNo!)
                
                
                
                
                
                /*
                plate = p.plateNo?.stringByReplacingOccurrencesOfString("-", withString: "")
                plate = p.plateNo?.stringByReplacingOccurrencesOfString("\"", withString: "")
                plate = p.plateNo?.stringByReplacingOccurrencesOfString("/", withString: "")
                plate = p.plateNo?.stringByReplacingOccurrencesOfString("\\", withString: "")
                plate = p.plateNo?.stringByReplacingOccurrencesOfString("_", withString: "")
                plate = p.plateNo?.stringByReplacingOccurrencesOfString("_", withString: "")
                plate = p.plateNo?.stringByReplacingOccurrencesOfString("(", withString: "")
                plate = p.plateNo?.stringByReplacingOccurrencesOfString(")", withString: "")
                plate = p.plateNo?.stringByReplacingOccurrencesOfString(")", withString: "")
 */

                
                
                let pair1 = "\(code!)\(plateNo)"
                let pair2 = "\(plateNo)\(code!)"
                print(pair1)
                print(pair2)
                print(plate)
                
                if plate.caseInsensitiveCompare(pair1) == ComparisonResult.orderedSame || plate.caseInsensitiveCompare(pair2) ==  ComparisonResult.orderedSame{
                    vehiclePermits.add(p.permitID!)
                    print("adding in the array")
                }
                
            }
            print( "Number of  \(array?.count)")
            
        } catch let error as NSError {
            print("EXCEPTION IN searchVehiclesByPlateNo(")
            
        }
        if array != nil {
        permits = fetchAllPermitsWithDrivers(vehiclePermits,lic_no: lic_no,permitId: permitId,type: type)
        
        }
        
        return permits
        
    } // END OF THE searchVehiclesByPlateNo
    
    
    func fetchAllPermitsWithDrivers(_ driversArray : NSArray,lic_no : String,permitId : String , type : String) -> NSMutableArray{
        var error : NSError?
        let allPermits = NSMutableArray()
        let permitsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllPermits")
        permitsRequest.fetchLimit = 10
       // let predicate = NSPredicate(format:"permitID IN %@ AND permitType CONTAINS[cd] %@",driversArray,type)
        let predicate = NSPredicate(format:"permitID IN %@ ",driversArray)
        
        
        print(predicate)
        permitsRequest.predicate = predicate
        
        if permitId != "" {
     //       let predicate = NSPredicate(format:"permitID IN %@ AND permitID CONTAINS[cd] %@ AND permitType CONTAINS[cd] %@" ,driversArray,permitId,type)
            let predicate = NSPredicate(format:"permitID IN %@ AND permitID CONTAINS[cd] %@" ,driversArray,permitId)
            
            print(predicate)
            permitsRequest.predicate = predicate
            
        }
        
        
        
        
        
        if lic_no != "" {
         //   let predicate = NSPredicate(format:"permitID IN %@ AND businessLicense CONTAINS[cd] %@ AND permitType CONTAINS[cd] %@" ,driversArray,lic_no,type)
            let predicate = NSPredicate(format:"permitID IN %@ AND businessLicense CONTAINS[cd] %@",driversArray,lic_no)
            
            print(predicate)
            permitsRequest.predicate = predicate
            
        }
        
        
        if permitId != "" && lic_no != "" {
      //      let predicate = NSPredicate(format:"permitID IN %@ AND permitID CONTAINS[cd] %@ AND businessLicense CONTAINS[cd] %@ AND permitType CONTAINS[cd] %@" ,driversArray,permitId,lic_no,type)
            let predicate = NSPredicate(format:"permitID IN %@ AND permitID CONTAINS[cd] %@ AND businessLicense CONTAINS[cd] %@" ,driversArray,permitId,lic_no)
            
            
            
            print(predicate)
            permitsRequest.predicate = predicate
            
        }
        
        
        let array: [AnyObject]?
        do {
            array = try self.appDel.managedObjectContext?.fetch(permitsRequest)
            print(array?.count)
        } catch let error1 as NSError {
            error = error1
            array = nil
        }
        for p in array as! [AllPermits] {
            let p1 = MainPermitDao()
            p1.permitID = p.permitID
            p1.appComment = p.appComment
            p1.businessLicense = p.businessLicense
            p1.contactNumber = p.contactNumber
            p1.coordinatorName = p.coordinatorName
            p1.endDate = p.endDate
            p1.expiryDate = p.expiryDate
            p1.issuedDate = p.issuedDate
            p1.startDate = p.startDate
            p1.organizerName = p.organizerName
            p1.subVenue = p.subvenue
            p1.campArea = p.campArea
            p1.permitType = p.permitType

            
            p1.drivers =  self.getDriversByPermitId(p.permitID!)
            p1.vehicles = self.getVehiclesByPermitId(p.permitID!)
            
            allPermits.add(p1)
            
            
            
        }// End of the for loop
        
        return allPermits

        
    }
    
    
    func addVehicles(_ allVehicles : NSMutableArray){
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator
        
        
       // managedObjectContext.performBlock { // runs asynchronously
            for a in 0 ..< allVehicles.count {
                autoreleasepool {
                    let singleVehicle = allVehicles.object(at: a) as! VehicleDao
                    let entity = NSEntityDescription.entity(forEntityName: "VehicleInfo", in: managedObjectContext)
                    
                    let managed = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! VehicleInfo
                    
                managed.tradeMarkname = singleVehicle.tradeMarkname
                managed.ownerName = singleVehicle.ownerName
                managed.plateNo = singleVehicle.plateNo
                managed.licIssue = singleVehicle.licIssue
                managed.licExpiry = singleVehicle.licExpiry
                managed.busLicExpiryDate = singleVehicle.busLicExpiryDate
                managed.vehComment = singleVehicle.vehComment
                managed.modelYear = singleVehicle.modelYear
                managed.placeofIssue = singleVehicle.placeofIssue
                managed.vehicleType = singleVehicle.vehicleType
                managed.permitExpiry = singleVehicle.permitExpiry
                managed.permitID = singleVehicle.permitID
                    
                    
                } // end of the autorelease
             } // end of the for loop
            
            do {
                try managedObjectContext.save()
                
            } catch let error as NSError {
                
            }
            
            
            
            managedObjectContext.reset()
            

       // } // end of the async
        }// end
    
    func addCompanies(_ companies : NSMutableArray) {
       // Update on Nav 17 2016 used private managed context and autorelease pool for memoery management
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        managedObjectContext.perform { // runs asynchronously

        for a in 0  ..< companies.count  {
            autoreleasepool {
        let singleCompany = companies.object(at: a) as! CompanyDao
            let entity = NSEntityDescription.entity(forEntityName: "Companies", in: managedObjectContext)
            let managed = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Companies
            managed.id = singleCompany.company_id
            managed.company_name = singleCompany.company_name
            managed.company_name_arabic = singleCompany.company_name_arabic
            managed.license_info = singleCompany.license_info
            managed.license_issue_date = singleCompany.license_issue_date
            managed.license_expiry_date = singleCompany.license_expire_date
            managed.landline = singleCompany.landline
            managed.address = singleCompany.address
            
            managed.phone_no = singleCompany.phone_no
            managed.email_address = singleCompany.email
            managed.pro_name = singleCompany.pro_name
            managed.pro_email = singleCompany.email_pro
            managed.pro_contact_no = singleCompany.pro_mobile
          
               // print("PRO INFO \(managed.pro_contact_no)")
                
            managed.latitude = singleCompany.lat
            managed.longitude = singleCompany.lon
            managed.category_name = singleCompany.category_name
            managed.category_name_arb = singleCompany.category_name_ar
            managed.alternativeNumber = singleCompany.alternativeNumber
            managed.activityType = singleCompany.activityType
            managed.activityType_Arb = singleCompany.activityType_ar
            managed.activity_code = singleCompany.activity_code
            managed.address_notes = singleCompany.address_note
            managed.company_notes = singleCompany.company_note
            managed.pro_name = singleCompany.pro_name
            managed.pro_email = singleCompany.email_pro
           // managed.pro_contact_no = singleCompany.email_pro
            }
            
            /*
            
            
            @NSManaged var company_name: String?
            @NSManaged var id: String?
            @NSManaged var company_name_arabic: String?
            @NSManaged var license_info: String?
            @NSManaged var license_issue_date: String?
            @NSManaged var landline: String?
            @NSManaged var phone_no: String?
            @NSManaged var email_address: String?
            @NSManaged var pro_name: String?
            @NSManaged var pro_email: String?
            @NSManaged var pro_contact_no: String?
            @NSManaged var latitude: String?
            @NSManaged var longitude: String?
            @NSManaged var category_name: String?
            @NSManaged var category_name_arb: String?
            @NSManaged var alternativeNumber: String?
            @NSManaged var activityType: String?
            @NSManaged var activityType_Arb: String?
            @NSManaged var created_date: String?
            
            }

           */
            
            
            
            
        } // end of the for loop
        
        
//        var error : NSError?
//        do {
//            try self.appDel.managedObjectContext?.save()
//        } catch let error1 as NSError {
//            error = error1
//        }
//        if error != nil {
//            print(error, terminator: "")
//        }
//        else {
//            print("Company added", terminator: "")
//        }
            do {
                 try managedObjectContext.save()
            
             } catch let error as NSError {
            
              }

        
            
    managedObjectContext.reset()
            
        }
    }
    
    
    func addViolations(_ violations : NSMutableArray) {
    
        for a in 0  ..< violations.count  {
            let singleViolations = violations.object(at: a) as! ViolationHistoryDao
            let entity = NSEntityDescription.entity(forEntityName: "Violations_History", in: appDel.managedObjectContext!)
            let dbObject = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! Violations_History
            
//            if singleWarning.question_desc != nil {
//                dbObject.question_desc = singleWarning.question_desc
//            }
//            if singleWarning.warning_duration != nil {
//                dbObject.warning_duration = singleWarning.warning_duration
//            }
//            
//            if singleWarning.entry_datetime != nil {
//                dbObject.entry_datetime = singleWarning.entry_datetime
//                
//            }

            
            dbObject.company_id = singleViolations.company_id
            dbObject.offencecode = singleViolations.offencecode
            dbObject.offencecodedescription = singleViolations.violation_name
            dbObject.offencecodedescription_arb = singleViolations.violation_name_ar
            dbObject.inspectiondate = singleViolations.inspectiondate
        
            
                
                
                
            
            
            
            
            
        } // end of the for loop
        
        var error : NSError?
        do {
            try self.appDel.managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil {
            print(error, terminator: "")
        }
        else {
            print("violations added for company ", terminator: "")
        }

    }

    func addWarnings(_ warnings : NSMutableArray , company_id : String){
        for a in 0  ..< warnings.count  {
          let singleWarning = warnings.object(at: a) as! WarningsDao
          let entity = NSEntityDescription.entity(forEntityName: "Warning_History", in: appDel.managedObjectContext!)
           let dbObject = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! Warning_History
            
            if singleWarning.question_desc != nil {
            dbObject.question_desc = singleWarning.question_desc
            }
            if singleWarning.warning_duration != nil {
            dbObject.warning_duration = singleWarning.warning_duration
            }
            
            if singleWarning.entry_datetime != nil {
            dbObject.entry_datetime = singleWarning.entry_datetime
            
            }
            dbObject.company_id = company_id
            
            
        } // end of the for loop
        
        var error : NSError?
        do {
            try self.appDel.managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil {
            print(error, terminator: "")
        }
        else {
            print("warnings added for company \(company_id)", terminator: "")
        }

        
    }
    
    
    func addCompanyViolations(_ violations : NSMutableArray , company_id : String) {
        for a in 0  ..< violations.count  {
            let singleViolation = violations.object(at: a) as! ViolationHistoryDao
            let entity = NSEntityDescription.entity(forEntityName: "Violations_History", in: appDel.managedObjectContext!)
            let dbObject = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! Violations_History
            /*
            @NSManaged var violationpaystatusName: String?
            @NSManaged var inspectorname: String?
            @NSManaged var offencecode: String?
            @NSManaged var inspectiondate: String?
            @NSManaged var offencecodedescription: String?
            @NSManaged var offencecodedescription_arb: String?
            @NSManaged var company_id: String?

             */
            
            
            if singleViolation.violationpaystatusName != nil {
            dbObject.violationpaystatusName = singleViolation.violationpaystatusName
                
            }
            
            if singleViolation.inspectorname != nil {
            dbObject.inspectorname = singleViolation.inspectorname
            }
            
            if singleViolation.offencecode != nil {
            dbObject.offencecode = singleViolation.offencecode
            }
            if singleViolation.inspectiondate != nil {
            dbObject.inspectiondate = singleViolation.inspectiondate
            }
            
            if singleViolation.violation_name != nil {
            dbObject.offencecodedescription = singleViolation.violation_name
                
            }
            if singleViolation.violation_name_ar != nil {
            dbObject.offencecodedescription_arb =  singleViolation.violation_name_ar
            }
            
            dbObject.company_id = company_id
            
            
            
            
        }
        
        var error : NSError?
        do {
            try self.appDel.managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil {
            print(error, terminator: "")
        }
        else {
            print("warnings added for company \(company_id)", terminator: "")
        }
        

        
            
            
            
        
    }
    func addInspectionList(_ questions : NSMutableArray , taskid : String){
        print("Add questions called")
        print("Questions on \(self.fetchQuestionList(taskid).count)")
        
//        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
//        
//        managedObjectContext.performBlock { // runs asynchronously
//
        

        for a in 0  ..< questions.count  {
           // autoreleasepool {
        let q1 = questions.object(at: a) as! QuestionDao
            let entity = NSEntityDescription.entity(forEntityName: "InspectionList", in: self.appDel.managedObjectContext!)

            let list = NSManagedObject(entity: entity!, insertInto: self.appDel.managedObjectContext!) as! InspectionList
            if q1.question_id != nil {
            list.q_id =  q1.question_id
            }
            if q1.list_id != nil {
            list.list_id = q1.list_id
            }
            if q1.catg_id != nil {
               list.catg_id = q1.catg_id
                
            }
            
            
            
            if q1.entry_datetime != nil {
             list.entry_Datetime = q1.entry_datetime
            }
            if q1.question_desc != nil {

            list.question_desc = q1.question_desc
            }
            if q1.question_desc_en != nil {
          //   list.question_desc
                list.question_desc_en = q1.question_desc_en
            }
            if q1.violation_code != nil {
            list.violation_code = q1.violation_code
          //  print("adding violaton code \(list.violation_code)")
            }
            if q1.notes != nil {
            list.notes = q1.notes
            }
            list.task_id = taskid
             self.addOption(q1.allOptions, q_id: q1.question_id)
            
            
             
            
            }
        //}// end of the for loop
            
            
        //}
        //managedObjectContext.reset()
        
       
    }
   
    func saveAllData(){
        var error : NSError?
        do {
            try self.appDel.managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil {
            print(error, terminator: "")
        }
        else {
           // print("Inspection added \(taskid)", terminator: "")
        }
    }
    
    func addOption(_ options : NSMutableArray , q_id : String) {
        //print("before Q_id \(q_id)")
        if self.checkOptions(q_id).count > 0 {
       //    print("returning for q_id \(q_id)")
        return
        }
        
        for a in 0  ..< options.count  {
            let o1 = options.object(at: a) as! OptionDao
            let entity = NSEntityDescription.entity(forEntityName: "Options", in: appDel.managedObjectContext!)
            
            let list = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! Options
            if o1.option_description != nil {
            list.description1 =  o1.option_description
            }
            if o1.entry_Datetime != nil {
            list.entry_Datetime = o1.entry_Datetime
            }
            if o1.is_required != nil {
            list.is_required = o1.is_required
            }
            if o1.option_id != nil {
            list.option_id = o1.option_id
            }
            if o1.option_label != nil {
            list.option_label = o1.option_label
            }
            if o1.option_type != nil {
            list.option_type = o1.option_type
            }
            if o1.is_selected != nil {
                list.is_selected = "\(o1.is_selected)"
                
            }
            
            if o1.question_id != nil {
            list.q_id = o1.question_id
             //print("Q_id \(list.q_id)")
            }
           // list.q_id = o1.question_id
            //list.violation_code = o1.violation_code
            self.addExtraOption(o1.allExraOptions , option_id: o1.option_id)
           
            
            
            /*

            @NSManaged var description1: String
            @NSManaged var entry_Datetime: String
            @NSManaged var is_required: String
            @NSManaged var option_id: String
            @NSManaged var option_label: String
            @NSManaged var option_type: String
            @NSManaged var q_id: String
            @NSManaged var violation_code: String
           */

        }
        var error : NSError?
        do {
            try self.appDel.managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil {
        print(error, terminator: "")
        }
//
    }
    func changeStatus(_ task_id : String){
        var error : NSError?
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let predicate = NSPredicate(format: "task_id = %@", task_id)
        print(predicate)
        
        taskRequest.predicate = predicate
        let array = (try! self.appDel.managedObjectContext?.fetch(taskRequest)) as! [Tasks]
        if array.count > 0 {
        let task = array[0]
           task.is_completed = "1"
            var error : NSError?
            do {
                try self.appDel.managedObjectContext?.save()
            } catch let error1 as NSError {
                error = error1
            }
            if error != nil {
                print(error, terminator: "")
            }
            
  
        }
    }
    
    
    func changeStatusOffline(_ unique : String){
        var error : NSError?
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let predicate = NSPredicate(format: "uniqueid = %@", unique)
        print(predicate)
        
        taskRequest.predicate = predicate
        let array = (try! self.appDel.managedObjectContext?.fetch(taskRequest)) as! [Tasks]
        
        print("Count found \(array.count) ")
        if array.count > 0 {
            let task = array[0]
            print(task.external_notes)
            
            task.is_completed = "1"
            var error : NSError?
            do {
                try self.appDel.managedObjectContext?.save()
            } catch let error1 as NSError {
                error = error1
            }
            if error != nil {
                print(error, terminator: "")
            }
            
            
        }
    }

    func chaneZoneStatus(_ task : TaskDao){
        var error : NSError?
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let predicate = NSPredicate(format: "task_id = %@", task.task_id)
        print(predicate)
        
        taskRequest.predicate = predicate
        let array = (try! self.appDel.managedObjectContext?.fetch(taskRequest)) as! [Tasks]
        if array.count > 0 {
            let task = array[0]
            task.zone_status = "started"
            var error : NSError?
            do {
                try self.appDel.managedObjectContext?.save()
            } catch let error1 as NSError {
                error = error1
            }
            if error != nil {
                print(error, terminator: "")
            }
            
            
        }

    }
    
    
    
    
    
    
    
    
    func updateCoInspector(task_id : String, unique_id : String? , coinspectors : String){
        var error : NSError?
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        if  task_id == "0" {
            if unique_id != nil {
            let predicate = NSPredicate(format: "uniqueid = %@", unique_id!)
            print(predicate)
            taskRequest.predicate = predicate
            }
        }
        else {
            let predicate = NSPredicate(format: "task_id = %@", task_id)
            print(predicate)
            taskRequest.predicate = predicate
            
        }
        let array = (try! self.appDel.managedObjectContext?.fetch(taskRequest)) as! [Tasks]
        if array.count > 0 {
             let dbtask = array[0]
            dbtask.coninspectors = coinspectors
            
        } // end of the if
        do {
            try self.appDel.managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
        }
        
    }
    
    func updateTaskDetail(_ task : TaskDao) {
     var error : NSError?
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let predicate = NSPredicate(format: "task_id = %@", task.task_id)
        print(predicate)
        taskRequest.predicate = predicate
        let array = (try! self.appDel.managedObjectContext?.fetch(taskRequest)) as! [Tasks]
        if array.count > 0 {
        let dbtask = array[0]
            dbtask.address_notes = task.company.address_note
            dbtask.latitude = task.company_lat
            dbtask.longitude = task.company_lon
            dbtask.company_notes = task.company.company_note
            dbtask.pro_name = task.company.pro_name
            dbtask.pro_email = task.company.email_pro
            dbtask.pro_contact = task.company.pro_mobile
            do {
                try self.appDel.managedObjectContext?.save()
            } catch let error1 as NSError {
                error = error1
            }
            if error != nil {
                print(error, terminator: "")
            }
            else {
             print("taskupdated from the detail")
            self.updateCompanyDetail(task)
            }
            

        } // end of the count
        
    }
    
    
    func updateCompanyDetail(_ task : TaskDao) {
        var error : NSError?
        let companyRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Companies")
        let predicate = NSPredicate(format: "id = %@", task.company.company_id!)
        print(predicate)
        companyRequest.predicate = predicate
        
        let array = (try! self.appDel.managedObjectContext?.fetch(companyRequest)) as! [Companies]
        if array.count > 0 {
           let company  = array[0]
           company.company_notes = task.company.company_note
           company.address_notes = task.company.address_note
           company.pro_email = task.company.email_pro
           company.pro_name = task.company.pro_name
           company.pro_contact_no = task.company.pro_mobile
            do {
                try self.appDel.managedObjectContext?.save()
            } catch let error1 as NSError {
                error = error1
            }
            if error != nil {
                print(error, terminator: "")
            }
 
            
        
        } // end of the if
        
        
    }// end of the if
    
    
    func updateTaskContactDetails(pro_desig : String,provided_by_desig : String,provided_by_name : String,pro_email : String, pro_name :
        String , pro_contact_no : String , license_No : String){
       var error : NSError?
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let predicate = NSPredicate(format: "license_info = %@", license_No)
         print(predicate)
        taskRequest.predicate = predicate
        let array = (try! self.appDel.managedObjectContext?.fetch(taskRequest)) as! [Tasks]
        for a in 0  ..< array.count  {
        let task = array[a]
            task.pro_designition = pro_desig
            task.providedby_desig = provided_by_desig
            task.provided_by = provided_by_name
            
            task.pro_email = pro_email
            task.pro_name = pro_name
            task.pro_contact = pro_contact_no
           
            
        
        }
        do {
            try self.appDel.managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil {
            print(error, terminator: "")
        }
        
        
    }
    
    
    func updateCompanyProDetail(pro_desig : String,provided_by_desig : String,provided_by_name : String,pro_email : String, pro_name : String , pro_contact_no : String , license_No : String) {
        var error : NSError?
        let companyRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Companies")
        let predicate = NSPredicate(format: "license_info = %@", license_No)
        print(predicate)
        companyRequest.predicate = predicate
        
        let array = (try! self.appDel.managedObjectContext?.fetch(companyRequest)) as! [Companies]
        if array.count > 0 {
            let company  = array[0]
            company.pro_desig = pro_desig
            company.provided_by_desig = provided_by_desig
            company.provided_by_name = provided_by_name
            
            company.pro_email = pro_email
            company.pro_name = pro_name
            company.pro_contact_no = pro_contact_no
            
            print(company.pro_desig)
            print(company.provided_by_desig)
            print(company.provided_by_name)
            
            
            
            do {
                try self.appDel.managedObjectContext?.save()
            } catch let error1 as NSError {
                error = error1
            }
            if error != nil {
                print(error, terminator: "")
            }
            
            
            
        } // end of the if
        
        
    }// end of the if
    
    
    
    func changeOnMyWayStatus(_ task_id : String, status : String){
        var error : NSError?
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let predicate = NSPredicate(format: "task_id = %@", task_id)
        print(predicate)
        taskRequest.predicate = predicate
        let array = (try! self.appDel.managedObjectContext?.fetch(taskRequest)) as! [Tasks]
        if array.count > 0 {
            let task = array[0]
            task.task_status = status
            var error : NSError?
            do {
                try self.appDel.managedObjectContext?.save()
            } catch let error1 as NSError {
                error = error1
            }
            if error != nil {
                print(error, terminator: "")
            }
            
            
        }
    }

    
    
    func deleteEverything(){
       
  //  self.deleteAllExtraOptions()
   // self.deleteAllOptions()
   // self.deleteAllQuestion()
    self.deleteAllTasks()
    self.deleteAllViolations()
    self.deleteAllWarnings()
        
    }
    func deleteSubVeneues(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subvenues")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.appDel.persistentStoreCoordinator!.execute(deleteRequest, with: self.appDel.managedObjectContext!)
            
        } catch let error as NSError {
            // TODO: handle the error
        }
    }
    
    
    
    
    func deleteVehicles(_ allPermits : NSMutableArray){
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VehicleInfo")
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(deleteRequest)
                try  managedObjectContext.save()
                
            } catch let error as NSError {
                // TODO: handle the error
            }
        } else {
            // Fallback on earlier versions
            
            
            
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "VehicleInfo")
            var error : NSError?
            let array: [AnyObject]?
            do {
                array = try managedObjectContext.fetch(fetch)
            } catch let error1 as NSError {
                error = error1
                array = nil
            }
            for a in 0  ..< array!.count  {
                //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
                if let object = array?[a] as? NSManagedObject {
                    managedObjectContext.delete(object)
                }
            }
            
            do {
                try managedObjectContext.save()
                
            } catch let error1 as NSError {
                error = error1
                
            }
            
            
        }
        self.addAllPermits(allPermits)
        
    }
    
    
    
    
    
    func deleteDrivers(){
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PermitDrivers")
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(deleteRequest)
                try  managedObjectContext.save()
                
            } catch let error as NSError {
                // TODO: handle the error
            }
        } else {
            // Fallback on earlier versions
            
            
            
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PermitDrivers")
            var error : NSError?
            let array: [AnyObject]?
            do {
                array = try managedObjectContext.fetch(fetch)
            } catch let error1 as NSError {
                error = error1
                array = nil
            }
            for a in 0  ..< array!.count  {
                //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
                if let object = array?[a] as? NSManagedObject {
                    managedObjectContext.delete(object)
                }
            }
            
            do {
                try managedObjectContext.save()
            } catch let error1 as NSError {
                error = error1
            }
            
            
        }
    }
    
    
    func deleteOfflinePermits(){
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllPermits")
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(deleteRequest)
                try  managedObjectContext.save()
                
            } catch let error as NSError {
                // TODO: handle the error
            }
        } else {
            // Fallback on earlier versions
            
            
            
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AllPermits")
            var error : NSError?
            let array: [AnyObject]?
            do {
                array = try managedObjectContext.fetch(fetch)
            } catch let error1 as NSError {
                error = error1
                array = nil
            }
            for a in 0  ..< array!.count  {
                //    self.appDel.managedObjectContext.deleteObject(array[a] as! NSManagedObject)
                if let object = array?[a] as? NSManagedObject {
                    managedObjectContext.delete(object)
                }
            }
            
            do {
                try managedObjectContext.save()
            } catch let error1 as NSError {
                error = error1
            }
            
            
        }
    }
    
    func addExtraOption(_ eOptions : NSMutableArray , option_id : String){
        if fetchExtraOptions(option_id).count > 0 {
             //print("Returning for  optiond id \(option_id)")
            return
        }
        for a in 0  ..< eOptions.count  {
            let eo1 = eOptions.object(at: a) as! ExtraOption
            let entity = NSEntityDescription.entity(forEntityName: "Extra_Options", in: appDel.managedObjectContext!)
            
            let list = NSManagedObject(entity: entity!, insertInto: appDel.managedObjectContext) as! Extra_Options
            list.e_option_id = eo1.extra_optionId
            list.option_id = eo1.option_id
            if eo1.option_id != nil {
            list.label = eo1.label
            }
            if eo1.value != nil {
            list.value = eo1.value
            }
            if eo1.is_selected != nil {
               
            list.is_selected = eo1.is_selected.stringValue
             print("saving to database \(list.is_selected)")
            }
            else {
            print("Extr option in nil")
            
            }
            if  eo1.violation_id != nil {
            list.violation_id = eo1.violation_id
            }
            list.entry_datetime = eo1.entry_datetime
            if eo1.valication_code != nil {
            list.valication_code = eo1.valication_code
            }
            if eo1.violation_name != nil {
            list.violation_nam = eo1.violation_name
            }
            
            
            
//            var extra_optionId : String!
//            
//            var  option_id : String!
//            
//            var label:String!
//            
//            var value : String!
//            
//            var is_selected:NSNumber! = NSNumber(int: 0)
//            
//            var violation_id : String!
//            var entry_datetime: String!
//            var valication_code:String!
//            var violation_name : String!
//            

            
        }
    }
    

    
}
