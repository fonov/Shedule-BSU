//
//  ViewController.swift
//  Shedule5.1
//
//  Created by CSergey on 25.04.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    @IBOutlet weak var outr: UIButton!
    @IBOutlet weak var ads: UILabel!
    @IBOutlet weak var outres: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        productIDs.append("mounlion.corp.Shedule4-0")
//        
//        requestProductInfo()

        outr.enabled = false
        
        if SKPaymentQueue.canMakePayments(){
            print("IAP is enable, loading")
            let productID: NSSet = NSSet(objects: "com.mounlion.sgedule40.ads")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        }else{
            print("IAP is not enable, loading")
        }
    }
    
    

//    var productIDs: Array<String!> = []
//    var productsArray: Array<SKProduct!> = []
//    
//    func requestProductInfo() {
//        if SKPaymentQueue.canMakePayments() {
//            let productIdentifiers = NSSet(array: productIDs)
//            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
//            productRequest.delegate = self
//            productRequest.start()
//        }
//        else {
//            print("Cannot perform In App Purchases.")
//        }
//    }
//    
//    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
//        if response.products.count != 0 {
//            for product in response.products {
//                productsArray.append(product)
//            }
//        }
//        else {
//            print("There are no products.")
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeads(sender: UIButton) {
        for product in list{
            let prodID = product.productIdentifier
            if prodID == "com.mounlion.sgedule40.ads"{
            p = product
            buyproduct()
            break;
            }
        }
    }
    
    @IBAction func restore(sender: UIButton) {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("Complite restore")
        
        var purchasedItemIDS = []
        for transaction in queue.transactions{
            var t: SKPaymentTransaction = transaction as SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "com.mounlion.sgedule40.ads":
                print("remove ads")
            default:
                print("IAP not setup")
                break
            }
            
        }
    }
    
    func removeads(){
    ads.removeFromSuperview()
    }
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func buyproduct(){
        print("buy "+p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("producnt request")
        let myProduct = response.products
        
        print(myProduct)
        
        for product in myProduct{
            
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product as SKProduct)
        }
        
        outr.enabled = true
    }
    
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        for transaction: SKPaymentTransaction in transactions{
            print(transaction.error)
            
            switch transaction.transactionState {
            case .Purchased:
                print("buy, ok unlock iap here")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID {
                case "com.mounlion.sgedule40.ads":
                    print("remove ads")
                default:
                    print("IAP not setup")
                    break
                }
                
                queue.finishTransaction(transaction)
                break
                
            case .Failed:
                print("bay error")
                queue.finishTransaction(transaction)
                break
            default:
                print("defult")
                break
            }
            
            
        }
    }
    
    func finishTransaction(trans: SKPaymentTransaction){
        print("finish trans")
    }
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove trans")
    }

}
