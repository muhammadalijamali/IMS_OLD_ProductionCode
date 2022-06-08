//
//  Date+Utility.swift
//  ADTourism
//
//  Created by Muhammad Ali on 8/29/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import Foundation
extension NSDate {
    /**
     Formats a Date
     
     - parameters format: (String) for eg dd-MM-yyyy hh-mm-ss
     */
    func format(format:String = "MM-dd-yyyy HH:mm:ss") -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self as Date)
        if let newDate = dateFormatter.date(from: dateString) {
            return newDate as NSDate
        } else {
            return self
        }
    }
}

