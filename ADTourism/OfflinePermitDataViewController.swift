//
//  OfflinePermitDataViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 1/29/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit

class OfflinePermitDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var vehicleCountlbl: UILabel!
    @IBOutlet weak var driverSwitch: UISwitch!
    
    @IBOutlet weak var selectallDrivers: UILabel!
    
    @IBOutlet weak var driverCountlbl: UILabel!
    
    
    
    
    
    @IBAction func driverSwitchMethod(_ sender: UISwitch) {
        if self.appDel.offlinePermit?.seachedDrLicense != nil && self.appDel.offlinePermit?.seachedDrLicense != "" {
            
            if !self.driverSwitch.isOn {
                self.driverArray = NSMutableArray()
                for driver in (self.appDel.offlinePermit?.drivers)!   {
                    if let driver1 = driver as? DriversDao {
                        print("\(driver1.drLicNo) == \(self.appDel.offlinePermit?.seachedDrLicense)")
                        if driver1.drLicNo!.caseInsensitiveCompare(self.appDel.offlinePermit!.seachedDrLicense!) == .orderedSame {
                            self.driverArray.add(driver1)
                        }
                    }
                }// end of the for loop
                self.drivertableView.reloadData()
            }
            else {
                self.driverArray = (self.appDel.offlinePermit?.drivers)!
                self.drivertableView.reloadData()
            }
            
            
            
            
        }
        else {
            self.driverSwitch.isHidden = true
            self.selectallDrivers.isHidden = true
            self.driverArray = (self.appDel.offlinePermit?.drivers)!
            self.drivertableView.reloadData()
            
        }
        
        
        
        
    }
    
    
    
    @IBAction func carsSwitchAction(_ sender: AnyObject) {
        if !self.carsSwitch.isOn {
            self.vehicleArray = NSMutableArray()
            for car in (self.appDel.offlinePermit?.vehicles)!   {
                if let car1 = car as? VehicleDao {
                    let plate = Util.removeSpecialCharsFromString(car1.plateNo!)
                    
                    let pair1 = "\(self.appDel.selectedCode!)\(self.appDel.searchedCar!)"
                    let pair2 = "\(self.appDel.searchedCar!)\(self.appDel.selectedCode!)"
                    
                    print("\(plate) == \(self.appDel.offlinePermit?.searchedCar)")
                    if plate.caseInsensitiveCompare(pair1) == ComparisonResult.orderedSame || plate.caseInsensitiveCompare(pair2) ==  ComparisonResult.orderedSame{       // self.vehicleArray.addObject(car1)
                        
                        self.vehicleArray.add(car1)
//                        if car1.plateNo != nil {
//                            self.appDel.selectedVehicles.addObject(("تفتيش السيارة - \(car1.plateNo!)"))
//                            
//                        }
                        
                    }
                }
            }// end of the for loop
            self.vehicleTable.reloadData()
        }
        else {
            self.vehicleArray = (self.appDel.offlinePermit?.vehicles)!
            self.vehicleTable.reloadData()
        }
        
        
    }
    
    @IBOutlet weak var selectAllbl: UILabel!
    
    
    @IBOutlet weak var carsSwitch: UISwitch!
    @IBOutlet weak var coordinatevaluelbl: UILabel!
    @IBOutlet weak var coordinateNamelbl: UILabel!
    @IBOutlet weak var numberofvehiclelbl: UILabel!
    @IBOutlet weak var permitidlbl: UILabel!
    @IBOutlet weak var companyNamelbl: UILabel!
    @IBOutlet weak var licenseExpirylbl: UILabel!
    @IBOutlet weak var licenseNolbl: UILabel!
    @IBOutlet weak var permitExpiryDatelbl: UILabel!
    @IBOutlet weak var permitStartDatelbl: UILabel!
    @IBOutlet weak var permitDatelbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var permitTypeTitle: UILabel!
    @IBOutlet weak var permitTitle: UILabel!
    @IBOutlet weak var outerScroll: UIScrollView!
    @IBOutlet weak var vehicleTable: UITableView!
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    
    
    
    
    
    
    @IBAction func showInspection(_ sender: AnyObject) {
        
        let cnt = self.storyboard?.instantiateViewController(withIdentifier: "cnt_addInspection") as! SearchViewController
        cnt.searchType = 1
        if self.appDel.offlinePermit?.businessLicense != nil {
            cnt.searchText = (self.appDel.offlinePermit?.businessLicense)!
        }
        
        self.navigationController?.pushViewController(cnt, animated: true)
    }
    
    
    
    @IBOutlet weak var organisemobilelbl: UILabel!
    @IBOutlet weak var subvenuelbl: UILabel!
    
    @IBOutlet weak var organisenamelbl: UILabel!
    
    @IBOutlet weak var numberofvehicleslbl: UILabel!
    
    @IBOutlet weak var noteslbl: UILabel!
    var vehicleArray = NSMutableArray()
    var driverArray = NSMutableArray()
    
    
    @IBOutlet weak var drivertableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController? .setNavigationBarHidden(false, animated:true)
        self.title = ""
        
        //        self.vehicleArray.addObject("")
        //        self.vehicleArray.addObject("")
        //        self.vehicleArray.addObject("")
        //        self.vehicleArray.addObject("")
        //        self.vehicleArray.addObject("")
        //        self.vehicleArray.addObject("")
        //        self.vehicleArray.addObject("")
        //self.vehicleArray = (self.appDel.offlinePermit?.vehicles)!
        print("Searched Car \(self.appDel.offlinePermit?.searchedCar)")
        if self.appDel.offlinePermit?.searchedCar != nil && self.appDel.offlinePermit?.searchedCar != "" {
            
            if !self.carsSwitch.isOn {
                self.vehicleArray = NSMutableArray()
                for car in (self.appDel.offlinePermit?.vehicles)!   {
                    if let car1 = car as? VehicleDao {
                        
                        var plate = Util.removeSpecialCharsFromString(car1.plateNo!)
                        //plate = car1.plateNo?.stringByReplacingOccurrencesOfString("-", withString: "")
                        
                        
                        let pair1 = "\(self.appDel.selectedCode!)\(self.appDel.searchedCar!)"
                        let pair2 = "\(self.appDel.searchedCar!)\(self.appDel.selectedCode!)"
                        print("Pair 1 \(pair1)")
                        print("Pair 2 \(pair2)")
                        print("car no \(plate)")
                        
                        if plate.caseInsensitiveCompare(pair1) == ComparisonResult.orderedSame || plate.caseInsensitiveCompare(pair2) ==  ComparisonResult.orderedSame{
                            
                            
                            
                            
                            // print("\(car1.plateNo) == \(self.appDel.offlinePermit?.searchedCar)")
                            //if car1.plateNo!.caseInsensitiveCompare(self.appDel.offlinePermit!.searchedCar!) == .OrderedSame {
                            self.vehicleArray.add(car1)
                            if car1.plateNo != nil {
                                self.appDel.selectedVehicles.add(("تفتيش السيارة - \(car1.plateNo!)"))
                                
                            }
                            
                        }
                    }
                }// end of the for loop
                self.vehicleTable.reloadData()
            }
            
            
        }
        else {
            self.carsSwitch.isHidden = true
            self.selectAllbl.isHidden = true
            self.vehicleArray = (self.appDel.offlinePermit?.vehicles)!
            self.vehicleTable.reloadData()
            
        }
        
        
        //////////////////////////
        
        
        if self.appDel.offlinePermit?.seachedDrLicense != nil && self.appDel.offlinePermit?.seachedDrLicense != "" {
            
            if !self.driverSwitch.isOn {
                self.driverArray = NSMutableArray()
                for driver in (self.appDel.offlinePermit?.drivers)!   {
                    if let driver1 = driver as? DriversDao {
                        print("\(driver1.drLicNo) == \(self.appDel.offlinePermit?.seachedDrLicense)")
                        if driver1.drLicNo?.caseInsensitiveCompare(self.appDel.offlinePermit!.seachedDrLicense!) == .orderedSame {
                            // if driver1.drLicNo == self.appDel.offlinePermit!.seachedDrLicense! {
                            
                            self.driverArray.add(driver1)
                            if driver1.drLicNo != nil {
                                self.appDel.selectedDrivers.add("تفتيش السائق -\(driver1.drLicNo!)")
                            }
                        }
                    }
                }// end of the for loop
                self.drivertableView.reloadData()
            }
            
            
        }
        else {
            self.driverSwitch.isHidden = true
            self.selectallDrivers.isHidden = true
            self.driverArray = (self.appDel.offlinePermit?.drivers)!
            self.drivertableView.reloadData()
            
        }
        
        
        
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "dubaiwatermark")!)
        self.vehicleTable.backgroundColor = UIColor.clear
        self.drivertableView.backgroundColor = UIColor.clear
        self.companyNamelbl.text = self.appDel.offlinePermit?.organizerName!
        self.licenseNolbl.text = self.appDel.offlinePermit?.businessLicense
        self.datelbl.text = self.appDel.offlinePermit?.issuedDate
        self.permitidlbl.text = self.appDel.offlinePermit?.permitID
        self.permitStartDatelbl.text = self.appDel.offlinePermit?.startDate
        self.permitExpiryDatelbl.text = self.appDel.offlinePermit?.endDate
        self.licenseExpirylbl.text = self.appDel.offlinePermit?.expiryDate
        self.subvenuelbl.text = self.appDel.offlinePermit?.subVenue
        self.organisenamelbl.text = self.appDel.offlinePermit?.coordinatorName
        self.organisemobilelbl.text = self.appDel.offlinePermit?.contactNumber
        self.numberofvehicleslbl.text = "\(self.appDel.offlinePermit!.vehicles.count)"
        self.noteslbl.text = self.appDel.offlinePermit?.appComment
        self.vehicleTable.estimatedRowHeight = 150
        self.vehicleTable.rowHeight = UITableViewAutomaticDimension
        self.drivertableView.rowHeight = UITableViewAutomaticDimension
        self.drivertableView.estimatedRowHeight = 150
        // print(self.appDel.offlinePermit?.permitID!)
        if self.appDel.offlinePermit != nil {
            if self.appDel.offlinePermit!.permitType != nil {
                if (self.appDel.offlinePermit!.permitID!.contains("CMP"))  {
                    self.organisenamelbl.isHidden = true
                    self.organisemobilelbl.isHidden = true
                    self.coordinateNamelbl.isHidden = true
                    self.coordinatevaluelbl.isHidden = true
                    self.numberofvehiclelbl.text = "مساحة المخيم               :"
                    print("مساحة المخيم  : \(self.appDel.offlinePermit?.campArea)")
                    self.numberofvehicleslbl.text = self.appDel.offlinePermit?.campArea
                    self.permitTypeTitle.text = "مخيم صحراوي"
                    
                    
                } // end elf.appDel.offlinePermit!.permitID!
            } // end of the self.appDel.offlinePermit!.permitType
        }// end of the self.appDel.offlinePermit
        
        
        //    NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "flashscrolls", userInfo: nil, repeats: true)
        
        
        // Do any additional setup after loading the view.
    }
    func flashscrolls(){
        
        self.vehicleTable.flashScrollIndicators()
        self.drivertableView.flashScrollIndicators()
        self.outerScroll.flashScrollIndicators()
        
        
    }
    
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == vehicleTable {
            print("Returning \(self.appDel.offlinePermit?.vehicles.count)")
            //return (self.appDel.offlinePermit?.vehicles.count)!
            return self.vehicleArray.count
        }
        else {
            
            return self.driverArray.count
            
            
        }
        //  return self.vehicleArray.count
        
    }
    
    
    @IBAction func selectAllVehciles(_ sender: UISwitch) {
        if sender.isOn {
        self.selectAllVehicles()
        }
        else {
            self.deSelectAllVehicles()
            
        }
    }
    func selectAllVehicles(){
        for vehicle in self.vehicleArray as! [VehicleDao] {
             self.appDel.selectedVehicles.remove("تفتيش السيارة - \(vehicle.plateNo!)")
            self.appDel.selectedVehicles.add("تفتيش السيارة - \(vehicle.plateNo!)")
           
            
        }
        self.vehicleCountlbl.text = "(\(self.appDel.selectedVehicles.count))"
        self.vehicleTable.reloadData()
        
    }
    func deSelectAllVehicles(){
       self.appDel.selectedVehicles.removeAllObjects()
         self.vehicleTable.reloadData()
       self.vehicleCountlbl.text = "(\(self.appDel.selectedVehicles.count))"
    }
    
    
    @IBAction func selectAllDriversSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.selectAllDrivers()
        }
        else {
            self.deSelectAllDrivers()
            
        }
    }
    
    func selectAllDrivers(){
        for driver in self.driverArray as! [DriversDao] {
           
            self.appDel.selectedDrivers.remove("تفتيش السائق -\(driver.drLicNo!)")
            self.appDel.selectedDrivers.add("تفتيش السائق -\(driver.drLicNo!)")
            
        }
       self.driverCountlbl.text = "(\(self.appDel.selectedDrivers.count))"
        self.drivertableView.reloadData()
    }
    func deSelectAllDrivers(){
        self.appDel.selectedDrivers.removeAllObjects()
        self.drivertableView.reloadData()
         self.driverCountlbl.text = "(\(self.appDel.selectedDrivers.count))"
        
    }
    @objc func selectVehcile(_ sender : InspectorBtn) {
        print(sender.vehiclePlateNo)
        if sender.isButtonSelected == 1 {
            sender.isButtonSelected = 0
            self.appDel.selectedVehicles.remove("تفتيش السيارة - \(sender.vehiclePlateNo!)")
            sender.setImage(UIImage(named: "toggle"), for: UIControlState())
            
            
        }
            
        else {
            sender.isButtonSelected = 1
            self.appDel.selectedVehicles.add("تفتيش السيارة - \(sender.vehiclePlateNo!)")
            sender.setImage(UIImage(named: "toggle_on"), for: UIControlState())
            
            
            
        }
        
          self.vehicleCountlbl.text = "(\(self.appDel.selectedVehicles.count))"
        
    }
    
    
    @objc func selectDriver(_ sender : InspectorBtn) {
        print(sender.driverNo)
        if sender.isButtonSelected == 1 {
            sender.isButtonSelected = 0
            self.appDel.selectedDrivers.remove("تفتيش السائق -\(sender.driverNo!)")
            sender.setImage(UIImage(named: "toggle"), for: UIControlState())
            
            
        }
            
        else {
            sender.isButtonSelected = 1
            self.appDel.selectedDrivers.add("تفتيش السائق -\(sender.driverNo!)")
            sender.setImage(UIImage(named: "toggle_on"), for: UIControlState())
            
            
            
        }
         self.driverCountlbl.text = "(\(self.appDel.selectedDrivers.count))"
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == vehicleTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_vehicle") as! VehicleCell
            
            let vehicleDao = self.vehicleArray.object(at: indexPath.row) as? VehicleDao
            cell.ownerName.text = vehicleDao?.ownerName
            cell.vehicleNumber.text = vehicleDao?.plateNo
            cell.typelbl.text = vehicleDao?.tradeMarkname
            cell.modelYearlbl.text = vehicleDao?.modelYear
            cell.issueDatelbl.text = vehicleDao?.licIssue
            cell.expiryDatelbl.text = vehicleDao?.licExpiry
            cell.checkItem.vehiclePlateNo = vehicleDao?.plateNo
            
            print("PLate No \(self.appDel.selectedVehicles.index(of: vehicleDao!.plateNo!))")
            
            if self.appDel.selectedVehicles.index(of: ("تفتيش السيارة - \(vehicleDao!.plateNo!)")) == NSNotFound {
                
                cell.checkItem.setImage(UIImage(named: "toggle"), for: UIControlState())
                cell.checkItem.isButtonSelected = 0
            }
            else {
                cell.checkItem.setImage(UIImage(named: "toggle_on"), for: UIControlState())
                cell.checkItem.isButtonSelected = 1
                
                
            }
            cell.checkItem.addTarget(self, action: (#selector(OfflinePermitDataViewController.selectVehcile(_:))), for: .touchUpInside)
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            //vehicleDao?.licExpiry = "14/11/2018"
            let locale = Locale(identifier: "en_AE")
            dateformat.locale = locale
            let today : String = dateformat.string(from: Date())
            
            // print(dateformat.stringFromDate(NSDate()))
            //print("Date \(vehicleDao?.licExpiry) \(today)")
            if vehicleDao!.licExpiry != nil{
                if dateformat.date(from: vehicleDao!.licExpiry!) != nil {
                    if dateformat.date(from: today) != nil {
                        if (dateformat.date(from: vehicleDao!.licExpiry!)!.isLessThanDate(dateformat.date(from: today)!) )
                            
                            
                        {
                            cell.contentView.backgroundColor = UIColor(red: 255/255, green: 231/255, blue: 229/255, alpha: 1.0)
                            print("Vehicle permit is expired")
                            
                        }
                        else {
                            cell.contentView.backgroundColor = UIColor.white
                            
                            print("driver permit is not expired")
                            
                        }
                    }
                }
            }
            
            
            
            cell.noteslbl.numberOfLines = 0
            cell.noteslbl.text = vehicleDao?.vehComment
            
            //cell.contentView.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = UIColor.clear
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_vehicle") as! DriverTableViewCell
            
            // let driverDao = self.appDel.offlinePermit?.drivers.objectAtIndex(indexPath.row) as? DriversDao
            let driverDao = self.driverArray.object(at: indexPath.row) as? DriversDao
            
            cell.driverNamelbl.text = driverDao?.driver_name
            cell.drivergenderlbl.text = driverDao?.nationality
            cell.licenseno.text = driverDao?.drLicNo
            cell.issueDatelbl.text = driverDao?.drLicIssue
            cell.expiryDate.text = driverDao?.drLicExpiry
            cell.firstsaidlbl.text = driverDao?.isFirstAid
            cell.noteslbl.text = driverDao?.drComment
            cell.checkItem.driverNo = driverDao?.drLicNo
            cell.checkItem.addTarget(self, action: (#selector(OfflinePermitDataViewController.selectDriver(_:))), for: .touchUpInside)
            
            if self.appDel.selectedDrivers.index(of: "تفتيش السائق -\(driverDao!.drLicNo!)") == NSNotFound {
                
                cell.checkItem.setImage(UIImage(named: "toggle"), for: UIControlState())
                 cell.checkItem.isButtonSelected = 0
            }
            else {
                cell.checkItem.setImage(UIImage(named: "toggle_on"), for: UIControlState())
                cell.checkItem.isButtonSelected = 1
                
                
            }
            
            
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            //driverDao!.drLicExpiry = "07/08/2017"
            
            let locale = Locale(identifier: "en_AE")
            dateformat.locale = locale
            let today : String = dateformat.string(from: Date())
            
            if driverDao!.drLicExpiry != nil{
                if dateformat.date(from: driverDao!.drLicExpiry!) != nil {
                    if dateformat.date(from: today) != nil {
                        if (dateformat.date(from: driverDao!.drLicExpiry!)!.isLessThanDate(dateformat.date(from: today)!) ) {
                            cell.contentView.backgroundColor = UIColor(red: 255/255, green: 231/255, blue: 229/255, alpha: 1.0)
                            
                            
                        }
                        else {
                            cell.contentView.backgroundColor = UIColor.white
                        }
                    }
                }
            }
            
            
            
            
            //            print("Date \(driverDao?.drLicExpiry) ss \(today)")
            //
            //            if (dateformat.dateFromString((driverDao?.drLicExpiry)!)?.compare(NSDate()) == .OrderedDescending)
            //            {
            //                cell.contentView.backgroundColor = UIColor(red: 255/255, green: 231/255, blue: 229/255, alpha: 1.0)
            //                print("Driver is  expired")
            //
            //            }
            //            else {
            //             print("Driver is not expired")
            //            }
            
            
            //cell.contentView.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = UIColor.clear
            return cell
            
        }
    }
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 80
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
