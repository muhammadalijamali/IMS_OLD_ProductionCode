//
//  Makani+CoreDataProperties.swift
//  ADTourism
//
//  Created by MACBOOK on 11/2/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import Foundation
import CoreData


extension Makani {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "Makani");
    }

    @NSManaged public var licenseNo: String?
    @NSManaged public var makani: String?

}
