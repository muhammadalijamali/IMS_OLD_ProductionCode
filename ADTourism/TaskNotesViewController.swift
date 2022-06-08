//
//  TaskNotesViewController.swift
//  ADTourism
//
//  Created by Administrator on 2/3/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class TaskNotesViewController: UIViewController {
    var notesString : String!
    
    @IBOutlet weak var tasksNoteslbl: UILabel!
    var localisation : Localisation!
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    

    @IBAction func cancelMethod(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var tasknotesTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("task : \(notesString)")
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        

        self.cancelBtn.title = localisation.localizedString(key: "questions.cancel")
        self.tasksNoteslbl.numberOfLines = 0
        self.tasksNoteslbl.text = notesString
        self.tasksNoteslbl.sizeToFit()
        
        //self.tasknotesTextView.text = notesString
        
       // self.tasksNoteslbl.text = "That the quick brown fox jumps over tge lazy dog , that the quick brown fox jumps over the , thsd ssdnsdbsdsjbd sbdhsbdsd sdjsbd sdsdhjsdhjsdh sjdhsdhsjdhs sd sdsjhds shdjsdshdhjsdhsdhsjdshdjhsdhsjhdsjdjshddjhsdjsdjsdjhsdjhshdsjhdsjhdsjdjshdjh  shjdhs shdsd sdsdhsdhjsdhjshdj hjsdhsdhshdsjhdsjbdsabdamnasdsadasdas asdasdjashdkasjhkasdjasd ashdjasdadjasjdahsdjashdjasdhjasdhadhakdh as dhasdk asd asdajsdhassjajs adhsdsakdjahsdh d hsadasjdasdhasdjhsahjsadhaskjdhadkhahd k adashdkasjhkdashjdhakdhadk"
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
