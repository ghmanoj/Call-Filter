//
//  SpammerDbUpdateViewModel.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/16/21.
//

import Foundation

class DbUpdateViewModel: ObservableObject {
	
	@Published var isUpdating = false
	
	@Published var spamDbInfo: SpamDbInfo? = nil

	private let spamDbApiService = SpamDbApiService()
	private let persistence = PersistenceController.shared
	
	
	init() {
		updateSpamDbInfo()
	}
	
	private func updateSpamDbInfo() {
		DispatchQueue.main.async {
			let callCount = self.persistence.getCallSpammerCount()
			let smsCount = self.persistence.getSmsSpammerCount()
			self.spamDbInfo = SpamDbInfo(callSpam: callCount, smsSpam: smsCount)
		}
	}
	
	func updateSpamDb() {
		if isUpdating {
			print("Update already started, ignoring this request..")
			return
		}
		
		isUpdating = true
		
		// do db update here
		// like fetching data from api and storing in core data..
		DispatchQueue.global(qos: .userInitiated).async {

			self.spamDbApiService.fetchData(pageNumber: 0) { result in
				switch result {
					case .success(let data):
						let result = self.parseData(data: data)
						print("Received \(result.count) spammer data models")
						
						DispatchQueue.main.async {
							self.persistence.saveSpamDb(spammerModel: result)
						}
						
						self.updateSpamDbInfo()
					case .failure(let error):
						print(error)
				}
				
				DispatchQueue.main.async { self.isUpdating = false }
			}
		}
	}
	
	private func parseData(data: Data) -> [SpammerModel] {
		
		do {
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
		
			let parsedData = try decoder.decode(SpamDbApiResponse.self, from: data)
			return parsedData.spammers
			
		} catch {
			print("Error parsing data \(error)")
		}
		return []
	}
	
}
