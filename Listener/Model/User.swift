//
//  User.swift
//  User
//
//  Created by Ellie Gadiel on 17/08/2021.
//

import Foundation

struct User {
	
	var id: String
	var name: String
	var email: String
	
	init(id: String, name: String, email: String) {
		self.id = id
		self.name = name
		self.email = email
	}
	
	func toJson()->[String : Any] {
		var json = [String : Any]()
		
		json["id"] = id
		json["name"] = name
		json["email"] = email

		return json
	}
	
	static func fromJson(json: [String : Any])-> User {
		return User(id: json["id"] as? String ?? "", name: json["name"] as? String ?? "", email: json["email"] as? String ?? "")
	}
}
