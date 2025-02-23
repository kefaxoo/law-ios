//
//  AddEventFactory.swift
//  law
//
//  Created by Bahdan Piatrouski on 06.01.25.
//

import UIKit

final class AddEventFactory {
    static func create(eventToShow event: CalendarEvent? = nil) -> AddEventViewController {
        AddEventViewController(viewModel: AddEventViewModel(eventToShow: event))
	}
}
