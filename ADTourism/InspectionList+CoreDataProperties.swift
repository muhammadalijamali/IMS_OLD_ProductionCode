//
//  InspectionList+CoreDataProperties.swift
//  ADTourism
//
//  Created by Muhammad Ali on 5/3/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension InspectionList {

    @NSManaged var audio: String?
    @NSManaged var entry_Datetime: String?
    @NSManaged var image: String?
    @NSManaged var list_id: String?
    @NSManaged var list_name: String?
    @NSManaged var notes: String?
    @NSManaged var q_id: String?
    @NSManaged var question_desc: String?
    @NSManaged var question_desc_en: String?
    @NSManaged var task_id: String?
    @NSManaged var violation_count: String?
    @NSManaged var warning_count: String?
    @NSManaged var violation_code: String?
    @NSManaged var catg_id : String?
    

}
