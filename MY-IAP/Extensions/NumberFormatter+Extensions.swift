//
//  NumberFormatter+Extensions.swift
//  MY-IAP
//
//  Created by Zaid Neurothrone on 2022-11-28.
//

import Foundation

extension NumberFormatter {
  static var localCurrency: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.locale = .current
    formatter.numberStyle = .currency
    return formatter
  }
}
