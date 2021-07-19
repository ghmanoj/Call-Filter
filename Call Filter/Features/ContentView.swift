//
//  ContentView.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/14/21.
//

import SwiftUI
import Combine

struct ContentView: View {
	
	@State var isLookup = true
	
	var body: some View {
		VStack {
			if isLookup {
				LookupView()
			} else {
				FilterView()
			}
			BottomBar(isLookup: $isLookup)
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
