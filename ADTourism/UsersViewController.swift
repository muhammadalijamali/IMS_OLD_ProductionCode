//
//  UsersViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 11/24/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

protocol UserSelectedDelegate {
     func userSelected(_ user : ChatUsers)
}
class UsersViewController: UIViewController , UITableViewDelegate,UITableViewDataSource,SessionDataDelegate{

    @IBAction func exit(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var usersTableView: UITableView!
    var users = NSMutableArray()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var del : UserSelectedDelegate?
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_chatuser") as! ChatUserCell
        let dao = users.object(at: indexPath.row) as! ChatUsers
       cell.username.text = dao.user_name!
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
            
        }
        else {
            cell.backgroundColor = UIColor.white
            
        }
        if dao.type == "hos" {
            cell.username.text = "HOS - \(dao.user_name!)"
    
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDownloadUsers()
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chat = self.users.object(at: indexPath.row) as! ChatUsers
        self.appDel.chatUser = chat
        self.del?.userSelected(chat)
        self.dismiss(animated: true, completion: nil)
        
        
    }
    func setupDownloadUsers(){
        if Reachability.connectedToNetwork()  {
            
            
            
            let session = SessionDataDownloader()
            
            session.del = self
           
            let loginUrl = "\(Constants.baseURL)getAdminAndHOSListForInspector?inspectorID=\(self.appDel.user.user_id!)"
            
            print(loginUrl)
            
            session.setupSessionDownload(loginUrl, session_id: String(describing: Date().addingTimeInterval(1970)))
            
        }
        
        
    }
    
    func dataDownloader(_ data: Data) {
        let parser = JsonParser()
        
        users = parser.chatUserParser(NSMutableData(data: data))
        print("There are \(users.count)")
        self.usersTableView.reloadData()
        
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
