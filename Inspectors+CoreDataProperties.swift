//
//  Inspectors+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 10/9/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//
//

import Foundation
import CoreData


extension Inspectors {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Inspectors> {
        return NSFetchRequest<Inspectors>(entityName: "Inspectors")
    }

    @NSManaged public var employee_id: String?
    @NSManaged public var inspector_id: String?
    @NSManaged public var inspector_Name: String?
    @NSManaged public var shift_id: String?
    @NSManaged public var shift_name: String?

}
