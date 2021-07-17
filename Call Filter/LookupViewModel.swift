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
	@Published var showPrompt = true
	
	private static let phonePattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#

	private let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", phonePattern)
	
	private var isPhoneNumberValidPubliser: AnyPublisher<Bool, Never> {
		$numberQuery
			.removeDuplicates()
			.map { input in
				return self.phoneCheck.evaluate(with: input)
			}
			.eraseToAnyPublisher()
	}
	
	var cancellable: AnyCancellable?

	init() {
		cancellable = isPhoneNumberValidPubliser
			.sink(receiveValue: { valid in
				self.showPrompt = !valid
			})
	}
	
}
