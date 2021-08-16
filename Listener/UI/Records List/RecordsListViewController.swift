//
//  RecordsListViewController.swift
//  RecordsListViewController
//
//  Created by Ellie Gadiel on 07/08/2021.
//

import UIKit

class RecordsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var listIdLabel: UILabel!
	@IBOutlet weak var listDetailsLabel: UILabel!
	@IBOutlet weak var recordsTable: UITableView!

	var listId: String?
	
	private var recordsList: RecordsList?

	// MARK: Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if (listId == nil) {
			navigationController?.popViewController(animated: true)
		}
		else {
			Model.instance.getList(byId: listId!, callback: { foundRecordsList in
				self.recordsList = foundRecordsList
				
				if (self.recordsList == nil) {
					self.navigationController?.popViewController(animated: true)
				}
				else {
					self.listIdLabel.text = self.listId
					self.listDetailsLabel.text = self.recordsList?.details
					self.navigationItem.title = self.recordsList?.name
					self.recordsTable.reloadData()
				}
			})
			
			
		}
	}

	@IBAction func onAddRecordClick(_ sender: UIButton) {
		// TODO add add method
		// Check if the last record is not empty
//		if (recordsList?.getRecords()[(recordsList?.getRecords().count ?? 1) - 1].text != "") {
//			recordsList?.getRecords().append(CheckedRecord(text: "", imgPath: "", isChecked: false))
//			recordsTable.reloadData()
//		}
	}
	
	@IBAction func onEllipsisClick(_ sender: Any) {
		let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
		
		alert.addAction(UIAlertAction(title: "Approve", style: .default , handler:{ (UIAlertAction)in
			print("User click Approve button")
		}))
		
		alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
			print("User click Edit button")
		}))

		alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
			print("User click Delete button")
		}))
		
		alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
			print("User click Dismiss button")
		}))

		
		//uncomment for iPad Support
		//alert.popoverPresentationController?.sourceView = self.view

		self.present(alert, animated: true, completion: {
			print("completion block")
		})
	}
	
	// MARK: - TableView
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.recordsList?.getRecords().count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = recordsTable.dequeueReusableCell(withIdentifier: "CheckedRecordCell", for: indexPath) as! CheckedRecordCell
		
		let currentRecord = (self.recordsList?.getRecords()[indexPath.section])!
		
		cell.setRecord(record: currentRecord)
		cell.selectionStyle = UITableViewCell.SelectionStyle.none
		
		return cell
	}

	
	// There is just one row in every section
	  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		  return 1
	  }
	
}
