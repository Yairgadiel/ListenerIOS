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
	let modelFirebase = ModelFirebase()
	
	private init() {
	}
	
	func getAllLists(callback: @escaping ([RecordsList])->Void) {
		modelFirebase.getAllRecordsList(since: 1, callback: callback)
		
	}
	
	func getList(byId: String, callback: @escaping (RecordsList?)->Void) {
		modelFirebase.getAllRecords(byField: "Id", value: byId) { data in
			var recordsList: RecordsList? = nil
			
			if (data.count > 0) {
				recordsList = data[0]
			}
			
			callback(recordsList)
		}
	}
	
	func addList(recordsList: RecordsList, callback: @escaping (Bool)->Void) {
		modelFirebase.add(recordsList: recordsList, callback: callback)
	}
	
	func deleteList(recordsList: RecordsList) {
		
	}
}
