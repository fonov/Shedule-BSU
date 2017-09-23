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
    
    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
    let nc = NotificationCenter.default

    override func awakeFromNib() {
        super.awakeFromNib()
        label.text = "Загрузка кэшированных данных"
        swipeinit()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btn(_ sender: AnyObject) {
        nc.post(name: Notification.Name(rawValue: "funcaboutcashe"), object: nil)
    }
    
    @IBAction func swipeact(_ sender: UISwitch) {
        if !sender.isOn{
            defaults.set(true, forKey: "nocashe")
        }
        if sender.isOn{
            defaults.set(false, forKey: "nocashe")
        }
    }
    
    func swipeinit(){
        if let nocashe = defaults.object(forKey: "nocashe"){
            if nocashe as! Bool{
                self.swipeout.isOn = false
            }
            if !(nocashe as! Bool){
                self.swipeout.isOn = true
            }
        }else{
            self.swipeout.isOn = true
        }
    }

}
