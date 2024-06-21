//
//  Holding.swift
//  Upstox
//
//  Created by Shreyash Shah on 23/05/24.
//

import Foundation

// MARK: - Holding
struct Holding: Decodable, Equatable {
    let id = UUID()
    let symbol: String
    let quantity: Int
    let averagePrice, previousClosingPrice: Double
    var latestTradedPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case quantity
        case latestTradedPrice = "ltp"
        case averagePrice = "avgPrice"
        case previousClosingPrice = "close"
    }
    
    init(symbol: String,
         quantity: Int,
         averagePrice: Double,
         previousClosingPrice: Double,
         latestTradedPrice: Double) {
        self.symbol = symbol
        self.quantity = quantity
        self.averagePrice = averagePrice
        self.previousClosingPrice = previousClosingPrice
        self.latestTradedPrice = latestTradedPrice
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.quantity = try container.decode(Int.self, forKey: .quantity)
        self.averagePrice = try container.decode(Double.self, forKey: .averagePrice)
        self.latestTradedPrice = try container.decode(Double.self, forKey: .latestTradedPrice)
        self.previousClosingPrice = try container.decode(Double.self, forKey: .previousClosingPrice)
    }
}

// MARK: Statistics
extension Holding {
    var currentValue: Double {
        return Double(quantity) * latestTradedPrice
    }
    
    var totalInvestment: Double {
        return Double(quantity) * averagePrice
    }
    
    var returns: Double {
        return currentValue - totalInvestment
    }
    
    var todayReturns: Double {
        return Double(quantity) * (latestTradedPrice - previousClosingPrice)
    }
}
