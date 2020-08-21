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
        ScrollView {
            VStack(alignment: .leading) {
                Text(day.date.capitalized)
                    .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
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
            .frame(maxHeight: 500)
        }
    }
}

struct ScheduleDayRow_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleDayRow(day: ScheduleDay(date: "12313", items: []))
    }
}
