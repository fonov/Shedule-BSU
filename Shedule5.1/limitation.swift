//
//  limitation.swift
//  Shedule5.1
//
//  Created by CSergey on 19.05.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import Foundation

public class limitation{
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    let nc = NSNotificationCenter.defaultCenter()
    var check: Bool{
        if defaults.objectForKey("ads") == nil{
            return false
        }else{
            return true
        }
    }
    var offlimitation: Bool{
        defaults.setObject(true, forKey: "ads")
        defaults.synchronize()
        return true
    }
    var onlimitation: Bool{
        defaults.removeObjectForKey("ads")
        return true
    }
}