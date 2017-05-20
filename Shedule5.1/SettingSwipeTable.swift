//
//  SettingSwipeTable.swift
//  Shedule5.1
//
//  Created by CSergey on 13.03.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingSwipeTable: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var swipec: UISwitch!
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    let nc = NSNotificationCenter.defaultCenter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        finit()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func swipeevent(sender: UISwitch) {
        if limitation().check{
        if defaults.objectForKey("SheduleSettingSwipeTable") == nil{
        nc.postNotificationName("funcinstructionaboutswitch", object: nil)
        }
        defaults.setObject(sender.on, forKey: "SheduleSettingSwipeTable")
        defaults.synchronize()
        }else{
            nc.postNotificationName("funcalertinfoaboutlimits", object: nil, userInfo:["title": label.text!])
            swipec.on = false
        }
    }
    
    func finit(){
        label.text = "Быстрое переключение недель"
        if let flag = defaults.objectForKey("SheduleSettingSwipeTable"){
            swipec.on = flag as! Bool
        }else{
            swipec.on = false
        }
    }

}
