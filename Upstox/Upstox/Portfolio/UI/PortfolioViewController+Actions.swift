//
//  PortfolioViewController+Actions.swift
//  Upstox
//
//  Created by Shreyash Shah on 24/05/24.
//

import UIKit

extension PortfolioViewController {
    func focused(on uiItem: Any) {
        if (uiItem as? PortfolioSummaryView) != summaryView {
            summaryView.collapse()
        }
    }
    
    
    func openHoldingDetailsScreen(for holding: Holding) {
        presentAlert(title: holding.symbol,
                     message: """
                              LTP: \(holding.latestTradedPrice.formatted(.currency(code: "INR")))
                              Avg Buying: \(holding.averagePrice.formatted(.currency(code: "INR")))
                              """)
    }
    
    func setupActions() {
        let refreshGestureRecognizer = UITapGestureRecognizer(target: self,
                                                              action: #selector(refreshButtonTapped))
        emptyStateView.addGestureRecognizer(refreshGestureRecognizer)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEnterBackground),
                                               name: UIScene.didEnterBackgroundNotification,
                                               object: nil)
        
    }
    
    @objc
    func refreshButtonTapped() {
        focused(on: navigationItem.rightBarButtonItem as Any)
        self.setupEmptyStateViews(to: .loading)
        viewModel.trigger(action: .fetchPortfolio)
    }
    
    @objc
    func appDidEnterBackground() {
        viewModel.trigger(action: .appDidEnterBackground)
    }
}
