//
//  SettingsViewModel.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/19/21.
//

import Foundation

class SettingsViewModel: ObservableObject {
	
	@Published var settings = FilterSettingsModel(isCall: false, isMessage: false)
	
	private let persistence = PersistenceController.shared
	
	init() {
		print("SettingsViewModel: Init()")
		
		persistence.getFilterSettings { fs in
			DispatchQueue.main.async {
				self.settings = FilterSettingsModel(isCall: fs.call, isMessage: fs.message)
			}
		}
	}
	
	func updateFilterSettings() {
		DispatchQueue.global(qos: .default).async {
			self.persistence.getFilterSettings { fs in
				fs.call = self.settings.isCall
				fs.message = self.settings.isMessage
				self.persistence.saveFilterSettings(settings: fs)
			}
		}
	}
}
