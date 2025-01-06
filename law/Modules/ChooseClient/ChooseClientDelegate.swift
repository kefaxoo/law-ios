//
//  ChooseClientDelegate.swift
//  law
//
//  Created by Bahdan Piatrouski on 7.01.25.
//

import Foundation

protocol ChooseClientDelegate: AnyObject {
    func clientDidChoose(_ client: ClientInfo)
}
