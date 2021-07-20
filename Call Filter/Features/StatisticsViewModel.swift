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
	}
	
	func fetchTopLocationStatistics() {
	}
}
