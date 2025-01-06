//
//  ChooseCaseDelegate.swift
//  law
//
//  Created by Bahdan Piatrouski on 7.01.25.
//

import Foundation

protocol ChooseCaseDelegate: AnyObject {
    func caseDidChoose(_ case: ClientCase)
}
