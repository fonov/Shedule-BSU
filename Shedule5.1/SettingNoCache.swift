//
//  SettingNoCache.swift
//  Shedule5.1
//
//  Created by CSergey on 31.05.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingNoCache: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var swipeout: UISwitch!
    
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    let nc = NSNotificationCenter.defaultCenter()

    override func awakeFromNib() {
        super.awakeFromNib()
        label.text = "Загрузка кэшированных данных"
        swipeinit()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btn(sender: AnyObject) {
        nc.postNotificationName("funcaboutcashe", object: nil)
    }
    
    @IBAction func swipeact(sender: UISwitch) {
        if !sender.on{
            defaults.setObject(true, forKey: "nocashe")
        }
        if sender.on{
            defaults.setObject(false, forKey: "nocashe")
        }
    }
    
    func swipeinit(){
        if let nocashe = defaults.objectForKey("nocashe"){
            if nocashe as! Bool{
                self.swipeout.on = false
            }
            if !(nocashe as! Bool){
                self.swipeout.on = true
            }
        }else{
            self.swipeout.on = true
        }
    }

}
