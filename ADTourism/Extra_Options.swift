//
//  Extra_Options.swift
//  
//
//  Created by Administrator on 12/6/15.
//
//

import Foundation
import CoreData
@objc(Extra_Options)
class Extra_Options: NSManagedObject {

    @NSManaged var e_option_id: String?
    @NSManaged var entry_datetime: String?
    @NSManaged var is_selected: String?
    @NSManaged var label: String?
    @NSManaged var option_id: String?
    @NSManaged var valication_code: String?
    @NSManaged var value: String?
    @NSManaged var violation_code: String?
    @NSManaged var violation_id: String?
    @NSManaged var violation_nam: String?
    @NSManaged var is_media : String?
    

}
