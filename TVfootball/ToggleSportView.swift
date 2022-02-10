//
//  ToggleSportView.swift
//  TVfootball
//
//  Created by Денис on 10.02.2022.
//

import SwiftUI

struct ToggleSportView: View {
    @EnvironmentObject var scheduleStore: ScheduleStore
    
    let sport: SportType
    @AppStorage var isOn: Bool
    
    init(sport: SportType) {
        self.sport = sport
        self._isOn = AppStorage(wrappedValue: false, sport.key, store: UserDefaults(suiteName: "home.TVfootball.tv"))
    }
    
    var body: some View {
        Toggle(sport.name, isOn: $isOn).onChange(of: isOn) { _ in
            scheduleStore.fetch()
        }
    }
}
