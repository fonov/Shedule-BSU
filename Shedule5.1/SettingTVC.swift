//
//  SettingTVC.swift
//  Shedule5.1
//
//  Created by kotmodell on 09.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class SettingTVC: UITableViewController, MFMailComposeViewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    var settingcell = [[], [["settingrow", ["О приложении"], "segueaboutpageview"], ["settingrow", ["Web Расписание"], "openweb"], ["settingrow", ["Помощь в улучшении приложения"], "sendmail"]]]
    
    let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.shedule")!
    let nc = NSNotificationCenter.defaultCenter()
    
    var list = [SKProduct]()
    var p = SKProduct()

    override func viewDidLoad() {
        super.viewDidLoad()
        deletecooke()
        initads()
        setsegmenttonavigationbar()
        nc.addObserver(self, selector: #selector(SettingTVC.shedulesettingsoursereload), name: "funcshedulesettingsoursereload", object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.instructionaboutswitch), name: "funcinstructionaboutswitch", object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.instructionaboutautoscroll), name: "funcinstructionaboutautoscroll", object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.instructionaboutLocalNotification), name: "funcinstructionaboutLocalNotification", object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.instructionaboutnotLocalNotification), name: "funcinstructionaboutnotLocalNotification", object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.alertads), name: "funcalertads", object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.alertinfoaboutlimits), name: "funcalertinfoaboutlimits", object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.aboutcashe), name: "funcaboutcashe", object: nil)
      }
    
    override func viewWillAppear(animated: Bool) {
        checkinappstore()
        shedulesettingsoursereload()
        checkallowlocalnotification()
        shedulerootviewcontroller("Настройки")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return settingcell.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settingcell[section].count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("settingrow", forIndexPath: indexPath)
        
        var cell: UITableViewCell!
        
        if settingcell[indexPath.section][indexPath.row][0] as! String == "settingrow"{
            
            cell = tableView.dequeueReusableCellWithIdentifier(settingcell[indexPath.section][indexPath.row][0] as! String, forIndexPath: indexPath)
            
            if settingcell[indexPath.section][indexPath.row][1].count == 1{
                cell.textLabel?.text = String((((settingcell[indexPath.section] as NSArray)[indexPath.row] as! NSArray)[1] as! NSArray)[0])
                cell.accessoryType = .DisclosureIndicator
            }else{
                cell.textLabel?.text = String((((settingcell[indexPath.section] as NSArray)[indexPath.row] as! NSArray)[1] as! NSArray)[0])
                cell.detailTextLabel?.text = String((((settingcell[indexPath.section] as NSArray)[indexPath.row] as! NSArray)[1] as! NSArray)[1])
                cell.accessoryType = .DisclosureIndicator
            }
            
        }
        
        if settingcell[indexPath.section][indexPath.row][0] as! String == "settingsourse"{
            
            cell = tableView.dequeueReusableCellWithIdentifier(settingcell[indexPath.section][indexPath.row][0] as! String, forIndexPath: indexPath)
            cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)
        }
        
        if settingcell[indexPath.section][indexPath.row][0] as! String == "settingautoscroll" || settingcell[indexPath.section][indexPath.row][0] as! String == "settingswipetable" || settingcell[indexPath.section][indexPath.row][0] as! String == "settingnoads" || settingcell[indexPath.section][indexPath.row][0] as! String == "settingnocashe"{
            
            cell = tableView.dequeueReusableCellWithIdentifier(self.settingcell[indexPath.section][indexPath.row][0] as! String, forIndexPath: indexPath)
        }
        
        if settingcell[indexPath.section][indexPath.row][0] as! String == "settinglocalnotification"{
            
           let celll = tableView.dequeueReusableCellWithIdentifier(self.settingcell[indexPath.section][indexPath.row][0] as! String, forIndexPath: indexPath) as! SettingLocalNotification
            
            if let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
            {
                if settings.types.contains([.Alert, .Badge])
                {}
                else
                {
                    if let flag = defaults.objectForKey("SheduleSettingLocalNotification"){
                        if flag as! Bool{
                            defaults.setObject(false, forKey: "SheduleSettingLocalNotification")
                            defaults.synchronize()
                        }
                    }
                }
                
            }
            
            celll.label.text = "Уведомление о начале пары"
            if let flag = defaults.objectForKey("SheduleSettingLocalNotification"){
                celll.sswipe.on = flag as! Bool
            }else{
                celll.sswipe.on = false
            }
            return celll
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if settingcell[indexPath.section][indexPath.row].count == 3{
            if settingcell[indexPath.section][indexPath.row][2] as! String == "openweb"{
            safariopenwebshedule()
            }else if settingcell[indexPath.section][indexPath.row][2] as! String == "sendmail"{
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            }else{
                performSegueWithIdentifier(settingcell[indexPath.section][indexPath.row][2] as! String, sender: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func shedulerootviewcontroller(text: String){
        self.tabBarController?.tabBar.hidden = false
        self.navigationItem.title = text
    }
    
    func setsegmenttonavigationbar(){
        let segmentTitles = [
            "Группа",
            "Преподаватель",
            ]
        let segmentedControl = UISegmentedControl(items: segmentTitles)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        // change the width from 400.0 to something you want if it's needed
        segmentedControl.frame = CGRectMake(0, 0, view.frame.width, 30.0)
        segmentedControl.addTarget(self, action: #selector(SettingTVC.segmentedControlValueChanged), forControlEvents:.ValueChanged)
        self.navigationItem.titleView = segmentedControl
        
        if let data = defaults.objectForKey("SheduleSettingSourseShedule"){
            segmentedControl.selectedSegmentIndex = data as! Int
        }else{
            segmentedControl.selectedSegmentIndex = 0
            defaults.setObject(segmentedControl.selectedSegmentIndex, forKey: "SheduleSettingSourseShedule")
            defaults.synchronize()
        }
    }
    
    func segmentedControlValueChanged(segment: UISegmentedControl) {
        defaults.setObject(segment.selectedSegmentIndex, forKey: "SheduleSettingSourseShedule")
        defaults.setObject(true, forKey: "SheduleSettingupdate")
        defaults.synchronize()
        shedulesettingsoursereload()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let backItem = UIBarButtonItem()
    backItem.title = "Назад"
    navigationItem.backBarButtonItem = backItem
    self.tabBarController?.tabBar.hidden = true
    }

    func shedulesettingsoursereload(){
    shedulesettingsoursereloadinit()
    shedulesettingweek()
    tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0), NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .None)
    }
    
    func shedulesettingsoursereloadinit(){
        if let data = defaults.objectForKey("SheduleSettingSourseShedule"){
            switch data as! Int{
            case 0:
                if let data1 = defaults.objectForKey("SheduleSettingSourseGroupID"){
                 settingcell[0][1] = ["settingrow", ["Группа", data1], "segueshedulesettingsoursegroup"]
                }else{
                 settingcell[0][1] = ["settingrow", ["Группа", "не выбрана"], "segueshedulesettingsoursegroup"]
                }
                break
            case 1:
                if let data2 = defaults.objectForKey("SheduleSettingSourseTeachID"){
                 settingcell[0][1] = ["settingrow", ["Преподаватель", data2[1]], "shedulesettingsourseteach"]
                }else{
                  settingcell[0][1] = ["settingrow", ["Преподаватель", "не выбран"], "shedulesettingsourseteach"]
                }
                break
            default:
                settingcell[0][1] = ["settingrow", ["Группа", "не выбрана"], "segueshedulesettingsoursegroup"]
                break
            }
        }else{
            settingcell[0][1] = ["settingrow", ["Группа", "не выбрана"], "segueshedulesettingsoursegroup"]
        }
    }
    
    func shedulesettingweek(){
        if let data = defaults.objectForKey("SheduleSettingtime"){
            switch data as! Int{
            case 0:
                settingcell[0][0] = ["settingrow", ["Время расписания", "прошлая неделя"], "seguesheduletime"]
                break
            case 1:
                settingcell[0][0] = ["settingrow", ["Время расписания", "текущая неделя"], "seguesheduletime"]
                break
            case 2:
                settingcell[0][0] = ["settingrow", ["Время расписания", "следующая неделя"], "seguesheduletime"]
                break
            case 3:
                if defaults.objectForKey("SheduleSettingCustomdatefist") != nil && defaults.objectForKey("SheduleSettingCustomdatelast") != nil{
                 let fistdate = defaults.objectForKey("SheduleSettingCustomdatefist") as! NSArray
                 let lastdate = defaults.objectForKey("SheduleSettingCustomdatelast") as! NSArray
                 settingcell[0][0] = ["settingrow", ["Время расписания", "\(String(fistdate[1]))-\(String(lastdate[1]))"], "seguesheduletime"]
                }else{
                 settingcell[0][0] = ["settingrow", ["Время расписания", "не задана дата"], "seguesheduletime"]
                }
                break
            default:
                settingcell[0][0] = ["settingrow", ["Время расписания", "не выбрано"], "seguesheduletime"]
                break
            }
        }else{
            settingcell[0][0] = ["settingrow", ["Время расписания", "не выбрано"], "seguesheduletime"]
        }
    }
    
    func safariopenwebshedule(){
        UIApplication.sharedApplication().openURL(NSURL(string: "http://lab.lionrepair.ru/uapp/demo")!)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["ask@mounlion.com"])
        mailComposerVC.setSubject("Помощь в улучшение приложения \"Расписание БелГУ\"")
        mailComposerVC.setMessageBody("<h1 style=\"border-bottom: 2px solid black;text-align: center;\">\"Расписание БелГУ\"</h1><small>Не удаляйте эту информацию (\(UIDevice.currentDevice().modelName); \(UIDevice.currentDevice().systemVersion))</small>", isHTML: true)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
//        smartalert("Расписание \"БелГУ\"", message: "Не возможно открыть почтовый клиент. Оставить отзыв в App Store?", ok: "В App Store", cancel: "Отмена")
//        
        let alertview = JSSAlertView().danger(
            self,
            title: "Расписание \"БелГУ\"",
            text: "Не возможно открыть почтовый клиент. Оставить отзыв в App Store?",
            buttonText: "Написать",
            cancelButtonText: "Скрыть"
        )
        
        alertview.addAction(self.openappstore)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func smartalert(title: String, message: String, ok: String, cancel: String){
    }
    
    func openappstore(){
        UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/ru/app/raspisanie-belgu/id1080402611")!)
    }
    
    func instructionaboutswitch(){
        let alertview = JSSAlertView().show(
            self,
            title: "Быстрое переключение недель",
            text: "Смахивайте расписание влево или вправо для переключение недель",
            buttonText: "Скрыть подсказку",
            iconImage: UIImage(named: "technology"),
            color: UIColorFromHex(0x3498db, alpha: 1)
        )
        alertview.setTextTheme(.Light)
    }
    
    func instructionaboutautoscroll(){
        let alertview = JSSAlertView().show(
            self,
            title: "Автоматическая прокрутка расписания",
            text: "Мы будем автоматически прокручивать расписание до текущего дня",
            buttonText: "Скрыть подсказку",
            iconImage: UIImage(named: "technology"),
            color: UIColorFromHex(0x3498db, alpha: 1)
        )
        alertview.setTextTheme(.Light)
    }
    
    func instructionaboutLocalNotification(){
        let alertview = JSSAlertView().show(
            self,
            title: "Уведомление о начале пары",
            text: "За 5 минут до начала пары мы будем уведомлять вас об этом",
            buttonText: "Скрыть подсказку",
            iconImage: UIImage(named: "technology"),
            color: UIColorFromHex(0x3498db, alpha: 1)
        )
        alertview.setTextTheme(.Light)
    }
    
    func instructionaboutnotLocalNotification(){
        JSSAlertView().danger(
            self,
            title: "Уведомление о начале пары",
            text: "Для того чтобы показывать уведомления их надо активировать в настройках",
            buttonText: "Скрыть подсказку"
        )
    }
    
    func alertinfoaboutlimits(notification: NSNotification){
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        SweetAlert().showAlert("Опс...", subTitle: "Для включения этой функции \"\(userInfo["title"]!)\" сначала нужно отключить ограничения", style: AlertStyle.Warning, buttonTitle:"Скрыть")
    }
    
    func checkallowlocalnotification(){
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 4, inSection: 0)], withRowAnimation: .None)
    }
    
    
    func initads(){
//        limitation().onlimitation
        if limitation().check{
            settingcell[0] = [["settingrow", ["Время расписания", "текущая неделя"], "seguesheduletime"], ["settingrow", ["Группа", "07001501"], "segueshedulesettingsoursegroup"], ["settingautoscroll"], ["settingswipetable"], ["settinglocalnotification"], ["settingnocashe"]]
        }else{
            settingcell[0] = [["settingrow", ["Время расписания", "текущая неделя"], "seguesheduletime"], ["settingrow", ["Группа", "07001501"], "segueshedulesettingsoursegroup"], ["settingautoscroll"], ["settingswipetable"], ["settinglocalnotification"], ["settingnocashe"], ["settingnoads"]]
        }
    }
    
    func alertads(){
        //Создадим Alert контроллер
        let alertController = UIAlertController(title: "Отключение ограничений", message: nil, preferredStyle: .Alert)
        
        let noadsAction = UIAlertAction(title: "Отключить ограничения", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            print("Отключить рекламу")
            self.buyinappstore()
        }
        let restoreadsAction = UIAlertAction(title: "Восстановить покупки", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            print("Восстановить покупки")
            self.restoreinappstore()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            print("Отмена")
            self.switchnoads()
        }
        
//        let devAction = UIAlertAction(title: "Режим разработчика", style: UIAlertActionStyle.Default) {
//            UIAlertAction in
//            print("Режим разработчика")
//            self.developermode()
//        }
        
        // Добавление кнопок
        alertController.addAction(noadsAction)
        alertController.addAction(restoreadsAction)
//        alertController.addAction(devAction)
        alertController.addAction(cancelAction)
        
        // Вывод Alert контроллера
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func removeads(){
        if !limitation().check{
        limitation().offlimitation
        let indexpath: NSIndexPath = NSIndexPath(forRow: settingcell[0].count-1, inSection: 0)
        settingcell[0].removeAtIndex(indexpath.row)
        tableView.deleteRowsAtIndexPaths([indexpath], withRowAnimation: .Fade)
        print("Delete ads")
        }
    }
    
    func checkinappstore(){
        // Set IAPS
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID:NSSet = NSSet(objects: "com.mounlion.sgedule.offlimit")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            list.append(product)
        }
        nc.postNotificationName("funcswitchenable", object: nil)
    }
    
    func buyinappstore(){
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "com.mounlion.sgedule.offlimit") {
                p = product
                buyProduct()
                break;
            }
        }
    }
    
    func restoreinappstore(){
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    func buyProduct() {
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("transactions restored")
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            switch prodID {
            case "com.mounlion.sgedule.offlimit":
                print("remove ads")
                removeads()
            default:
                print("IAP not setup")
            }
            
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        print("failed restore");
        switchnoads()
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add paymnet")
        
        for transaction:AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
                
            case .Purchased:
                print("buy, ok unlock iap here")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID {
                case "com.mounlion.sgedule.offlimit":
                    print("remove ads")
                    removeads()
                default:
                    print("IAP not setup")
                }
                queue.finishTransaction(trans)
                break;
            case .Failed:
                print("buy error")
                queue.finishTransaction(trans)
                break;
            default:
                print("default")
                break;
                
            }
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction)
    {
        print("finish trans")
        SKPaymentQueue.defaultQueue().finishTransaction(trans)
    }
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction])
    {
        print("remove trans");
        switchnoads()
    }
    
    func switchnoads(){
        NSNotificationCenter.defaultCenter().postNotificationName("funcnoads", object: nil)
    }
    
    func deletecooke(){
        if defaults.objectForKey("deletecooke") == nil{
            defaults.removeObjectForKey("SheduleSettingAutoScroll")
            defaults.removeObjectForKey("SheduleSettingSwipeTable")
            defaults.removeObjectForKey("SheduleSettingLocalNotification")
            defaults.setObject(true, forKey: "deletecooke")
            defaults.synchronize()
            print("delete cooke")
        }
    }
    
    func developermode(){
        removeads()
    }
    
    func aboutcashe(){
        SweetAlert().showAlert("Загрузка кэшированных данных", subTitle: "Для повышения отказа устойчивости и быстроты загрузки данных мы используем кэширование данных. В некоторых случаях расписание может не совпадать с официальной версией расписания.", style: AlertStyle.None, buttonTitle: "Скрыть")
    }

}
