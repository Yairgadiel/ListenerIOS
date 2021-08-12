//
//  Model.swift
//  Model
//
//  Created by Ellie Gadiel on 06/08/2021.
//

import Foundation

class Model {
	static let instance = Model()
	private var lists: [RecordsList]
	
	private init() {
		// TODO get lists from DB
		lists = []
		lists.append(RecordsList(id: "123", name: "123 name", details: "detail so many bla blas", records: []))
	}
	
	func getAllLists() -> [RecordsList] {
		return lists
	}
	
	func getListById(id: String) -> RecordsList? {
		
		var recordsList: RecordsList? = nil
		
		for list in lists {
			if (list.id == id) {
				recordsList = list
				
				recordsList?.records.append(CheckedRecord(text: "text", imgPath: "path", isChecked: true))
				recordsList?.records.append(CheckedRecord(text: "text2", imgPath: "path", isChecked: false))
			
				break;
			}
		}
		
		return recordsList
	}
	
	func addList(recordsList: RecordsList) {
		lists.append(recordsList)
	}
	
	func deleteList(recordsList: RecordsList) {		
		for i in 0..<lists.count {
			if (lists[i].id == recordsList.id) {
				lists.remove(at: i)
				break
			}
		}
	}
}
