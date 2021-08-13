//
//  Model.swift
//  Model
//
//  Created by Ellie Gadiel on 06/08/2021.
//

import Foundation
import UIKit
import CoreData

class Model {
	static let instance = Model()
	private init() {
	}
	
	func getAllLists(callback: @escaping ([RecordsList])->Void) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
		let req = RecordsList.fetchRequest() as NSFetchRequest<RecordsList>
		req.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
		
		DispatchQueue.global().async {
			var lists: [RecordsList] = [RecordsList]()
		
			do {
				lists = try context.fetch(req)
			}
			catch {
				lists = [RecordsList]()
			}
			
			DispatchQueue.global().async {
				callback(lists)
			}
		}
	}
	
	func getList(byId: String) -> RecordsList? {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
		var recordsList: RecordsList? = nil
		
		let req = RecordsList.fetchRequest() as NSFetchRequest<RecordsList>
		req.predicate = NSPredicate(format: "id == \(byId)")
		
		do {
			let recordsLists = try context.fetch(req)
			
			if (recordsLists.count > 0) {
				recordsList = recordsLists[0]
			}
			
		}
		catch {
		}
		
		return recordsList
	}
	
	func addList(recordsList: RecordsList) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
		do {
			try context.save()
		}
		catch {
			
		}
	}
	
	func deleteList(recordsList: RecordsList) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		context.delete(recordsList)
		
		do {
			try context.save()
		}
		catch {
			
		}
//		for i in 0..<lists.count {
//			if (lists[i].id == recordsList.id) {
//				lists.remove(at: i)
//				break
//			}
//		}
	}
}
