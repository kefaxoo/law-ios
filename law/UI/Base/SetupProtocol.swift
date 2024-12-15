//
//  SetupProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation

protocol SetupProtocol {}

extension SetupProtocol where Self: AnyObject {
    func setup(_ completion: (Self) throws -> Void) rethrows -> Self {
        try completion(self)
        return self
    }
}

extension NSObject: SetupProtocol {}
