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
    let nc = NotificationCenter.default
    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        settable(false)
        todayshedule()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        settable(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        settable(true)
        completionHandler(.newData)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todayshedule().count == 0{
            return 1
        }else{
            if defaults.object(forKey: "ads") == nil{
            return 1
            }else{
            return (todayshedule()[1] as AnyObject).count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if todayshedule().count == 0 || defaults.object(forKey: "ads") == nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: "shcelldefult", for: indexPath) as! Cellno
            if defaults.object(forKey: "ads") == nil{
                cell.label.text = "Отключите ограничения"
            }else{
                cell.label.text = "Расписание на сегодня отсутствует"
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "shcell", for: indexPath) as! WidjetCell
            cell.widjetnumber.text = String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[0] as! String)
            cell.widjettypesubject.text = String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[2] as! String)
            cell.widjetsubject.text = String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[3] as! String)
            cell.widjetaud.text = ftcbodyaud(String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[6-(self.defaults.object(forKey: "SheduleSettingSourseShedule") as! Int)] as! String))[0] as? String
            if !(ftcbodyaud(String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[6-(self.defaults.object(forKey: "SheduleSettingSourseShedule") as! Int)] as! String))[1] as! Bool){
                cell.widjetaud.textColor = UIColor(red: 196/255, green: 201/255, blue: 204/255, alpha: 1)
            }
            cell.widjetview.backgroundColor = ftcbodyindcolor(String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[2] as! String))
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let layer: CAShapeLayer = CAShapeLayer()
        let bounds: CGRect = cell.bounds.insetBy(dx: 0, dy: 0)
        if todayshedule().count == 0{
            cell.backgroundColor = UIColor.clear
        }else{
        if checkdataless(String(todayshedule()[0] as! String), less: String(((((todayshedule()[1]) as! NSArray)[indexPath.row]) as! NSArray)[0] as! String)){
            cell.backgroundColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 0.15)
        }else{
            cell.backgroundColor = UIColor.clear
            var goldflag: Bool!
            if indexPath.row+1 < tableView.numberOfRows(inSection: indexPath.section)-1 || indexPath.row+1 == tableView.numberOfRows(inSection: indexPath.section)-1{
                if checkdataless(String(todayshedule()[0] as! String), less: String(((((todayshedule()[1]) as! NSArray)[indexPath.row+1]) as! NSArray)[0] as! String)){
                goldflag = false
                }else{
                    goldflag = true
                }
            }else{
                goldflag = true
            }
            if (indexPath.row != tableView.numberOfRows(inSection: indexPath.section)-1 && goldflag){
                let lineLayer: CALayer = CALayer()
                let lineHeight: CGFloat = (1.0 / UIScreen.main.scale)
                lineLayer.frame = CGRect(x: bounds.minX, y: bounds.size.height-lineHeight, width: bounds.size.width, height: lineHeight)
                lineLayer.backgroundColor = UIColor.gray.cgColor
                layer.addSublayer(lineLayer)
            }
        }
        }
        let testView: UIView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, at: 0)
        cell.backgroundView = testView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if todayshedule().count == 0{
            return 50
        }else{
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if todayshedule().count == 0{
            return 50
        }else{
            return 70
        }
    }
    
    func widgetMarginInsets
        (forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsets.zero
    }
    
    func settable(_ reload: Bool){
        if reload{
            tableView.reloadData()
        }
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.preferredContentSize = tableView.contentSize
    }
    
    func checkdata(_ date: String)->Bool{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale.current
        let convertedDate = dateFormatter.string(from: currentDate)
        let cdate = date.components(separatedBy: " ")
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
    
    func checkdataless(_ date: String, less: String)->Bool{
        //
        let lesstime = [[830, 1005], [1015, 1150], [1200, 1335], [1400, 1535], [1545, 1720], [1730, 1905], [1915, 2050]]
        if checkdata(date){
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "Hmm"
            dateFormatter.locale = Locale.current
            let convertedDate = dateFormatter.string(from: currentDate)
            let lessa: Int = Int(less)!-1
            let sless: Int = lesstime[lessa][0]
            let fless: Int = lesstime[lessa][1]
            let nowtime: Int = Int(convertedDate)!
            if ((sless < nowtime || sless == nowtime) && (fless > nowtime) && defaults.object(forKey: "ads") != nil){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func todayshedule()-> NSArray{
        if let dta = defaults.object(forKey: "sheduledata"){
            let shedulearray: NSArray = (((dta as! NSDictionary)["data"] as! NSDictionary)["data"] as! NSArray)
            for (_, item) in shedulearray.enumerated(){
                if self.checkdata(String(describing: (item as! NSArray)[0])){
                    return item as! NSArray
                }
            }
            return [AnyObject]() as NSArray
        }else{
            return [AnyObject]() as NSArray
        }
    }
    
    func ftcbodyaud(_ aud: String)->NSArray{
        var ad: String = aud
        if aud == "ауд. ,"{
            ad = "аудитория не указана"
            return [ad, false]
        }else{
            return [ad, true]
        }
    }
    
    func ftcbodyindcolor(_ type: String)->UIColor{
        var color: UIColor
        switch type.lowercased(){
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
