//
//  CountryChangeUseCaseContracts.swift
//  UnitTesting
//
//  Created by Göksel Köksal on 21.12.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

/**
 Requirements:
 Show a notification with current exchange rate if the user travels abroad.
 */

protocol CountryChangeUseCaseProtocol {
  func start()
}

// MARK: Current country

protocol CountryChangeListenerDelegate {
  func didChangeCountry(_ newCountry: Country)
}

protocol CountryChangeListenerProtocol: class {
  var delegate: CountryChangeListenerDelegate? { get set }
  func start()
}

// MARK: Home country

protocol HomeCountryProviderProtocol: class {
  func homeCountry() -> Country?
}

// MARK: Exchange rate

protocol ExchangeRateProviderProtocol {
  func homeCurrency(for country: Country) -> Currency?
  func exchangeRate(for pair: CurrencyPair) -> Decimal?
}

// MARK: Notification

struct ExchangeRateNotificationPayload: Equatable {
  let country: Country
  let currencyPair: CurrencyPair
  let rate: Decimal
}

protocol ExchangeRateNotificationManagerProtocol {
  func showExchangeRateNotification(with payload: ExchangeRateNotificationPayload)
}
