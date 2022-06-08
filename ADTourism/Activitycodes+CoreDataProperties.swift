//
//  Activitycodes+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 3/22/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Activitycodes {

    @NSManaged var id: String?
    @NSManaged var activity_code: String?
    @NSManaged var activity_name: String?
    @NSManaged var activity_name_arabic: String?

}
