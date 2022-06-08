//
//  ReasonNotCompleteViewController.swift
//  ADTourism
//
//  Created by Administrator on 2/3/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol ReasonDelegate{
    @objc optional func reasonSelected(_ reason : String ,  reasonnotes : String)
}

class ReasonNotCompleteViewController: UIViewController, UITextViewDelegate{
    var delegate : ReasonDelegate!
    var reason : String?
    var localisation : Localisation!
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var dropdownView: UIView!
    var fromHistory : Int?  // 1 yes from history
    var closed_notes : String?
    var closed_reason : String?
    
    
    @IBOutlet weak var closeTaskTitle: UILabel!
    @IBOutlet weak var noteslbl: UILabel!
    
    @IBAction func cancelMethod(_ sender: AnyObject) {
    
    self.dismiss(animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.view.superview!.layer.cornerRadius = 0;
    }
    
    @IBAction func closeTask(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
        
    }
    

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBAction func saveMethod(_ sender: AnyObject) {
        if self.reason != nil {
        self.delegate.reasonSelected!(reason!, reasonnotes: self.notesTextView.text)
        self.dismiss(animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "", message:localisation.localizedString(key: "options.inactivetitle"), preferredStyle: UIAlertControllerStyle.alert)
            let reason1 = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.default, handler: nil)
            
            alert.addAction(reason1)
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBAction func inspectionTypeMethod(_ sender: AnyObject) {
    let alert = UIAlertController(title:localisation.localizedString(key:"options.inactivetitle"), message: "", preferredStyle: UIAlertControllerStyle.alert)
        let reason1 = UIAlertAction(title: "مغلق", style: UIAlertActionStyle.default, handler: {  Void in
       
           self.inspectionTypeBtn.setTitle("مغلق", for: UIControlState())
           self.reason = "مغلق"
        })
        alert.addAction(reason1)
        
        let reason2 = UIAlertAction(title: "غير قائم", style: UIAlertActionStyle.default, handler: {
             Void in
           
            self.inspectionTypeBtn.setTitle("غير قائم", for: UIControlState())
            self.reason = "غير قائم"
        })
        alert.addAction(reason2)
        
        let reason3 = UIAlertAction(title: "الموقع غير جاهز", style: UIAlertActionStyle.default, handler: {
             Void in
           
            self.inspectionTypeBtn.setTitle("الموقع غير جاهز", for: UIControlState())
            self.reason = "الموقع غير جاهز"
        })
        alert.addAction(reason3)
        
   let reason10 =   UIAlertAction(title: "الشركة غير موجودة", style: UIAlertActionStyle.default, handler: {
     Void in
           
            self.inspectionTypeBtn.setTitle("الشركة غير موجودة", for: UIControlState())
            self.reason = "الشركة غير موجودة"
        })
        alert.addAction(reason10)

        
       
        let reason4 = UIAlertAction(title: "العنوان غير معروف", style: UIAlertActionStyle.default, handler: {
             Void in
           
            self.inspectionTypeBtn.setTitle("العنوان غير معروف", for: UIControlState())
            self.reason = "العنوان غير معروف"
        })
        alert.addAction(reason4)
        
        let reason7 = UIAlertAction(title: "تم إغلاق الشركة", style: UIAlertActionStyle.default, handler: {
             Void in
           
            self.inspectionTypeBtn.setTitle("تم إغلاق الشركة", for: UIControlState())
            self.reason = "تم إغلاق الشركة"
        })
        alert.addAction(reason7)
        
        
        let reason8 = UIAlertAction(title: "المخيم مغلق", style: UIAlertActionStyle.default, handler: {
            Void in
            
            self.inspectionTypeBtn.setTitle(  "المخيم مغلق", for: UIControlState())
            self.reason = "المخيم مغلق"
        })
        alert.addAction(reason8)
        
        
        
        
        
        
       
        let reason5 = UIAlertAction(title: "أخرى", style: UIAlertActionStyle.default, handler: {
             Void in
           
            self.inspectionTypeBtn.setTitle("أخرى", for: UIControlState())
            self.reason = "أخرى"
        })
        alert.addAction(reason5)
        
        
        
        
        
        
        
        
        
        let action = UIAlertAction(title: localisation.localizedString(key: "questions.cancel"), style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var inspectionTypeBtn: UIButton!
    
    @objc func hideKeypad(){
    self.notesTextView.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        //
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ReasonNotCompleteViewController.hideKeypad))
        self.view.addGestureRecognizer(gesture)
        

        // Do any additional setup after loading the view.
    self.inspectionTypeBtn.setTitle(localisation.localizedString(key: "options.inactivetitle"), for: UIControlState())
    self.cancelBtn.setTitle(localisation.localizedString(key: "questions.cancel"), for: UIControlState())
    self.saveBtn.setTitle(localisation.localizedString(key: "company.save"), for: UIControlState())
        self.noteslbl.text = localisation.localizedString(key: "tasks.notes")
   self.saveBtn.layer.cornerRadius = 3.0
   self.cancelBtn.layer.cornerRadius = 3.0
   self.closeTaskTitle.text = localisation.localizedString(key: "tasks.closetask")
   self.dropdownView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
    self.dropdownView.layer.borderWidth = 1.0
        
        self.notesTextView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
        self.notesTextView.layer.borderWidth = 1.0
        
        if self.fromHistory == 1 {
        self.inspectionTypeBtn.isEnabled = false
        self.notesTextView.isEditable = false
        self.notesTextView.text = self.closed_notes
        self.inspectionTypeBtn.setTitle(self.closed_reason!, for: UIControlState())
        self.saveBtn.isHidden = true
        self.cancelBtn.isHidden = true
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
