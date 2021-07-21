//
//  SettingsViewModel.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/19/21.
//

import Foundation

class SettingsViewModel: ObservableObject {
	
	@Published var settings: FilterSettingsModel
	
	private let persistence = PersistenceController.shared
	
	init() {
		let entity = persistence.getFilterSettings()
		self.settings = FilterSettingsModel(isCall: entity.call, isMessage: entity.message)
	}
	
	func updateFilterSettings() {
		DispatchQueue.global(qos: .default).async {
			let s = self.persistence.getFilterSettings()
			s.call = self.settings.isCall
			s.message = self.settings.isMessage
			self.persistence.saveFilterSettings(settings: s)
		}
	}
}
