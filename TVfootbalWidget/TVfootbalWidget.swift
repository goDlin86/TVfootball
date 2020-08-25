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
        ScheduleEntry(date: Date(), items: ["--"])
    }

    func getSnapshot(in context: Context, completion: @escaping (ScheduleEntry) -> ()) {
        let entry = ScheduleEntry(date: Date(), items: ["--"])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ScheduleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = ScheduleEntry(date: entryDate, items: ["matchtv"])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ScheduleEntry: TimelineEntry {
    let date: Date
    let items: [String]
}

struct TVfootbalWidgetEntryView : View {
    var items: [String]

    var body: some View {
        ForEach(items, id: \.self) { item in
            Text(item)
        }
    }
}

@main
struct TVfootbalWidget: Widget {
    let kind: String = "TVfootbalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TVfootbalWidgetEntryView(items: entry.items)
        }
        .configurationDisplayName("TV football")
        .description("Match TV football")
    }
}

struct TVfootbalWidget_Previews: PreviewProvider {
    static var previews: some View {
        TVfootbalWidgetEntryView(items: ["--"])
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
