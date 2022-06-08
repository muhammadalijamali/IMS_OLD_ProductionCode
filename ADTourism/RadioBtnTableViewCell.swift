//
//  RadioBtnTableViewCell.swift
//  ADTourism
//
//  Created by Administrator on 8/28/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

class RadioBtnTableViewCell: UITableViewCell {

    @IBOutlet weak var clickBtn1: ADButton!
    @IBOutlet weak var outerbg: UIView!
    @IBOutlet weak var notesBtn: ADButton!
    @IBOutlet weak var recordBtn: ADButton!
    @IBOutlet weak var cameraBtn: ADButton!
    
    @IBOutlet weak var cameraBtn2: ADButton!
    
    @IBOutlet weak var nolbl: UILabel!
    @IBOutlet weak var reddot: UIImageView!
    
    @IBOutlet weak var cameraBtn3: ADButton!
    @IBOutlet weak var barIndicator: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var title4: UILabel!
    @IBOutlet weak var radio4: ADButton!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var radio3: ADButton!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var radio2: ADButton!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var radio1: ADButton!
    @IBOutlet weak var title5: UILabel!
    
    @IBOutlet weak var amountTextField: MarginTextField!
    @IBOutlet weak var view5: UIView!
    
    @IBOutlet weak var radio5: ADButton!
    @IBOutlet weak var questionTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    override func prepareForReuse() {
//        super.prepareForReuse()
//     
//            //    println("Resetting the cell")
//            
//            radio1.setImage(UIImage(named: "toggle"), forState: UIControlState.Normal)
//            radio2.setImage(UIImage(named: "toggle"), forState: UIControlState.Normal)
//            radio3.setImage(UIImage(named: "toggle"), forState: UIControlState.Normal)
//           radio4.setImage(UIImage(named: "toggle"), forState: UIControlState.Normal)
//            
//            
//        
//    }
//    
//   
}
