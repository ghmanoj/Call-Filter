//
//  SpammerDbUpdateViewModel.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/16/21.
//

import Foundation

class DbUpdateViewModel: ObservableObject {
	
	@Published var updateCounter: Double = 0
	
	private var isUpdating = false
	
	func updateDb() {
		
		if isUpdating {
			print("Update already started, ignoring this request..")
			return
		}
		isUpdating = true
		
		// do db update here
		// like fetching data from api and storing in core data..
		DispatchQueue.global(qos: .userInitiated).async {
			for _ in 0..<10000 {
				DispatchQueue.main.async {
					self.updateCounter += 20
				}
			}
			self.isUpdating = false
		}
	}
	
}
