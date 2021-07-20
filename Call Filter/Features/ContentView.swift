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
	
	var body: some View {
		VStack {
			switch(layoutType) {
				case .lookup:
					LookupView()
				case .filter:
					FilterView()
				case .settings:
					SettingsView()
			}

			BottomBar(layoutType: $layoutType)
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	@StateObject static var dbUpdateViewModel = DbUpdateViewModel()
	@StateObject static var statisticsViewModel = StatisticsViewModel()
	@StateObject static var lookupViewModel = LookupViewModel()
	
	static var previews: some View {
		ContentView()
			.environmentObject(dbUpdateViewModel)
			.environmentObject(statisticsViewModel)
			.environmentObject(lookupViewModel)	}
}
