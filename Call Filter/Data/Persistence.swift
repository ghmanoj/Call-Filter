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
				try ctx.save()
			} catch {
				print("Error while saving filter settings \(error)")
			}
		}
	}
}
