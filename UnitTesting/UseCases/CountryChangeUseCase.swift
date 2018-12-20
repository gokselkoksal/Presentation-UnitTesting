//
//  CountryChangeUseCase.swift
//  UnitTesting
//
//  Created by Göksel Köksal on 21.12.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

final class CountryChangeUseCase: CountryChangeUseCaseProtocol {
  
  let homeCountryProvider: HomeCountryProviderProtocol
  let countryChangeListener: CountryChangeListenerProtocol
  let exchangeRateProvider: ExchangeRateProviderProtocol
  let notificationManager: ExchangeRateNotificationManagerProtocol
  
  init(homeCountryProvider: HomeCountryProviderProtocol,
       countryChangeListener: CountryChangeListenerProtocol,
       exchangeRateProvider: ExchangeRateProviderProtocol,
       notificationManager: ExchangeRateNotificationManagerProtocol)
  {
    self.homeCountryProvider = homeCountryProvider
    self.countryChangeListener = countryChangeListener
    self.exchangeRateProvider = exchangeRateProvider
    self.notificationManager = notificationManager
    
    self.countryChangeListener.delegate = self
  }
  
  func start() {
    countryChangeListener.start()
  }
}

extension CountryChangeUseCase: CountryChangeListenerDelegate {
  
  func didChangeCountry(_ newCountry: Country) {
    let foreignCountry = newCountry
    
    guard
      let homeCountry = homeCountryProvider.homeCountry(),
      homeCountry != foreignCountry,
      let homeCurrency = exchangeRateProvider.homeCurrency(for: homeCountry),
      let foreignCurrency = exchangeRateProvider.homeCurrency(for: foreignCountry)
    else {
      return
    }
    
    let pair = CurrencyPair(foreignCurrency, homeCurrency)
    guard let rate = exchangeRateProvider.exchangeRate(for: pair) else {
      return
    }
    
    let payload = ExchangeRateNotificationPayload(
      country: foreignCountry,
      currencyPair: pair,
      rate: rate
    )
    notificationManager.showExchangeRateNotification(with: payload)
  }
}
