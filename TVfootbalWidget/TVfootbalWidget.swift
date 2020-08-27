//
//  TVfootbalWidget.swift
//  TVfootbalWidget
//
//  Created by Денис on 25.08.2020.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    let service = ScheduleService()
    
    func placeholder(in context: Context) -> ScheduleEntry {
        ScheduleEntry(date: Date(), day: ScheduleDay(date: "23 aug", items: []))
    }

    func getSnapshot(in context: Context, completion: @escaping (ScheduleEntry) -> ()) {
        let entry = ScheduleEntry(date: Date(), day: ScheduleDay(date: "23 aug", items: []))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let components = DateComponents(hour: 2)
        let futureDate = Calendar.current.date(byAdding: components, to: Date())!
        
        service.fetch(date: Date()) { result in
            var sDay: ScheduleDay
            switch result {
            case .success(let day):
                sDay = day
            case .failure:
                sDay = ScheduleDay(date: "23 aug", items: [])
            }
        
            let entry = ScheduleEntry(date: Date(), day: sDay)

            let timeline = Timeline(entries: [entry], policy: .after(futureDate))
            completion(timeline)
        }
    }
}

struct ScheduleEntry: TimelineEntry {
    let date: Date
    let day: ScheduleDay
}

struct TVfootbalWidgetEntryView : View {
    let day: ScheduleDay

    var body: some View {
        VStack(alignment: .leading) {
            Text(day.date.capitalized)
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            ForEach(day.items, id: \.time) {
                item in ScheduleRow(item: item)
            }
        }
        .padding(10)
    }
}

@main
struct TVfootbalWidget: Widget {
    let kind: String = "TVfootballWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TVfootbalWidgetEntryView(day: entry.day)
        }
        .configurationDisplayName("TV football")
        .description("Match TV football")
    }
}
