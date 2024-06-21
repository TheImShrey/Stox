//
//  PortfolioViewController.swift
//  Upstox
//
//  Created by Shreyash Shah on 22/05/24.
//

import UIKit
import SnapKit
import UniformTypeIdentifiers
//let queue = DispatchQueue(label: "com.helper.thread", qos: .background, attributes: .concurrent)
//DispatchQueue.main.async {
//  
//  print("Step1")
//  
//  queue.async {
//    print("This is an async block")
//  }
//  
//  print("Step2")
//  
//  queue.sync {
//    print("This is a sync block")
//  }
//  
//  print("Step3")
//}
//
/////
//Step1
//****
//Step2
//This is an async block
//This is a sync block
//Step3


//class ViewModel {
//  
//  func networkCall(completionHandler: @escaping (String) -> ()) {
//    sleep(2)
//    //here you can pass the response data
//    completionHandler("Data is fetched")
//  }
//  
//}
//
//
//class ViewController {
//  
//  var neededDataThatShouldBeFetchFromAPI: String?
//  
//  var viewModel = ViewModel()
//  
//  func apiCall() {
//    viewModel.networkCall { response in
//      self.neededDataThatShouldBeFetchFromAPI = response
//    }
//  }
//  
//}

SOLID
Single Respo
open extension closed modification
Libscov
Inversion
Dependancy injection


class PortfolioViewController: UIViewController, AlertPresentable {
    struct Theme {
        static let refreshIcon = AppImages.refresh.image
        static let backgroundColor: UIColor = .systemBackground
        static let disabledUIControlColor: UIColor = .systemGray3
        static let navigationButtonTintColor: UIColor = .systemYellow
        static let navigationBarBackgroundColor: UIColor = .tintColor
    }
    
    struct Metrics {
        static let refreshButtonHeight: CGFloat = 80
        static let standardPadding: CGFloat = 18
        static let collapsedSummaryViewHeight: CGFloat = 30
    }
    
    let viewModel: PortfolioViewModel
    
    let holdingsCollectionView: HoldingsCollectionView = {
        let collectionView = HoldingsCollectionView()
        return collectionView
    }()
    
    let emptyStateView: HoldingsEmptyStateView = {
        return HoldingsEmptyStateView()
    }()
    
    let summaryView: PortfolioSummaryView = {
        let view = PortfolioSummaryView()
        view.clipsToBounds = false
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -10)
        return view
    }()

    init(environment: Environment,
         portfolioService: PortfolioServicible) {
        
        self.viewModel = PortfolioViewModel(environment: environment,
                                                portfolioService: portfolioService)
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.onStateChange = { [weak self] in self?.handle(stateChange: $0)}
        self.holdingsCollectionView.dataSource = self
        self.holdingsCollectionView.holdingsDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// Adds support for iPhone & iPad with landscape and portrait modes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = holdingsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else {
            return
        }
        flowLayout.invalidateLayout()
    }


    func setupUI() {
        self.holdingsCollectionView.emptyStateView = emptyStateView
        self.setupNavigationBar()

        view.backgroundColor = Theme.backgroundColor
        view.addSubview(self.holdingsCollectionView)
        view.addSubview(self.summaryView)
        self.setupConstraints()
        self.setupActions()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Theme.refreshIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(self.refreshButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Theme.navigationButtonTintColor
        navigationItem.title = "Portfolio"
        navigationController?.navigationBar.isTranslucent = false
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = Theme.navigationBarBackgroundColor
        navigationController?.navigationBar.standardAppearance = barAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
    }
    
    func setupConstraints() {
        holdingsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Metrics.collapsedSummaryViewHeight + Metrics.standardPadding)
        }
        
        summaryView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            make.height.greaterThanOrEqualTo(Metrics.collapsedSummaryViewHeight)
        }
    }
    
    func handle(stateChange: PortfolioViewModel.StateChanges) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            switch stateChange {
            case .openHoldingDetails(let holding):
                self.openHoldingDetailsScreen(for: holding)
                
            case .reloadAll:
                self.updateSummaryView()
                self.setupEmptyStateViews(to: self.viewModel.state.holdings.isEmpty ? .empty : .loaded)
                self.holdingsCollectionView.reloadData()
                if !self.viewModel.state.holdings.isEmpty {
                    self.holdingsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredVertically, animated: true)
                }
                
            case .reloadItems(let itemTuples):
                self.updateSummaryView()
                self.setupEmptyStateViews(to: .loaded)
                self.holdingsCollectionView.performBatchUpdates { [weak self] in
                    let indexPaths = itemTuples.map { IndexPath(item: $0.index, section: 0) }
                    self?.holdingsCollectionView.reloadItems(at: indexPaths)
                }
                
            case .showGeneralError(let title, let error):
                self.setupEmptyStateViews(to: .empty)
                self.presentAlert(title: title, message: "Error: \(error)")
            }
        }
    }
    
    func setupEmptyStateViews(to state: HoldingsEmptyStateView.State) {
        self.emptyStateView.set(state: state)
        self.navigationItem.rightBarButtonItem?.tintColor = state == .loading ? Theme.disabledUIControlColor : Theme.navigationButtonTintColor
    }
    
    func updateSummaryView() {
        summaryView.set(currentValue: self.viewModel.state.currentTotalValue,
                        totalInvestment: self.viewModel.state.totalInvestment,
                        todayReturns: self.viewModel.state.todayReturns,
                        totalReturns:  self.viewModel.state.totalReturns)
    }
}
