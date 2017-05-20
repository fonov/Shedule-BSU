//
//  FSpostjson.swift
//  Shedule5.1
//
//  Created by kotmodell on 11.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import Foundation

class SFpostjson{
    
    var post: String = ""
    var url: String = ""
    
    init(in_post: String, in_url: String){
        self.post = in_post
        self.url = in_url
    }
    
    var json: NSDictionary{
        
        var returndict: NSDictionary!
        
        returndict = ["data": [], "code": 00, "status": false]
        
        let request = NSMutableURLRequest(URL: NSURL(string: self.url)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = self.post.dataUsingEncoding(NSUTF8StringEncoding)
        
        let semaphore = dispatch_semaphore_create(0)
        
        _ = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil{
                if error!.code == -1009{
                    returndict = ["data": [], "code": 01, "status": false]
                }
                else{
                    
                    returndict = ["data": [], "code": 02, "status": false]
                    
                }
            }else{
                do {
                    let jsondata: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    if(jsondata["status"] as! Bool){
                        returndict = ["data": jsondata, "code": 03, "status": true]
                    }else{
                        returndict = ["data": jsondata, "code": 04, "status": false]
                    }
                }catch {
                    returndict = ["data": [], "code": 05, "status": false]
                }
            }
            dispatch_semaphore_signal(semaphore)
            }.resume()
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return returndict
    }
    
    
    
    
}
