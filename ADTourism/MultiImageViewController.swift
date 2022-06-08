//
//  MultiImageViewController.swift
//  ADTourism
//
//  Created by Muhammad Ali on 8/17/17.
//  Copyright © 2017 Muhammad Ali. All rights reserved.
//

import UIKit
import PKHUD
import ANLoader
import EZLoadingActivity

@objc protocol MultiImageDelegae{
   @objc optional func imageAdded(_ images : NSMutableArray)
}

class MultiImageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageTableView: UITableView!
    let TOTOTAL_IMAGES : Int = 3
    @IBOutlet weak var titlelbl: UILabel!
    var delegate : MultiImageDelegae?
    
    var question_id : String?
    //var countlbl : UILabel?
    
    var question : QuestionDao?
    var del : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    @IBAction func closeMethod(_ sender: UIButton) {
     self.delegate?.imageAdded!(self.multipleImageArray)
    self.dismiss(animated: true, completion: nil)
        
    }
    var multipleImageArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Image Count \(multipleImageArray.count)")
        
//        let dao = ImageDao()
//        dao.image_id = "\(self.multipleImageArray.count + 1)"
//        dao.q_id = self.question_id
//        dao.image = UIImage(named: "imageOverlay")
        
       // self.multipleImageArray.addObject(dao)
        //self.multipleImageArray.addObject("")
      
        

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CELL_IDENTIFIER  = "cell_multiImage"
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as! MultiTableViewCell
        let dao = self.multipleImageArray.object(at: indexPath.row)  as! ImageDao
        
       // cell.captureImageBtn
        
            cell.deleteImageBtn.isHidden = false
            cell.deleteImagelbl.isHidden = false
            cell.imagenolbl.text = "Image No \(indexPath.row + 1)"
        
        
        
        cell.capturedImage.image = dao.image!
        
        cell.captureImageBtn.addTarget(self, action:#selector(MultiImageViewController.openCameraOrGallery(_:)),for: UIControlEvents.touchUpInside)
        cell.deleteImageBtn.tag = indexPath.row
        cell.deleteImageBtn.addTarget(self, action:#selector(MultiImageViewController.deleteImage(_:)) , for: UIControlEvents.touchUpInside)
        
        
        return cell
    }
    @objc func deleteImage(_ sender : UIButton){
    self.multipleImageArray.removeObject(at: sender.tag)
     
    self.imageTableView.reloadData()
    self.delegate?.imageAdded!(self.multipleImageArray)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let customPicker : CustomImageController =  picker as! CustomImageController
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //print(tempImage)
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
//
    //(picker as! CustomImageController).button!.setImage(image, forState: UIControlState.Normal)
      picker.dismiss(animated: true, completion: nil)
        if self.multipleImageArray.count <= TOTOTAL_IMAGES {
           if Reachability.connectedToNetwork() {
            let dao = ImageDao()
            dao.image_id = "\(self.multipleImageArray.count + 1)"
            dao.q_id = self.question_id
            dao.image = image
            
            
            self.createMultipart("notes.jpeg" , q: question! , imageData: UIImageJPEGRepresentation(image, 0.1) as Data? , type: "image")
            }
            else {
                let file = MyFileManager()
                file.createTaskFolder(self.del.unique)
                file.createAudioFolder(self.del.unique)
                file.createImageFolder(self.del.unique)
                //self.currentBtn.setImage(self.selectedImage, forState: UIControlState.Normal)
                let imageData = UIImageJPEGRepresentation(image ,0.1)
            
                file.writeImage(self.del.unique, q_id: "\(question!.question_id!),\(self.multipleImageArray.count)", data: imageData!)
                
                
                
                let dao = ImageDao()
                dao.image_id = "\(question!.allImages.count + 1)"
                dao.q_id = question!.question_id
                dao.image = UIImage(data: imageData!)
                dao.media_id = self.del.unique
                question!.allImages.add(dao)
                
                
                

            }
            
            
           // self.multipleImageArray.addObject(dao)
         //  self.multipleImageArray =  NSMutableArray(array:multipleImageArray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
           //self.multipleImageArray = self.multipleImageArray.reverse() as! NSMutableArray
            self.imageTableView.reloadData()
            
        }
    }
    
    
    @IBAction func openCameraOrGallery(_ sender: UIButton) {
        if self.multipleImageArray.count >= 3 {
        print("Array \(self.multipleImageArray.count)")
        SCLAlertView().showError("", subTitle: "You can not add more than 3 images")
        return 
        }

        
           let alert = SCLAlertView()
        alert.showCloseButton  = false
        //alert.title = "Select photo source"
        alert.addButton("Camera", action: {
           
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.camera) {
                
                let imagePicker = CustomImageController()
                imagePicker.button = sender
                
                
                imagePicker.delegate = self
              //  self.whichImage = sender.tag
                
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.camera
                // imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                
                self.present(imagePicker, animated: true,
                    completion: nil)
                
            }
            
            
        })
        alert.addButton("Gallery", action: {
           
            
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.photoLibrary) {
                
                let imagePicker = CustomImageController()
               // self.whichImage = sender.tag
                //print("Which Media \(self.whichImage)")
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.photoLibrary
                // imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                imagePicker.button = sender
                
                self.present(imagePicker, animated: true,
                    completion: nil)
                
            }
            
            
            
        })
        
        alert.addButton("Cancel", action: {
           
            
        })
        
        alert.showInfo("Select photo source", subTitle: "")

        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return multipleImageArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createMultipart(_ filename : String , q : QuestionDao , imageData : Data? , type : String){
        // use SwiftyJSON to convert a dictionary to JSON
        
        // let myUrl = NSURL(string: "http://einspection.net/api/saveMedia");
        let myUrl = URL(string: Constants.kUploadMedia);
        
        if imageData != nil{
            var request = URLRequest(url: myUrl!)
            
            let session = URLSession.shared
           // PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
           // PKHUD.sharedHUD.show()
//           DispatchQueue.global(qos: .utility).async {
//            DispatchQueue.main.async {
//            //EZLoadingActivity.show("Loading...", disableUI: false)
//            }
//            }
            
            
            request.httpMethod = "POST"
            request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
            
            
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            //  println("Content Type \(contentType)")
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            let body = NSMutableData()
            
            
            // Title
            body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"media\"; filename=\"\(filename)\"\\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(imageData!)
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            
            
            
            request.httpBody = body as Data
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
                //PKHUD.sharedHUD.hide(animated: true)
               // EZLoadingActivity.hide(true, animated: true)
                
                
                if error != nil
                {
                    print(error!.localizedDescription)
                }
                else
                {
                    //Converting data to String
                    let responseStr:NSString = NSString(data:data!, encoding:String.Encoding.utf8.rawValue)!
                    print("Returning url \(responseStr)")
                    let parser =  JsonParser()
                    let str = parser.parseMedia(data!)
                    if str != "error"{
                        if type == "audio" {
                            
                            
                        }
                        else {
                            
                            let dao = ImageDao()
                            dao.image_id = "\(q.allImages.count + 1)"
                            dao.q_id = q.question_id
                            dao.image = UIImage(data: imageData!)
                            dao.media_id = str
                            
                            q.allImages.add(dao)
                              DispatchQueue.main.async(execute: {
                            self.imageTableView.reloadData()
                            })
                            //self.allImage.setValue(str, forKey: q.question_id)
                            
                        }
                    }
                }
                
            })
            
            
            task.resume()
            
//            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler:{(response:URLResponse?, responseData:Data?, error: NSError?)  in
//                PKHUD.sharedHUD.hide(animated: true)
//
//                if error != nil
//                {
//                    print(error!.description)
//                }
//                else
//                {
//                    //Converting data to String
//                    let responseStr:NSString = NSString(data:responseData!, encoding:String.Encoding.utf8.rawValue)!
//                    print("Returning url \(responseStr)")
//                    let parser =  JsonParser()
//                    let str = parser.parseMedia(responseData!)
//                    if str != "error"{
//                        if type == "audio" {
//
//
//                        }
//                        else {
//
//                            let dao = ImageDao()
//                            dao.image_id = "\(q.allImages.count + 1)"
//                            dao.q_id = q.question_id
//                            dao.image = UIImage(data: imageData!)
//                            dao.media_id = str
//
//                            q.allImages.add(dao)
//
//                            self.imageTableView.reloadData()
//                            //self.allImage.setValue(str, forKey: q.question_id)
//
//                        }
//                    }
//                }
//            } as! (URLResponse?, Data?, Error?) -> Void)
//
            
            
            //  var returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            
            // var returnString = NSString(data: returnData!, encoding: NSUTF8StringEncoding)
            
            // println("returnString \(returnString)")
            
                   }
        else {
            print("data is null")
        }
        
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
