//
//  SettingGroupInputCell.swift
//  Shedule5.1
//
//  Created by kotmodell on 02.03.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingGroupInputCell: UITableViewCell {

    @IBOutlet weak var groupinput: UITextField!
    let nc = NSNotificationCenter.defaultCenter()
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    var grouparray = [[AnyObject]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shedulesettinggroupcellinit()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }    
    @IBAction func eventgrinput(sender: AnyObject) {
        if groupinput.text!.characters.count != 0{
            self.defaults.setObject(String(UTF8String: groupinput.text!), forKey: "SheduleSettingSourseGroupID")
            self.defaults.setObject(true, forKey: "SheduleSettingupdate")
            self.defaults.synchronize()
            seacrhgpush(groupinput.text!)
        }
        groupinput.resignFirstResponder()
        nc.postNotificationName("funcfromgrouptosetting", object: nil)
    }
    
    func shedulesettinggroupcellinit(){
        groupinput.keyboardAppearance = UIKeyboardAppearance.Dark
        groupinput.placeholder = "Введите номер группы"
    }
    
    func seacrhgpush(group: String){
        sgupdate()
        for (index, _) in grouparray.enumerate() {
            grouparray[index][1] = false
        }
        grouparray.append([group, true])
        sgsave()
        print(grouparray)
    }
    func sgsave(){
        if grouparray.count != 0{
            self.defaults.setObject(grouparray, forKey: "SheduleSettingGroupArray")
            self.defaults.synchronize()}
        else{
            self.sgdell()
        }
    }
    func sgdell(){
        self.defaults.removeObjectForKey("SheduleSettingGroupArray")
    }
    
    func sgupdate(){
        if defaults.objectForKey("SheduleSettingGroupArray") != nil{
            grouparray = defaults.objectForKey("SheduleSettingGroupArray") as! [[AnyObject]]
        }
    }

}
