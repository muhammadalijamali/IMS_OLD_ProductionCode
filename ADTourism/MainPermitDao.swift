//
//  MainPermitDao.swift
//  ADTourism
//
//  Created by Muhammad Ali on 1/26/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit

class MainPermitDao: NSObject {
   
      var businessLicense: String?
      var organizerName: String?
      var expiryDate: String?
      var permitID: String?
      var startDate: String?
      var endDate: String?
      var coordinatorName: String?
      var contactNumber: String?
      var appComment: String?
      var issuedDate: String?
      var subVenue : String?
      var campArea : String?
      var permitType :String?
      var drivers : NSMutableArray = NSMutableArray()
      var vehicles : NSMutableArray = NSMutableArray()
      var seachedDrLicense : String?
      var searchedCar: String?
     var isOutdated : Bool = false 
 


}
