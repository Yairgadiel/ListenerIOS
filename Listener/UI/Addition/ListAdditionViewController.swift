//
//  ListAdditionViewController.swift
//  ListAdditionViewController
//
//  Created by Ellie Gadiel on 06/08/2021.
//

import UIKit

class ListAdditionViewController: UIViewController {
	
	@IBOutlet weak var listId: UITextField!
	@IBOutlet weak var listName: UITextField!
	@IBOutlet weak var listDetails: UITextField!
	@IBOutlet weak var loader: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	@IBAction func createAction(_ sender: UIButton) {
		let id = listId.text!
		let name = listName.text!
		let details = listDetails.text!
		
		// TODO validate input
		
		loader.startAnimating()
		
		// Get current user
		let user = Model.instance.getLoggedUser()
		
		if (user == nil) {
			print("No logged user")
			self.loader.stopAnimating()
		}
		else {
			Model.instance.addList(recordsList: RecordsList.create(id: id,
																   name: name,
																   details: details,
																   lastUpdated: 0,
																   userId: user!.id)) { isSuccess in
				self.loader.stopAnimating()
				
				if (isSuccess) {
					self.navigationController?.popViewController(animated: true)
				}
			}
		}
	}
	
	@IBAction func cancelAction(_ sender: UIButton) {
		navigationController?.popViewController(animated: true)
	}
}
