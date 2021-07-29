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
	
	private let container: NSPersistentContainer!
	
	var context: NSManagedObjectContext {
		return container.viewContext
	}
	
	init() {
		container = NSPersistentContainer(name: "AppPersistenceModel")
		container.loadPersistentStores { description, error in
			if let error = error {
				fatalError("Error loading persistence container \(error)")
			}
			print(description)
		}
	}
	
	func getSpamDbCount(callback: @escaping (Int) -> Void) {
		container.performBackgroundTask { ctx in
			let fetchRequest: NSFetchRequest<Spammer> = NSFetchRequest(entityName: "Spammer")
			var spamDbCount = 0
			do {
				let spammers = try ctx.fetch(fetchRequest)
				spamDbCount = spammers.count
			} catch {
				print("Error while fetching spammer info \(error)")
			}
			callback(spamDbCount)
		}
	}
	
	
	func getSpammerCounts(callback: @escaping (Int, Int) -> Void) {
		
		container.performBackgroundTask { ctx in
			let fetchRequest: NSFetchRequest<Spammer> = NSFetchRequest(entityName: "Spammer")
			
			var callSpammerCount = 0
			var smsSpammerCount = 0
			
			do {
				let spammers = try ctx.fetch(fetchRequest)
				callSpammerCount = spammers.filter { $0.type == 0 }.count
				smsSpammerCount = spammers.filter { $0.type == 1 }.count
				
			} catch {
				print("Error while fetching spammer info \(error)")
			}
			
			callback(callSpammerCount, smsSpammerCount)
		}
	}
	
	
	func getFilterSettings(callback: @escaping (FilterSettings) -> Void) {
		container.performBackgroundTask { ctx in
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
				self.saveFilterSettings(settings: settings!)
			}
			
			callback(settings!)
		}
	}
	
	
	func saveFilterSettings(settings: FilterSettings) {
		if settings.isUpdated {
			
			container.performBackgroundTask { ctx in
				do {
					try ctx.save()
				} catch {
					print("Error while saving filter settings \(error)")
				}
			}
		}
	}
	
	func clearSpamDb(callback: @escaping () -> Void) {
		container.performBackgroundTask { ctx in
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spammer")
			let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
			
			do {
				try ctx.execute(batchDeleteRequest)
			} catch {
				print("Error while truncating Spammer table \(error)")
			}
			callback()
		}
	}
	
	func saveSpamDb(spammerModel: [SpammerModel], callback: @escaping () -> Void) {
		
		container.performBackgroundTask { ctx in
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spammer")
			let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
			
			do {
				try ctx.execute(batchDeleteRequest)
			} catch {
				print("Error while truncating Spammer table \(error)")
			}
			
			var index = 0
			let total = spammerModel.count
			
			let batchInsert = NSBatchInsertRequest(entity: Spammer.entity()) { (managedObject: NSManagedObject) -> Bool in
				guard index < total else { return true }
				
				if let spammer = managedObject as? Spammer {
					let data = spammerModel[index]
					spammer.id = Int64(data.id)
					spammer.location = data.state
					spammer.number = data.number
					spammer.type = data.type == .call ? 0 : 1
				}
				index += 1
				return false
			}
			
			do {
				try ctx.execute(batchInsert)
			} catch {
				print("Error while saving spammer database \(error)")
			}
			callback()
		}
	}
	
	func getSpammers(_ number: String) -> [Spammer] {
		
		let fetchRequest: NSFetchRequest<Spammer> = NSFetchRequest(entityName: "Spammer")
		let predicate = NSPredicate(format: "number BEGINSWITH[c] %@", number)
		fetchRequest.predicate = predicate
		
		var spammers = [Spammer]()
		
		do {
			spammers = try context.fetch(fetchRequest)
		} catch {
			print("Error while fetching spammer info \(error)")
		}
		return spammers
	}
	
	
	func getManualInputSpammers(limit: Int, callback: @escaping ([Spammer]) -> Void) {
		
		container.performBackgroundTask { ctx in
			let fetchRequest: NSFetchRequest<Spammer> = NSFetchRequest(entityName: "Spammer")
			fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Spammer.id, ascending: false)]
			//fetchRequest.predicate = NSPredicate(format: "manual == true")
			fetchRequest.fetchLimit = limit
			
			var spammers: [Spammer] = []
			
			do {
				spammers = try ctx.fetch(fetchRequest)
			} catch {
				print("Error while truncating Spammer table \(error)")
			}
			
			callback(spammers)
		}
	}
	
}
