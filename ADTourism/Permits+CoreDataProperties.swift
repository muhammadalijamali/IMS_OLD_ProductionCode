//
//  Permits+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 2/5/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import Foundation
import CoreData


extension Permits {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "Permits");
    }

    @NSManaged public var company_id: String?
    @NSManaged public var expire_date: String?
    @NSManaged public var issue_date: String?
    @NSManaged public var license_info: String?
    @NSManaged public var permit_type: String?
    @NSManaged public var permit_url: String?
    @NSManaged public var permitID: String?
    @NSManaged public var record_id: String?
    @NSManaged public var lat: String?
    @NSManaged public var lon: String?

}
