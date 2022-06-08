//
//  Warning_History+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 2/21/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Warning_History {

    @NSManaged var question_desc: String?
    @NSManaged var warning_duration: String?
    @NSManaged var entry_datetime: String?
    @NSManaged var company_id: String?

}
