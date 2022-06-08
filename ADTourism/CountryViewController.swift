//
//  CountryViewController.swift
//  ADTourism
//
//  Created by MACBOOK on 7/11/18.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit




 protocol CountryDelegate{
    //@objc optional func dataDownloaded(_ data : NSMutableData ,  identity : String)
 func countrySelected(country : CountryDao)
    
}


class CountryViewController: UIViewController , UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
     
    @IBOutlet weak var passportcountry: UILabel!
    @IBOutlet weak var countryTable: UITableView!
    @IBOutlet weak var searchField: UITextField!
     var localisation : Localisation!
    var allCountries : NSMutableArray?
    var del : CountryDelegate?
    var isSearching : Int = 0
    var appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func exit(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
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
       self.passportcountry.text = localisation.localizedString(key: "individual.passportCountry")
        
        // Do any additional setup after loading the view.
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(textField.text! + string)
        if textField.text! + string == "" {
            self.isSearching = 0
            self.allCountries = self.appDel.allCountries
            self.countryTable.reloadData()
        }
        else {
            self.isSearching = 1
            self.allCountries = self.filterArray(searchStr: textField.text!+string, array: self.appDel.allCountries)
            self.countryTable.reloadData()
        }
     return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.isSearching = 0
        self.allCountries = appDel.allCountries
        self.countryTable.reloadData()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCountries!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "country_cell")
        let dao = allCountries![indexPath.row] as! CountryDao
        let eng = cell?.contentView.viewWithTag(100) as! UILabel
        let ar = cell?.contentView.viewWithTag(200) as! UILabel
        eng.text = dao.country_name
        ar.text = dao.country_name_ar
      //  cell?.textLabel?.text = dao.country_name_ar

        return cell!
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dao = allCountries![indexPath.row] as? CountryDao
        self.del?.countrySelected(country: dao!)
        self.dismiss(animated: true, completion: nil)
        
    }
    func filterArray(searchStr : String , array : NSMutableArray) -> NSMutableArray {
        if searchStr == "" {
            return array
            
        }
        let array1 = array as NSArray as? [CountryDao]
        let array2 = array1?.filter(){
            
            return ($0.country_name_ar?.lowercased().contains(searchStr.lowercased()))! || ($0.country_name?.lowercased().contains(searchStr.lowercased()))!
        }
        
        return NSMutableArray(array:array2!)
        
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
