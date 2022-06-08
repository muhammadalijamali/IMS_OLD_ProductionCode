//
//  OfflineTasks+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 3/23/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension OfflineTasks {

    @NSManaged var company_id: String?
    @NSManaged var taskdatetime: String?
    @NSManaged var list_id: String?
    @NSManaged var category_id: String?

}
