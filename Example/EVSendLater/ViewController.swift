//
//  ViewController.swift
//  EVSendLater
//
//  Created by Enzo Vergara on 10/08/2015.
//  Copyright (c) 2015 Enzo Vergara. All rights reserved.
//

import UIKit
import EVSendLater
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var inputField: UITextField!
    var saves:NSDictionary!
    let formatter = NSDateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "MMM d, h:mm a"
        saves = EVSendLater.sharedManager.getAllSaves(false)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendNowOrLater(url:String, params:[String:AnyObject], completion:(success:Bool) -> Void){
        Alamofire.request(.POST, url, parameters: params).responseJSON { (request, response, result) -> Void in
            if result.isFailure{
                EVSendLater.sharedManager.saveForLater(url, params: params)
                self.saves  = EVSendLater.sharedManager.getAllSaves(false)
                self.table.reloadData()
                EVSendLater.sharedManager.synchronizeSaves()
            }
            completion(success: result.isSuccess)
        }
    }

    @IBAction func syncAction(sender: UIButton) {
        for (url, params) in EVSendLater.sharedManager.getAllSaves(true){
            if let u = url as? String{
                if let parameters = params as? [[String: AnyObject]]{
                    for p in parameters{
                        sendNowOrLater(u, params: p, completion: { (success) -> Void in
                            if success{
                                self.saves = EVSendLater.sharedManager.getAllSaves(false)
                                self.table.reloadData()
                            }
                            EVSendLater.sharedManager.synchronizeSaves()
                        })
                    }
                }
            }
        }
//        EVSendLater.sharedManager.synchronizeSaves()
//        let url = "http://httpbin.org/post"
//        if let params = EVSendLater.sharedManager.getSavesForUrl(url, delete:true){
//            for p in params{
//                sendNowOrLater(url, params: p, completion: { (success) -> Void in
//                    if success{
//                        self.saves  = EVSendLater.sharedManager.getSavesForUrl(url, delete:false)
//                        self.table.reloadData()
//                        EVSendLater.sharedManager.synchronizeSaves()
//                    }
//                })
//            }
//        }
    }
    
    @IBAction func sendAction(sender: UIButton) {
        sendNowOrLater("http://httpbin.org/post", params: ["string":inputField.text!, "date":NSDate().timeIntervalSince1970]) { (success) -> Void in
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return saves.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if saves == nil{
            return 0
        }
        if let key = saves.allKeys[section] as? String{
            return saves.objectForKey(key)!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        if let key = saves.allKeys[indexPath.section] as? String{
            if let save = saves.objectForKey(key)![indexPath.row] as? NSDictionary{
                cell.textLabel?.text = save.objectForKey("string") as! String!
                cell.detailTextLabel?.text = formatter.stringFromDate(NSDate(timeIntervalSince1970: save.objectForKey("date")!.doubleValue))
            }
        }
        
        return cell
        
    }
}

