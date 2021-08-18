//
//  User.swift
//  User
//
//  Created by Ellie Gadiel on 17/08/2021.
//

import Foundation

class User {
	
	var id: String
	var name: String
	var email: String
	
	init(id: String, name: String, email: String) {
		self.id = id
		self.name = name
		self.email = email
	}
}
