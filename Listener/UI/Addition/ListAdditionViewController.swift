//
//  ListAdditionViewController.swift
//  ListAdditionViewController
//
//  Created by Ellie Gadiel on 06/08/2021.
//

import UIKit

class ListAdditionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	// MARK: Outlets
	
	@IBOutlet weak var listId: UITextField!
	@IBOutlet weak var listName: UITextField!
	@IBOutlet weak var listDetails: UITextField!
	@IBOutlet weak var loader: UIActivityIndicatorView!
	@IBOutlet weak var existingListsTable: UITableView!
	@IBOutlet weak var tableLoader: UIActivityIndicatorView!
	@IBOutlet weak var validation: UILabel!
	
	// MARK: Properteis
	
	var existingLists : [RecordsList]?
	
	// MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableLoader.startAnimating()
		
		Model.instance.getNotMyLists() { data in
			self.existingLists = data
			self.existingListsTable.reloadData()
			self.tableLoader.stopAnimating()
		}
	}
	
	// MARK: Outlet Actions
	
	@IBAction func createAction(_ sender: UIButton) {
		let id = listId.text!
		let name = listName.text!
		let details = listDetails.text!
		
		loader.startAnimating()
		
		// Validate input
		validate() { errorString in
			self.validation.text = errorString
			
			self.loader.stopAnimating()
			
			// Show/Hide Password Validation Label
			UIView.animate(withDuration: 0.5, animations: {
				self.validation.isHidden = errorString == ""
			})
			
			// No error
			if (errorString == "") {
				// Get current user
				let user = Model.instance.getLoggedUser()
				
				if (user == nil) {
					print("No logged user")
				}
				else {
					self.addList(RecordsList.create(id: id,
											   name: name,
											   details: details,
											   lastUpdated: 0,
											   userId: user!.id))
				}
			}
		}
	}
	
	// MARK: TableView
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.existingLists?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = existingListsTable.dequeueReusableCell(withIdentifier: "ExistListCell", for: indexPath) as! ExistingListCell
		
		let currentList = (self.existingLists?[indexPath.section])!
		
		cell.setList(currentList)
		
		return cell
	}
	
	// method to run when table view cell is tapped
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// note that indexPath.section is used rather than indexPath.row
		
		let clickedList = (self.existingLists?[indexPath.section])!
		clickedList.add(userId: Model.instance.getLoggedUser()!.id)
		
		addList(clickedList)
	}
	
	// There is just one row in every section
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	// MARK: Methods
	
	// The method adds (or updates) the given list in the remote
	func addList(_ list: RecordsList) {
		loader.startAnimating()
		
		Model.instance.addList(recordsList: list) { isSuccess in
			self.loader.stopAnimating()
			
			if (isSuccess) {
				self.navigationController?.popViewController(animated: true)
			}
		}
	}
	
	func validate(callback: @escaping (String)->Void) {
		let emptyIdErr = "The list nust have an ID!"
		let emptyNameErr = "The list must have a name!"
		let idTakenErr = "The list ID is already taken!"
		
		if (listId.text == "")  {
			callback(emptyIdErr)
		}
		else if (listName.text == "") {
			callback(emptyNameErr)
		}
		else {
			Model.instance.getList(byId: listId.text!) { list in
				callback(list == nil ? "" : idTakenErr)
			}
		}
	}
}
