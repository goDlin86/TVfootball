//
//  ScheduleDayRow.swift
//  TVfootball
//
//  Created by Денис on 20.08.2020.
//

import SwiftUI

struct ScheduleDayRow: View {
    let day: ScheduleDay

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text(day.date.capitalized)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10.0)
                ForEach(day.items, id: \.time) {
                    item in ScheduleRow(item: item)
                }
            }
            .padding(10)
            .background(Color.black)
            .cornerRadius(10)
            //.frame(maxHeight: 500)
        }
        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.7), radius: 10)
    }
}

struct ScheduleDayRow_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleDayRow(day: ScheduleDay(date: "12313", items: []))
    }
}
