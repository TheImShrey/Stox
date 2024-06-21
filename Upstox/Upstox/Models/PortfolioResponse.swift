//
//  PortfolioResponse.swift
//  Upstox
//
//  Created by Shreyash Shah on 22/05/24.
//

import Foundation

// MARK: - PortfolioResponse
struct PortfolioResponse: Decodable, Equatable {
    
    // MARK: - Payload
    struct Payload: Decodable, Equatable {
        enum CodingKeys: String, CodingKey {
            case holdings = "userHolding"
        }
        
        let holdings: [Holding]
        
        init(holdings: [Holding]) {
            self.holdings = holdings
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            self.holdings = try container.decodeIfPresent([Holding].self, forKey: .holdings) ?? []
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case payload = "data"
    }
    
    let payload: Payload?
}
