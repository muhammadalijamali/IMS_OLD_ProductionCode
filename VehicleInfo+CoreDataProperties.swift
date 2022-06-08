//
//  VehicleInfo+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 1/26/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import Foundation
import CoreData


extension VehicleInfo {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "VehicleInfo");
    }

    @NSManaged public var tradeMarkname: String?
    @NSManaged public var ownerName: String?
    @NSManaged public var plateNo: String?
    @NSManaged public var licIssue: String?
    @NSManaged public var licExpiry: String?
    @NSManaged public var busLicExpiryDate: String?
    @NSManaged public var vehComment: String?
    @NSManaged public var modelYear: String?
    @NSManaged public var placeofIssue: String?
    @NSManaged public var vehicleType: String?
    @NSManaged public var permitExpiry: String?
    @NSManaged public var permitID: String?

}
