//
//  UpstoxTests.swift
//  UpstoxTests
//
//  Created by Shreyash Shah on 24/05/24.
//

import XCTest
@testable import Upstox

@MainActor
final class UpstoxTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchPortfolio() throws {
        let portfolioService = MockPortfolioService()
        let viewModel = PortfolioViewModel(environment: Environment(with: .debug),
                                           portfolioService: portfolioService)
        
        viewModel.trigger(action: .fetchPortfolio)
        
        XCTAssertEqual(viewModel.state.holdings.count, 3)
    }
    
    func testTotalCurrentValue() throws {
        let portfolioService = MockPortfolioService()
        let viewModel = PortfolioViewModel(environment: Environment(with: .debug),
                                           portfolioService: portfolioService)
        
        viewModel.trigger(action: .fetchPortfolio)
        
        XCTAssertEqual(viewModel.state.currentTotalValue, portfolioService.totalCurrentValue)
    }
    
    func testTodayProfitValue() throws {
        let portfolioService = MockPortfolioService()
        let viewModel = PortfolioViewModel(environment: Environment(with: .debug),
                                           portfolioService: portfolioService)
        
        viewModel.trigger(action: .fetchPortfolio)
        
        XCTAssertEqual(viewModel.state.todayReturns, portfolioService.todayReturns)
    }
    
    func testTotalInvestmentValue() throws {
        let portfolioService = MockPortfolioService()
        let viewModel = PortfolioViewModel(environment: Environment(with: .debug),
                                           portfolioService: portfolioService)
        
        viewModel.trigger(action: .fetchPortfolio)
        
        XCTAssertEqual(viewModel.state.totalInvestment, portfolioService.totalInvestment)
    }
    
    func testTotalReturnsValue() throws {
        let portfolioService = MockPortfolioService()
        let viewModel = PortfolioViewModel(environment: Environment(with: .debug),
                                           portfolioService: portfolioService)
        
        viewModel.trigger(action: .fetchPortfolio)
        
        XCTAssertEqual(viewModel.state.totalReturns, portfolioService.totalReturns)
    }
    
    func testHoldingsPriceChange() throws {
        let portfolioService = MockPortfolioService()
        let viewModel = PortfolioViewModel(environment: Environment(with: .debug),
                                           portfolioService: portfolioService)
        
        viewModel.trigger(action: .fetchPortfolio)
        var holding = viewModel.state.holdings[0]
        holding.latestTradedPrice = 50
        XCTAssertEqual(holding.returns, -500)
    }
}
