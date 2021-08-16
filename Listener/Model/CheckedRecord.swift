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

extension CheckedRecord {
	func toJson()->String {
		var json = "{"
		
		json.append("ImgPath=" + (imgPath ?? "null"))
		json.append(", ")
		json.append("Text=" + text)
		json.append(", ")
		json.append("IsChecked=" + (isChecked ? "true" : "false"))
		json.append("}")
		
		return json
	}
	
	static func fromJsonMap(json: [String : Any])-> CheckedRecord{

		let text: String = json["Text"] as! String
		let imgPath: String = (json["ImgPath"] as! String)
		let isChecked: Bool = (json["IsChecked"] as! String) == "true" ? true : false
	
		return CheckedRecord(text: text, imgPath: imgPath, isChecked: isChecked)
	}
}
