//
//  RecordsList+CoreDataClass.swift
//  RecordsList
//
//  Created by Ellie Gadiel on 12/08/2021.
//
//

import Foundation
import CoreData
import UIKit
import Firebase

@objc(RecordsList)
public class RecordsList: NSManagedObject {
	var recordObjects: [CheckedRecord] = [CheckedRecord]()
	var userIdObjects: [String] = [String]()
	
	static func create(id: String, name: String, details: String, lastUpdated: Int64, userId: String) -> RecordsList {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
		let recordsList = RecordsList(context: context)
		recordsList.id = id
		recordsList.name = name
		recordsList.details = details
		recordsList.dateCreated = Int64(Date().timeIntervalSince1970 * 1000)
		recordsList.records = ""
		recordsList.type = 1
		recordsList.lastUpdated = lastUpdated
		recordsList.userIds = userId
		recordsList.userIdObjects = [userId]
		
		return recordsList
	}
	
	func getRecords() -> [CheckedRecord] {
		if (recordObjects.isEmpty) {
			recordObjects = stringToRecords(recordsStr: self.records ?? "")
		}
		
		return recordObjects
	}
	
	func add(record: CheckedRecord) {
		self.recordObjects.append(record)
	}
	
	func updateRecords() {
		self.records = self.recordsToString(records: self.recordObjects)
	}
	
	func remove(userId: String) {
		for i in 0..<userIdObjects.count {
			
			if (userIdObjects[i] == userId) {
				userIdObjects.remove(at: i)
				self.userIds = RecordsList.usersToString(users: self.userIdObjects)
				break
			}
		}	
	}
	
	// MARK: Records Converter
	
	private let TYPE_SEPARATOR: String = "@"
	private let LIST_OPENER: String = "["
	private let LIST_CLOSER: String = "]"
	private let RECORD_SEPARATOR: String = "},{" /*"\\x7D\\x2C\\x7B"*/ // },{
	private let ENTRY_SEPARATOR: String = ", "
	private let VALUE_SEPARATOR: String = "="
	private let PRE_POST_FIX_LEN: Int = 2 // [{ or }]
	
	func recordsToString(records: [CheckedRecord]) -> String {
		var json: String = ""
		
		if (!records.isEmpty) {
			json.append(LIST_OPENER);
			
			for i in 0..<records.count {
				let record: CheckedRecord = records[i]
				
				// Not saving empty records
				if (record.text != "") {
					json.append(record.toJson())
					
					// Separate records with ','
					if (i < records.count - 1) {
						json.append(",")
					}
				}
			}
			
			// At last, add the records' type
			json.append(LIST_CLOSER)
			json.append(TYPE_SEPARATOR)
			json.append("CheckedRecord")
			
			/*
			 [{text: val, isChecked: true}, {text: val, isChecked: true}, {text: val, isChecked: true}]@CheckedRecord
			 */
		}
		
		return json
	}
	
	func stringToRecords(recordsStr: String?) -> [CheckedRecord] {
		if (recordsStr != nil) {
			recordObjects = [CheckedRecord]()
			
			if (recordsStr != "") {
				// Separate the content from the type
				let typeSplit: [String] = recordsStr?.components(separatedBy: TYPE_SEPARATOR) ?? []
				
				// Exclude prefix and postfix
				let noPrePostFix: String = typeSplit[0].substring(with: PRE_POST_FIX_LEN..<(typeSplit[0].count - PRE_POST_FIX_LEN))
				
				// Split all the records
				let splittedRecords: [String] = noPrePostFix.components(separatedBy: RECORD_SEPARATOR)
				
				for splittedRecord in splittedRecords {
					var record = [String : Any]()
					
					let entries: [String] = splittedRecord.components(separatedBy: ENTRY_SEPARATOR)
					
					for entry in entries {
						let splittedEntry: [String] = entry.components(separatedBy: VALUE_SEPARATOR)
						// record[splittedEntry[0]] = splittedEntry[1] This doesn't work since the image urls have '=' in them
						record[splittedEntry[0]] = entry.substring(from: splittedEntry[0].count + 1)
					}
					
					// Add a new record to the redords list according to its type
					if (typeSplit[1] == "CheckedRecord") {
						recordObjects.append(CheckedRecord.fromJsonMap(json: record))
					}
					// TODO add implementation for other records
				}
			}
		}
		
		return recordObjects
	}
	
	// MARK: Users Converter
	
	static func usersToString(users: [String]) -> String {
		var json: String = ""
		
		if (!users.isEmpty) {
			for i in 0..<users.count {
				let userId: String = users[i]
				
				json.append(userId)
				
				// Separate records with ','
				if (i < users.count - 1) {
					json.append(",")
				}
			}
		}
		
		return json
	}
	

	func stringToUsers(usersStr: String?) -> [String] {
		if (usersStr != nil) {
			userIdObjects = [String]()
			
			if (usersStr != "") {
				// Separate the users
				userIdObjects = usersStr!.components(separatedBy: ",")
			}
		}
		
		return userIdObjects
	}
}

// MARK: DB
extension RecordsList {
	static func getAll(callback: @escaping ([RecordsList])->Void) {
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
			
			DispatchQueue.main.async {
				callback(lists)
			}
		}
	}
	
	static func getList(byId: String) -> RecordsList? {
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
	
	static func save() {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		
		do {
			try context.save()
		}
		catch {
			
		}
	}
	
	func delete() {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		context.delete(self)
	}
}

extension RecordsList {
	func toJson()->[String : Any] {
		var json = [String : Any]()
		
		json["Id"] = id!
		json["Name"] = name!
		json["Details"] = details ?? ""
		json["DateCreated"] = dateCreated
		json["Records"] = records ?? ""
		json["Type"] = 1
		json["LastUpdated"] = FieldValue.serverTimestamp()
		json["Users"] = userIdObjects
		
		return json
	}
	
	static func fromJson(json: [String : Any])-> RecordsList{
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let list = RecordsList(context: context)
		
		list.id = json["Id"] as? String
		list.name = json["Name"] as? String
		list.details = json["Details"] as? String
		list.dateCreated = json["DateCreated"] as! Int64
		list.records = json["Records"] as? String
		list.type = json["Type"] as! Int16
		list.lastUpdated = (json["LastUpdated"] as? Timestamp)?.seconds ?? 0
		list.userIdObjects = json["Users"] as? [String] ?? [String]()
		list.userIds = usersToString(users: list.userIdObjects)
		
		return list
	}
}

// MARK: Last update
extension RecordsList {
	static func setLocalLastUpdate(lastUpdate: Int64) {
		UserDefaults.standard.setValue(lastUpdate, forKey: "RecordsLastUpdateDate")
	}
	
	static func getLocalLastUpdate() -> Int64 {
		Int64(UserDefaults.standard.integer(forKey: "RecordsLastUpdateDate"))
	}
}

// MARK: substring

extension String {
	func index(from: Int) -> Index {
		return self.index(startIndex, offsetBy: from)
	}

	func substring(from: Int) -> String {
		let fromIndex = index(from: from)
		return String(self[fromIndex...])
	}

	func substring(to: Int) -> String {
		let toIndex = index(from: to)
		return String(self[..<toIndex])
	}

	func substring(with r: Range<Int>) -> String {
		let startIndex = index(from: r.lowerBound)
		let endIndex = index(from: r.upperBound)
		return String(self[startIndex..<endIndex])
	}
}
