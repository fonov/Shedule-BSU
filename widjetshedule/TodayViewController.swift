//
//  TodayViewController.swift
//  widjetshedule
//
//  Created by CSergey on 20.04.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let nc = NSNotificationCenter.defaultCenter()
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        settable(false)
        todayshedule()
    }
    
    override func viewDidAppear(animated: Bool) {
        settable(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        settable(true)
        completionHandler(.NewData)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todayshedule().count == 0{
            return 1
        }else{
            if defaults.objectForKey("ads") == nil{
            return 1
            }else{
            return todayshedule()[1].count
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if todayshedule().count == 0 || defaults.objectForKey("ads") == nil{
            let cell = tableView.dequeueReusableCellWithIdentifier("shcelldefult", forIndexPath: indexPath) as! Cellno
            if defaults.objectForKey("ads") == nil{
                cell.label.text = "Отключите ограничения"
            }else{
                cell.label.text = "Расписание на сегодня отсутствует"
            }
            cell.selectionStyle = .None
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("shcell", forIndexPath: indexPath) as! WidjetCell
            cell.widjetnumber.text = String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[0] as! String)
            cell.widjettypesubject.text = String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[2] as! String)
            cell.widjetsubject.text = String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[3] as! String)
            cell.widjetaud.text = ftcbodyaud(String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[6-(self.defaults.objectForKey("SheduleSettingSourseShedule") as! Int)] as! String))[0] as? String
            if !(ftcbodyaud(String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[6-(self.defaults.objectForKey("SheduleSettingSourseShedule") as! Int)] as! String))[1] as! Bool){
                cell.widjetaud.textColor = UIColor(red: 196/255, green: 201/255, blue: 204/255, alpha: 1)
            }
            cell.widjetview.backgroundColor = ftcbodyindcolor(String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[2] as! String))
            cell.selectionStyle = .None
            return cell
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let layer: CAShapeLayer = CAShapeLayer()
        let bounds: CGRect = CGRectInset(cell.bounds, 0, 0)
        if todayshedule().count == 0{
            cell.backgroundColor = UIColor.clearColor()
        }else{
        if checkdataless(String(todayshedule()[0] as! String), less: String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[0] as! String)){
            cell.backgroundColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 0.15)
        }else{
            cell.backgroundColor = UIColor.clearColor()
            var goldflag: Bool!
            if indexPath.row+1 < tableView.numberOfRowsInSection(indexPath.section)-1 || indexPath.row+1 == tableView.numberOfRowsInSection(indexPath.section)-1{
                if checkdataless(String(todayshedule()[0] as! String), less: String(((((todayshedule()[1]) as! NSArray)[indexPath.row+1]) as! NSArray)[0] as! String)){
                goldflag = false
                }else{
                    goldflag = true
                }
            }else{
                goldflag = true
            }
            if (indexPath.row != tableView.numberOfRowsInSection(indexPath.section)-1 && goldflag){
                let lineLayer: CALayer = CALayer()
                let lineHeight: CGFloat = (1.0 / UIScreen.mainScreen().scale)
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight)
                lineLayer.backgroundColor = UIColor.grayColor().CGColor
                layer.addSublayer(lineLayer)
            }
        }
        }
        let testView: UIView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, atIndex: 0)
        cell.backgroundView = testView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if todayshedule().count == 0{
            return 50
        }else{
            return 70
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if todayshedule().count == 0{
            return 50
        }else{
            return 70
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsetsZero
    }
    
    func settable(reload: Bool){
        if reload{
            tableView.reloadData()
        }
        tableView.tableFooterView = UIView(frame: CGRectZero)
        self.preferredContentSize = tableView.contentSize
    }
    
    func checkdata(date: String)->Bool{
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = NSLocale.currentLocale()
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        let cdate = date.componentsSeparatedByString(" ")
        if cdate.count == 2{
            if cdate[0] == convertedDate{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func checkdataless(date: String, less: String)->Bool{
        //
        let lesstime = [[830, 1005], [1015, 1150], [1200, 1335], [1400, 1535], [1545, 1720], [1730, 1905], [1915, 2050]]
        if checkdata(date){
            let currentDate = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "Hmm"
            dateFormatter.locale = NSLocale.currentLocale()
            let convertedDate = dateFormatter.stringFromDate(currentDate)
            let lessa: Int = Int(less)!-1
            let sless: Int = lesstime[lessa][0]
            let fless: Int = lesstime[lessa][1]
            let nowtime: Int = Int(convertedDate)!
            if ((sless < nowtime || sless == nowtime) && (fless > nowtime) && defaults.objectForKey("ads") != nil){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func todayshedule()-> NSArray{
        if let dta = defaults.objectForKey("sheduledata"){
            let shedulearray: NSArray = (((dta as! NSDictionary)["data"] as! NSDictionary)["data"] as! NSArray)
            for (_, item) in shedulearray.enumerate(){
                if self.checkdata(String((item as! NSArray)[0])){
                    return item as! NSArray
                }
            }
            return [AnyObject]()
        }else{
            return [AnyObject]()
        }
    }
    
    func ftcbodyaud(aud: String)->NSArray{
        var ad: String = aud
        if aud == "ауд. ,"{
            ad = "аудитория не указана"
            return [ad, false]
        }else{
            return [ad, true]
        }
    }
    
    func ftcbodyindcolor(type: String)->UIColor{
        var color: UIColor
        switch type.lowercaseString{
        case "лек.":
            color = UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1)
            break
        case "пр.з.":
            color = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1)
            break
        case "конс.":
            color = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
            break
        case "экз.":
            color = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1)
            break
        case "лаб.":
            color = UIColor(red: 75/255, green: 0/255, blue: 130/255, alpha: 1)
            break
        case "тест":
            color = UIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 1)
            break
        case "о.лек.":
            color = UIColor(red: 102/255, green: 205/255, blue: 170/255, alpha: 1)
            break
        default:
            color = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
            break
        }
        return color
    }

}
