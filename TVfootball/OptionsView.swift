//
//  OptionsView.swift
//  TVfootball
//
//  Created by Денис on 13.01.2022.
//

import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var scheduleStore: ScheduleStore
    
    @AppStorage("isFootball", store: UserDefaults(suiteName: "tv")) var isFootball = true
    @AppStorage("isBiathlon", store: UserDefaults(suiteName: "tv")) var isBiathlon = false
    
    var body: some View {
        HStack {
            Toggle("Футбол", isOn: $isFootball).onChange(of: isFootball) { _ in
                scheduleStore.fetch()
            }
            Toggle("Биатлон", isOn: $isBiathlon).onChange(of: isBiathlon) { _ in
                scheduleStore.fetch()
            }
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
