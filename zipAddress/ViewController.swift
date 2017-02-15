//
//  ViewController.swift
//  zipAddress
//
//  Created by NOWALL on 2016/09/10.
//  Copyright © 2016年 NOWALL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var prefLabel: UILabel!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBAction func tapReturn() {
        
    }
    
    @IBAction func tapSearch() {
        
        guard let ziptext = zipTextField.text else {
            // if data is nil, return from this method
            return
        }
        
        // generate url for request
        let urlStr = "http://api.zipaddress.net/?zipcode=\(ziptext)"
        
        // view str
        print(urlStr)
        
        if let url = NSURL(string: urlStr) {
            // generate 検索処理object
            let urlSession = NSURLSession.sharedSession()
            
            // when tasks of search are completed, fire "onGetAddress" method as callback func
            let task = urlSession.dataTaskWithURL(url, completionHandler: self.onGetAddress)
            
            // exec task
            task.resume()
            
        }
    }
    
    func onGetAddress(data: NSData?, res: NSURLResponse?, error: NSError?) {
        
        do {
            // parse json
            let jsonDic = try NSJSONSerialization.JSONObjectWithData( data! , options: NSJSONReadingOptions.MutableContainers ) as! NSDictionary
            
            if let code = jsonDic["code"] as? Int {
                if code != 200 {
                    if let errmsg = jsonDic["message"] as? String {
                        print (errmsg)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.prefLabel.text = errmsg
                        }
                    }
                }
            }
            
            if let data = jsonDic["data"] as? NSDictionary {
                if let pref = data["pref"] as? String {
                    print("prefecture: \(pref)")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.prefLabel.text = pref
                    }
                }
                
                if let address = data["address"] as? String {
                    print("address: \(address)")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.addressLabel.text = address
                    }
                }
            }
        }
        catch {
            print("err! on catch")
            dispatch_async(dispatch_get_main_queue()) {
                self.addressLabel.text = "An Err!"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

