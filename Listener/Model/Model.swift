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
	
	func getAllLists(callback: @escaping ([RecordsList])->Void) {
		modelFirebase.getAllRecordsList(since: 1, callback: callback)
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
	
	func addList(recordsList: RecordsList) {
		modelFirebase.add(recordsList: recordsList){ (isSuccess) in
			self.notificaionRecordsList.post()
		}
	}
	
	func deleteList(recordsList: RecordsList) {
		
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
