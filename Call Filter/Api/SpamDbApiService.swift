//
//  SpamDbApiService.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/18/21.
//

import Foundation


class SpamDbApiService {
	private let apiUrl = "http://filterapi.mghimire.com:8081/latest_spamdb?size=4096"
	
	func fetchData(pageNumber: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
		guard let url = URL(string: apiUrl) else {
			completion(.failure(.badURL))
			return
		}
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let data = data {
				completion(.success(data))
			} else if error != nil {
				completion(.failure(.requestFailed))
			} else {
				completion(.failure(.unknown))
			}
		}.resume()
	}
}
