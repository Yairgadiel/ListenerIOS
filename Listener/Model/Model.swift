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
	
	func getAllLists(callback: @escaping ([RecordsList])->Void) {
		// Get the local update date
		var localLastUpdate = RecordsList.getLocalLastUpdate()
		
		// Get updates from remote
		modelFirebase.getAllRecordsList(since: localLastUpdate) { (data) in
			// Update local DB
			
			if (data.count > 0) {
				// Save ALL data in local DB (the context was updated on each creation)
				data[0].save()
								
				for list in data {					
					// Get the latest last update
					if (list.lastUpdated > localLastUpdate) {
						localLastUpdate = list.lastUpdated
					}
					
					// TODO if our user isn't a part of this list - delete it
					// list.delete()
				}
				
				RecordsList.setLocalLastUpdate(lastUpdate: localLastUpdate)
				
				// Read all records lists from local DB and update the caller
				RecordsList.getAll(callback: callback)
			}
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
	
	// MARK: Storage
	
	func saveRecordAttachment(name: String, img: UIImage, callback: @escaping (String)->Void) {
		modelFirebase.uploadImage(name: name, img: img, callback: callback)
	}
	
	func loadRecordAttachment(name: String, callback: @escaping (UIImage?)->Void) {
		modelFirebase.loadImage(name: name, callback: callback)
	}
	
	func deleteRecordAttachment(name: String, callback: @escaping (Bool)->Void) {
		modelFirebase.deleteImage(name: name, callback: callback)
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
