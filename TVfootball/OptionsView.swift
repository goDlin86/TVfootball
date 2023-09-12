//
//  OptionsView.swift
//  TVfootball
//
//  Created by Денис on 13.01.2022.
//

import SwiftUI

struct OptionsView: View {
    
    var body: some View {
        HStack {
            ForEach(Config.sports, id: \.key) {  ToggleSportView(sport: $0)
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    OptionsView()
}
