//
//  CountryChangeUseCaseTests.swift
//  UnitTestingTests
//
//  Created by Göksel Köksal on 21.12.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import XCTest
@testable import UnitTesting

class CountryChangeUseCaseTests: XCTestCase {
  
  private var useCase: CountryChangeUseCase!
  private var homeCountryProvider: MockHomeCountryProvider!
  private var countryChangeListener: MockCountryChangeListener!
  private var exchangeRateProvider: MockExchangeRateProvider!
  private var notificationManager: MockNotificationManager!

  override func setUp() {
    homeCountryProvider = MockHomeCountryProvider()
    countryChangeListener = MockCountryChangeListener()
    exchangeRateProvider = MockExchangeRateProvider()
    notificationManager = MockNotificationManager()
    
    useCase = CountryChangeUseCase(
      homeCountryProvider: homeCountryProvider,
      countryChangeListener: countryChangeListener,
      exchangeRateProvider: exchangeRateProvider,
      notificationManager: notificationManager
    )
  }

  /**
   GIVEN I am in Turkey and EUR/TRY is 4.0
   WHEN I travel to Ireland
   THEN I expect to see a notification with EUR/TRY = 4.0
   */
  func testHappyPath() {
    // Given:
    homeCountryProvider.country = Country.turkey
    exchangeRateProvider.homeCurrencies = [
      Country.ireland: Currency.euro,
      Country.turkey: Currency.lira
    ]
    let pair = CurrencyPair(.euro, .lira)
    let rate: Decimal = 4.0
    exchangeRateProvider.exchangeRates = [pair: rate]
    
    // When:
    useCase.start()
    countryChangeListener.travel(to: .ireland)
    
    // Then:
    let expectedPayload = ExchangeRateNotificationPayload(
      country: .ireland,
      currencyPair: pair,
      rate: rate
    )
    XCTAssertEqual(notificationManager.latestPayload, expectedPayload)
  }
}

// MARK: - Mocks

private final class MockCountryChangeListener: CountryChangeListenerProtocol {
  
  var delegate: CountryChangeListenerDelegate?
  private var didStart = false
  
  func start() {
    didStart = true
  }
  
  func travel(to country: Country) {
    guard didStart else { return }
    delegate?.didChangeCountry(country)
  }
}

private final class MockHomeCountryProvider: HomeCountryProviderProtocol {
  
  var country: Country? = nil
  
  func homeCountry() -> Country? {
    return country
  }
}

private final class MockExchangeRateProvider: ExchangeRateProviderProtocol {
  
  var homeCurrencies: [Country: Currency] = [:]
  var exchangeRates: [CurrencyPair: Decimal] = [:]
  
  func homeCurrency(for country: Country) -> Currency? {
    return homeCurrencies[country]
  }
  
  func exchangeRate(for pair: CurrencyPair) -> Decimal? {
    return exchangeRates[pair]
  }
}

private final class MockNotificationManager: ExchangeRateNotificationManagerProtocol {
  
  private(set) var latestPayload: ExchangeRateNotificationPayload?
  
  func showExchangeRateNotification(with payload: ExchangeRateNotificationPayload) {
    latestPayload = payload
  }
}
