//
//  SideMenuViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 4/9/16.
//  Copyright © 2016 Muhammad Ali. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let menuItem = NSMutableArray()
    var selectedItem : Int = 0
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    
    @IBOutlet weak var sideMenu: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
         menuItem.add("newhome")
        menuItem.add("newhistory")
        menuItem.add("newprofile")
        menuItem.add("newnotifications")
        menuItem.add("permiticon")
        menuItem.add("chat_un")
        menuItem.add("newsettings")
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
        self.revealViewController().rearViewRevealWidth = 143
        }
        else {
            self.revealViewController().rearViewRevealWidth = 97
            
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

    
    //MARK:- UITableViewDelegate and DataSpurce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_menu") as! MenuItemTableViewCell
        
        let dao = self.menuItem.object(at: indexPath.row) as! String
        //cell.menuButton
        print(dao)
       
        
        cell.menuButton.setBackgroundImage(UIImage(named: dao), for: UIControlState())
        cell.menuButton.tag = indexPath.row
        cell.menuButton.addTarget(self, action: #selector(SideMenuViewController.showDetail(_:)), for: UIControlEvents.touchUpInside)
        if self.selectedItem == 0 && indexPath.row == 0 {
            cell.menuButton.setBackgroundImage(UIImage(named: "newhomesel"), for: UIControlState())
            
        }
        
        if self.selectedItem == 1 && indexPath.row == 1 {
            cell.menuButton.setBackgroundImage(UIImage(named: "newhistorysel"), for: UIControlState())
            
        }
        
        if self.selectedItem == 2 && indexPath.row == 2 {
            cell.menuButton.setBackgroundImage(UIImage(named: "newprofilesel"), for: UIControlState())
            
        }
        
        if self.selectedItem == 3 && indexPath.row == 3 {
            cell.menuButton.setBackgroundImage(UIImage(named: "newnotifsel"), for: UIControlState())
            
        }
        if self.selectedItem == 5 && indexPath.row == 5 {
            cell.menuButton.setBackgroundImage(UIImage(named: "chat_sel"), for: UIControlState())
            
        }
        
        if self.selectedItem == 6 && indexPath.row == 6 {
            cell.menuButton.setBackgroundImage(UIImage(named: "newsettingssel"), for: UIControlState())
            
        }
        
        
        if self.selectedItem == 4 && indexPath.row == 4 {
            cell.menuButton.setBackgroundImage(UIImage(named: "permiticonsel"), for: UIControlState())
            
        }

        
        return cell
        
        
    }
    @objc func showDetail(_ sender : UIButton){
        self.selectedItem = sender.tag
        self.sideMenu.reloadData()
        if self.selectedItem == 0 {
           sender.setBackgroundImage(UIImage(named: "newhomesel"), for: UIControlState())
          
            self.performSegue(withIdentifier: "sw_homescreen", sender: nil)
            
        }
      
        if self.selectedItem == 1 {
            sender.setBackgroundImage(UIImage(named: "newhistorysel"), for: UIControlState())
            self.performSegue(withIdentifier: "sw_menutohistory", sender: nil)
           
        }
        
        if self.selectedItem == 2 {
            sender.setBackgroundImage(UIImage(named: "newprofilesel"), for: UIControlState())
            self.performSegue(withIdentifier: "sw_menutoprofile", sender: nil)
        }
        
        if self.selectedItem == 3 {
            sender.setBackgroundImage(UIImage(named: "newnotifsel"), for: UIControlState())
            self.performSegue(withIdentifier: "sw_sidemenutonotifications", sender: nil)

        }
        if self.selectedItem == 5 {
            sender.setBackgroundImage(UIImage(named: "chat_sel"), for: UIControlState())
           self.performSegue(withIdentifier: "sw_chat", sender: nil)
        }
        
        if self.selectedItem == 6 {
            sender.setBackgroundImage(UIImage(named: "newsettingssel"), for: UIControlState())
            self.performSegue(withIdentifier: "sw_menutosettings", sender: nil)
        }
        
        
        
        if self.selectedItem == 4 {
            sender.setBackgroundImage(UIImage(named: "permiticonsel"), for: UIControlState())
        self.performSegue(withIdentifier: "sw_permitmenu", sender: nil)
            

            
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
        
        
        return 146
        }
        else {
        return 100
        }
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selcted")
    }
}
