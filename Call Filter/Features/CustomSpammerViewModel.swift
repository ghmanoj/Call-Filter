//
//  CustomSpammerViewModel.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/27/21.
//

import Foundation

class CustomSpammerViewModel: ObservableObject {
	@Published var manualInput: [SpammerModel] = []
	
	private let persistence = PersistenceController.shared

	init() {
		fetchManualInputData()
	}
	
	func fetchManualInputData() {
		DispatchQueue.global(qos: .userInitiated).async {
			self.persistence.getManualInputSpammers(limit: 10) { entities in
				
				let modelMap = entities.map { entity in
					SpammerModel(
						id: Int(entity.id),
						number: entity.number!,
						state: entity.location!,
						type: entity.type == 0 ? .call : .sms,
						manual: entity.manual
					)
				}
				DispatchQueue.main.async { self.manualInput = modelMap }
			}
		}
	}
	
}
