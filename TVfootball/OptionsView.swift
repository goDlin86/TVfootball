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
        .padding(.vertical, 1)
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
