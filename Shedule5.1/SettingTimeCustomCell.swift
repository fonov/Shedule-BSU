//
//  SettingTimeCustomCell.swift
//  Shedule5.1
//
//  Created by kotmodell on 10.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingTimeCustomCell: UITableViewCell {

    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
//    let nc = NSNotificationCenter.defaultCenter()
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shedulesettingtimecustominit()
        shedulesettingtimecustomdefult()
        shedulesettingcustomlabeltimeinit()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var date_picker: UIDatePicker!
    @IBOutlet weak var outlettypedate: UISegmentedControl!
    @IBOutlet weak var labelcustomtime: UILabel!
    
    
    @IBAction func Sermentdatecustom(sender: UISegmentedControl) {
        shedulesettingtimecustominit()
    }
    
    @IBAction func change_date_picker(sender: UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        let strDate = dateFormatter.stringFromDate(date_picker.date)
        
        let dateFormatter_out = NSDateFormatter()
        dateFormatter_out.dateFormat = "dd.MM.yyyy"
        let strDate_out = dateFormatter_out.stringFromDate(date_picker.date)
        
        var timekey: String!
        
        if outlettypedate.selectedSegmentIndex == 0{
            timekey = "SheduleSettingCustomdatefist"
        }
        if outlettypedate.selectedSegmentIndex == 1{
            timekey = "SheduleSettingCustomdatelast"
        }
        
        defaults.setObject([strDate,strDate_out], forKey: timekey)
        self.defaults.setObject(true, forKey: "SheduleSettingupdate")
        defaults.synchronize()
        
        print(strDate)
//        nc.postNotificationName("funcshedulesettingtimecustomdetal", object: nil)
        shedulesettingcustomlabeltimeinit()
    }
    
    func shedulesettingtimecustominit(){
        if outlettypedate.selectedSegmentIndex == 0{
           if let fistdate = defaults.objectForKey("SheduleSettingCustomdatefist"){
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                let df = NSDateFormatter()
                df.dateFormat = "ddMMyyyy"
                let date = df.dateFromString(String((fistdate as! NSArray)[0]))
                dispatch_async(dispatch_get_main_queue()) {
                self.date_picker.setDate(date!, animated: true)
                }
            }
            }
        }
        if outlettypedate.selectedSegmentIndex == 1{
            if let lastdate = defaults.objectForKey("SheduleSettingCustomdatelast"){
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    let df = NSDateFormatter()
                    df.dateFormat = "ddMMyyyy"
                    let date = df.dateFromString(String((lastdate as! NSArray)[0]))
                    dispatch_async(dispatch_get_main_queue()) {
                        self.date_picker.setDate(date!, animated: true)
                    }
                }
            }
        }
        
    }
    
    func shedulesettingtimecustomdefult(){
        if defaults.objectForKey("SheduleSettingCustomdatefist") == nil && defaults.objectForKey("SheduleSettingCustomdatelast") == nil{

            let currentDate = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "ddMMyyyy"
            dateFormatter.locale = NSLocale.currentLocale()
            let convertedDate = dateFormatter.stringFromDate(currentDate)
            
            let currentDate_out = NSDate()
            let dateFormatter_out = NSDateFormatter()
            dateFormatter_out.dateFormat = "dd.MM.yyyy"
            dateFormatter_out.locale = NSLocale.currentLocale()
            let convertedDate_out = dateFormatter_out.stringFromDate(currentDate_out)
            
            self.defaults.setObject([convertedDate,convertedDate_out], forKey: "SheduleSettingCustomdatefist")
            self.defaults.setObject([convertedDate,convertedDate_out], forKey: "SheduleSettingCustomdatelast")
            self.defaults.setObject(true, forKey: "SheduleSettingupdate")
            defaults.synchronize()
            
        }
    }
    
    func shedulesettingcustomlabeltimeinit(){
        var detalcustomdate: String!
        if defaults.objectForKey("SheduleSettingCustomdatefist") != nil && defaults.objectForKey("SheduleSettingCustomdatefist") != nil{
            let fistdate = self.defaults.objectForKey("SheduleSettingCustomdatefist")
            let lastdate = self.defaults.objectForKey("SheduleSettingCustomdatelast")
            detalcustomdate = "\(String((fistdate as! NSArray)[1]))-\(String((lastdate as! NSArray)[1]))"
        }else{
            detalcustomdate = ""
        }
        labelcustomtime.text = detalcustomdate
    }
    
}
