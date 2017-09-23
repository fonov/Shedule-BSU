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
    
    let defaults: UserDefaults = UserDefaults(suiteName: "group.com.shedule")!
    let nc = NotificationCenter.default
    
    var list = [SKProduct]()
    var p = SKProduct()

    override func viewDidLoad() {
        super.viewDidLoad()
        deletecooke()
        initads()
        setsegmenttonavigationbar()
        nc.addObserver(self, selector: #selector(SettingTVC.shedulesettingsoursereload), name: NSNotification.Name(rawValue: "funcshedulesettingsoursereload"), object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.instructionaboutswitch), name: NSNotification.Name(rawValue: "funcinstructionaboutswitch"), object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.instructionaboutautoscroll), name: NSNotification.Name(rawValue: "funcinstructionaboutautoscroll"), object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.instructionaboutLocalNotification), name: NSNotification.Name(rawValue: "funcinstructionaboutLocalNotification"), object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.instructionaboutnotLocalNotification), name: NSNotification.Name(rawValue: "funcinstructionaboutnotLocalNotification"), object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.alertads), name: NSNotification.Name(rawValue: "funcalertads"), object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.alertinfoaboutlimits), name: NSNotification.Name(rawValue: "funcalertinfoaboutlimits"), object: nil)
        nc.addObserver(self, selector: #selector(SettingTVC.aboutcashe), name: NSNotification.Name(rawValue: "funcaboutcashe"), object: nil)
      }
    
    override func viewWillAppear(_ animated: Bool) {
        checkinappstore()
        shedulesettingsoursereload()
        checkallowlocalnotification()
        shedulerootviewcontroller("Настройки")
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return settingcell.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settingcell[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("settingrow", forIndexPath: indexPath)
        
        var cell: UITableViewCell!
        
        if settingcell[indexPath.section][indexPath.row][0] as! String == "settingrow"{
            
            cell = tableView.dequeueReusableCell(withIdentifier: settingcell[indexPath.section][indexPath.row][0] as! String, for: indexPath)
            
            if (settingcell[indexPath.section][indexPath.row][1] as AnyObject).count == 1{
                cell.textLabel?.text = String(describing: (((settingcell[indexPath.section] as NSArray)[indexPath.row] as! NSArray)[1] as! NSArray)[0])
                cell.accessoryType = .disclosureIndicator
            }else{
                cell.textLabel?.text = String(describing: (((settingcell[indexPath.section] as NSArray)[indexPath.row] as! NSArray)[1] as! NSArray)[0])
                cell.detailTextLabel?.text = String(describing: (((settingcell[indexPath.section] as NSArray)[indexPath.row] as! NSArray)[1] as! NSArray)[1])
                cell.accessoryType = .disclosureIndicator
            }
            
        }
        
        if settingcell[indexPath.section][indexPath.row][0] as! String == "settingsourse"{
            
            cell = tableView.dequeueReusableCell(withIdentifier: settingcell[indexPath.section][indexPath.row][0] as! String, for: indexPath)
            cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0)
        }
        
        if settingcell[indexPath.section][indexPath.row][0] as! String == "settingautoscroll" || settingcell[indexPath.section][indexPath.row][0] as! String == "settingswipetable" || settingcell[indexPath.section][indexPath.row][0] as! String == "settingnoads" || settingcell[indexPath.section][indexPath.row][0] as! String == "settingnocashe"{
            
            cell = tableView.dequeueReusableCell(withIdentifier: self.settingcell[indexPath.section][indexPath.row][0] as! String, for: indexPath)
        }
        
        if settingcell[indexPath.section][indexPath.row][0] as! String == "settinglocalnotification"{
            
           let celll = tableView.dequeueReusableCell(withIdentifier: self.settingcell[indexPath.section][indexPath.row][0] as! String, for: indexPath) as! SettingLocalNotification
            
            if let settings = UIApplication.shared.currentUserNotificationSettings
            {
                if settings.types.contains([.alert, .badge])
                {}
                else
                {
                    if let flag = defaults.object(forKey: "SheduleSettingLocalNotification"){
                        if flag as! Bool{
                            defaults.set(false, forKey: "SheduleSettingLocalNotification")
                            defaults.synchronize()
                        }
                    }
                }
                
            }
            
            celll.label.text = "Уведомление о начале пары"
            if let flag = defaults.object(forKey: "SheduleSettingLocalNotification"){
                celll.sswipe.isOn = flag as! Bool
            }else{
                celll.sswipe.isOn = false
            }
            return celll
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settingcell[indexPath.section][indexPath.row].count == 3{
            if settingcell[indexPath.section][indexPath.row][2] as! String == "openweb"{
            safariopenwebshedule()
            }else if settingcell[indexPath.section][indexPath.row][2] as! String == "sendmail"{
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            }else{
                performSegue(withIdentifier: settingcell[indexPath.section][indexPath.row][2] as! String, sender: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func shedulerootviewcontroller(_ text: String){
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = text
    }
    
    func setsegmenttonavigationbar(){
        let segmentTitles = [
            "Группа",
            "Преподаватель",
            ]
        let segmentedControl = UISegmentedControl(items: segmentTitles)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.autoresizingMask = UIViewAutoresizing.flexibleWidth
        // change the width from 400.0 to something you want if it's needed
        segmentedControl.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30.0)
        segmentedControl.addTarget(self, action: #selector(SettingTVC.segmentedControlValueChanged), for:.valueChanged)
        self.navigationItem.titleView = segmentedControl
        
        if let data = defaults.object(forKey: "SheduleSettingSourseShedule"){
            segmentedControl.selectedSegmentIndex = data as! Int
        }else{
            segmentedControl.selectedSegmentIndex = 0
            defaults.set(segmentedControl.selectedSegmentIndex, forKey: "SheduleSettingSourseShedule")
            defaults.synchronize()
        }
    }
    
    func segmentedControlValueChanged(_ segment: UISegmentedControl) {
        defaults.set(segment.selectedSegmentIndex, forKey: "SheduleSettingSourseShedule")
        defaults.set(true, forKey: "SheduleSettingupdate")
        defaults.synchronize()
        shedulesettingsoursereload()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let backItem = UIBarButtonItem()
    backItem.title = "Назад"
    navigationItem.backBarButtonItem = backItem
    self.tabBarController?.tabBar.isHidden = true
    }

    func shedulesettingsoursereload(){
    shedulesettingsoursereloadinit()
    shedulesettingweek()
    tableView.reloadRows(at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)], with: .none)
    }
    
    func shedulesettingsoursereloadinit(){
        if let data = defaults.object(forKey: "SheduleSettingSourseShedule"){
            switch data as! Int{
            case 0:
                if let data1 = defaults.object(forKey: "SheduleSettingSourseGroupID"){
                 settingcell[0][1] = ["settingrow", ["Группа", data1], "segueshedulesettingsoursegroup"]
                }else{
                 settingcell[0][1] = ["settingrow", ["Группа", "не выбрана"], "segueshedulesettingsoursegroup"]
                }
                break
            case 1:
                if let data2 = defaults.object(forKey: "SheduleSettingSourseTeachID"){
                 settingcell[0][1] = ["settingrow", ["Преподаватель", (data2 as! AnyObject)[1] as! String], "shedulesettingsourseteach"]
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
        if let data = defaults.object(forKey: "SheduleSettingtime"){
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
                if defaults.object(forKey: "SheduleSettingCustomdatefist") != nil && defaults.object(forKey: "SheduleSettingCustomdatelast") != nil{
                 let fistdate = defaults.object(forKey: "SheduleSettingCustomdatefist") as! NSArray
                 let lastdate = defaults.object(forKey: "SheduleSettingCustomdatelast") as! NSArray
                 settingcell[0][0] = ["settingrow", ["Время расписания", "\(String(describing: fistdate[1]))-\(String(describing: lastdate[1]))"], "seguesheduletime"]
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
        UIApplication.shared.openURL(URL(string: "http://lab.lionrepair.ru/uapp/demo")!)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["ask@mounlion.com"])
        mailComposerVC.setSubject("Помощь в улучшение приложения \"Расписание БелГУ\"")
        mailComposerVC.setMessageBody("<h1 style=\"border-bottom: 2px solid black;text-align: center;\">\"Расписание БелГУ\"</h1><small>Не удаляйте эту информацию (\(UIDevice.current.modelName); \(UIDevice.current.systemVersion))</small>", isHTML: true)
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func smartalert(_ title: String, message: String, ok: String, cancel: String){
    }
    
    func openappstore(){
        UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/ru/app/raspisanie-belgu/id1080402611")!)
    }
    
    func instructionaboutswitch(){
        let alertview = JSSAlertView().show(
            self,
            title: "Быстрое переключение недель",
            text: "Смахивайте расписание влево или вправо для переключение недель",
            buttonText: "Скрыть подсказку",
            color: UIColorFromHex(0x3498db, alpha: 1),
            iconImage: UIImage(named: "technology")
        )
        alertview.setTextTheme(.light)
    }
    
    func instructionaboutautoscroll(){
        let alertview = JSSAlertView().show(
            self,
            title: "Автоматическая прокрутка расписания",
            text: "Мы будем автоматически прокручивать расписание до текущего дня",
            buttonText: "Скрыть подсказку",
            color: UIColorFromHex(0x3498db, alpha: 1),
            iconImage: UIImage(named: "technology")
        )
        alertview.setTextTheme(.light)
    }
    
    func instructionaboutLocalNotification(){
        let alertview = JSSAlertView().show(
            self,
            title: "Уведомление о начале пары",
            text: "За 5 минут до начала пары мы будем уведомлять вас об этом",
            buttonText: "Скрыть подсказку",
            color: UIColorFromHex(0x3498db, alpha: 1),
            iconImage: UIImage(named: "technology")
        )
        alertview.setTextTheme(.light)
    }
    
    func instructionaboutnotLocalNotification(){
        JSSAlertView().danger(
            self,
            title: "Уведомление о начале пары",
            text: "Для того чтобы показывать уведомления их надо активировать в настройках",
            buttonText: "Скрыть подсказку"
        )
    }
    
    func alertinfoaboutlimits(_ notification: Notification){
        let userInfo:Dictionary<String,String?> = notification.userInfo as! Dictionary<String,String?>
        SweetAlert().showAlert("Опс...", subTitle: "Для включения этой функции \"\(userInfo["title"]!!)\" сначала нужно отключить ограничения", style: AlertStyle.warning, buttonTitle:"Скрыть")
    }
    
    func checkallowlocalnotification(){
        tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
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
        let alertController = UIAlertController(title: "Отключение ограничений", message: nil, preferredStyle: .alert)
        
        let noadsAction = UIAlertAction(title: "Отключить ограничения", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("Отключить рекламу")
            self.buyinappstore()
        }
        let restoreadsAction = UIAlertAction(title: "Восстановить покупки", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("Восстановить покупки")
            self.restoreinappstore()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel) {
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
        self.present(alertController, animated: true, completion: nil)
    }
    
    func removeads(){
        if !limitation().check{
        limitation().offlimitation
        let indexpath: IndexPath = IndexPath(row: settingcell[0].count-1, section: 0)
        settingcell[0].remove(at: indexpath.row)
        tableView.deleteRows(at: [indexpath], with: .fade)
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
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
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
        nc.post(name: Notification.Name(rawValue: "funcswitchenable"), object: nil)
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
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func buyProduct() {
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
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
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("failed restore");
        switchnoads()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add paymnet")
        
        for transaction:AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
                
            case .purchased:
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
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break;
            default:
                print("default")
                break;
                
            }
        }
    }
    
    func finishTransaction(_ trans:SKPaymentTransaction)
    {
        print("finish trans")
        SKPaymentQueue.default().finishTransaction(trans)
    }
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction])
    {
        print("remove trans");
        switchnoads()
    }
    
    func switchnoads(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "funcnoads"), object: nil)
    }
    
    func deletecooke(){
        if defaults.object(forKey: "deletecooke") == nil{
            defaults.removeObject(forKey: "SheduleSettingAutoScroll")
            defaults.removeObject(forKey: "SheduleSettingSwipeTable")
            defaults.removeObject(forKey: "SheduleSettingLocalNotification")
            defaults.set(true, forKey: "deletecooke")
            defaults.synchronize()
            print("delete cooke")
        }
    }
    
    func developermode(){
        removeads()
    }
    
    func aboutcashe(){
        SweetAlert().showAlert("Загрузка кэшированных данных", subTitle: "Для повышения отказа устойчивости и быстроты загрузки данных мы используем кэширование данных. В некоторых случаях расписание может не совпадать с официальной версией расписания.", style: AlertStyle.none, buttonTitle: "Скрыть")
    }

}
