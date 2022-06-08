//
//  QuestionCategories+CoreDataProperties.swift
//  ADTourism
//
//  Created by MACBOOK on 7/10/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//
//

import Foundation
import CoreData


extension QuestionCategories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionCategories> {
        return NSFetchRequest<QuestionCategories>(entityName: "QuestionCategories")
    }

    @NSManaged public var catg_id: String?
    @NSManaged public var catg_name_ar: String?
    @NSManaged public var catg_name_eng: String?

}
