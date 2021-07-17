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
	static var previews: some View {
		ContentView()
	}
}
