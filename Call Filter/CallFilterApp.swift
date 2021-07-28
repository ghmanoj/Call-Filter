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
	@StateObject var customSpammerViewModel = CustomSpammerViewModel()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.modifier(DarkModeViewModifier())
				.environmentObject(dbUpdateViewModel)
				.environmentObject(statisticsViewModel)
				.environmentObject(lookupViewModel)
				.environmentObject(settingsViewModel)
				.environmentObject(customSpammerViewModel)
		}
	}
}

// https://developer.apple.com/forums/thread/658818
// https://stackoverflow.com/questions/64015565/how-to-implement-a-color-scheme-switch-with-the-system-value-option
public struct DarkModeViewModifier: ViewModifier {
	@AppStorage("isDarkMode") var isDarkMode: Bool = true
	
	public func body(content: Content) -> some View {
//		UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light

		return content
			.environment(\.colorScheme, isDarkMode ? .dark : .light)
			.preferredColorScheme(isDarkMode ? .dark : .light)
	}
}
