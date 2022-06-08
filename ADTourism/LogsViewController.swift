//
//  LogsViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 8/29/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import MessageUI

class LogsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var logsTable: UITableView!
    var del : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var logCountlbl: UILabel!
    
    @IBAction func shareMethod(_ sender: UIButton) {
        
        var csvStr : String = ""
        for var a in self.logs as! [TaskResultsDao] {
            if a.isSubmitted == 1 {
                csvStr = csvStr + "Inspection Date: \(String(describing: a.entry_datetime!)) Submitted:\(String(describing: a.isSubmitted!))  \(String(describing: a.json_string!))  Server Response :\(String(describing: a.server_reponse!)) Submitted Date \(a.submit_datetime!) \n"
            } else {
                
                csvStr = csvStr + " Inspection Date: \(String(describing: a.entry_datetime!)) Submitted:\(String(describing: a.isSubmitted!))  \(String(describing: a.json_string!)) \n"
            }
        }
        
        let fileName = "Tasks -\(del.user.user_id).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        do {
            if path != nil {
                try csvStr.write(to: path!, atomically: true, encoding: .utf8)
            }
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
        let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
        vc.popoverPresentationController?.sourceView = sender

        present(vc, animated: true, completion: nil)
        
    }
    
    var logs = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        logs = DatabaseManager().fetchAllOfflineTasksStatus()
        logsTable.estimatedRowHeight = 60
        self.logCountlbl.text = "\(DatabaseManager().getAllUnSubmittedTasks().count)"
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func close(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_logs")
        let result = logs.object(at: indexPath.row) as! TaskResultsDao
        let label = cell?.contentView.viewWithTag(100) as! UILabel
      
        if result.isSubmitted != 1 {
            
           cell?.backgroundColor = UIColor(red: 249/255, green: 186/255, blue: 205/255, alpha: 1.0)
            label.text = "Inspection Date: \(String(describing: result.entry_datetime!)) Submitted:\(String(describing: result.isSubmitted!)) \n \(String(describing: result.json_string!))"
            
            
        }
        else {
            cell?.backgroundColor = UIColor.white
              label.text = "Inspection Date: \(String(describing: result.entry_datetime!)) Submitted:\(String(describing: result.isSubmitted!)) \n \(String(describing: result.json_string!)) \n Server Response :\(String(describing: result.server_reponse!)) Submitted Date \(result.submit_datetime!)"
            
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
