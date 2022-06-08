//
//  NotesViewController.swift
//  ADTourism
//
//  Created by Administrator on 8/28/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol NotesDelegate{
   @objc optional func notesSaved(_ data : String ,  sender : ADButton)
}


class NotesViewController: UIViewController {
    var localisation : Localisation!

    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var notesText: UITextView!
     var notes:NSMutableDictionary!
    var notesStr: String!
    
    
    
     var btn: ADButton!
    var appDel : AppDelegate!
    var delegate : NotesDelegate?
    var isEditable : Int = 1
    

    @IBAction func HidePopover(_ sender: AnyObject) {
        if self.appDel.fromHistoryToResult == 1 {
            self.dismiss(animated: true, completion: nil)

        }
        else {
        self.dismiss(animated: true, completion: nil)
    delegate?.notesSaved!(notesText.text, sender: btn)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDel = UIApplication.shared.delegate as! AppDelegate

        if self.appDel.fromHistoryToResult == 1 {
        self.notesText.isEditable = false
         self.notesText.text = self.notesStr
        }
        else {
        
        self.notesText.text = notes.object(forKey: String(btn.questionid)) as? String
        
      //  print(notes)
        }
        
        if self.isEditable == 0 {
            self.notesText.isEditable = false

        }
        else {
        self.notesText.becomeFirstResponder()
        }
        
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            self.notesText.textAlignment = NSTextAlignment.left
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            self.notesText.textAlignment = NSTextAlignment.right
            
        }
        if let font = UIFont(name: "DroidArabicKufi", size: 15.0) {
        
         self.doneBtn.title = localisation.localizedString(key: "general.done")
        self.doneBtn.setTitleTextAttributes([NSAttributedStringKey.font:font], for: UIControlState())
        }
        else {
        
        }
        // Do any additional setup after loading the view.
        
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
