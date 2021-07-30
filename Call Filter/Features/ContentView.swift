//
//  ContentView.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/14/21.
//

import SwiftUI
import Combine

struct ContentView: View {
	
	@State var layoutType: LayoutType = .lookup
	
	@EnvironmentObject private var viewModel: DbUpdateViewModel
	
	var body: some View {
		VStack {
			switch(layoutType) {
				case .lookup:
					LookupView()
				case .filter:
					FilterView()
				case .customspammer:
					CustomSpammerView()
				case .settings:
					SettingsView()
			}

			BottomBar(layoutType: $layoutType)
				.onAppear { loadData() }
			
		}
	}
	
	func loadData() {
		DispatchQueue.global(qos: .userInitiated).async {
			viewModel.isSpamDbValid { isValid in
				if isValid {
					print("SpamDB contains data so it is valid")
				}
				DispatchQueue.main.async {
					self.layoutType = isValid ? .lookup : .filter
				}
			}
		}
	}
	
}


struct ContentView_Previews: PreviewProvider {
	@StateObject static var dbUpdateViewModel = DbUpdateViewModel()
	@StateObject static var statisticsViewModel = StatisticsViewModel()
	@StateObject static var lookupViewModel = LookupViewModel()
	@StateObject static var customSpammerViewModel = CustomSpammerViewModel()
	
	static var previews: some View {
		ContentView()
			.environmentObject(dbUpdateViewModel)
			.environmentObject(statisticsViewModel)
			.environmentObject(lookupViewModel)
			.environmentObject(customSpammerViewModel)
	}
}
