//
//  ScheduleStore.swift
//  TVfootball
//
//  Created by Денис on 19.08.2020.
//

import SwiftUI

final class ScheduleStore: ObservableObject {
    @Published private(set) var data: [ScheduleDay] = []
    
    @AppStorage("isFootball", store: UserDefaults(suiteName: "tv")) private var isFootball: Bool?
    @AppStorage("isBiathlon", store: UserDefaults(suiteName: "tv")) private var isBiathlon: Bool?
    
    private let service: ScheduleService
    init(service: ScheduleService) {
        self.service = service
    }

    func fetch() {
        let date = Date()
        
        var sports: [String] = []
        if isFootball ?? true {
            sports.append("Футбол")
        }
        if isBiathlon ?? false {
            sports.append("Биатлон")
        }
        
        data = [ScheduleDay](repeating: ScheduleDay(date: "", items: []), count: 7)
        
        for i in 0...6 {
            let newDate = Calendar.current.date(byAdding: .day, value: i, to: date)!
            
            service.fetch(date: newDate, sports: sports) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let day):
                        self?.data[i] = day
                    case .failure:
                        print(newDate)
                    }
                }
            }
        }
    }
}
