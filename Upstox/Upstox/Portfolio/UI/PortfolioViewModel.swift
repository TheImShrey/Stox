//
//  PortfolioViewModel.swift
//  Upstox
//
//  Created by Shreyash Shah on 22/05/24.
//

import Foundation
import SwiftData

@MainActor
class PortfolioViewModel: StatefulViewModellable {
    struct State: Stateful {
        var holdings: [Holding]
        
        static var initial: State {
            return State(holdings: [])
        }
        
        static var zero: State {
            return State.initial
        }
        
        var currentTotalValue: Double {
            return holdings.reduce(0) { partialResult, holding in
                return partialResult + holding.currentValue
            }
        }
        
        var totalInvestment: Double {
            return holdings.reduce(0) { partialResult, holding in
                return partialResult + holding.totalInvestment
            }
        }
        
        var totalReturns: Double {
            return holdings.reduce(0) { partialResult, holding in
                return partialResult + holding.returns
            }
        }
        
        var todayReturns: Double {
            return holdings.reduce(0) { partialResult, holding in
                return partialResult + holding.todayReturns
            }
        }
    }
    
    enum StateChanges {
        case openHoldingDetails(Holding)
        case reloadItems([(index: Int, oldItemId: UUID)])
        case reloadAll
        case showGeneralError(String, Error)
    }
    
    enum Actions {
        case fetchPortfolio
        case appDidEnterBackground
    }
    
    private(set) var state: State
    var onStateChange: StateChangeTrigger?
    
    let environment: Environment
    private let portfolioService: PortfolioServicible
    private var fetchPortfolioTask: (any NetworkTaskable)?
    
    init(environment: Environment,
         portfolioService: PortfolioServicible) {
        self.portfolioService = portfolioService
        self.state = State.initial
        self.environment = environment
        self.initialPortfolioSetup()
    }

    private func resetPortfolio(with holdings: [Holding]) {
        self.state.holdings = holdings
        self.broadcast(stateChange: .reloadAll)
    }
    
    private func initialPortfolioSetup() {
        self.setupWithPersistedHoldings()
        self.fetchPortfolio()
    }
    
    private func fetchPortfolio() {
        self.fetchPortfolioTask?.cancel()
        self.fetchPortfolioTask = self.portfolioService.fetchPortfolio { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let payload):
                self.resetPortfolio(with: payload.holdings)
            case .failure(let error):
                self.broadcast(stateChange: .showGeneralError("Error fetching portfolio", error))
            }
            self.fetchPortfolioTask = nil
        }
    }
    
    func broadcast(stateChange: StateChanges) {
        self.onStateChange?(stateChange)
    }
    
    public func trigger(action: Actions) {
        switch action {
        case .fetchPortfolio:
            self.fetchPortfolio()
        case .appDidEnterBackground:
            self.persistHoldings()
        }
    }
}

// MARK: Persistance
extension PortfolioViewModel {
    func setupWithPersistedHoldings() {
        do {
            let persistanceContainer = self.environment.persistanceContainer
            guard let persistanceContainer else { return }
            
            let holdingsFetchDescriptor = FetchDescriptor<Persistables.Holding>(sortBy: [SortDescriptor(\.id)])
            let persistedHoldings = try persistanceContainer.mainContext.fetch(holdingsFetchDescriptor)
            let holdings = persistedHoldings.map { persistedHolding in
                return Holding(from: persistedHolding)
            }
            
            self.resetPortfolio(with: holdings)
        } catch {
            debugPrint("Error fetching holdings list from persisted storage", error)
        }

    }
    
    func persistHoldings() {
        guard let persistanceContainer = self.environment.persistanceContainer else { return }
        let holdings = self.state.holdings
        
        holdings.forEach { holding in
            let persistableHolding = holding.buildPersistable()
            persistanceContainer.mainContext.insert(persistableHolding)
        }
    }
}
