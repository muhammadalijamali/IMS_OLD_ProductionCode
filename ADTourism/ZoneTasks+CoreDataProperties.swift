//
//  ZoneTasks+CoreDataProperties.swift
//  ADTourism
//
//  Created by MACBOOK on 11/27/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import Foundation
import CoreData


extension ZoneTasks {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "ZoneTasks");
    }

    @NSManaged public var task_id: String?
    @NSManaged public var zone_id: String?
    @NSManaged public var zone_name: String?
    @NSManaged public var zone_status: String?
    @NSManaged public var zone_startDate: String?
    @NSManaged public var zone_expiryDate: String?

}
