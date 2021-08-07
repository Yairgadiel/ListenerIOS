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
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func createAction(_ sender: UIButton) {
		let id = listId.text!
		let name = listName.text!
		let details = listDetails.text!
		
		// TODO validate input
		
		Model.instance.addList(recordsList: RecordsList(id: id,
														name: name,
														details: details,
														dateCreated: Int64(Date().timeIntervalSince1970 * 1000)))
		
		navigationController?.popViewController(animated: true)
	}
	
	@IBAction func cancelAction(_ sender: UIButton) {
		navigationController?.popViewController(animated: true)
	}
}