//
//  RecordsList.swift
//  Listener
//
//  Created by Ellie Gadiel on 30/07/2021.
//

import UIKit

class RecordsList: NSObject {
	var id: String
	var name: String
	var details: String?
	var dateCreated: Int64
	var listType: Int = 1 // Will be enum in the future
	var records: [CheckedRecord]

	init(id: String, name: String, details: String, dateCreated: Int64, records: [CheckedRecord]) {
		self.id = id
		self.name = name
		self.details = details
		self.dateCreated = dateCreated
		self.records = records
	}
	
	init(id: String, name: String, details: String, dateCreated: Int64) {
		self.id = id
		self.name = name
		self.details = details
		self.dateCreated = dateCreated
		self.records = []
	}
}
