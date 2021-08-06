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

	init(id: String, name: String, details: String) {
		self.id = id
		self.name = name
		self.details = details
	}
}
