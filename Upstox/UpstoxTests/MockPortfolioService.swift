//
//  MockPortfolioService.swift
//  UpstoxTests
//
//  Created by Shreyash Shah on 24/05/24.
//

import Foundation
@testable import Upstox

class MockPortfolioService: PortfolioServicible {
    var mockData: PortfolioResponse.Payload {
        let holding1 = Holding(symbol: "AAPL", quantity: 10, averagePrice: 100.0, previousClosingPrice: 99.0, latestTradedPrice: 101.0)
        let holding2 = Holding(symbol: "GOOGL", quantity: 20, averagePrice: 200.0, previousClosingPrice: 199.0, latestTradedPrice: 201.0)
        let holding3 = Holding(symbol: "MSFT", quantity: 30, averagePrice: 300.0, previousClosingPrice: 299.0, latestTradedPrice: 301.0)
        
        return PortfolioResponse.Payload(holdings: [holding1, holding2, holding3])
    }
    
    var totalCurrentValue: Double {
        return 14060
    }
    
    var todayReturns: Double {
        return 120
    }
    
    var totalInvestment: Double {
        return 14000
    }
    
    var totalReturns: Double {
        return 60
    }
    
    func fetchPortfolio(onFetch: @escaping PortfolioFetchResult) -> NetworkTaskable {
        let mockData = mockData
        onFetch(.success(mockData))
        return NoopTask()
    }
}
