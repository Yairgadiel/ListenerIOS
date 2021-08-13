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

@objc(RecordsList)
public class RecordsList: NSManagedObject {
	static func create(id: String, name: String, details: String) -> RecordsList {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
		let recordsList = RecordsList(context: context)
		recordsList.id = id
		recordsList.name = name
		recordsList.details = details
		recordsList.dateCreated = Int64(Date().timeIntervalSince1970 * 1000)
		recordsList.records = ""
		
		return recordsList
	}
	
//	static func create(id: String, name: String, details: String, records: [CheckedRecord]) -> RecordsList {
//		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//		let recordsList = RecordsList(context: context)
//		recordsList.id = id
//		recordsList.name = name
//		recordsList.details = details
//		recordsList.dateCreated = Int64(Date().timeIntervalSince1970 * 1000)
//		recordsList.records = recordsToString(records: records)
//
//		return recordsList
//	}
	
	// MARK: Records Converter
	
//	private static let TYPE_SEPARATOR: String = "@";
//	private static let LIST_OPENER: String = "[";
//	private static let LIST_CLOSER: String = "]";
//	private static let RECORD_SEPARATOR: String = "},{" /*"\\x7D\\x2C\\x7B"*/; // },{
//	private static let ENTRY_SEPARATOR: String = ", ";
//	private static let VALUE_SEPARATOR: String = "=";
//	private static let PRE_POST_FIX_LEN: Int8 = 2; // [{ or }]
//	
//	static func recordsToString(records: [CheckedRecord]) -> String {
//		var json: String = ""
//		
//		if (!records.isEmpty) {
//			json.append(LIST_OPENER);
//			
//			for i in 0..<records.count {
//				var record: CheckedRecord = records[i]
//
//				json.append(record.toJson());
//
//				// Separate records with ','
//				if (i < records.count - 1) {
//					json.append(",")
//				}
//			}
//
//			// At last, add the records' type
//			json.append(LIST_CLOSER)
//			json.append(TYPE_SEPARATOR)
//			json.append("CheckedRecord")
//
//			  /*
//			   [{text: val, isChecked: true}, {text: val, isChecked: true}, {text: val, isChecked: true}]@CheckedRecord
//			   */
//		  }
//
//		  return json
//	}
//	
//	static func stringToRecords(recordsStr: String) -> [CheckedRecord] {
//		
//	}
}
