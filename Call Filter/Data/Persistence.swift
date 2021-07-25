//
//  Persistence.swift
//  Call Filter
//
//  Created by Manoj Ghimire on 7/20/21.
//

import Foundation
import CoreData


class PersistenceController {
	static let shared = PersistenceController()
	
	private let container: NSPersistentContainer
	
	init() {
		container = NSPersistentContainer(name: "AppPersistenceModel")
		container.loadPersistentStores { description, error in
			if let error = error {
				fatalError("Error loading persistence container \(error)")
			}
			print(description)
		}
		
	}
	
	func getCallSpammerCount() -> Int {
		let ctx = container.viewContext
		let fetchRequest: NSFetchRequest<Spammer> = NSFetchRequest(entityName: "Spammer")

		var callSpammerCount = 0
		
		do {
			let spammers = try ctx.fetch(fetchRequest)
			callSpammerCount = spammers.filter { $0.type == 0 }.count
		} catch {
			print("Error while fetching spammer info \(error)")
		}
		return callSpammerCount
	}
	
	func getSmsSpammerCount() -> Int {
		let ctx = container.viewContext
		let fetchRequest: NSFetchRequest<Spammer> = NSFetchRequest(entityName: "Spammer")

		var smsSpammerCount = 0
		
		do {
			let spammers = try ctx.fetch(fetchRequest)
			smsSpammerCount = spammers.filter { $0.type == 1 }.count
		} catch {
			print("Error while fetching spammer info \(error)")
		}
		return smsSpammerCount
	}
	
	
	func getFilterSettings() -> FilterSettings {
		let ctx = container.viewContext
		let fetchRequest: NSFetchRequest<FilterSettings> = NSFetchRequest(entityName: "FilterSettings")
		
		var settings: FilterSettings?
		
		do {			
			settings = try ctx.fetch(fetchRequest).first
		} catch {
			print("Error while fetching filter settings \(error)")
		}
		
		if settings == nil {
			settings = FilterSettings(context: ctx)
			settings!.call = false
			settings!.message = false
			saveFilterSettings(settings: settings!)
		}
		
		return settings!
	}
	
	
	func saveFilterSettings(settings: FilterSettings) {
		let ctx = container.viewContext
		
		if settings.isUpdated {
			do {
				ctx.perform {
					
				}
				try ctx.save()
			} catch {
				print("Error while saving filter settings \(error)")
			}
		}
	}
	
	func saveSpamDb(spammerModel: [SpammerModel]) {
		let ctx = container.viewContext
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spammer")
		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		
		do {
			try ctx.execute(batchDeleteRequest)
		} catch {
			print("Error while truncating Spammer table \(error)")
		}

		
		var spammers = [Spammer]()
		
		for i in 0..<spammerModel.count {
			let model = spammerModel[i]
			
			let sp = Spammer(context: ctx)
			sp.id = Int64(model.id)
			sp.location = model.state
			sp.number = model.number
			sp.type = model.type == .call ? 0 : 1
			
			spammers.append(sp)
		}
		
		do {
			try ctx.save()
		} catch {
			print("Error while saving spammer database \(error)")
		}
	}
	
	func getSpammers(_ number: String) -> [Spammer] {
		let ctx = container.viewContext
		let fetchRequest: NSFetchRequest<Spammer> = NSFetchRequest(entityName: "Spammer")
		let predicate = NSPredicate(format: "number BEGINSWITH[c] %@", number)
		fetchRequest.predicate = predicate
		
		var spammers = [Spammer]()
		
		do {
			spammers = try ctx.fetch(fetchRequest)
		} catch {
			print("Error while fetching spammer info \(error)")
		}
		
		return spammers
	}

}
