//
//  SpammerLocation.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/16/21.
//

import Foundation


struct FilterSettingsModel {
	var isCall: Bool
	var isMessage: Bool
}


struct SpamDbInfo {
	let callSpam: Int
	let smsSpam: Int
}

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


struct SpammerModel: Codable {
	let id: Int
	let number: String
	let state: String
	let type: SpammerType
}


enum SpammerType: Int, Codable {
	case call, sms
}

struct SpamDbApiResponse: Codable {
	let pageNumber: Int
	let moreAvailable: Bool
	let spammers: [SpammerModel]
}

// https://www.hackingwithswift.com/books/ios-swiftui/understanding-swifts-result-type
enum NetworkError: Error {
	case badURL, requestFailed, unknown
}
