//
//  CasesAnalyticsViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import UIKit
import SwiftData

final class CasesAnalyticsViewModel: CasesAnalyticsViewModelProtocol {
    @Published private var isPeriod = false
    var isPeriodPublished: CPublisher<Bool> {
        $isPeriod.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published private var selectedStartPeriod: Date?
    var selectedStartPeriodPublished: CPublisher<Date?> {
        $selectedStartPeriod.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published private var selectedEndPeriod: Date?
    var selectedEndPeriodPublished: CPublisher<Date?> {
        $selectedEndPeriod.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var present = CPassthroughSubject<UIViewController>()
    
    @UserDefaultsWrapper(key: .currentUserId, value: nil)
    private var currentUserId: String?
    private var currentUser: User?
    
    init() {
        if let currentUserId {
            DatabaseService.shared.fetchObjects(type: User.self, predicate: #Predicate { $0.id == currentUserId }) { [weak self] objects, error in
                self?.currentUser = objects?.first
            }
        }
    }
}

// MARK: - Actions
extension CasesAnalyticsViewModel {
    func periodTextFieldDidSelect(isBegin: Bool) {
        if !isBegin,
           self.selectedStartPeriod == nil {
            let alert = UIAlertController(title: "Ошибка", message: "Выберите дату начала периода, чтобы выбрать дату конца периода", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
                alert.dismiss(animated: true)
            }))
            
            self.present.send(alert)
            return
        }
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        if !isBegin {
            datePicker.minimumDate = self.selectedStartPeriod
        }
        
        
        let alert = UIAlertController(title: "Выберите \(isBegin ? "начало" : "конец") периода\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { (make) in
            make.centerX.equalTo(alert.view)
            make.top.equalTo(alert.view).offset(16)
        }
        
        let ok = UIAlertAction(title: "Выбрать", style: .default) { _ in
            let date = datePicker.date
            if isBegin {
                self.selectedStartPeriod = date
                if date > self.selectedEndPeriod ?? Date() {
                    self.selectedEndPeriod = nil
                }
            } else {
                self.selectedEndPeriod = date
            }
        }
        
        let cancel = UIAlertAction(title: "Отменить", style: .destructive)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present.send(alert)
    }

    func setIsPeriod(_ value: Bool) {
        self.isPeriod = value
    }
    
    func generateButtonDidTap() {
        if self.isPeriod {
            guard let selectedStartPeriod else {
                let alert = UIAlertController(title: "Ошибка", message: "Выберите начало периода", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
                    alert.dismiss(animated: true)
                }))
                
                self.present.send(alert)
                return
            }
            
            var predicate: Predicate<ClientCase> = .true
            if let selectedEndPeriod {
                predicate = #Predicate { $0.startDate >= selectedStartPeriod.timeIntervalSince1970 && $0.endDate ?? 0 <= selectedEndPeriod.timeIntervalSince1970 }
            } else {
                predicate = #Predicate { $0.startDate >= selectedStartPeriod.timeIntervalSince1970 }
            }
            
            DatabaseService.shared.fetchObjects(type: ClientCase.self, predicate: predicate) { [weak self] objects, error in
                guard let objects else { return }
                
                self?.casesDidFetch(objects)
            }
        } else {
            DatabaseService.shared.fetchObjects(type: ClientCase.self) { [weak self] objects, error in
                guard let objects else { return }
                
                self?.casesDidFetch(objects)
            }
        }
    }
}

// MARK: - Generation
private extension CasesAnalyticsViewModel {
    func casesDidFetch(_ cases: [ClientCase]) {
        guard !cases.isEmpty else {
            let alert = UIAlertController(title: "Ошибка", message: "Дел за выбранный период не было найдено", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
                alert.dismiss(animated: true)
            }))
            
            self.present.send(alert)
            return
        }
        
        let casesCount = "📌 Общее количество дел: \(cases.count)"
        let activeCasesCount = "✅ Активные дела: \(cases.filter({ $0.status == .active }).count)"
        let doneCasesCount = "❌ Закрытые дела: \(cases.filter({ $0.status == .closed }).count)"
        let criminalCasesCount = "Количество уголовных дел: \(cases.filter({ $0.type == .criminal }).count)"
        let civilCasesCount = "Количество гражданских дел: \(cases.filter({ $0.type == .civil }).count)"
        let administrativeCasesCount = "Количество административных дел: \(cases.filter({ $0.type == .administrative }).count)"
        
        let averageDurationText: String
        let durations = cases.filter({ $0.endDate != nil }).compactMap({ $0.endDate! - $0.startDate }).compactMap({ Int($0) })
        if durations.isEmpty {
            averageDurationText = ""
        } else {
            let averageDuration = durations.reduce(0, +) / durations.count / 86400
            averageDurationText = "📊 Средняя длительность дела: \(averageDuration) дней"
        }
            
        let message = """
            \(casesCount)
            \(activeCasesCount)
            \(doneCasesCount)
            \n
            \(criminalCasesCount)
            \(civilCasesCount)
            \(administrativeCasesCount)
            \(averageDurationText)
        """
        
        let alert = UIAlertController(title: "Отчет", message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Выгрузить в PDF", style: .default, handler: { [weak self] _ in
            let data = PDFManager.createPDFData(metadata: .init(creator: self?.currentUser?.login ?? "", title: "Статистика дел"), title: "Статистика дел") {
                _ = $0.addMultiLineText(fontSize: 14, weight: .medium, text: message, indent: 74, cursor: $1, pdfSize: $2)
            }
            
            self?.present.send(PDFViewerViewController(documentData: data))
        }))
        
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: {  _ in
            alert.dismiss(animated: true)
        }))
        
        self.present.send(alert)
    }
}
