//
//  HoldingItemCell.swift
//  Upstox
//
//  Created by Shreyash Shah on 23/05/24.
//

import UIKit
import SnapKit

class HoldingItemCell: UICollectionViewCell, CollectionViewCellCustomizing {
    struct Theme {
        static let contentViewBackgroundColor: UIColor = .secondarySystemGroupedBackground
        static let holdingNameTextColor: UIColor = .label
        static let profitColor: UIColor = .systemGreen
        static let lossColor: UIColor = .systemRed
        static let defaultInfoValueColor: UIColor = .label
    }
    
    struct Metrics {
        static let stackMinInterItemSpacing: CGFloat = 10
        static let interStackMinPadding: CGFloat = 20
        static let stackViewHeight: CGFloat = 25
        static let contentPadding: CGFloat = 15
    }
    
    private var viewModel: HoldingCellViewModel?
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()

    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = Metrics.interStackMinPadding
        stackView.alignment = .center
        return stackView
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = Metrics.interStackMinPadding
        stackView.alignment = .center
        return stackView
    }()

    private let holdingNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        label.text = "-"
        label.textColor = Theme.holdingNameTextColor
        return label
    }()

    private let lastTradedPriceView: ShortInfoView = {
        let infoView = ShortInfoView()
        return infoView
    }()
    
    private let quantityView: ShortInfoView = {
        let infoView = ShortInfoView()
        return infoView
    }()
    
    private let returnsView: ShortInfoView = {
        let infoView = ShortInfoView()
        return infoView
    }()


    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.setupHierarchy()
        self.setupActions()
        self.setupAppearance()
    }
    
    // MARK: - Appearance Setup
    private func setupAppearance() {
        contentView.backgroundColor = Theme.contentViewBackgroundColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    // MARK: - Hierarchy Setup
    private func setupHierarchy() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(topStackView)
        topStackView.addArrangedSubview(holdingNameLabel)
        topStackView.addArrangedSubview(UIView())
        topStackView.addArrangedSubview(lastTradedPriceView)
        
        containerView.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(quantityView)
        bottomStackView.addArrangedSubview(UIView())
        bottomStackView.addArrangedSubview(returnsView)

        holdingNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lastTradedPriceView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        topStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Metrics.stackViewHeight)
        }
        
        quantityView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        returnsView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        bottomStackView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(Metrics.stackViewHeight)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Metrics.contentPadding)
        }
    }
    
    // MARK: - UI Actions
    private func setupActions() {}
    
    func configure(using holding: Holding) {
        self.viewModel = HoldingCellViewModel(holding: holding)
        self.updateUI()
    }
    
    func updateUI() {
        setHoldingName()
        setLastTradedPrice()
        setQuantity()
        setReturns()
        trackPrice()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        updateUI()
    }
    
    private func setHoldingName() {
        if let viewModel {
            holdingNameLabel.text = viewModel.state.holding.symbol
        } else {
            holdingNameLabel.text = "-"
        }
    }
    
    private func setLastTradedPrice() {
        if let viewModel {
            lastTradedPriceView.set(title: "LTP:",
                                    value: "\(viewModel.state.holding.latestTradedPrice)",
                                    valueColor: Theme.defaultInfoValueColor)
        } else {
            lastTradedPriceView.set(title: "LTP:",
                                    value: "-",
                                    valueColor: Theme.defaultInfoValueColor)
        }
    }
    
    private func setQuantity() {
        if let viewModel {
            quantityView.set(title: "NET QTY:",
                             value: "\(viewModel.state.holding.quantity)",
                             valueColor: Theme.defaultInfoValueColor)
        } else {
            quantityView.set(title: "NET QTY:",
                             value: "-",
                             valueColor: Theme.defaultInfoValueColor)
        }
    }
    
    private func setReturns() {
        if let viewModel {
            let returns = viewModel.state.holding.returns
            returnsView.set(title: "P&L:",
                            value: "\(returns.formatted(.currency(code: "INR")))",
                            valueColor: returns < 0 ? Theme.lossColor : Theme.profitColor)
        } else {
            returnsView.set(title: "P&L:",
                            value: "-",
                            valueColor: Theme.defaultInfoValueColor)
        }
    }

    private func trackPrice() {
        self.viewModel?.onStateChange = { [weak self] stateChange in
            DispatchQueue.main.async {
                guard let self else { return }
                switch stateChange {
                case .priceUpdated:
                    self.setLastTradedPrice()
                    self.setReturns()
                }
            }
        }
    }
}
