//
//  UsStates.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/29/21.
//

import Foundation


struct USState: Codable {
	var id = UUID()
	let name: String
	let abbreviation: String
	
	private enum CodingKeys: String, CodingKey {
		case name, abbreviation
	}
}

func loadUSStatesFromFile() -> [USState] {
	guard let fileUrl = Bundle.main.url(forResource: "usa_states", withExtension: "json") else {
		fatalError("Error geting path of us_states.json file")
	}
	
	do {
		let data = try String(contentsOf: fileUrl).data(using: .utf8)
		let decoder = JSONDecoder()
		return try decoder.decode([USState].self, from: data!)
	} catch {
		fatalError("Error loading data from us_states.json")
	}
}
