//
//  ShortInfoView.swift
//  Upstox
//
//  Created by Shreyash Shah on 23/05/24.
//

import UIKit
import SnapKit

class ShortInfoView: UIView {
    var title: String?
    var value: String?
    var valueColor: UIColor?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        return stackView
    }()
    
    init(title: String? = nil, value: String? = nil, valueColor: UIColor? = nil) {
        self.title = title
        self.value = value
        self.valueColor = valueColor
        super.init(frame: .zero)
        self.setupView()
        self.resetContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)

        addSubview(stackView)
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func resetContent() {
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.textColor = valueColor
    }
    
    func set(title: String, value: String, valueColor: UIColor) {
        self.title = title
        self.value = value
        self.valueColor = valueColor
        self.resetContent()
    }
    
    func set(title: String) {
        self.title = title
        self.resetContent()
    }
    
    func set(value: String) {
        self.value = value
        self.resetContent()
    }
    
    func set(valueColor: UIColor) {
        self.valueColor = valueColor
        self.resetContent()
    }
}
