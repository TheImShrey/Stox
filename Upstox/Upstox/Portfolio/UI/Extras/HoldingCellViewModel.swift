//
//  HoldingCellViewModel.swift
//  Upstox
//
//  Created by Shreyash Shah on 23/05/24.
//

import Foundation

class HoldingCellViewModel: StatefulViewModellable {
    struct State: Stateful {
        var holding: Holding
    }
    
    enum StateChanges {
        case priceUpdated
    }
    
    enum Actions {
        case update(lastTradedPrice: Double)
    }
    
    private(set) var state: State
    var onStateChange: StateChangeTrigger?
    
    init(holding: Holding) {
        self.state = State(holding: holding)
        self.onStateChange = nil
    }
    
    func trigger(action: Actions) {
        switch action {
        case .update(let lastTradedPrice):
            self.state.holding.latestTradedPrice = lastTradedPrice
            self.broadcast(stateChange: .priceUpdated)
        }
    }
}
