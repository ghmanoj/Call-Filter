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
				.modifier(DarkModeViewModifier())
				.environmentObject(dbUpdateViewModel)
				.environmentObject(statisticsViewModel)
				.environmentObject(lookupViewModel)
				.environmentObject(settingsViewModel)
		}
	}
}


public struct DarkModeViewModifier: ViewModifier {
	@AppStorage("isDarkMode") var isDarkMode: Bool = true
	
	public func body(content: Content) -> some View {
		content
			.environment(\.colorScheme, isDarkMode ? .dark : .light)
			.preferredColorScheme(isDarkMode ? .dark : .light)
	}
}
