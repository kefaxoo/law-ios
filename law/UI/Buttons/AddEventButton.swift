//
//  AddEventButton.swift
//  law
//
//  Created by Bahdan Piatrouski on 26.04.25.
//

import UIKit

final class AddEventButton: UIButton {
    private lazy var iconImageView = UIImageView().setup {
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints({ $0.size.equalTo(19) })
    }
    
    private lazy var textLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 17, weight: .medium)
    }
    
    private lazy var hStackView = UIStackView().setup {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.isUserInteractionEnabled = false
        $0.addArrangedSubview(self.iconImageView)
        $0.addArrangedSubview(self.textLabel)
    }
    
    override var tintColor: UIColor? {
        didSet {
            self.iconImageView.tintColor = self.tintColor
            self.textLabel.textColor = self.tintColor
        }
    }
    
    var image: UIImage? {
        get {
            self.iconImageView.image
        }
        set {
            self.iconImageView.image = newValue
        }
    }
    
    var text: String? {
        get {
            self.textLabel.text
        }
        set {
            self.textLabel.text = newValue
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(self.hStackView)
        self.hStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        self.iconImageView.tintColor = self.tintColor
        self.textLabel.textColor = self.tintColor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
