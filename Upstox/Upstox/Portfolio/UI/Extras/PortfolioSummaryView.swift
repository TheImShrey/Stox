//
//  PortfolioSummaryView.swift
//  Upstox
//
//  Created by Shreyash Shah on 24/05/24.
//

import UIKit
import SnapKit

class PortfolioSummaryView: UIView {
    enum ExpansionState {
        case expanded
        case collapsed
    }
    
    private(set) var expansionState: ExpansionState = .expanded
    
    var currentValue: Double
    var todayReturns: Double
    var totalReturns: Double
    var totalInvestment: Double
    
    private let tapGesture = UITapGestureRecognizer()
    private var animator: UIViewPropertyAnimator?

    private let currentValueView: LongInfoView = {
        let view = LongInfoView(title: "Current Value*")
        return view
    }()
    
    private let totalInvestmentView: LongInfoView = {
        let view = LongInfoView(title: "Total Investment*")
        return view
    }()
    
    private let todayReturnsView: LongInfoView = {
        let view = LongInfoView(title: "Today's Profit & Loss*")
        return view
    }()
    
    private let totalReturnsView: LongInfoView = {
        let view = LongInfoView(title: "Profit & Loss*  ▲")
        return view
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 6
        return stackView
    }()
    
    init(currentValue: Double = 0,
         todayReturns: Double = 0,
         totalReturns: Double = 0,
         totalInvestment: Double = 0) {
        self.currentValue = currentValue
        self.todayReturns = todayReturns
        self.totalReturns = totalReturns
        self.totalInvestment = totalInvestment
        super.init(frame: .zero)
        self.setupView()
        self.resetContent()
        self.set(expansion: .collapsed)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        tapGesture.removeTarget(self, action: #selector(expand))
    }
    
    func setupView() {
        self.backgroundColor = .tertiarySystemBackground
        
        stackView.addArrangedSubview(currentValueView)
        stackView.addArrangedSubview(totalInvestmentView)
        stackView.addArrangedSubview(todayReturnsView)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(totalReturnsView)

        addSubview(stackView)
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
        setupActions()
    }
    
    private func set(expansion state: ExpansionState) {
        self.expansionState = state
        switch state {
        case .collapsed:
            totalReturnsView.set(title: "Profit & Loss*  ▲")
            stackView.arrangedSubviews
                .forEach { $0.isHidden = $0 != totalReturnsView }
        case .expanded:
            totalReturnsView.set(title: "Profit & Loss*  ▼")
            stackView.arrangedSubviews
                .forEach { $0.isHidden = false }
        }
    }
    
    private func setupActions() {
        tapGesture.addTarget(self, action: #selector(expand))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    private func resetContent() {
        currentValueView.set(value: "\(currentValue.formatted(.currency(code: "INR")))")
        
        totalInvestmentView.set(value: "\(totalInvestment.formatted(.currency(code: "INR")))")
        
        todayReturnsView.set(value: "\(todayReturns.formatted(.currency(code: "INR")))")
        todayReturnsView.set(valueColor: todayReturns < 0 ? .systemRed : .systemGreen)
        
        totalReturnsView.set(value: "\(totalReturns.formatted(.currency(code: "INR")))")
        totalReturnsView.set(valueColor: totalReturns < 0 ? .systemRed : .systemGreen)
    }
    
    func set(currentValue: Double,
             totalInvestment: Double,
             todayReturns: Double,
             totalReturns: Double) {
        self.currentValue = currentValue
        self.totalInvestment = totalInvestment
        self.todayReturns = todayReturns
        self.totalReturns = totalReturns
        self.resetContent()
    }
    
    @objc 
    func expand() {
        animator?.stopAnimation(true)
        switch expansionState {
        case .collapsed:
            self.animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
                self.set(expansion: .expanded)
                self.layoutIfNeeded()
            }
            animator?.startAnimation()
        default:
            break
        }
    }
    
    func collapse() {
        animator?.stopAnimation(true)
        switch expansionState {
        case .expanded:
            self.animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
                self.set(expansion: .collapsed)
                self.layoutIfNeeded()
            }
            animator?.startAnimation()
        default:
            break
        }
    }
}
