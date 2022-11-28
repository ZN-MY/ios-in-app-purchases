//
//  ProductRowView.swift
//  MY-IAP
//
//  Created by Zaid Neurothrone on 2022-11-28.
//

import StoreKit
import SwiftUI

struct ProductRowView: View {
  @ObservedObject var storeManager: StoreManager
  
  let product: SKProduct
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(product.localizedTitle)
          .font(.headline)
        
        Text(product.localizedDescription)
          .font(.caption2)
      }
      
      Spacer()
      
      if UserDefaults.standard.bool(forKey: product.productIdentifier) {
        Text("Purchased")
          .foregroundColor(.green)
      } else {
        Button("Buy for \(product.price.toLocalCurrency)") {
          storeManager.purchaseProduct(product: product)
        }
      }
    }
  }
}
