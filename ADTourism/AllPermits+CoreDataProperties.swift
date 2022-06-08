//
//  AllPermits+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 2/5/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import Foundation
import CoreData


extension AllPermits {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "AllPermits");
    }

    @NSManaged public var appComment: String?
    @NSManaged public var businessLicense: String?
    @NSManaged public var contactNumber: String?
    @NSManaged public var coordinatorName: String?
    @NSManaged public var endDate: String?
    @NSManaged public var expiryDate: String?
    @NSManaged public var issuedDate: String?
    @NSManaged public var organizerName: String?
    @NSManaged public var permitID: String?
    @NSManaged public var startDate: String?
    @NSManaged public var subvenue: String?
    @NSManaged public var campArea: String?
    @NSManaged public var permitType : String?
    

}
