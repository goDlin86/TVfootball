//
//  TVfootbalWidget.swift
//  TVfootbalWidget
//
//  Created by Денис on 25.08.2020.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ScheduleEntry {
        ScheduleEntry(date: Date(), day: ScheduleDay(date: "", items: []))
    }

    func getSnapshot(in context: Context, completion: @escaping (ScheduleEntry) -> ()) {
        let entry = ScheduleEntry(date: Date(), day: ScheduleDay(date: "", items: []))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ScheduleEntry] = []
        
        let service = ScheduleService()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "ru_Ru")
        dayFormatter.dateFormat = "EEEE, dd MMM"
        
        service.fetch(date: dateFormatter.string(from: date)) { result in
            var day: ScheduleDay
            switch result {
            case .success(let items):
                day = ScheduleDay(
                    date: dayFormatter.string(from: date),
                    items: items.filter { $0.title.contains("Футбол") }
                )
            case .failure:
                day = ScheduleDay(date: dayFormatter.string(from: date), items: [])
            }
        

            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = ScheduleEntry(date: entryDate, day: day)
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
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
        Text(day.date)
        ForEach(day.items, id: \.time) { item in
            Text(item.title)
        }
    }
}

@main
struct TVfootbalWidget: Widget {
    let kind: String = "TVfootbalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TVfootbalWidgetEntryView(day: entry.day)
        }
        .configurationDisplayName("TV football")
        .description("Match TV football")
    }
}
