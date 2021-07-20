//
//  Call_FilterApp.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/14/21.
//

import SwiftUI

@main
struct CallFilterApp: App {
	@StateObject var dbUpdateViewModel = DbUpdateViewModel()
	@StateObject var statisticsViewModel = StatisticsViewModel()
	@StateObject var lookupViewModel = LookupViewModel()
	@StateObject var settingsViewModel = SettingsViewModel()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(dbUpdateViewModel)
				.environmentObject(statisticsViewModel)
				.environmentObject(lookupViewModel)
				.environmentObject(settingsViewModel)
		}
	}
}
