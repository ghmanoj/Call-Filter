//
//  SettingsViewModel.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/19/21.
//

import Foundation

class SettingsViewModel: ObservableObject {
	@Published var isCallFilterOn: Bool = false
	@Published var isMessageFilterOn: Bool = false
	
	
	init() {
		getUserSettings()
	}
	
	func onCallFilterUpdate() {
		
	}
	
	func onMessageFilterUpdate() {
		
	}
	
	private func getUserSettings() {
		// get things from persistence
		isCallFilterOn = true
		isMessageFilterOn = false
	}
}
