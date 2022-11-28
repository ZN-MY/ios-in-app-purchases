//
//  IAPApp.swift
//  MY-IAP
//
//  Created by Zaid Neurothrone on 2022-11-27.
//

import SwiftUI

@main
struct IAPApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(StoreManager())
    }
  }
}
