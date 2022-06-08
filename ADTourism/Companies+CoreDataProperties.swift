//
//  Companies+CoreDataProperties.swift
//  
//
//  Created by MACBOOK on 3/25/18.
//
//

import Foundation
import CoreData


extension Companies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Companies> {
        return NSFetchRequest<Companies>(entityName: "Companies")
    }

    @NSManaged public var activity_code: String?
    @NSManaged public var activityType: String?
    @NSManaged public var activityType_Arb: String?
    @NSManaged public var address: String?
    @NSManaged public var address_notes: String?
    @NSManaged public var alternativeNumber: String?
    @NSManaged public var category_name: String?
    @NSManaged public var category_name_arb: String?
    @NSManaged public var company_name: String?
    @NSManaged public var company_name_arabic: String?
    @NSManaged public var company_notes: String?
    @NSManaged public var created_date: String?
    @NSManaged public var email_address: String?
    @NSManaged public var id: String?
    @NSManaged public var landline: String?
    @NSManaged public var latitude: String?
    @NSManaged public var license_expiry_date: String?
    @NSManaged public var license_info: String?
    @NSManaged public var license_issue_date: String?
    @NSManaged public var longitude: String?
    @NSManaged public var phone_no: String?
    @NSManaged public var pro_contact_no: String?
    @NSManaged public var pro_email: String?
    @NSManaged public var pro_name: String?
    @NSManaged public var pro_desig: String?
    @NSManaged public var provided_by_desig: String?
    @NSManaged public var provided_by_name: String?

}
