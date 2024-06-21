//
//  HoldingPersistable.swift
//  Upstox
//
//  Created by Shreyash Shah on 24/05/24.
//

import SwiftData
import Foundation

@Model
final class HoldingPersistable {
    @Attribute(.unique)
    let id: UUID
    let symbol: String
    let quantity: Int
    let averagePrice: Double
    let previousClosingPrice: Double
    let latestTradedPrice: Double
    
    init(id: UUID, 
         symbol: String,
         quantity: Int,
         averagePrice: Double,
         previousClosingPrice: Double,
         latestTradedPrice: Double) {
        self.id = id
        self.symbol = symbol
        self.quantity = quantity
        self.averagePrice = averagePrice
        self.previousClosingPrice = previousClosingPrice
        self.latestTradedPrice = latestTradedPrice
    }
}

extension Holding {
    init(from model: HoldingPersistable) {
        self.init(symbol: model.symbol,
                  quantity: model.quantity,
                  averagePrice: model.averagePrice,
                  previousClosingPrice: model.previousClosingPrice,
                  latestTradedPrice: model.latestTradedPrice)
    }
    
    func buildPersistable() -> HoldingPersistable {
        return HoldingPersistable(id: self.id,
                                  symbol: self.symbol,
                                  quantity: self.quantity,
                                  averagePrice: self.averagePrice,
                                  previousClosingPrice: self.previousClosingPrice,
                                  latestTradedPrice: self.latestTradedPrice)
    }
}
