//
//  StoreManager.swift
//  MY-IAP
//
//  Created by Zaid Neurothrone on 2022-11-28.
//

import Foundation
import StoreKit

final class StoreManager: NSObject, ObservableObject {
  @Published var products: [SKProduct] = []
  @Published var coinProduct: SKProduct?
  @Published var premiumProduct: SKProduct?
  
  @Published var transactionState: SKPaymentTransactionState?
  
  var request: SKProductsRequest!
  
  override init() {
    super.init()
    
    SKPaymentQueue.default().add(self)
  }
  
  func getProducts(productIDs: [String]) {
    print("ℹ️ -> Start requesting products...")
    
    let request = SKProductsRequest(productIdentifiers: Set(productIDs))
    request.delegate = self
    request.start()
  }
  
  func request(_ request: SKRequest, didFailWithError error: Error) {
    print("❌ -> Request did fail: \(error.localizedDescription)")
  }
  
  func purchaseProduct(product: SKProduct) {
    if SKPaymentQueue.canMakePayments() {
      let payment = SKPayment(product: product)
      SKPaymentQueue.default().add(payment)
    } else {
      print("❌ -> User can't make payment.")
    }
  }
  
  func restoreProducts() {
      print("ℹ️ -> Restoring products...")
    
      SKPaymentQueue.default().restoreCompletedTransactions()
  }
}

//MARK: - SKProductsRequestDelegate conformance
extension StoreManager: SKProductsRequestDelegate {
  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    print("ℹ️ -> Did receive response")
    
    guard response.products.isNotEmpty else { return }
    
    DispatchQueue.main.async {
      self.products = []
    }
    
    for product in response.products {
      if product.productIdentifier == "Coin" {
        DispatchQueue.main.async {
          self.coinProduct = product
        }
      }
      
      if product.productIdentifier == "Premium" {
        DispatchQueue.main.async {
          self.premiumProduct = product
        }
      }
    }
    
    DispatchQueue.main.async {
      self.products = response.products
    }
    
    for invalidIdentifier in response.invalidProductIdentifiers {
      print("ℹ️ -> Invalid identifier found: \(invalidIdentifier)")
    }
  }
}

//MARK: - SKPaymentTransactionObserver conformance
extension StoreManager: SKPaymentTransactionObserver {
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch transaction.transactionState {
      case .purchasing:
        transactionState = .purchasing
      case .purchased:
        UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
        print("✅ -> Purchased!")
        transactionState = .purchased
        queue.finishTransaction(transaction)
      case .restored:
        print("✅ -> Restored!")
        UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
        transactionState = .restored
        queue.finishTransaction(transaction)
      case .failed, .deferred:
        let error = transaction.error?.localizedDescription ?? "Unknown"
        print("Payment Queue Error: \(error)")
        
        transactionState = .failed
        queue.finishTransaction(transaction)
      default:
        queue.finishTransaction(transaction)
      }
    }
  }
}
