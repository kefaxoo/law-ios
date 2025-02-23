//
//  LaywerAnalyticsViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 23.02.25.
//

import UIKit

final class LaywerAnalyticsViewModel: TypeAnalyticsViewModelProtocol {
    @Published var isPeriod = false
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
    var push = CPassthroughSubject<BaseViewController>()
    
    @UserDefaultsWrapper(key: .currentUserId, value: nil)
    private var currentUserId: String?
    private var currentUser: User?
    
    private var laywers = [User]()
    
    init() {
        DatabaseService.shared.fetchObjects(type: User.self) { [weak self] objects, error in
            self?.laywers = objects ?? []
            if let currentUserId = self?.currentUserId {
                self?.currentUser = objects?.first(where: { $0.id == currentUserId })
            }
        }
    }
}

// MARK: - Actions
extension LaywerAnalyticsViewModel {
    func periodTextFieldDidSelect(isBegin: Bool) {
        if !isBegin,
           self.selectedStartPeriod == nil {
            self.present.send(UIAlertController.okAlert(title: "Ошибка", message: "Выберите дату начала периода, чтобы выбрать дату конца периода"))
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
                self.present.send(UIAlertController.okAlert(title: "Ошибка", message: "Выберите начало периода"))
                return
            }
            
            var predicate: Predicate<ClientCase> = .true
            if let selectedEndPeriod = selectedEndPeriod?.timeIntervalSince1970 {
                predicate = #Predicate { $0.startDate >= selectedStartPeriod.timeIntervalSince1970 && $0.endDate ?? (selectedEndPeriod + 1) <= selectedEndPeriod }
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
private extension LaywerAnalyticsViewModel {
    func casesDidFetch(_ cases: [ClientCase]) {
        guard !cases.isEmpty else {
            self.present.send(UIAlertController.okAlert(title: "Ошибка", message: "Дел за выбранный период не было найдено"))
            return
        }
        
        let laywersCount = "👨‍⚖ Общее количество адвокатов: \(self.laywers.count)"
        let casesCount = "📂 Всего дел: \(cases.count)"
        let averageCaseCount = "✅ Среднее количество дел на адвоката: \(self.laywers.count / cases.count)"
        
        let casesDuration = cases.filter({ $0.endDate != nil }).compactMap({ $0.endDate! - $0.startDate })
        let averageDuration = casesDuration.reduce(0, +) / Double(casesDuration.count) / 86400
        let averageDurationCase: String
        if averageDuration.isNaN || averageDuration.isInfinite {
            averageDurationCase = ""
        } else {
            averageDurationCase = "🕒 Средняя длительность работы над делом: \(averageDuration) дней"
        }
        
        let activeCases = "🟢 Активные дела: \(cases.filter({ $0.status == .active }).count)"
        let doneCases = "🔴 Завершенные дела: \(cases.filter({ $0.status == .closed }).count)"
        
        let message = """
            \(laywersCount)
            \(casesCount)
            \(averageCaseCount)
            \(averageDurationCase)
            \n
            \(activeCases)
            \(doneCases)
        """
        
        let alert = UIAlertController(title: "Отчет", message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Выгрузить в PDF", style: .default, handler: { _ in
            let data = PDFManager.createPDFData(metadata: .init(creator: self.currentUser?.login ?? "", title: "Загруженность адвокатов"), title: "Загруженность адвокатов") {
                _ = $0.addMultiLineText(fontSize: 14, weight: .medium, text: message, indent: 74, cursor: $1, pdfSize: $2)
            }
            
            self.present.send(PDFViewerViewController(documentData: data))
        }))

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        
        self.present.send(alert)
    }
}
