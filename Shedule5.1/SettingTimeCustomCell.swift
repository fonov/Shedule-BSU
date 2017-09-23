//
//  SettingTimeCustomCell.swift
//  Shedule5.1
//
//  Created by kotmodell on 10.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingTimeCustomCell: UITableViewCell {

    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
//    let nc = NSNotificationCenter.defaultCenter()
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shedulesettingtimecustominit()
        shedulesettingtimecustomdefult()
        shedulesettingcustomlabeltimeinit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var date_picker: UIDatePicker!
    @IBOutlet weak var outlettypedate: UISegmentedControl!
    @IBOutlet weak var labelcustomtime: UILabel!
    
    
    @IBAction func Sermentdatecustom(_ sender: UISegmentedControl) {
        shedulesettingtimecustominit()
    }
    
    @IBAction func change_date_picker(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        let strDate = dateFormatter.string(from: date_picker.date)
        
        let dateFormatter_out = DateFormatter()
        dateFormatter_out.dateFormat = "dd.MM.yyyy"
        let strDate_out = dateFormatter_out.string(from: date_picker.date)
        
        var timekey: String!
        
        if outlettypedate.selectedSegmentIndex == 0{
            timekey = "SheduleSettingCustomdatefist"
        }
        if outlettypedate.selectedSegmentIndex == 1{
            timekey = "SheduleSettingCustomdatelast"
        }
        
        defaults.set([strDate,strDate_out], forKey: timekey)
        self.defaults.set(true, forKey: "SheduleSettingupdate")
        defaults.synchronize()
        
        print(strDate)
//        nc.postNotificationName("funcshedulesettingtimecustomdetal", object: nil)
        shedulesettingcustomlabeltimeinit()
    }
    
    func shedulesettingtimecustominit(){
        if outlettypedate.selectedSegmentIndex == 0{
           if let fistdate = defaults.object(forKey: "SheduleSettingCustomdatefist"){
            let priority = DispatchQueue.GlobalQueuePriority.default
            DispatchQueue.global(priority: priority).async {
                let df = DateFormatter()
                df.dateFormat = "ddMMyyyy"
                let date = df.date(from: String(describing: (fistdate as! NSArray)[0]))
                DispatchQueue.main.async {
                self.date_picker.setDate(date!, animated: true)
                }
            }
            }
        }
        if outlettypedate.selectedSegmentIndex == 1{
            if let lastdate = defaults.object(forKey: "SheduleSettingCustomdatelast"){
                let priority = DispatchQueue.GlobalQueuePriority.default
                DispatchQueue.global(priority: priority).async {
                    let df = DateFormatter()
                    df.dateFormat = "ddMMyyyy"
                    let date = df.date(from: String(describing: (lastdate as! NSArray)[0]))
                    DispatchQueue.main.async {
                        self.date_picker.setDate(date!, animated: true)
                    }
                }
            }
        }
        
    }
    
    func shedulesettingtimecustomdefult(){
        if defaults.object(forKey: "SheduleSettingCustomdatefist") == nil && defaults.object(forKey: "SheduleSettingCustomdatelast") == nil{

            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyy"
            dateFormatter.locale = Locale.current
            let convertedDate = dateFormatter.string(from: currentDate)
            
            let currentDate_out = Date()
            let dateFormatter_out = DateFormatter()
            dateFormatter_out.dateFormat = "dd.MM.yyyy"
            dateFormatter_out.locale = Locale.current
            let convertedDate_out = dateFormatter_out.string(from: currentDate_out)
            
            self.defaults.set([convertedDate,convertedDate_out], forKey: "SheduleSettingCustomdatefist")
            self.defaults.set([convertedDate,convertedDate_out], forKey: "SheduleSettingCustomdatelast")
            self.defaults.set(true, forKey: "SheduleSettingupdate")
            defaults.synchronize()
            
        }
    }
    
    func shedulesettingcustomlabeltimeinit(){
        var detalcustomdate: String!
        if defaults.object(forKey: "SheduleSettingCustomdatefist") != nil && defaults.object(forKey: "SheduleSettingCustomdatefist") != nil{
            let fistdate = self.defaults.object(forKey: "SheduleSettingCustomdatefist")
            let lastdate = self.defaults.object(forKey: "SheduleSettingCustomdatelast")
            detalcustomdate = "\(String(describing: (fistdate as! NSArray)[1]))-\(String(describing: (lastdate as! NSArray)[1]))"
        }else{
            detalcustomdate = ""
        }
        labelcustomtime.text = detalcustomdate
    }
    
}
