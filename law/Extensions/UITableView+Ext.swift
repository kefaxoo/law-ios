//
//  UITableView+Ext.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

extension UITableView {
    func register(_ cells: BaseTableViewCell.Type...) {
        cells.forEach({ self.register($0, forCellReuseIdentifier: $0.id) })
    }
}
