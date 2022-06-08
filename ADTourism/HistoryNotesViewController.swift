//
//  HistoryNotesViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 4/28/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol HistoryNotesDelegate{
    @objc optional func historyNotesSaved(_ data : String ,  history_taskId : String)
}


class HistoryNotesViewController: UIViewController {
    var localisation : Localisation!
     var appDel : AppDelegate!
    var history_notes : String?
    
    
    @IBOutlet weak var historynotestitlelbl: UILabel!
    @IBOutlet weak var addHistoryNotesLbl: UILabel!
    
    @IBAction func saveMethod(_ sender: AnyObject) {
        del?.historyNotesSaved!(self.notesText.text, history_taskId: self.history_task_id!)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    @IBOutlet weak var saveBtn: UIButton!
    var history_task_id : String?
    
    @IBAction func closeMethod(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
        
    }
    var del : HistoryNotesDelegate?
    var allNotes : String?
    
    @IBOutlet weak var notesText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localisation = Localisation()
        self.saveBtn.layer.cornerRadius = 5.0
        
        self.appDel = UIApplication.shared.delegate as! AppDelegate
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
            self.notesText.textAlignment = NSTextAlignment.left
            
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
            self.notesText.textAlignment = NSTextAlignment.right
            
            
        }
        if self.allNotes != nil {
        self.notesText.text = self.allNotes
        }
        
        self.notesText.becomeFirstResponder()
       // self.addHistoryNotesLbl.text = localisation.localizedString(key: "")
        
       self.saveBtn.setTitle(localisation.localizedString(key: "settings.savechanges"), for: UIControlState())
       self.historynotestitlelbl.text = localisation.localizedString(key: "history.addnotes")
       //self.no
       // self.notesText.layer.cornerRadius = 5.0
        //settings.savechanges
        
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
