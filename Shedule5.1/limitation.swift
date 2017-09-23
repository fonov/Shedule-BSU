//
//  limitation.swift
//  Shedule5.1
//
//  Created by CSergey on 19.05.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import Foundation

open class limitation{
    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
    let nc = NotificationCenter.default
    var check: Bool{
        if defaults.object(forKey: "ads") == nil{
            return false
        }else{
            return true
        }
    }
    var offlimitation: Bool{
        defaults.set(true, forKey: "ads")
        defaults.synchronize()
        return true
    }
    var onlimitation: Bool{
        defaults.removeObject(forKey: "ads")
        return true
    }
}
