//
//  ViolationAssignedViewController.swift
//  ADTourism
//
//  Created by Administrator on 9/25/15.
//  Copyright (c) 2015 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol ViolationDelegate{
  @objc  optional func readyToSubmit()
}

class ViolationAssignedViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

    @IBAction func cancelMethod(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitMethod(_ sender: AnyObject) {
    self.delegate.readyToSubmit!()
    self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var violtationTable: UITableView!
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var delegate : ViolationDelegate!
    
    
     override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print("Total Count \(self.appDel.selectedViolation.allKeys.count)")
        return self.appDel.selectedViolation.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell =  tableView.dequeueReusableCell(withIdentifier: "cell_violation")! 
        let option :ADButton  = self.appDel.selectedViolation.object(forKey: self.appDel.selectedViolation.allKeys[indexPath.row]) as! ADButton
        
        
      
        print(option.extraOption.valication_code)
        let violationCodelbl = cell.viewWithTag(1000) as! UILabel
        let questionlbl = cell.viewWithTag(2000) as! UILabel
        violationCodelbl.text = option.extraOption.valication_code
        questionlbl.text = option.question.question_desc
        return cell
        
        
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
