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
        
        let request = NSMutableURLRequest(url: URL(string: self.url)!)
        request.httpMethod = "POST"
        request.httpBody = self.post.data(using: String.Encoding.utf8)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        
        _ = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            
            if error != nil{
                if error!._code == -1009{
                    returndict = ["data": [], "code": 01, "status": false]
                }
                else{
                    
                    returndict = ["data": [], "code": 02, "status": false]
                    
                }
            }else{
                do {
                    let jsondata: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if(jsondata["status"] as! Bool){
                        returndict = ["data": jsondata, "code": 03, "status": true]
                    }else{
                        returndict = ["data": jsondata, "code": 04, "status": false]
                    }
                }catch {
                    returndict = ["data": [], "code": 05, "status": false]
                }
            }
            semaphore.signal()
            }) .resume()
        
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return returndict
    }
    
    
    
    
}
