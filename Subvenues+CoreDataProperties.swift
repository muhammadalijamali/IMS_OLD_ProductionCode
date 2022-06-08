//
//  Subvenues+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 6/6/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import Foundation
import CoreData


extension Subvenues {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "Subvenues");
    }

    @NSManaged public var id: String?
    @NSManaged public var licenseNumber: String?
    @NSManaged public var subVenue: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?

}
