//
//  Inspection_logs+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 7/5/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//
//

import Foundation
import CoreData


extension Inspection_logs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Inspection_logs> {
        return NSFetchRequest<Inspection_logs>(entityName: "Inspection_logs")
    }

    @NSManaged public var archieve_date: String?
    @NSManaged public var archieve_serverrespomse: String?
    @NSManaged public var audio_attached: NSNumber?
    @NSManaged public var company_name: String?
    @NSManaged public var created_on: String?
    @NSManaged public var inspector_id: String?
    @NSManaged public var inspector_name: String?
    @NSManaged public var json_string: String?
    @NSManaged public var license_no: String?
    @NSManaged public var media_attached: NSNumber?
    @NSManaged public var number_of_photos: NSNumber?
    @NSManaged public var server_response: String?
    @NSManaged public var submitted_on: String?
    @NSManaged public var task_id: String?
    @NSManaged public var unique_id: String?

}
