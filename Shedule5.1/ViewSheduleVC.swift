//
//  ViewSheduleVC.swift
//  Shedule5.1
//
//  Created by kotmodell on 15.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ViewSheduleVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // REMOVE DEBAG LINE!!!!!!!   +
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoimg: UIImageView!
    @IBOutlet weak var infolabel: UILabel!
    @IBOutlet weak var loadind: UIActivityIndicatorView!
    @IBOutlet weak var loadlabel: UILabel!
    
    var hidingNavBarManager: HidingNavigationBarManager?
    let nc = NotificationCenter.default
    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
    var SFjson: NSDictionary!
    var tableupdata: Bool = false
    var refreshControl:UIRefreshControl!
    var tablealert: Bool = false
    var tablealerttext: String = ""
    var upflag: Bool = false
    var openview: Bool = false
    var chromtimer: Timer!
    var flagads: Bool!
    var counads: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initautohidetabbarandnavcontroller()
        refreshinit()
        initswipetableview()
        nc.addObserver(self, selector: #selector(ViewSheduleVC.updateactualsection), name: NSNotification.Name(rawValue: "funcupdateactualsection"), object: nil)
        nc.addObserver(self, selector: #selector(ViewSheduleVC.chromtimerstart), name: NSNotification.Name(rawValue: "funcchromtimerstart"), object: nil)
        nc.addObserver(self, selector: #selector(ViewSheduleVC.chromtimerstop), name: NSNotification.Name(rawValue: "funcchromtimerstop"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hidingNavBarManager?.viewWillAppear(animated)
        inittimerstart()
        sheduleviewsheduleinit(false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        hidingNavBarManager?.viewWillDisappear(animated)
        inittimerfinish()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hidingNavBarManager?.viewDidLayoutSubviews()
    }

    
    func sheduleviewsheduleinit(_ eswipe: Bool){
        // reset all setting
        tableViewinit()
        // update title
        sheduleviewtitleinit()
        
        if let update = defaults.object(forKey: "SheduleSettingupdate"){
            
            if defaults.object(forKey: "SheduleSettingSourseShedule") == nil{
                infopanel("Для отображения расписания его нужно настроить. Установите тип расписания.", img: "shedule", hide: false)
                return
            }
            if defaults.object(forKey: "SheduleSettingtime") == nil{
                infopanel("Для отображения расписания его нужно настроить. Установите время расписания.", img: "shedule", hide: false)
                return
            }
            if defaults.object(forKey: "SheduleSettingtime") as! Int == 3 && (defaults.object(forKey: "SheduleSettingCustomdatefist") == nil || defaults.object(forKey: "SheduleSettingCustomdatelast") == nil){
                infopanel("Для отображения расписания его нужно настроить. Установите своё время расписания.", img: "shedule", hide: false)
                return
            }
            if defaults.object(forKey: "SheduleSettingSourseShedule") as! Int == 0 && defaults.object(forKey: "SheduleSettingSourseGroupID") == nil{
                infopanel("Для отображения расписания его нужно настроить. Установите номер группы.", img: "shedule", hide: false)
                return
            }
            if defaults.object(forKey: "SheduleSettingSourseShedule") as! Int == 1 && defaults.object(forKey: "SheduleSettingSourseTeachID") == nil{
                infopanel("Для отображения расписания его нужно настроить. Выберите преподавателя.", img: "shedule", hide: false)
                return
            }
            
            infopanel("", img: "shedule", hide: true)
            
            if (update as! Bool)||(!checkactualweek()){
                // on load indicator
                self.loadindicator(false, hide: false)
                let priority = DispatchQueue.GlobalQueuePriority.default
                DispatchQueue.global(priority: priority).async {
                
                    var stingpost: String!
                    if self.defaults.object(forKey: "SheduleSettingSourseShedule") as! Int == 0{
                        stingpost = "group=\(self.defaults.object(forKey: "SheduleSettingSourseGroupID") as! String)"
                    }
                    if self.defaults.object(forKey: "SheduleSettingSourseShedule") as! Int == 1{
                         let teachid: [String] = self.defaults.object(forKey: "SheduleSettingSourseTeachID") as! Array<String>
                        stingpost = "teach=\(teachid[0])"
                    }
                    if self.defaults.object(forKey: "SheduleSettingtime") as! Int == 0 || self.defaults.object(forKey: "SheduleSettingtime") as! Int == 1 ||  self.defaults.object(forKey: "SheduleSettingtime") as! Int == 2 {
                        var week: Int = self.defaults.object(forKey: "SheduleSettingtime") as! Int
                        week = week+1
                        stingpost = stingpost+"&week=\(week)"
                    }
                    if self.defaults.object(forKey: "SheduleSettingtime") as! Int == 3{
                        let fistdate: [String] = self.defaults.object(forKey: "SheduleSettingCustomdatefist") as! [String]
                        let lastdate: [String] = self.defaults.object(forKey: "SheduleSettingCustomdatelast") as! [String]
                        stingpost = stingpost+"&week=\(fistdate[0])\(lastdate[0])"
                    }
                    print(stingpost)
                    
                    stingpost = stingpost+"&model=\(UIDevice.current.modelName)&version=\(UIDevice.current.systemVersion)"
//                    stingpost = stingpost+"&debag_mode=on"
                    stingpost = self.nocashe(stingpost)
                    
                    
                    print(stingpost)
                    
                
                    let SFCpostjson = SFpostjson(in_post: stingpost, in_url: "http://lab.lionrepair.ru/uapp/api.php")
                    self.SFjson = SFCpostjson.json
                    
                    DispatchQueue.main.async {
                    
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
                let priority = DispatchQueue.GlobalQueuePriority.default
                DispatchQueue.global(priority: priority).async {
                    self.SFjson = self.sheduledatainit()
                    DispatchQueue.main.async {
                        self.tableViewShow()
                        self.autoscrolltable()
                    }
                }
            }
        }else{
            infopanel("Для отображения расписания его нужно настроить. Перейдите на вкладку настройки.", img: "shedule", hide: false)
        }
    }
    
    func infopanel(_ label: String, img: String, hide: Bool){
        infoimg.image = UIImage(named: img)
        infolabel.text = label
        infolabel.textColor = UIColor.black
        infoimg.isHidden = hide
        infolabel.isHidden = hide
        loadind.stopAnimating()
        loadlabel.isHidden = true
    }
    
    func jsoncode00(_ eswith: Bool){
        if eswith{
            self.tableView.alpha = 1
        }
        self.loadindicator(true, hide: false)
        let text = "Неизвестная ошибка."
        infopanel(text, img: "cross31", hide: true)
        tableViewalert(text)
        newindicatorreload(text)
    }
    
    func jsoncode01(_ eswith: Bool){
        if eswith{
            self.tableView.alpha = 1
        }
        let text = "Oтсутствует подключение к интернету"
        self.loadindicator(true, hide: false)
        infopanel(text, img: "cross31", hide: true)
        tableViewalert(text)
        newindicatorreload(text)
    }
    
    func jsoncode02(_ eswith: Bool){
        if eswith{
            self.tableView.alpha = 1
        }
        self.loadindicator(true, hide: false)
        let text = "Невозможно загрузить данные"
        infopanel("Невозможно загрузить данные", img: "cross31", hide: true)
        tableViewalert(text)
        newindicatorreload(text)
    }
    
    func jsoncode03(_ eswith: Bool){
        let priority = DispatchQueue.GlobalQueuePriority.default
        DispatchQueue.global(priority: priority).async {
            self.mainshedulesave()
            self.setactualweek()
            //  set notification
            self.localnotification()
            DispatchQueue.main.async {
                self.loadindicator(true, hide: true)
                self.infopanel("", img: "cross31", hide: true)
                self.tableViewShow()
                self.mainfeedbackappstore()
                self.autoscrolltable()
                if eswith{
                    UIView.animate(withDuration: 1.0, animations: {
                        self.tableView.alpha = 1
                        }, completion: { _ in
                    })
                }
            }
        }
    }

    func jsoncode04(_ eswith: Bool){
        if eswith{
            self.tableView.alpha = 1
        }
        self.loadindicator(true, hide: true)
        let text = String((self.SFjson["data"] as! NSDictionary)["info"] as! String)
        infopanel(text!, img: "cross31", hide: false)
        tableViewhide()
    }
    
    func jsoncode05(_ eswith: Bool){
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
        return defaults.object(forKey: "sheduledata") as! NSDictionary
    }
    
    func sheduleviewtitleinit(){
        var text: String!
        var subtext: String!
        var doublelabel: Bool!
        text = "Расписание"
        subtext = ""
        doublelabel = false
        
        if self.defaults.object(forKey: "SheduleSettingSourseShedule") != nil && self.defaults.object(forKey: "SheduleSettingSourseGroupID") != nil && self.defaults.object(forKey: "SheduleSettingSourseShedule") as! Int == 0{
            text = "Группа \(self.defaults.object(forKey: "SheduleSettingSourseGroupID") as! String)"
        }
        if self.defaults.object(forKey: "SheduleSettingSourseShedule") != nil && self.defaults.object(forKey: "SheduleSettingSourseTeachID") != nil && self.defaults.object(forKey: "SheduleSettingSourseShedule") as! Int == 1{
            let teachid: [String] = self.defaults.object(forKey: "SheduleSettingSourseTeachID") as! Array<String>
            text = teachid[1]
        }
        
        if self.defaults.object(forKey: "SheduleSettingtime") != nil{
            switch self.defaults.object(forKey: "SheduleSettingtime") as! Int{
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
                if self.defaults.object(forKey: "SheduleSettingCustomdatefist") != nil && self.defaults.object(forKey: "SheduleSettingCustomdatelast") != nil{
                    let fistdate: [String] = self.defaults.object(forKey: "SheduleSettingCustomdatefist") as! [String]
                    let lastdate: [String] = self.defaults.object(forKey: "SheduleSettingCustomdatelast") as! [String]
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
    
    
    func addTitleAndSubtitleToNavigationBar (_ title: String, subtitle: String, num: Int) {
        let label = UILabel(frame: CGRect(x: 10.0, y: 0.0, width: 50.0, height: 40.0))
        if num == 1{
            label.font = UIFont.boldSystemFont(ofSize: 18.0)
        }else{
            label.font = UIFont.boldSystemFont(ofSize: 15.0)
        }
        label.numberOfLines = num
        label.text = "\(title)\n\(subtitle)"
//        label.textColor = UIColor.whiteColor()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.center
        self.navigationItem.titleView = label
    }

    func loadindicator(_ flag: Bool, hide: Bool){
        if flag && hide{
            SwiftSpinner.hide()
        }else{
            SwiftSpinner.show("Загрузка расписания...")
        }
        infoimg.isHidden = true
        infolabel.isHidden = true
    }
    func tableViewinit(){
        upflag = false
        tableView.separatorStyle = .none
        tableView.isHidden = true
        tableupdata = false
        tablealert = false
        flagads = false
    }
    
    func tableViewShow(){
        tableView.isHidden = false
        tableupdata = true
        tablealert = false
        tableView.reloadData()
    }
    func tableViewhide(){
        tableView.isHidden = true
        tableupdata = false
        tablealert = false
        tableView.reloadData()
    }
    
    func tableViewalert(_ text: String){
        let priority = DispatchQueue.GlobalQueuePriority.default
        DispatchQueue.global(priority: priority).async {
            // do some task
            DispatchQueue.main.async {
                self.tablealerttext = text
                self.tableupdata = false
                self.tablealert = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections: Int
        if (SFjson != nil){
            numberOfSections = ((SFjson["data"] as! [String:AnyObject])["data"]?.count)!
        } else {
            numberOfSections = 1
        }
        if tableupdata{
            return numberOfSections
        }
        else if tablealert{
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableupdata{
        
            let date: [[Any]] = ((SFjson["data"] as? [String:Any])!["data"] as? [[Any]])!
            var num: Int = (date[section][1] as AnyObject).count
            
        num = num+1
        return num
        }
        else if tablealert{
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableupdata{
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tschead", for: indexPath) as! tschead
            cell.tlabel.text = ftschead(String(describing: (((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[0]))
            cell.selectionStyle = .none
            return cell
        }else{
                let crow = indexPath.row - 1
                let cell = tableView.dequeueReusableCell(withIdentifier: "tscbody", for: indexPath) as! tscbody
                cell.ltimesh.text = ftshbodytime(String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[1]), num: 0)[0]
                cell.ltimesi.text = ftshbodytime(String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[1]), num: 0)[1]
                cell.lnumber.text = String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[0])
                cell.ltimefh.text = ftshbodytime(String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[1]), num: 1)[0]
                cell.ltimefi.text = ftshbodytime(String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[1]), num: 1)[1]
                cell.vsheduleindicator.backgroundColor = ftcbodyindcolor(String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[2]))
                cell.lsubsubject.text = String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[2])
                cell.lsabject.text = String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[3])
                if self.defaults.object(forKey: "SheduleSettingSourseShedule") as! Int == 0{
                    cell.lsubteacher.text = String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[4])
                }
                if self.defaults.object(forKey: "SheduleSettingSourseShedule") as! Int == 1{
                    cell.lsubteacher.text = "группа"
                }
                cell.lteacher.text = String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[5-(self.defaults.object(forKey: "SheduleSettingSourseShedule") as! Int)])
                cell.laud.text = ftcbodyaud(String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[6-(self.defaults.object(forKey: "SheduleSettingSourseShedule") as! Int)]))[0] as? String
                if !(ftcbodyaud(String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[6-(self.defaults.object(forKey: "SheduleSettingSourseShedule") as! Int)]))[1] as! Bool){
                    cell.laud.textColor = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1)
                }else{
                    cell.laud.textColor = UIColor.black
                }
                cell.selectionStyle = .none
                return cell
            }
            }else if tablealert{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tscalert", for: indexPath) as! tscalert
            cell.label.text = tablealerttext
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = UITableViewCell()
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if (cell.responds(to: #selector(getter: UIView.tintColor))){
            if (tableView == self.tableView) {
                let cornerRadius : CGFloat = 6.0
                cell.backgroundColor = UIColor.clear
                let layer: CAShapeLayer = CAShapeLayer()
                let pathRef:CGMutablePath = CGMutablePath()
                let bounds: CGRect = cell.bounds.insetBy(dx: 15.0, dy: 0)
                var addLine: Bool = false
                
                if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
                    pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
                } else if (indexPath.row == 0) {
                      pathRef.move(to: CGPoint(x:bounds.minX, y: bounds.maxY))
                      pathRef.addArc(tangent1End: CGPoint(x:bounds.minX, y:bounds.minY), tangent2End: CGPoint(x:bounds.midX, y:bounds.minY), radius: cornerRadius)
                      pathRef.addArc(tangent1End: CGPoint(x:bounds.maxX, y:bounds.minY), tangent2End: CGPoint(x:bounds.maxX, y:bounds.midY), radius: cornerRadius)
                      pathRef.addLine(to: CGPoint(x:bounds.maxX, y: bounds.maxY))
//                    CGPathMoveToPoint(pathRef, nil, bounds.minX, bounds.maxY)
//                    CGPathAddArcToPoint(pathRef, nil, bounds.minX, bounds.minY, bounds.midX, bounds.minY, cornerRadius)
//                    CGPathAddArcToPoint(pathRef, nil, bounds.maxX, bounds.minY, bounds.maxX, bounds.midY, cornerRadius)
//                    CGPathAddLineToPoint(pathRef, nil, bounds.maxX, bounds.maxY)
                    addLine = true
                } else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
                    
                    pathRef.move(to: CGPoint(x:bounds.minX, y: bounds.minY))
                    pathRef.addArc(tangent1End: CGPoint(x:bounds.minX, y:bounds.maxY), tangent2End: CGPoint(x:bounds.midX, y:bounds.maxY), radius: cornerRadius)
                    pathRef.addArc(tangent1End: CGPoint(x:bounds.maxX, y:bounds.maxY), tangent2End: CGPoint(x:bounds.maxX, y:bounds.midY), radius: cornerRadius)
                    pathRef.addLine(to: CGPoint(x:bounds.maxX, y: bounds.minY))
                    
//                    CGPathMoveToPoint(pathRef, nil, bounds.minX, bounds.minY)
//                    CGPathAddArcToPoint(pathRef, nil, bounds.minX, bounds.maxY, bounds.midX, bounds.maxY, cornerRadius)
//                    CGPathAddArcToPoint(pathRef, nil, bounds.maxX, bounds.maxY, bounds.maxX, bounds.midY, cornerRadius)
//                    CGPathAddLineToPoint(pathRef, nil, bounds.maxX, bounds.minY)
                } else {
                      pathRef.addRect(bounds)
//                    CGPathAddRect(pathRef, nil, bounds)
                    addLine = true
                }
                layer.path = pathRef
                
                if tableupdata{
                if indexPath.row == 0{
                    if checkdata(String(describing: (((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[0])){
                        layer.fillColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1.0).cgColor
                        upflag = true
                    }else{
                        layer.fillColor = UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1.0).cgColor
                    }
                }else{
                    let crow = indexPath.row - 1
                    if checkdataless(String(describing: (((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[0]), less: String(describing: (((((SFjson["data"] as! NSDictionary)["data"] as! NSArray)[indexPath.section] as! NSArray)[1] as! NSArray)[crow] as! NSArray)[0])){
                        layer.fillColor = UIColor(red: 255/255, green: 250/255, blue: 205/255, alpha: 0.9).cgColor
                    }else{
                        layer.fillColor = UIColor.white.cgColor
                    }
                }
                }else if tablealert{
                    layer.fillColor = UIColor.white.cgColor
                }else{
                    layer.fillColor = UIColor.white.cgColor
                }
                
                if addLine {
                    let lineLayer: CALayer = CALayer()
                    let lineHeight: CGFloat = (1.0 / UIScreen.main.scale)
                    lineLayer.frame = CGRect(x: bounds.minX, y: bounds.size.height-lineHeight, width: bounds.size.width, height: lineHeight)
                    lineLayer.backgroundColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1).cgColor
                    layer.addSublayer(lineLayer)
                }
                
                let testView: UIView = UIView(frame: bounds)
                testView.layer.insertSublayer(layer, at: 0)
                testView.backgroundColor = UIColor.clear
                cell.backgroundView = testView
            }
        }
    }

    func ftschead(_ date: String)->String{
        let cdate = date.components(separatedBy: " ")
        var cdatestr: String!
        if cdate.count == 2{
          cdatestr = "\(cdate[1]), \(cdate[0])"
        }
        else{
          cdatestr = date
        }
        return cdatestr
    }
    
    func ftshbodytime(_ date: String, num: Int)->[String]{
        let cdate = date.components(separatedBy: "-")
        if cdate.count == 2{
            let ccdate = cdate[num].components(separatedBy: ":")
            if ccdate.count == 2{
            return ccdate
            }else{
            return ["", ""]
            }
        }else{
            return ["", ""]
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
    func ftcbodyaud(_ aud: String)->NSArray{
        var ad: String = aud
        if aud == "ауд. ,"{
        ad = "аудитория не указана"
        return [ad, false]
        }else{
        return [ad, true]
        }
    }
    func ftcbodygroup(_ group: String)->String{
        var str: [String]!
        str = group.components(separatedBy: " ")
        if str.count == 2{
            return str[1]
        }else{
            return ""
        }
    }
    func refreshinit(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = UIColor.orange
        refreshControl.addTarget(self, action: #selector(ViewSheduleVC.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    func refresh(_ sender:AnyObject) {
        refreshBegin("Refresh",
            refreshEnd: {(x:Int) -> () in
                self.sheduleviewsheduleinit(false)
                self.refreshControl.endRefreshing()
        })
    }
    
    func refreshBegin(_ newtext:String, refreshEnd:@escaping (Int) -> ()) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            self.defaults.set(true, forKey: "SheduleSettingupdate")
            self.defaults.synchronize()
            DispatchQueue.main.async {
                refreshEnd(0)
            }
        }
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
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func autoscrolltable(){
        let priority = DispatchQueue.GlobalQueuePriority.default
        DispatchQueue.global(priority: priority).async {
            DispatchQueue.main.async {
                if let flag = self.defaults.object(forKey: "SheduleSettingAutoScroll"){
                    if flag as! Bool{
                        let shedulearray: NSArray = ((self.SFjson["data"] as! NSDictionary)["data"] as! NSArray)
                        var flagscroll: Bool = false
                        for (index, item) in shedulearray.enumerated(){
                            if self.checkdata(String(describing: (item as! NSArray)[0])){
                                self.tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
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
        if self.defaults.object(forKey: "scopeload") == nil{
            self.defaults.set(0, forKey: "scopeload")
            self.defaults.synchronize()
        }else{
            if self.defaults.object(forKey: "scopeload") as! Int == 10{
                
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
                alertview.setTextTheme(.light)
                alertview.addCancelAction(myCancelCallbackCancel)
                alertview.addAction(myCancelCallback)
                
                
            }
            var scope = self.defaults.object(forKey: "scopeload") as! Int
//            print(scope)
            scope = scope+1
            self.defaults.set(scope, forKey: "scopeload")
            self.defaults.synchronize()
        }
    }
    
    
    func openappstore(){
        UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/ru/app/raspisanie-belgu/id1080402611")!)
    }
    func repiataskfeedback(){
        self.defaults.set(0, forKey: "scopeload")
        self.defaults.synchronize()
    }
    
    func initswipetableview(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewSheduleVC.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewSheduleVC.handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(leftSwipe)
        tableView.addGestureRecognizer(rightSwipe)
    }
    
    func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            print("Swipe Left")
            if defaults.object(forKey: "SheduleSettingSwipeTable") != nil{
            if tableupdata && defaults.object(forKey: "SheduleSettingSwipeTable") as! Bool{
            if self.defaults.object(forKey: "SheduleSettingtime") != nil{
            let priority = DispatchQueue.GlobalQueuePriority.default
            DispatchQueue.global(priority: priority).async {
            var flags: Bool = false
            var num: Int = self.defaults.object(forKey: "SheduleSettingtime") as! Int
            if num == 0 || num == 1{
                num = num+1
                flags = true
                self.defaults.set(num, forKey: "SheduleSettingtime")
                self.defaults.set(true, forKey: "SheduleSettingupdate")
                self.defaults.synchronize()
            }
            DispatchQueue.main.async {
              if flags{
                        self.tableanimation(0)
                }
              }
            }
          }
        }
        }
            
        }
        if (sender.direction == .right) {
            print("Swipe Right")
            if defaults.object(forKey: "SheduleSettingSwipeTable") != nil{
            if tableupdata && defaults.object(forKey: "SheduleSettingSwipeTable") as! Bool{
                if self.defaults.object(forKey: "SheduleSettingtime") != nil{
                    let priority = DispatchQueue.GlobalQueuePriority.default
                    DispatchQueue.global(priority: priority).async {
                        var flags: Bool = false
                        var num: Int = self.defaults.object(forKey: "SheduleSettingtime") as! Int
                        if num == 1 || num == 2{
                            num = num-1
                            flags = true
                            self.defaults.set(num, forKey: "SheduleSettingtime")
                            self.defaults.set(true, forKey: "SheduleSettingupdate")
                            self.defaults.synchronize()
                        }
                        DispatchQueue.main.async {
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
    
    func tableanimation(_ num: CGFloat){
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = num
            }, completion: { _ in
                self.sheduleviewsheduleinit(true)
        })
    }
    
    func mainshedulesave(){
        defaults.set(SFjson, forKey: "sheduledata")
        defaults.set(false, forKey: "SheduleSettingupdate")
        defaults.synchronize()
    }
    
    func setactualweek(){
        self.defaults.set(nowweeksun(), forKey: "Shedule_actualweek")
        self.defaults.synchronize()
    }
    
    
    func checkactualweek()->Bool{
        if let lastweek = self.defaults.object(forKey: "Shedule_actualweek"){
            if (lastweek as! Int == nowweeksun()) || (self.defaults.object(forKey: "SheduleSettingtime") as! Int == 3){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func nowweeksun()->Int{
        var currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "E"
        let strday = dateFormatter.string(from: currentDate)
        var intweek: TimeInterval!
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
        currentDate = Date(timeIntervalSinceNow: intweek*24*60*60)
        dateFormatter.dateFormat = "dMyyyy"
        let nowsun = dateFormatter.string(from: currentDate)
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
        chromtimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ViewSheduleVC.updateactualsectionchron), userInfo: nil, repeats: true)
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
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Hmm"
        dateFormatter.locale = Locale.current
        let convertedDate = dateFormatter.string(from: currentDate)
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
        let priority = DispatchQueue.GlobalQueuePriority.default
        DispatchQueue.global(priority: priority).async {
            DispatchQueue.main.async {
                self.sheduleviewsheduleinit(false)
            }
        }
    }
    
    func shedulereloaddata(){
        let priority = DispatchQueue.GlobalQueuePriority.default
        DispatchQueue.global(priority: priority).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func inittimerstart(){
        openview = true
        chromtimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ViewSheduleVC.updateactualsectionchron), userInfo: nil, repeats: true)
        print("start timer when open view")
    }
    
    func inittimerfinish(){
        openview = false
        chromtimer.invalidate()
        print("stop timer when close view")
    }
    
    func localnotification(){
        if let flag = defaults.object(forKey: "SheduleSettingLocalNotification"){
            if flag as! Bool{
                
        UIApplication.shared.cancelAllLocalNotifications()
                
        let shedulearray: NSArray = ((self.SFjson["data"] as! NSDictionary)["data"] as! NSArray)
        for (_, item) in shedulearray.enumerated(){
            var temp_week: String = (item as! NSArray)[0] as! String
            let cdate = temp_week.components(separatedBy: " ")
            temp_week = cdate[0]
            let shedulelessarray: NSArray = (item as! NSArray)[1] as! NSArray
            var tempnumber: String!
            
            for (_, item_t) in shedulelessarray.enumerated(){
                if tempnumber == nil || tempnumber != String(describing: (item_t as! NSArray)[0]){
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
                    switch self.defaults.object(forKey: "SheduleSettingSourseShedule") as! Int {
                    case 0:
                        auditor = String(describing: (item_t as! NSArray)[6])
                        break
                    case 1:
                        auditor = String(describing: (item_t as! NSArray)[5])
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
                    localNotification.timeZone = TimeZone.current
                    UIApplication.shared.scheduleLocalNotification(localNotification)
//                    print("Установленно уведомление на \(timenotification) с текстом \(titlenotification)")
                    }
                    
                    tempnumber = (item_t as! NSArray)[0] as! String
            }
          }
        }
      }
     }
    }
    
    func notifdate(_ dateString: String)-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy-H-mm"
        return dateFormatter.date(from: dateString)!
    }
    
    func checknotifdate(_ ndate: Date)->Bool{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyHmm"
        dateFormatter.locale = Locale.current
        let nowdata = dateFormatter.string(from: currentDate)
        let notifdate = dateFormatter.string(from: ndate)
        if Int(notifdate) > Int(nowdata) || Int(notifdate) == Int(nowdata){
            return true
        }else{
            return false
        }
    }
    
    func thisday()->String{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale.current
        let convertedDate = dateFormatter.string(from: currentDate)
        return convertedDate
    }
    
    func newindicatorreload(_ text: String){
        SwiftSpinner.show(text, animated:false).addTapHandler({
            self.sheduleviewsheduleinit(false)
        })
    }
    
    func customsheduletitle(_ labeltext: String, sublabeltext: String, doublelabel: Bool){
        if doublelabel{
            let navBarTitleView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.navigationController!.navigationBar.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height))
//            navBarTitleView.clipsToBounds = true
//            navBarTitleView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.navigationController!.navigationBar.frame.size.width, height: 20))
            label.center = CGPoint(x: self.navigationController!.navigationBar.frame.size.width/2, y: self.navigationController!.navigationBar.frame.size.height/3)
            label.textAlignment = NSTextAlignment.center
            label.text = labeltext
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.numberOfLines = 1;
            label.autoresizingMask = UIViewAutoresizing.flexibleWidth
            label.adjustsFontSizeToFitWidth = true
            navBarTitleView.addSubview(label)
            
            let sublabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.navigationController!.navigationBar.frame.size.width, height: 20))
            sublabel.center = CGPoint(x: self.navigationController!.navigationBar.frame.size.width/2, y: self.navigationController!.navigationBar.frame.size.height/1.3)
            sublabel.textAlignment = NSTextAlignment.center
            sublabel.text = sublabeltext
            sublabel.font = sublabel.font.withSize(14)
            sublabel.textColor = UIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1)
            sublabel.numberOfLines = 1;
            sublabel.adjustsFontSizeToFitWidth = true
            sublabel.autoresizingMask = UIViewAutoresizing.flexibleWidth
            navBarTitleView.addSubview(sublabel)
            
            navBarTitleView.backgroundColor = UIColor.clear
            
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
        self.tableView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
    }
    
    func custombg(){
        self.tableView.backgroundColor = UIColor.clear
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.view.frame.size
        gradient.colors = [UIColor(red: 0 / 255.0, green: 57 / 255.0, blue: 115 / 255.0, alpha: 1).cgColor, UIColor(red: 229 / 255.0, green: 229 / 255.0, blue: 190 / 255.0, alpha: 1).cgColor]
        gradient.zPosition = -1
        self.view.layer.addSublayer(gradient)
    }
    
    func nocashe(_ text: String)->String{
        if let nocashe = defaults.object(forKey: "nocashe"){
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
