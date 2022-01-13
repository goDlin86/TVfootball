//
//  ContentView.swift
//  TVfootball
//
//  Created by Денис on 19.08.2020.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var scheduleStore: ScheduleStore
    
    private var gridItemLayout: [GridItem] =
    Array(repeating: .init(.flexible(), alignment: .top), count: 7)
    
    var body: some View {
        ScrollView {
            OptionsView()
            LazyVGrid(columns: gridItemLayout, alignment: .center) {
                ForEach(scheduleStore.data, id: \.date) {
                    day in ScheduleDayRow(day: day)
                }
            }
            .padding(10)
        }
        .frame(minWidth: 800, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity, alignment: .center)
        .onAppear(perform: fetch)
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
