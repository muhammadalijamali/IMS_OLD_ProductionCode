//
//  PermitDao.swift
//  ADTourism
//
//  Created by Muhammad Ali on 9/18/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class PermitDao: NSObject {
/*
 
     1:License No
     2:Establishment Name
     3:Permit No/Id
     4:Permit Type
     5:Location
     6:URL (permit pdf url)
     7:Issue Date
     8:Expiry Date
 
     "id": "1",
     "permitID": "23430",
     "permit_type": "party",
     "permit_url": "InitialPermit.pdf",
     "issue_date": "2016-08-01",
     "expire_date": "2016-11-26",
     "company_name": "AL FUTTAIM TRAVEL CO (LLC) - BRANCH 3",
     "company_name_arabic": "شركة الفطيم للسفريات ( ذ م م ) - فرع 3",
     "license_info": "633016",
     "alternativeNumber": "0"
     */
    
    
    
    var license_info : String?
    var company_name : String?
    var company_name_arabic : String?
    
    var permitID : String?
    var permit_type : String?
    var url : String?
    var issue_date : String?
    var expire_date : String?
    var id : String?
    var alternativeNumber : String?
    var ReportID : String?
    var sub_venue : String?
    var lat : String?
    var lon : String?
    var fromSearch : Int = 0; // 0 from not search 1 from search

    
    
    
    
}
