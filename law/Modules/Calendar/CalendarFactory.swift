//
//  CalendarFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 06.01.25.
//

import UIKit

final class CalendarFactory {
	static func create() -> CalendarViewController {
		CalendarViewController(viewModel: CalendarViewModel())
	}
}
