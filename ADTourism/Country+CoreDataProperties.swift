//
//  Country+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 7/15/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var countryCode: String?
    @NSManaged public var countryName: String?
    @NSManaged public var countryNameAr: String?
    @NSManaged public var dnrdCode: String?

}
