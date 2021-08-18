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
	
	private let recordsListsKey = "com.gy.NotificationKey.RecordsLists"
	private let loginKey = "com.gy.NotificationKey.Login"
	
	public var notificaionRecordsList : NotificationListener
	public var notificaionlogin : NotificationListener
	
	private init() {
		self.notificaionRecordsList = NotificationListener(name: recordsListsKey)
		self.notificaionlogin = NotificationListener(name: loginKey)
	}
	
	// MARK: Firestore
	
	// MARK: Records Lists
	
	func getAllLists(callback: @escaping ([RecordsList])->Void) {
		// Making sure there aren't any unsaved changes (like additions).
		// If they were not saved already, we don't need them
		RecordsList.rollback()
		
		// Get the local update date
		var localLastUpdate = RecordsList.getLocalLastUpdate()
		
		// Get updates from remote
		modelFirebase.getAllRecordsList(since: localLastUpdate) { (data) in
			// Update local DB
			
			if (data.count > 0) {
				// Save ALL data in local DB (the context was updated on each creation)
				RecordsList.save()
				
				RecordsList.getAll() {data in
					// Get the current user
					let user = self.modelFirebase.getLoggedUser()
									
					for list in data {
						// Get the latest last update
						if (list.lastUpdated > localLastUpdate) {
							localLastUpdate = list.lastUpdated
						}
						
						// If our (the logged) user isn't a part of this list - delete it
						if (user == nil || list.userIds == nil || !list.userIds!.contains(user!.id)) {
							// Remove from local DB (if existed)
							list.delete()
						}
					}
					
					RecordsList.save()
										
					RecordsList.setLocalLastUpdate(lastUpdate: localLastUpdate)
					
					// Read all records lists from local DB and update the caller
					RecordsList.getAll(callback: callback)
					
//					RecordsList.getAll() { data in
//						var relevantData = [RecordsList]()
//
//						for list in data {
//							if (user != nil && list.userIds != nil && list.userIds!.contains(user!.id)) {
//								relevantData.append(list)
//							}
//						}
//
//						callback(relevantData)
//					}
				}
			}
		}
	}
	
	func getNotMyLists(callback: @escaping ([RecordsList])->Void) {
		// Get the current user
		let user = self.modelFirebase.getLoggedUser()
		
		if (user == nil) {
			callback([RecordsList]())
		}
		else {
			modelFirebase.getLists(withoutUser: user!.id, callback: callback)
		}
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
		modelFirebase.add(recordsList: recordsList){ (isSuccess) in
			self.notificaionRecordsList.post()
			callback(isSuccess)
		}
	}
	
	// MARK: Users
	
	func set(user: User, callback: @escaping (Bool)->Void) {
		modelFirebase.set(user: user, callback: callback)
	}
	
	func getAllUsers(byField: String, value: String, callback:@escaping ([User])->Void) {
		modelFirebase.getAllUsers(byField: byField, value: value, callback: callback)
	}
			
	// MARK: Storage
	
	func saveRecordAttachment(name: String, img: UIImage, callback: @escaping (String)->Void) {
		modelFirebase.uploadImage(name: name, img: img, callback: callback)
	}
	
	func loadRecordAttachment(name: String, callback: @escaping (UIImage?)->Void) {
		modelFirebase.loadImage(name: name, callback: callback)
	}
	
	func deleteRecordAttachment(name: String, callback: @escaping (Bool)->Void) {
		modelFirebase.deleteImage(url: name, callback: callback)
	}
	
	// MARK: Authentication
	
	func signIn(email: String, password: String, callback: @escaping (Bool)->Void) {
		modelFirebase.signIn(email: email, password: password, callback: callback)
	}
	
	func signUp(email: String, name: String, password: String, callback: @escaping (Bool)->Void) {
		modelFirebase.signUp(email: email, name: name, password: password) {isSuccess in
			if (isSuccess) {
				let user = self.modelFirebase.getLoggedUser()
				
				if (user == nil) {
					callback(false)
				}
				else {
					// Adding the newly created user to the remote DB
					self.modelFirebase.set(user: user!, callback: callback)
				}
			}
			else {
				callback(false)
			}
		}
	}
	
	func signOut() {
		modelFirebase.signOut()
	}
	
	func getLoggedUser() -> User? {
		return modelFirebase.getLoggedUser()
	}
}

class NotificationListener {

	var key: String
	
	init (name: String) {
		self.key = name
	}
	
	func post() {
		NotificationCenter.default.post(name: NSNotification.Name(key), object: self)
	}
	
	func observe(callback: @escaping ()->Void) {
		NotificationCenter.default.addObserver(forName: NSNotification.Name(key),
											   object: nil,
											   queue: nil,
											   using: { (notification) in
			callback()
		})
	}
}
