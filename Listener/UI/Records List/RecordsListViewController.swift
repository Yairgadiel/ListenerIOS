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
			recordsList = Model.instance.getListById(id: listId!)
			
			if (recordsList == nil) {
				navigationController?.popViewController(animated: true)
			}
			else {
				listIdLabel.text = listId
				listDetailsLabel.text = recordsList?.details
				self.navigationItem.title = recordsList?.name
			}
		}
	}
	
	@IBAction func addRecordClick(_ sender: UIButton) {
		// Check if the last record is not empty
		if (recordsList?.records[(recordsList?.records.count ?? 1) - 1].text != "") {
			recordsList?.records.append(CheckedRecord(text: "", imgPath: "", isChecked: false))
			recordsTable.reloadData()
		}
	}
	
	
	// MARK: - TableView
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return (self.recordsList?.records.count)!
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = recordsTable.dequeueReusableCell(withIdentifier: "CheckedRecordCell", for: indexPath) as! CheckedRecordCell
		
		let currentRecord = (self.recordsList?.records[indexPath.section])!
		
		cell.setRecord(record: currentRecord)
		cell.selectionStyle = UITableViewCell.SelectionStyle.none
		
		return cell
	}

	
	// There is just one row in every section
	  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		  return 1
	  }
	
}
