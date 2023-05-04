//
//  TVfootballApp.swift
//  TVfootball
//
//  Created by Денис on 19.08.2020.
//

import SwiftUI

@main
struct TVfootballApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ScheduleStore(service: .init()))
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
