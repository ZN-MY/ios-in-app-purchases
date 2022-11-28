//
//  NSDecimalNumber+Extensions.swift
//  MY-IAP
//
//  Created by Zaid Neurothrone on 2022-11-28.
//

import Foundation

extension NSDecimalNumber {
  var toLocalCurrency: String {
    NumberFormatter.localCurrency.string(from: self as NSNumber) ?? ""
  }
}
