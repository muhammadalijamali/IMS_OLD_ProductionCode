//
//  Violations_History+CoreDataProperties.swift
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

extension Violations_History {

    @NSManaged var violationpaystatusName: String?
    @NSManaged var inspectorname: String?
    @NSManaged var offencecode: String?
    @NSManaged var inspectiondate: String?
    @NSManaged var offencecodedescription: String?
    @NSManaged var offencecodedescription_arb: String?
    @NSManaged var company_id: String?

}
