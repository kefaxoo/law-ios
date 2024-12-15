//
//  BaseTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    static var id: String { String(describing: Self.self) }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupInterface()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInterface() {
        self.setupLayout()
        self.setupConstraints()
    }
    
    func setupLayout() {}
    func setupConstraints() {}
}
