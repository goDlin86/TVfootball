//
//  ScheduleRow.swift
//  TVfootball
//
//  Created by Денис on 19.08.2020.
//

import SwiftUI

struct ScheduleRow: View {
    let item: ScheduleItem

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.time)
                .font(.subheadline)
                .foregroundColor(Color(white: 1, opacity: 0.6))
            Text(item.title)
                .font(.headline)
                .foregroundColor(Color(white: 1, opacity: 0.85))
        }
        .padding(.vertical, 1)
    }
}
