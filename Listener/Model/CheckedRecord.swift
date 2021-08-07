//
//  CheckedRecord.swift
//  CheckedRecord
//
//  Created by Ellie Gadiel on 07/08/2021.
//

import Foundation

class CheckedRecord {
	var text: String
	var imgPath: String?
	
	var isChecked: Bool
	
	init(text: String, imgPath: String, isChecked: Bool) {
		self.text = text
		self.isChecked = isChecked
		self.imgPath = imgPath
	}
}
