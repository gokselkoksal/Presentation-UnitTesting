//
//  CurrencyPair.swift
//  UnitTesting
//
//  Created by Göksel Köksal on 21.12.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

struct CurrencyPair: Equatable, Hashable {
  
  let foreign: Currency
  let home: Currency
  
  init(_ foreign: Currency, _ home: Currency) {
    self.foreign = foreign
    self.home = home
  }
}
