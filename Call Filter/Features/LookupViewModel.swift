//
//  LookupViewModel.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/16/21.
//


import SwiftUI
import Combine


class LookupViewModel: ObservableObject {
	
	@Published var numberQuery = ""
	@Published private(set) var showPrompt = true
	@Published private(set) var spammer: [SpammerModel] = []
	
	private let persistence = PersistenceController.shared
	
	
	private static let phonePattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
	// private static let phonePattern = #"^\d{3}-\d{3}-\d{4}$"#

	
	private let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", phonePattern)
	
	private var isPhoneNumberValidPubliser: AnyPublisher<Bool, Never> {
		$numberQuery
			.receive(on: RunLoop.main)
			.removeDuplicates()
			.map { input in
				return self.phoneCheck.evaluate(with: input)
			}
			.eraseToAnyPublisher()
	}
	
	var phValidationCancellable: AnyCancellable?
		
	init() {
		phValidationCancellable = isPhoneNumberValidPubliser
			.sink(receiveValue: { valid in
				self.showPrompt = !valid
				if valid {
					print("Number format is \(self.numberQuery)")
					let formatted = self.numberQuery.toPhoneNumber()
					self.lookupSpammer(formatted)
				} else {
					print("Invalid and query number is \(self.numberQuery)")
					self.spammer = []
				}
			})
	}
	
	
	func lookupSpammer(_ number: String) {
		let spammerEntities = persistence.getSpammers(number)
				
		DispatchQueue.main.async {
			self.spammer = spammerEntities.map { item in
				SpammerModel(
					id: Int(item.id),
					number: item.number!,
					state: item.location!,
					type: item.type == 0 ? .call : .sms
				)
			}
		}
	}
}

extension String {
	public func toPhoneNumber() -> String {
		return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "$1-$2-$3", options: .regularExpression, range: nil)
	}
}
