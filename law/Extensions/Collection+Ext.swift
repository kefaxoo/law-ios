//
//  Collection+Ext.swift
//  law
//
//  Created by Bahdan Piatrouski on 25.02.25.
//

import Foundation

extension Collection {
    subscript(safeAt index: Self.Index) -> Element? {
        guard self.indices.contains(index) else { return nil }
        
        return self[index]
    }
}
