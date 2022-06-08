//
//  Options.swift
//  
//
//  Created by Administrator on 12/6/15.
//
//

import Foundation
import CoreData
@objc(Options)
class Options: NSManagedObject {

    @NSManaged var description1: String?
    @NSManaged var entry_Datetime: String?
    @NSManaged var is_required: String?
    @NSManaged var option_id: String?
    @NSManaged var option_label: String?
    @NSManaged var option_type: String?
    @NSManaged var q_id: String?
    @NSManaged var violation_code: String?
    @NSManaged var is_selected: String?
    @NSManaged var warning_duration: String?

}
