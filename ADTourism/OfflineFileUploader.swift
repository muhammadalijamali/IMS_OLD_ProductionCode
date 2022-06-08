//
//  OfflineFileUploader.swift
//  
//
//  Created by Administrator on 12/11/15.
//
//

import UIKit
import PKHUD

class OfflineFileUploader: NSObject {
    
    var pathToDelete: String?
    
    func createMultipart(_ filename : String , imageData : Data? , type : String , q_id : String , task_id : String , identifier : String){
        // use SwiftyJSON to convert a dictionary to JSON
        
        let myUrl = URL(string: Constants.kUploadMedia);
         
        
        if imageData != nil{
          //  println(imageData)
             var request = URLRequest(url: myUrl!)
            request.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
            
            var session = URLSession.shared
//            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
//            PKHUD.sharedHUD.show()
//            PKHUD.sharedHUD.dimsBackground = true
//

            
            
            
            
            request.httpMethod = "POST"
            
            var boundary = NSString(format: "---------------------------14737809831466499882746641449")
            var contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            //  println("Content Type \(contentType)")
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            var body = NSMutableData()
            // Title
            body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; question_id=\"\(q_id)\" ; task_id=\"\(task_id)\" ;  name=\"media\"; filename=\"\(filename)\"\\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(imageData!)
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            request.httpBody = body as Data
           
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
             //   PKHUD.sharedHUD.hide(animated: true)
                
                if error != nil
                {
                    
                    print(error!.localizedDescription)
                }
                    
                else
                {//Converting data to String
                    let responseStr:NSString = NSString(data:data!, encoding:String.Encoding.utf8.rawValue)!
                    print("Returning url \(responseStr)")
                    let error : NSError?
                    let parser =  JsonParser()
                    let str = parser.parseMedia(data!)
                    if str != "error"{
                        let urlStr = "\(Constants.saveOfflineMedia)\(str)&task_id=\(task_id)&question_id=\(q_id)&offline_identifier=\(identifier)"
                        print(urlStr)
                        let u = URL(string: urlStr)!
                        var request1 = URLRequest(url: u)
                        request1.setValue(Constants.DTCMAPIKEY, forHTTPHeaderField: "DTCM-API-KEY")
                      //  let returnData = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
                       // let str = NSString(data: returnData! , encoding: NSUTF8StringEncoding)

                        //print(str)
                        NSURLConnection.sendAsynchronousRequest(request1, queue: OperationQueue.main, completionHandler:{(response:URLResponse?, responseData:Data?, error: Error?)  in
                        print("Media data uploadded")
                            if self.pathToDelete != nil && error == nil {
                            do {
                                try FileManager.default.removeItem(atPath: self.pathToDelete!)
                            } catch let error1 as NSError {
                             // error = error1
                                print(error)
                            }
                            
                            }
                        })
                            
                    }}
                })
            task.resume()
            
            
            
//              var returnData = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
//            if returnData != nil {
//             var returnString = NSString(data: returnData!, encoding: NSUTF8StringEncoding)
//            
//             print("returnString \(returnString)")
//            }
           
        }
        else {
            print("data is null")
        }
        
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
            DispatchQueue.global(qos: .utility).async {
                DispatchQueue.main.async {
                  //  EZLoadingActivity.show("Loading...", disableUI: false)
                }
            }
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
                //EZLoadingActivity.hide(true, animated: true)
                
                
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
                              //  self.imageTableView.reloadData()
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
