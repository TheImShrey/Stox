//
//  PortfolioViewController+CollectionView.swift
//  Upstox
//
//  Created by Shreyash Shah on 24/05/24.
//

import UIKit

extension PortfolioViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.holdingsCollectionView:
            return viewModel.state.holdings.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        lazy var emptyCell = UICollectionViewCell()
        
        switch collectionView {
        case self.holdingsCollectionView:
            guard let holding = viewModel.state.holdings.item(at: indexPath.row),
                  let holdingCell = holdingsCollectionView.dequeueReusableCell(of: HoldingItemCell.self, for: indexPath)
            else {
                return emptyCell
            }
            
            holdingCell.configure(using: holding)
            return holdingCell
        default:
            return emptyCell
        }
    }
}

extension PortfolioViewController: HoldingsCollectionViewDelegate {
    func holdingsCollectionView(_ holdingsCollectionView: HoldingsCollectionView, didSelectItemAt indexPath: IndexPath) {
        focused(on: holdingsCollectionView)
        switch holdingsCollectionView {
        case self.holdingsCollectionView:
            guard let holding = viewModel.state.holdings.item(at: indexPath.row) else { return }
            self.openHoldingDetailsScreen(for: holding)
        default:
            break
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        focused(on: scrollView)
    }
}
