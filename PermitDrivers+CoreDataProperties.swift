//
//  PermitDrivers+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 1/26/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import Foundation
import CoreData


extension PermitDrivers {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "PermitDrivers");
    }

    @NSManaged public var driver_name: String?
    @NSManaged public var nationality: String?
    @NSManaged public var drLicNo: String?
    @NSManaged public var drLicIssue: String?
    @NSManaged public var drLicExpiry: String?
    @NSManaged public var drComment: String?
    @NSManaged public var isFirstAid: String?
    @NSManaged public var permitID: String?

}
