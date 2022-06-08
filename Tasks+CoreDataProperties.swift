//
//  Tasks+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 7/11/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var activity_code: String?
    @NSManaged public var additional_email: String?
    @NSManaged public var address: String?
    @NSManaged public var address_notes: String?
    @NSManaged public var area_id: String?
    @NSManaged public var area_name: String?
    @NSManaged public var attribute: String?
    @NSManaged public var auditor_id: String?
    @NSManaged public var auditor_name: String?
    @NSManaged public var category_id: String?
    @NSManaged public var classification: String?
    @NSManaged public var company_categoriesCount: NSNumber?
    @NSManaged public var company_id: String?
    @NSManaged public var company_name: String?
    @NSManaged public var company_name_arabic: String?
    @NSManaged public var company_notes: String?
    @NSManaged public var created_by: String?
    @NSManaged public var due_date: String?
    @NSManaged public var email_address: String?
    @NSManaged public var establishmentID: String?
    @NSManaged public var expire_date: String?
    @NSManaged public var external_notes: String?
    @NSManaged public var ins_type_name: String?
    @NSManaged public var ins_type_name_arb: String?
    @NSManaged public var inspection_type: String?
    @NSManaged public var inspector_id: String?
    @NSManaged public var is_completed: String?
    @NSManaged public var is_Submitted: String?
    @NSManaged public var isSubvenue: String?
    @NSManaged public var issue_date: String?
    @NSManaged public var isZoneTask: NSNumber?
    @NSManaged public var landline: String?
    @NSManaged public var latitude: String?
    @NSManaged public var license_expire_date: String?
    @NSManaged public var license_info: String?
    @NSManaged public var license_issue_date: String?
    @NSManaged public var list_id: String?
    @NSManaged public var list_title: String?
    @NSManaged public var longitude: String?
    @NSManaged public var parent_task_id: String?
    @NSManaged public var parent_zone_status: String?
    @NSManaged public var permit_lat: String?
    @NSManaged public var permit_lon: String?
    @NSManaged public var permit_type: String?
    @NSManaged public var permit_url: String?
    @NSManaged public var permitID: String?
    @NSManaged public var phone_no: String?
    @NSManaged public var pool: String?
    @NSManaged public var priority: String?
    @NSManaged public var pro_contact: String?
    @NSManaged public var pro_designition: String?
    @NSManaged public var pro_email: String?
    @NSManaged public var pro_name: String?
    @NSManaged public var provided_by: String?
    @NSManaged public var providedby_desig: String?
    @NSManaged public var record_id: String?
    @NSManaged public var subvenue: String?
    @NSManaged public var task_DueDate: NSDate?
    @NSManaged public var task_id: String?
    @NSManaged public var task_name: String?
    @NSManaged public var task_notes: String?
    @NSManaged public var task_status: String?
    @NSManaged public var type_id: String?
    @NSManaged public var type_name: String?
    @NSManaged public var uniqueid: String?
    @NSManaged public var waiting_for_audit: String?
    @NSManaged public var zone_expiryDate: String?
    @NSManaged public var zone_id: String?
    @NSManaged public var zone_name_ar: String?
    @NSManaged public var zone_name_eng: String?
    @NSManaged public var zone_startDate: String?
    @NSManaged public var zone_status: String?

}
