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
	}
	
	func getAllLists() -> [RecordsList] {
		return lists
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
