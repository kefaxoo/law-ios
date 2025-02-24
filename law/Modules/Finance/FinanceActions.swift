//
//  FinanceActions.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import Foundation

enum FinanceActions: CaseIterable {
    case financeOperations
    case receivables // задолженность
}

extension FinanceActions: ActionsProtocol {
    var title: String {
        switch self {
            case .financeOperations:
                "Финансовые операции"
            case .receivables:
                "Дебиторская задолженность"
        }
    }
    
    var vc: BaseViewController {
        switch self {
            case .financeOperations:
                FinanceOperationsFactory.create()
            default:
                ReceivablesClientsFactory.create()
        }
    }
}
