//
//  CalendarViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 06.01.25.
//

import UIKit

final class CalendarViewController: BaseViewController {
    private lazy var calendarView = UICalendarView().setup {
        let calendar = Calendar(identifier: .gregorian)
        $0.calendar = calendar
        let selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        selectionBehavior.setSelected(calendar.dateComponents([.year, .month, .day], from: Date()), animated: false)
        $0.selectionBehavior = selectionBehavior
        $0.delegate = self
        if let currentDate = Date.currentDate?.addingTimeInterval(-90 * 86400),
           let maxDate = Date.max {
            $0.availableDateRange = DateInterval(start: currentDate, end: maxDate)
        }
    }
    
    private lazy var eventsTableView = UITableView().setup {
        $0.dataSource = self
        $0.register(TextTableViewCell.self)
        $0.delegate = self
    }
    
    private let viewModel: CalendarViewModelProtocol

	init(viewModel: CalendarViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupLayout() {
        self.view.addSubview(self.calendarView)
        self.view.addSubview(self.eventsTableView)
    }
    
    override func setupConstraints() {
        self.calendarView.snp.makeConstraints({ $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide) })
        self.eventsTableView.snp.makeConstraints { make in
            make.top.equalTo(self.calendarView.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Календарь"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBarButtonItemDidTap))
    }
    
    override func setupBindings() {
        self.viewModel.pushVC.sink { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .fetchEvents).receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.viewModel.fetchEvents()
        }.store(in: &cancellables)
        
        self.viewModel.eventsPublished.sink { [weak self] events in
            self?.calendarView.reloadInputViews()
            self?.calendarView.invalidateIntrinsicContentSize()
            let currentMonth = Calendar(identifier: .gregorian).component(.month, from: Date())
            let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())
            let forThisMonth = events.compactMap({ Calendar.current.dateComponents([.year, .month, .day], from: $0.date.toDate) })
                .filter({ $0.year == currentYear && $0.month == currentMonth })
            
            if !forThisMonth.isEmpty{
                self?.calendarView.reloadDecorations(forDateComponents: forThisMonth, animated: true)
            }
        }.store(in: &cancellables)
        
        self.viewModel.eventsToShowPublished.sink { [weak self] _ in
            self?.eventsTableView.reloadData()
        }.store(in: &cancellables)
        
        self.viewModel.present.sink { [weak self] vc in
            self?.present(vc, animated: true)
        }.store(in: &cancellables)
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate
extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        self.viewModel.dateDidSelect(dateComponents: dateComponents)
    }
}

// MARK: - Actions
private extension CalendarViewController {
    @objc func rightBarButtonItemDidTap(_ sender: UIBarButtonItem) {
        self.viewModel.rightBarButtonDidTap()
    }
}

// MARK: - UICalendarViewDelegate
extension CalendarViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        guard self.viewModel.events.contains(where: { $0.date == dateComponents }) else { return nil }
        
        return UICalendarView.Decoration.default(color: .systemRed, size: .small)
    }
}

// MARK: - UITableViewDataSource
extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.eventsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.id, for: indexPath)
        (cell as? TextTableViewCell)?.text = self.viewModel.eventsToShow[indexPath.row].calendarScreenText
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.eventDidTap(at: indexPath)
    }
}
