//
//  CompanyActCodes+CoreDataProperties.swift
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

extension CompanyActCodes {

    @NSManaged var id: String?
    @NSManaged var company_id: String?
    @NSManaged var activity_id: String?

}
