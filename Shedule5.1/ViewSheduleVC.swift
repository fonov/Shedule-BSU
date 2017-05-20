//
//  ViewSheduleVC.swift
//  Shedule5.1
//
//  Created by kotmodell on 15.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class ViewSheduleVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // REMOVE DEBAG LINE!!!!!!!   +
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoimg: UIImageView!
    @IBOutlet weak var infolabel: UILabel!
    @IBOutlet weak var loadind: UIActivityIndicatorView!
    @IBOutlet weak var loadlabel: UILabel!
    
    var hidingNavBarManager: HidingNavigationBarManager?
    let nc = NSNotificationCenter.defaultCenter()
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    var SFjson: NSDictionary!
    var tableupdata: Bool = false
    var refreshControl:UIRefreshControl!
    var tablealert: Bool = false
    var tablealerttext: String = ""
    var upflag: Bool = false
    var openview: Bool = false
    var chromtimer: NSTimer!
    var flagads: Bool!
    var counads: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initautohidetabbarandnavcontroller()
        refreshinit()
        initswipetableview()
        nc.addObserver(self, selector: #selector(ViewSheduleVC.updateactualsection), name: "funcupdateactualsection", object: nil)
        nc.addObserver(self, selector: #selector(ViewSheduleVC.chromtimerstart), name: "funcchromtimerstart", object: nil)
        nc.addObserver(self, selector: #selector(ViewSheduleVC.chromtimerstop), name: "funcchromtimerstop", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        hidingNavBarManager?.viewWillAppear(animated)
        inittimerstart()
        sheduleviewsheduleinit(false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        hidingNavBarManager?.viewWillDisappear(animated)
        inittimerfinish()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hidingNavBarManager?.viewDidLayoutSubviews()
    }

    
    func sheduleviewsheduleinit(eswipe: Bool){
        // reset all setting
        tableViewinit()
        // update title
        sheduleviewtitleinit()
        
        if let update = defaults.objectForKey("SheduleSettingupdate"){
            
            if defaults.objectForKey("SheduleSettingSourseShedule") == nil{
                infopanel("Для отображения расписания его нужно настроить. Установите тип расписания.", img: "shedule", hide: false)
                return
            }
            if defaults.objectForKey("SheduleSettingtime") == nil{
                infopanel("Для отображения расписания его нужно настроить. Установите время расписания.", img: "shedule", hide: false)
                return
            }
            if defaults.objectForKey("SheduleSettingtime") as! Int == 3 && (defaults.objectForKey("SheduleSettingCustomdatefist") == nil || defaults.objectForKey("SheduleSettingCustomdatelast") == nil){
                infopanel("Для отображения расписания его нужно настроить. Установите своё время расписания.", img: "shedule", hide: false)
                return
            }
            if defaults.objectForKey("SheduleSettingSourseShedule") as! Int == 0 && defaults.objectForKey("SheduleSettingSourseGroupID") == nil{
                infopanel("Для отображения расписания его нужно настроить. Установите номер группы.", img: "shedule", hide: false)
                return
            }
            if defaults.objectForKey("SheduleSettingSourseShedule") as! Int == 1 && defaults.objectForKey("SheduleSettingSourseTeachID") == nil{
                infopanel("Для отображения расписания его нужно настроить. Выберите преподавателя.", img: "shedule", hide: false)
                return
            }
            
            infopanel("", img: "shedule", hide: true)
            
            if (update as! Bool)||(!checkactualweek()){
                // on load indicator
                self.loadindicator(false, hide: false)
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                    var stingpost: String!
                    if self.defaults.objectForKey("SheduleSettingSourseShedule") as! Int == 0{
                        stingpost = "group=\(self.defaults.objectForKey("SheduleSettingSourseGroupID") as! String)"
                    }
                    if self.defaults.objectForKey("SheduleSettingSourseShedule") as! Int == 1{
                        let teachid: [String] = self.defaults.objectForKey("SheduleSettingSourseTeachID") as! Array<String>
                        stingpost = "teach=\(teachid[0])"
                    }
                    if self.defaults.objectForKey("SheduleSettingtime") as! Int == 0 || self.defaults.objectForKey("SheduleSettingtime") as! Int == 1 ||  self.defaults.objectForKey("SheduleSettingtime") as! Int == 2 {
                        var week: Int = self.defaults.objectForKey("SheduleSettingtime") as! Int
                        week = week+1
                        stingpost = "\(stingpost)&week=\(week)"
                    }
                    if self.defaults.objectForKey("SheduleSettingtime") as! Int == 3{
                        let fistdate: [String] = self.defaults.objectForKey("SheduleSettingCustomdatefist") as! [String]
                        let lastdate: [String] = self.defaults.objectForKey("SheduleSettingCustomdatelast") as! [String]
                        stingpost = "\(stingpost)&week=\(fistdate[0])\(lastdate[0])"
                    }
                    
                    stingpost = "\(stingpost)&model=\(UIDevice.currentDevice().modelName)&version=\(UIDevice.currentDevice().systemVersion)"
//                    stingpost = "\(stingpost)&debag_mode=on"
                    stingpost = self.nocashe(stingpost)
                    print(stingpost)
                    
                    
                    let SFCpostjson = SFpostjson(in_post: stingpost, in_url: "http://lab.lionrepair.ru/uapp/api.php")
                    self.SFjson = SFCpostjson.json
                    
                    dispatch_async(dispatch_get_main_queue()) {
                    
                        let codejson: Int = self.SFjson["code"] as! Int
                        switch codejson{
                        case 01:
                            self.jsoncode01(eswipe)
                            break
                        case 02:
                            self.jsoncode02(eswipe)
                            break
                        case 03:
                            self.jsoncode03(eswipe)
                            break
                        case 04:
                            self.jsoncode04(eswipe)
                            break
                        case 05:
                            self.jsoncode05(eswipe)
                            break
                        default:
                            self.jsoncode00(eswipe)
                            break
                        }
                    }
                }

            }else{
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    self.SFjson = self.sheduledatainit()
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableViewShow()
                        self.autoscrolltable()
                    }
                }
            }
        }else{
            infopanel("Для отображения расписания его нужно настроить. Перейдите на вкладку настройки.", img: "shedule", hide: false)
        }
    }
    
    func infopanel(label: String, img: String, hide: Bool){
        infoimg.image = UIImage(named: img)
        infolabel.text = label
        infolabel.textColor = UIColor.blackColor()
        infoimg.hidden = hide
        infolabel.hidden = hide
        loadind.stopAnimating()
        loadlabel.hidden = true
    }
    
    func jsoncode00(eswith: Bool){
        if eswith{
            self.tableView.alpha = 1
        }
        self.loadindicator(true, hide: false)
        let text = "Неизвестная ошибка."
        infopanel(text, img: "cross31", hide: true)
        tableViewalert(text)
        newindicatorreload(text)
    }
    
    func jsoncode01(eswith: Bool){
        if eswith{
            self.tableView.alpha = 1
        }
        let text = "Oтсутствует подключение к интернету"
        self.loadindicator(true, hide: false)
        infopanel(text, img: "cross31", hide: true)
        tableViewalert(text)
        newindicatorreload(text)
    }
    
    func jsoncode02(eswith: Bool){
        if eswith{
            self.tableView.alpha = 1
        }
        self.loadindicator(true, hide: false)
        let text = "Невозможно загрузить данные"
        infopanel("Невозможно загрузить данные", img: "cross31", hide: true)
        tableViewalert(text)
        newindicatorreload(text)
    }
    
    func jsoncode03(eswith: Bool){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.mainshedulesave()
            self.setactualweek()
            //  set notification
            self.localnotification()
            dispatch_async(dispatch_get_main_queue()) {
                self.loadindicator(true, hide: true)
                self.infopanel("", img: "cross31", hide: true)
                self.tableViewShow()
                self.mainfeedbackappstore()
                self.autoscrolltable()
                if eswith{
                    UIView.animateWithDuration(1.0, animations: {
                        self.tableView.alpha = 1
                        }, completion: { _ in
                    })
                }
            }
        }
    }

    func jsoncode04(eswith: Bool){
        if eswith{
            self.tableView.alpha = 1
        }
        self.loadindicator(true, hide: true)
        let text = String((self.SFjson["data"] as! NSDictionary)["info"] as! String)
        infopanel(text, img: "cross31", hide: false)
        tableViewhide()
    }
    
    func jsoncode05(eswith: Bool){
        if eswith{
            self.tableView.alpha = 1
        }
        let text = "Невозможно обработать данные"
        self.loadindicator(true, hide: false)
        infopanel(text, img: "cross31", hide: true)
        tableViewalert(text)
        newindicatorreload(text)
    }
    
    func sheduledatainit()->NSDictionary{
        return defaults.objectForKey("sheduledata") as! NSDictionary
    }
    
    func sheduleviewtitleinit(){
        var text: String!
        var subtext: String!
        var doublelabel: Bool!
        text = "Расписание"
        subtext = ""
        doublelabel = false
        
        if self.defaults.objectForKey("SheduleSettingSourseShedule") != nil && self.defaults.objectForKey("SheduleSettingSourseGroupID") != nil && self.defaults.objectForKey("SheduleSettingSourseShedule") as! Int == 0{
            text = "Группа \(self.defaults.objectForKey("SheduleSettingSourseGroupID") as! String)"
        }
        if self.defaults.objectForKey("SheduleSettingSourseShedule") != nil && self.defaults.objectForKey("SheduleSettingSourseTeachID") != nil && self.defaults.objectForKey("SheduleSettingSourseShedule") as! Int == 1{
            let teachid: [String] = self.defaults.objectForKey("SheduleSettingSourseTeachID") as! Array<String>
            text = teachid[1]
        }
        
        if self.defaults.objectForKey("SheduleSettingtime") != nil{
            switch self.defaults.objectForKey("SheduleSettingtime") as! Int{
            case 0:
                doublelabel = true
                subtext = "прошлая неделя"
                break
            case 1:
                doublelabel = true
                subtext = "текущая неделя"
                break
            case 2:
                doublelabel = true
                subtext = "следующая неделя"
                break
            case 3:
                if self.defaults.objectForKey("SheduleSettingCustomdatefist") != nil && self.defaults.objectForKey("SheduleSettingCustomdatelast") != nil{
                    let fistdate: [String] = self.defaults.objectForKey("SheduleSettingCustomdatefist") as! [String]
                    let lastdate: [String] = self.defaults.objectForKey("SheduleSettingCustomdatelast") as! [String]
                    doublelabel = true
                    subtext = "\(fistdate[1])-\(lastdate[1])"
                }
                break
            default:
                break
            }
        }
        
        customsheduletitle(text, sublabeltext: subtext, doublelabel: doublelabel)
    }
    
    
    func addTitleAndSubtitleToNavigationBar (title: String, subtitle: String, num: Int) {
        let label = UILabel(frame: CGRectMake(10.0, 0.0, 50.0, 40.0))
        if num == 1{
            label.font = UIFont.boldSystemFontOfSize(18.0)
        }else{
            label.font = UIFont.boldSystemFontOfSize(15.0)
        }
        label.numberOfLines = num
        label.text = "\(title)\n\(subtitle)"
//        label.textColor = UIColor.whiteColor()
        label.textColor = UIColor.blackColor()
        label.backgroundColor = UIColor.clearColor()
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.Center
        self.navigationItem.titleView = label
    }

    func loadindicator(flag: Bool, hide: Bool){
        if flag && hide{
            SwiftSpinner.hide()
        }else{
            SwiftSpinner.show("Загрузка расписания...")
        }
        infoimg.hidden = true
        infolabel.hidden = true
    }
    func tableViewinit(){
        upflag = false
        tableView.separatorStyle = .None
        tableView.hidden = true
        tableupdata = false
        tablealert = false
        flagads = false
    }
    
    func tableViewShow(){
        tableView.hidden = false
        tableupdata = true
        tablealert = false
        tableView.reloadData()
    }
    func tableViewhide(){
        tableView.hidden = true
        tableupdata = false
        tablealert = false
        tableView.reloadData()
    }
    
    func tableViewalert(text: String){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            dispatch_async(dispatch_get_main_queue()) {
                self.tablealerttext = text
                self.tableupdata = false
                self.tablealert = true
                self.tableView.hidden = false
                self.tableView.reloadData()
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableupdata{
            return SFjson["data"]!["data"]!!.count}
        else if tablealert{
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableupdata{
        var num: Int = SFjson["data"]!["data"]!![section][1].count
        num = num+1
        return num
        }
        else if tablealert{
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableupdata{
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("tschead", forIndexPath: indexPath) as! tschead
            cell.tlabel.text = ftschead(String((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[0]))
            cell.selectionStyle = .None
            return cell
        }else{
                let crow = indexPath.row - 1
                let cell = tableView.dequeueReusableCellWithIdentifier("tscbody", forIndexPath: indexPath) as! tscbody
                cell.ltimesh.text = ftshbodytime(String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[1]), num: 0)[0]
                cell.ltimesi.text = ftshbodytime(String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[1]), num: 0)[1]
                cell.lnumber.text = String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[0])
                cell.ltimefh.text = ftshbodytime(String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[1]), num: 1)[0]
                cell.ltimefi.text = ftshbodytime(String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[1]), num: 1)[1]
                cell.vsheduleindicator.backgroundColor = ftcbodyindcolor(String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[2]))
                cell.lsubsubject.text = String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[2])
                cell.lsabject.text = String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[3])
                if self.defaults.objectForKey("SheduleSettingSourseShedule") as! Int == 0{
                    cell.lsubteacher.text = String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[4])
                }
                if self.defaults.objectForKey("SheduleSettingSourseShedule") as! Int == 1{
                    cell.lsubteacher.text = "группа"
                }
                cell.lteacher.text = String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[5-(self.defaults.objectForKey("SheduleSettingSourseShedule") as! Int)])
                cell.laud.text = ftcbodyaud(String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[6-(self.defaults.objectForKey("SheduleSettingSourseShedule") as! Int)]))[0] as? String
                if !(ftcbodyaud(String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[6-(self.defaults.objectForKey("SheduleSettingSourseShedule") as! Int)]))[1] as! Bool){
                    cell.laud.textColor = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1)
                }else{
                    cell.laud.textColor = UIColor.blackColor()
                }
                cell.selectionStyle = .None
                return cell
            }
            }else if tablealert{
            let cell = tableView.dequeueReusableCellWithIdentifier("tscalert", forIndexPath: indexPath) as! tscalert
            cell.label.text = tablealerttext
            cell.selectionStyle = .None
            return cell
        }else{
            let cell = UITableViewCell()
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if (cell.respondsToSelector(Selector("tintColor"))){
            if (tableView == self.tableView) {
                let cornerRadius : CGFloat = 6.0
                cell.backgroundColor = UIColor.clearColor()
                let layer: CAShapeLayer = CAShapeLayer()
                let pathRef:CGMutablePathRef = CGPathCreateMutable()
                let bounds: CGRect = CGRectInset(cell.bounds, 15.0, 0)
                var addLine: Bool = false
                
                if (indexPath.row == 0 && indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1) {
                    CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius)
                } else if (indexPath.row == 0) {
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius)
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius)
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
                    //                    addLine = true
                } else if (indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1) {
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius)
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius)
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
                } else {
                    CGPathAddRect(pathRef, nil, bounds)
                    addLine = true
                }
                layer.path = pathRef
                
                if tableupdata{
                if indexPath.row == 0{
                    if checkdata(String((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[0])){
                        layer.fillColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1.0).CGColor
                        upflag = true
                    }else{
                        layer.fillColor = UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1.0).CGColor
                    }
                }else{
                    let crow = indexPath.row - 1
                    if checkdataless(String((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[0]), less: String((((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[0])){
                        layer.fillColor = UIColor(red: 255/255, green: 250/255, blue: 205/255, alpha: 0.9).CGColor
                    }else{
                        layer.fillColor = UIColor.whiteColor().CGColor
                    }
                }
                }else if tablealert{
                    layer.fillColor = UIColor.whiteColor().CGColor
                }else{
                    layer.fillColor = UIColor.whiteColor().CGColor
                }
                
                if addLine {
                    let lineLayer: CALayer = CALayer()
                    let lineHeight: CGFloat = (1.0 / UIScreen.mainScreen().scale)
                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight)
                    lineLayer.backgroundColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1).CGColor
                    layer.addSublayer(lineLayer)
                }
                
                let testView: UIView = UIView(frame: bounds)
                testView.layer.insertSublayer(layer, atIndex: 0)
                testView.backgroundColor = UIColor.clearColor()
                cell.backgroundView = testView
            }
        }
    }

    func ftschead(date: String)->String{
        let cdate = date.componentsSeparatedByString(" ")
        var cdatestr: String!
        if cdate.count == 2{
          cdatestr = "\(cdate[1]), \(cdate[0])"
        }
        else{
          cdatestr = date
        }
        return cdatestr
    }
    
    func ftshbodytime(date: String, num: Int)->[String]{
        let cdate = date.componentsSeparatedByString("-")
        if cdate.count == 2{
            let ccdate = cdate[num].componentsSeparatedByString(":")
            if ccdate.count == 2{
            return ccdate
            }else{
            return ["", ""]
            }
        }else{
            return ["", ""]
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
    func ftcbodyaud(aud: String)->NSArray{
        var ad: String = aud
        if aud == "ауд. ,"{
        ad = "аудитория не указана"
        return [ad, false]
        }else{
        return [ad, true]
        }
    }
    func ftcbodygroup(group: String)->String{
        var str: [String]!
        str = group.componentsSeparatedByString(" ")
        if str.count == 2{
            return str[1]
        }else{
            return ""
        }
    }
    func refreshinit(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = UIColor.orangeColor()
        refreshControl.addTarget(self, action: #selector(ViewSheduleVC.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    func refresh(sender:AnyObject) {
        refreshBegin("Refresh",
            refreshEnd: {(x:Int) -> () in
                self.sheduleviewsheduleinit(false)
                self.refreshControl.endRefreshing()
        })
    }
    
    func refreshBegin(newtext:String, refreshEnd:(Int) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.defaults.setObject(true, forKey: "SheduleSettingupdate")
            self.defaults.synchronize()
            dispatch_async(dispatch_get_main_queue()) {
                refreshEnd(0)
            }
        }
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
            if ((sless < nowtime || sless == nowtime) && (fless > nowtime)){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func defaultscroll(){
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
    }
    
    func autoscrolltable(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                if let flag = self.defaults.objectForKey("SheduleSettingAutoScroll"){
                    if flag as! Bool{
                        let shedulearray: NSArray = ((self.SFjson["data"] as! NSDictionary)["data"] as! NSArray)
                        var flagscroll: Bool = false
                        for (index, item) in shedulearray.enumerate(){
                            if self.checkdata(String((item as! NSArray)[0])){
                                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: .Top, animated: true)
                                flagscroll = true
                            }
                        }
                        if !flagscroll{
                           self.defaultscroll()
                        }
                    }
                }
            }
        }
        
    }
    
    func mainfeedbackappstore(){
        if self.defaults.objectForKey("scopeload") == nil{
            self.defaults.setObject(0, forKey: "scopeload")
            self.defaults.synchronize()
        }else{
            if self.defaults.objectForKey("scopeload") as! Int == 10{
                
                func myCancelCallbackCancel() {
                    self.repiataskfeedback()
                }
                func myCancelCallback() {
                    self.openappstore()
                }
                let alertview = JSSAlertView().show(
                    self,
                    title: "Расписание \"БелГУ\"",
                    text: "Мы заметили что вы уже успешно пользуйтесь приложением \"Расписание БелГУ\". Нам нужно знать ваше мнение. Перейти в App Store для написания отзыва?",
                    buttonText: "Написать",
                    cancelButtonText: "Скрыть",
                    color: UIColorFromHex(0x3498db, alpha: 1)
                )
                alertview.setTextTheme(.Light)
                alertview.addCancelAction(myCancelCallbackCancel)
                alertview.addAction(myCancelCallback)
                
                
            }
            var scope = self.defaults.objectForKey("scopeload") as! Int
//            print(scope)
            scope = scope+1
            self.defaults.setObject(scope, forKey: "scopeload")
            self.defaults.synchronize()
        }
    }
    
    
    func openappstore(){
        UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/ru/app/raspisanie-belgu/id1080402611")!)
    }
    func repiataskfeedback(){
        self.defaults.setObject(0, forKey: "scopeload")
        self.defaults.synchronize()
    }
    
    func initswipetableview(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewSheduleVC.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewSheduleVC.handleSwipes(_:)))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        tableView.userInteractionEnabled = true
        tableView.addGestureRecognizer(leftSwipe)
        tableView.addGestureRecognizer(rightSwipe)
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            print("Swipe Left")
            if defaults.objectForKey("SheduleSettingSwipeTable") != nil{
            if tableupdata && defaults.objectForKey("SheduleSettingSwipeTable") as! Bool{
            if self.defaults.objectForKey("SheduleSettingtime") != nil{
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
            var flags: Bool = false
            var num: Int = self.defaults.objectForKey("SheduleSettingtime") as! Int
            if num == 0 || num == 1{
                num = num+1
                flags = true
                self.defaults.setObject(num, forKey: "SheduleSettingtime")
                self.defaults.setObject(true, forKey: "SheduleSettingupdate")
                self.defaults.synchronize()
            }
            dispatch_async(dispatch_get_main_queue()) {
              if flags{
                        self.tableanimation(0)
                }
              }
            }
          }
        }
        }
            
        }
        if (sender.direction == .Right) {
            print("Swipe Right")
            if defaults.objectForKey("SheduleSettingSwipeTable") != nil{
            if tableupdata && defaults.objectForKey("SheduleSettingSwipeTable") as! Bool{
                if self.defaults.objectForKey("SheduleSettingtime") != nil{
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        var flags: Bool = false
                        var num: Int = self.defaults.objectForKey("SheduleSettingtime") as! Int
                        if num == 1 || num == 2{
                            num = num-1
                            flags = true
                            self.defaults.setObject(num, forKey: "SheduleSettingtime")
                            self.defaults.setObject(true, forKey: "SheduleSettingupdate")
                            self.defaults.synchronize()
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            if flags{
                                self.tableanimation(0)
                            }
                        }
                    }
                }
            }
        }
        }
        
    }
    
    func tableanimation(num: CGFloat){
        UIView.animateWithDuration(0.3, animations: {
            self.tableView.alpha = num
            }, completion: { _ in
                self.sheduleviewsheduleinit(true)
        })
    }
    
    func mainshedulesave(){
        defaults.setObject(SFjson, forKey: "sheduledata")
        defaults.setObject(false, forKey: "SheduleSettingupdate")
        defaults.synchronize()
    }
    
    func setactualweek(){
        self.defaults.setObject(nowweeksun(), forKey: "Shedule_actualweek")
        self.defaults.synchronize()
    }
    
    
    func checkactualweek()->Bool{
        if let lastweek = self.defaults.objectForKey("Shedule_actualweek"){
            if (lastweek as! Int == nowweeksun()) || (self.defaults.objectForKey("SheduleSettingtime") as! Int == 3){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func nowweeksun()->Int{
        var currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "E"
        let strday = dateFormatter.stringFromDate(currentDate)
        var intweek: NSTimeInterval!
        switch strday{
        case "Mon":
            intweek = 6
            break
        case "Tue":
            intweek = 5
            break
        case "Wed":
            intweek = 4
            break
        case "Thu":
            intweek = 3
            break
        case "Fri":
            intweek = 2
            break
        case "Sat":
            intweek = 1
            break
        case "Sun":
            intweek = 0
            break
        default:
            intweek = 0
            break
        }
        currentDate = NSDate(timeIntervalSinceNow: intweek*24*60*60)
        dateFormatter.dateFormat = "dMyyyy"
        let nowsun = dateFormatter.stringFromDate(currentDate)
        return Int(nowsun)!
    }
    
    func updateactualsection(){
        if upflag && self.checkactualweek() && tableupdata{
        shedulereloaddata()
        print("update when open shedule")
        } else if !self.checkactualweek() && tableupdata{
            shedulereload()
            print("again load shedule when open shedule")
        }
    }
    
    func chromtimerstart(){
        if openview{
        chromtimer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(ViewSheduleVC.updateactualsectionchron), userInfo: nil, repeats: true)
        print("chromtimerstart")
        }
    }
    
    func chromtimerstop(){
        if openview{
        chromtimer.invalidate()
        print("chromtimerstop")
        }
    }
    
    func updateactualsectionchron(){
        if upflag && self.checkactualweek() && tableupdata{
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "Hmm"
        dateFormatter.locale = NSLocale.currentLocale()
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        let lesstime = [0, 830, 1005, 1015, 1150, 1200, 1335, 1400, 1535, 1545, 1720, 1730, 1905, 1915, 2050]
        for ttime in lesstime{
            if ttime == Int(convertedDate){
                shedulereloaddata()
            }
        }
        }else if !self.checkactualweek() && tableupdata{
            shedulereload()
            print("again load shedule when open viewcontroller")
        }
    }
    
    func shedulereload(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.sheduleviewsheduleinit(false)
            }
        }
    }
    
    func shedulereloaddata(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    func inittimerstart(){
        openview = true
        chromtimer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(ViewSheduleVC.updateactualsectionchron), userInfo: nil, repeats: true)
        print("start timer when open view")
    }
    
    func inittimerfinish(){
        openview = false
        chromtimer.invalidate()
        print("stop timer when close view")
    }
    
    func localnotification(){
        if let flag = defaults.objectForKey("SheduleSettingLocalNotification"){
            if flag as! Bool{
                
        UIApplication.sharedApplication().cancelAllLocalNotifications()
                
        let shedulearray: NSArray = ((self.SFjson["data"] as! NSDictionary)["data"] as! NSArray)
        for (_, item) in shedulearray.enumerate(){
            var temp_week: String = (item as! NSArray)[0] as! String
            let cdate = temp_week.componentsSeparatedByString(" ")
            temp_week = cdate[0]
            let shedulelessarray: NSArray = (item as! NSArray)[1] as! NSArray
            var tempnumber: String!
            
            for (_, item_t) in shedulelessarray.enumerate(){
                if tempnumber == nil || tempnumber != String((item_t as! NSArray)[0]){
                    var timenotification: String!
                    var titlenotification: String!
                    let lesstimenotif = ["8-25", "10-10", "11-50", "13-55", "15-40", "17-25", "19-10"]
                    switch (item_t as! NSArray)[0] as! String{
                    case "1":
                        timenotification = "\(temp_week)-\(lesstimenotif[0])"
                        break
                    case "2":
                        timenotification = "\(temp_week)-\(lesstimenotif[1])"
                        break
                    case "3":
                        timenotification = "\(temp_week)-\(lesstimenotif[2])"
                        break
                    case "4":
                        timenotification = "\(temp_week)-\(lesstimenotif[3])"
                        break
                    case "5":
                        timenotification = "\(temp_week)-\(lesstimenotif[4])"
                        break
                    case "6":
                        timenotification = "\(temp_week)-\(lesstimenotif[5])"
                        break
                    case "7":
                        timenotification = "\(temp_week)-\(lesstimenotif[6])"
                        break
                    default:
                        timenotification = "\(temp_week)-\(lesstimenotif[0])"
                        break
                    }
                    var auditor: String!
                    switch self.defaults.objectForKey("SheduleSettingSourseShedule") as! Int {
                    case 0:
                        auditor = String((item_t as! NSArray)[6])
                        break
                    case 1:
                        auditor = String((item_t as! NSArray)[5])
                        break
                    default:
                        auditor = ""
                        break
                    }
                    
                    if auditor == "ауд. ," || auditor == ""{
                        titlenotification = "Скоро начнется \((item_t as! NSArray)[2]) \((item_t as! NSArray)[3])"
                    }else{
                        titlenotification = "Скоро начнется \((item_t as! NSArray)[2]) \((item_t as! NSArray)[3]) в \(auditor)"
                    }
                    
                    if checknotifdate(notifdate(timenotification)){
                    let localNotification = UILocalNotification()
                    localNotification.fireDate = notifdate(timenotification)
                    localNotification.alertBody = titlenotification
                    localNotification.timeZone = NSTimeZone.defaultTimeZone()
                    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
//                    print("Установленно уведомление на \(timenotification) с текстом \(titlenotification)")
                    }
                    
                    tempnumber = (item_t as! NSArray)[0] as! String
            }
          }
        }
      }
     }
    }
    
    func notifdate(dateString: String)-> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy-H-mm"
        return dateFormatter.dateFromString(dateString)!
    }
    
    func checknotifdate(ndate: NSDate)->Bool{
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyHmm"
        dateFormatter.locale = NSLocale.currentLocale()
        let nowdata = dateFormatter.stringFromDate(currentDate)
        let notifdate = dateFormatter.stringFromDate(ndate)
        if Int(notifdate) > Int(nowdata) || Int(notifdate) == Int(nowdata){
            return true
        }else{
            return false
        }
    }
    
    func thisday()->String{
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = NSLocale.currentLocale()
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        return convertedDate
    }
    
    func newindicatorreload(text: String){
        SwiftSpinner.show(text, animated:false).addTapHandler({
            self.sheduleviewsheduleinit(false)
        })
    }
    
    func customsheduletitle(labeltext: String, sublabeltext: String, doublelabel: Bool){
        if doublelabel{
            let navBarTitleView = UIView(frame: CGRectMake(0.0, 0.0, self.navigationController!.navigationBar.frame.size.width, self.navigationController!.navigationBar.frame.size.height))
//            navBarTitleView.clipsToBounds = true
//            navBarTitleView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            
            let label = UILabel(frame: CGRectMake(0, 0, self.navigationController!.navigationBar.frame.size.width, 20))
            label.center = CGPointMake(self.navigationController!.navigationBar.frame.size.width/2, self.navigationController!.navigationBar.frame.size.height/3)
            label.textAlignment = NSTextAlignment.Center
            label.text = labeltext
            label.font = UIFont.boldSystemFontOfSize(17)
            label.numberOfLines = 1;
            label.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            label.adjustsFontSizeToFitWidth = true
            navBarTitleView.addSubview(label)
            
            let sublabel = UILabel(frame: CGRectMake(0, 0, self.navigationController!.navigationBar.frame.size.width, 20))
            sublabel.center = CGPointMake(self.navigationController!.navigationBar.frame.size.width/2, self.navigationController!.navigationBar.frame.size.height/1.3)
            sublabel.textAlignment = NSTextAlignment.Center
            sublabel.text = sublabeltext
            sublabel.font = sublabel.font.fontWithSize(14)
            sublabel.textColor = UIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1)
            sublabel.numberOfLines = 1;
            sublabel.adjustsFontSizeToFitWidth = true
            sublabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            navBarTitleView.addSubview(sublabel)
            
            navBarTitleView.backgroundColor = UIColor.clearColor()
            
            self.navigationItem.titleView = navBarTitleView
        }
        if !doublelabel{
            self.navigationItem.title = labeltext
        }
    }
    
    func initautohidetabbarandnavcontroller(){
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        if let tabBar = navigationController?.tabBarController?.tabBar {
            hidingNavBarManager?.manageBottomBar(tabBar)
        }
        self.tableView.frame = self.view.bounds
        self.tableView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleHeight, .FlexibleWidth, .FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleRightMargin]
    }
    
    func custombg(){
        self.tableView.backgroundColor = UIColor.clearColor()
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.view.frame.size
        gradient.colors = [UIColor(red: 0 / 255.0, green: 57 / 255.0, blue: 115 / 255.0, alpha: 1).CGColor, UIColor(red: 229 / 255.0, green: 229 / 255.0, blue: 190 / 255.0, alpha: 1).CGColor]
        gradient.zPosition = -1
        self.view.layer.addSublayer(gradient)
    }
    
    func nocashe(text: String)->String{
        if let nocashe = defaults.objectForKey("nocashe"){
            if nocashe as! Bool{
                return "\(text)&debag_mode=on"
            }else if !(nocashe as! Bool){
                return text
            }else{
                return text
            }
        }else{
            return text
        }
    }
}
