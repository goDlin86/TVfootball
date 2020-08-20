//
//  ContentView.swift
//  TVfootball
//
//  Created by Денис on 19.08.2020.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var scheduleStore: ScheduleStore
    
    var body: some View {
        List {
            ForEach(scheduleStore.items) {
                item in ScheduleRow(item: item)
            }
        }.onAppear(perform: fetch)
    }
    
    private func fetch() {
        scheduleStore.fetch()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
