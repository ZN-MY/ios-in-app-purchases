//
//  ContentView.swift
//  MY-IAP
//
//  Created by Zaid Neurothrone on 2022-11-27.
//

import StoreKit
import SwiftUI

struct ContentView: View {
  @EnvironmentObject var storeManager: StoreManager
  
  private let productIDs = [
    "Coin",
    "Premium"
  ]
  
  var body: some View {
    NavigationStack {
      content
        .navigationTitle("Buy things 🏴‍☠️")
        .onAppear {
          storeManager.getProducts(productIDs: productIDs)
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Restore Purchases") {
              storeManager.restoreProducts()
            }
          }
        }
    }
  }
  
  private var content: some View {
    List {
      Section {
        if let coinProduct = storeManager.coinProduct {
          ProductRowView(storeManager: storeManager, product: coinProduct)
        } else {
          Text("No Coin Product")
        }
      } header: {
        Text("Coin Product")
      }
      
      Section {
        if let premiumProduct = storeManager.premiumProduct {
          ProductRowView(storeManager: storeManager, product: premiumProduct)
        } else {
          Text("No Premium Product")
        }
      } header: {
        Text("Premium Product")
      }
      
      Section {
        ForEach(storeManager.products, id: \.self) { product in
          ProductRowView(storeManager: storeManager, product: product)
        }
      } header: {
        Text("Products")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(StoreManager())
  }
}
