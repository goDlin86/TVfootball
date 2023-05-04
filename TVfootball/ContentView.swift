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
            LazyVGrid(columns: gridItemLayout, alignment: .leading) {
                ForEach(scheduleStore.data, id: \.date) {
                    day in ScheduleDayRow(day: day)
                }
            }
            .padding(10)
        }
        .frame(minWidth: 1100, minHeight: 600, alignment: .center)
        .onAppear(perform: scheduleStore.fetch)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
