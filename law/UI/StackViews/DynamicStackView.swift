//
//  DynamicStackView.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class DynamicScrollView: BaseView {
    private lazy var mainStackView = {
        $0.distribution = .fill
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    private lazy var mainScrollView = { scrollView in
        scrollView.backgroundColor = .clear
        scrollView.addSubview(self.mainStackView)
        self.mainStackView.snp.makeConstraints({ $0.edges.equalTo(scrollView.contentLayoutGuide) })
        return scrollView
    }(UIScrollView())
    
    private let axis: NSLayoutConstraint.Axis
    
    var showsScrollIndicator: Bool {
        get {
            switch self.axis {
            case .horizontal:
                self.mainScrollView.showsHorizontalScrollIndicator
            case .vertical:
                self.mainScrollView.showsVerticalScrollIndicator
            @unknown default:
                false
            }
        }
        set {
            self.mainScrollView.showsVerticalScrollIndicator = newValue
            self.mainScrollView.showsHorizontalScrollIndicator = newValue
        }
    }
    
    var elements: [UIView] {
        self.mainStackView.subviews
    }
    
    var contentInset: UIEdgeInsets {
        get {
            self.mainScrollView.contentInset
        }
        set {
            self.mainScrollView.contentInset = newValue
        }
    }
    
    init(axis: NSLayoutConstraint.Axis) {
        self.axis = axis
        
        super.init()
    }
    
    override func setupLayout() {
        self.addSubview(self.mainScrollView)
    }
    
    override func setupConstraints() {
        self.mainScrollView.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
    
    func addSubview(_ view: UIView, spacingAfter spacing: CGFloat = 0) {
        self.mainStackView.addArrangedSubview(view)
        self.mainStackView.setCustomSpacing(spacing, after: view)
    }
    
    override func addSubview(_ view: UIView) {
        if view == self.mainScrollView {
            super.addSubview(view)
        } else {
            self.mainStackView.addArrangedSubview(view)
        }
    }
}
