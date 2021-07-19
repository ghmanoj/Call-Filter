//
//  StatisticsViewModel.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/17/21.
//

import Foundation


class StatisticsViewModel: ObservableObject {
	
	@Published var actionStatistics: ActionsStatistics
	@Published var topLocationStatistics: [SpammerLocation]
	
	init() {
		actionStatistics = ActionsStatistics(calls: 0, sms: 0, blockedPercent: 0)
		topLocationStatistics = []
	}
	
	func fetchActionStatistics() {
		// get statistics and update from dispatchqueuemain
		actionStatistics = ActionsStatistics(calls: 3234, sms: 32423, blockedPercent: 0.9)
	}
	
	func fetchTopLocationStatistics() {
		topLocationStatistics = [
			.init(state: "Arizona", count: 100),
			.init(state: "California", count: 50),
			.init(state: "New York", count: 3290),
			.init(state: "Ohio", count: 321)
		]
	}
}
