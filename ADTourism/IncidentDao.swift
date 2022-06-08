//
//  IncidentDao.swift
//  ADTourism
//
//  Created by Muhammad Ali on 8/2/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class IncidentDao: NSObject {
    /*
    "id": "2",
    "inspectorID": "370",
    "establishmentID": "10",
    "notes": "This is image",
    "status": "pending",
    "latitude": "25.25127251",
    "longitude": "55.34432193",
    "source": "Inspection-App",
    "category": "2",
    "urgency": "3",
    "entry_datetime": "2016-08-02 11:08:46",
    "establishmentName": null,
    "establishmentNameArb": null,
    "extEstablishmentName": "Dubai Electricity and Water Authority - DEWA      ",
    "extEstablishmentNameArb": "هيئة كهرباء ومياه دبي",
    "first_name": "Fahad",
 */
    var incident_id : String?
    var inspectorID : String?
    var establishmentID : String?
    var latitude : String?
    var longitude : String?
    var source : String?
    var category : String? // category 1  DTCM catgeory NON-DTCM
    var urgency : String? // 1 low , 2 medium , 3 high
    var establishmentName : String?
    var establishmentNameArb :String?
    var extEstablishmentName : String?
    var extEstablishmentNameArb : String?
    var inspector_Name : String?
    var incidentMedia : IncidentMediaDao?
    var notes  : String?
    var incidentMediaArray : NSMutableArray = NSMutableArray()
    var incident_comments : String?
    
    
    
    
    
    
    
    
    
    
    
    
}
