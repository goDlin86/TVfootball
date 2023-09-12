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
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                ForEach(day.date.capitalized.components(separatedBy: ", "), id: \.self) { s in
                    Text(s)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                }
            }.padding(.bottom, 10.0)
            
            ForEach(day.items, id: \.time) {
                item in ScheduleRow(item: item)
            }
        }
        .padding(10)
        .background(Color.black)
        .cornerRadius(10)
        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.7), radius: 10)
    }
}

#Preview {
    ScheduleDayRow(day: ScheduleDay(date: "12313", items: []))
}
