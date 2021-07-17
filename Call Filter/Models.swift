//
//  SpammerLocation.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/16/21.
//

import Foundation


struct SpammerLocation: Identifiable {
	var id = UUID()
	let state: String
	let count: Int
}




struct ActionsStatistics {
	let calls: Int
	let sms: Int
	let blockedPercent: Double
}


