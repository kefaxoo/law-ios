//
//  Combine+Typealias.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation
import Combine

typealias CPublisher<T> = AnyPublisher<T, Never>
typealias CPassthroughSubject<T> = PassthroughSubject<T, Never>
