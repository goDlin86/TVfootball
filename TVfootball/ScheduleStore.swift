//
//  ScheduleStore.swift
//  TVfootball
//
//  Created by Денис on 19.08.2020.
//

import Foundation
import Combine

final class ScheduleStore: ObservableObject {
    @Published private(set) var data: [ScheduleDay] = []
    
    var i = 0

    private let service: ScheduleService
    init(service: ScheduleService) {
        self.service = service
    }

    func fetch() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "ru_Ru")
        dayFormatter.dateFormat = "EEEE, dd MMM"
        
        let newDate = Calendar.current.date(byAdding: .day, value: i, to: date)!
            
        service.fetch(date: dateFormatter.string(from: newDate)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.data.append(
                        ScheduleDay(
                            date: dayFormatter.string(from: newDate),
                            items: items.filter { $0.title.contains("Футбол") }
                        )
                    )
                case .failure:
                    print(newDate)
                    //self?.items = []
                }
                
                if self!.i < 6 {
                    self?.i += 1
                    self?.fetch()
                }
            }
        }
    }
}
