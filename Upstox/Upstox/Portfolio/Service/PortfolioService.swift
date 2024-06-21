//
//  PortfolioService.swift
//  Upstox
//
//  Created by Shreyash Shah on 22/05/24.
//

import Foundation
typealias PortfolioFetchResult = ((Result<PortfolioResponse.Payload, Error>) -> Void)

protocol PortfolioServicible {
    func fetchPortfolio(onFetch: @escaping PortfolioFetchResult) -> NetworkTaskable
}

final class PortfolioService {
    private let environment: Environment
    
    init(environment: Environment) {
        self.environment = environment
    }
    
    enum Endpoints: String {
        case portfolio = "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
    }
}

extension PortfolioService.Endpoints: Requestable {
    var url: URL {
        let url = URL(string: self.rawValue)
        guard let url else {
            assertionFailure("Invalid Endpoint URL, please check if the raw value is valid URL string")
            fatalError()
        }
        
        return url
    }
    
    var method: RequestableMethod {
        switch self {
        case .portfolio:
            return .get
        }
    }
}
    
extension PortfolioService: PortfolioServicible {
    func fetchPortfolio(onFetch: @escaping PortfolioFetchResult) -> NetworkTaskable {
        let request = Endpoints.portfolio.request
        
        let task = environment.sharedNetworkSession.dataTask(with: request) { (data, response, error) in
            if let error {
                onFetch(.failure(error))
            } else if let data {
                do {
                    let portfolioResponse = try JSONDecoder().decode(PortfolioResponse.self, from: data)
                    if let payload = portfolioResponse.payload {
                        onFetch(.success(payload))
                    } else {
                        onFetch(.failure(AppError.missingData))
                    }
                } catch {
                    onFetch(.failure(error))
                }
            } else {
                onFetch(.failure(AppError.somethingWentWrong))
            }
        }
        
        task.resume()
        
        return task
    }
}
