//
//  TVfootballApp.swift
//  TVfootball
//
//  Created by Денис on 19.08.2020.
//

import SwiftUI

@main
struct TVfootballApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ScheduleStore(service: .init()))
        }
    }
}
