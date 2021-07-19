//
//  SpammerDbUpdateViewModel.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/16/21.
//

import Foundation

class DbUpdateViewModel: ObservableObject {
	
	@Published var isUpdating = false
	
	
	private let spamDbApiService = SpamDbApiService()

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
						print(result)
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
