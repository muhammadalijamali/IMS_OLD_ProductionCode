//
//  ABCViewController.swift
//  ADTourism
//
//  Created by MACBOOK on 9/27/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit

@objc protocol ABCSelectedDelegate{
    @objc optional func codeSelected(_ code : String)
}

class ABCViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var atozArray : NSMutableArray = NSMutableArray()
    var del : ABCSelectedDelegate?
    var localisation : Localisation!
    var appDel : AppDelegate =  UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.localisation = Localisation()
        if self.appDel.selectedLanguage == 1{
            self.localisation.setPreferred("en", fallback: "ar")
        }
        else {
            self.localisation.setPreferred("ar", fallback: "en")
        }
        //permit.selectCode
        self.atozArray.add(self.localisation.localizedString(key: "permit.selectCode"))
        self.atozArray.add("A")
    
        self.atozArray.add("B")
        self.atozArray.add("C")
        self.atozArray.add("D")
        self.atozArray.add("E")
        self.atozArray.add("F")
        self.atozArray.add("G")
        self.atozArray.add("H")
        self.atozArray.add("I")
        self.atozArray.add("J")
        self.atozArray.add("K")
        self.atozArray.add("L")
        self.atozArray.add("M")
        self.atozArray.add("N")
        self.atozArray.add("O")
        self.atozArray.add("P")
        self.atozArray.add("Q")
        self.atozArray.add("R")
        self.atozArray.add("S")
        self.atozArray.add("T")
        self.atozArray.add("U")
        self.atozArray.add("V")
        self.atozArray.add("W")
        self.atozArray.add("X")
        self.atozArray.add("Y")
        self.atozArray.add("Z")
        
        
        


        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var abcTable: UITableView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.atozArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_atozcell")
        let lbl = cell?.viewWithTag(10) as! UILabel
        lbl.text = self.atozArray.object(at: indexPath.row) as? String
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     del?.codeSelected!(self.atozArray.object(at: indexPath.row) as! String)
     self.dismiss(animated: true, completion: nil)
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
