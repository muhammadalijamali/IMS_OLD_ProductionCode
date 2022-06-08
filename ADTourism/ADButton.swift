//
//  ADButton.swift
//  ADTourism
//
//  Created by Administrator on 8/26/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit
import MapKit
class ADButton: UIButton {
    var questionid:Int!
    var option_id:Int!
    var valueSelect : Int =  0 // 1 selected 0 not selected
    var rowIndex: Int!
    var audioState:Int! = -1
    var question : QuestionDao!
    var option : OptionDao!
    var extraOption : ExtraOption!
    var mediaId : String!
    var radioCell:RadioBtnTableViewCell!
    var buttonnumber : Int = 0 // 1 ,2, 3, 4, 5
    var dividedOption : DividedQuestion?
    var taskDao : TaskDao!
    var violation_code : String?
    var history_taskid : String?
    var hisory_notes : String?
    var annotation : MKAnnotation?
    var countlbl : UILabel?
    var redDotImage : UIImageView?
    var historyTask : TaskHistoryDao?
    
    
    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
