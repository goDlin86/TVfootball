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
    
    @AppStorage("isFootball", store: UserDefaults(suiteName: "tv")) private var isFootball: Bool?
    @AppStorage("isBiathlon", store: UserDefaults(suiteName: "tv")) private var isBiathlon: Bool?
    
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
        var sports: [String] = []
        if isFootball ?? true {
            sports.append("Футбол")
        }
        if isBiathlon ?? false {
            sports.append("Биатлон")
        }
        
        service.fetch(date: Date(), sports: sports) { result in
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
            HStack {
                Text(day.date.capitalized)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(.gray)
                Spacer()
                Image("MatchTV")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            .padding(.bottom, 5)
            ForEach(day.items.prefix(2), id: \.time) {
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

struct TVfootbalWidget_Previews: PreviewProvider {
    static var previews: some View {
        TVfootbalWidgetEntryView(day: ScheduleDay(date: "27 august", items: []))
    }
}
