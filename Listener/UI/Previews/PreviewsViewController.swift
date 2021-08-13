//
//  PreviewsViewController.swift
//  PreviewsViewController
//
//  Created by Ellie Gadiel on 04/08/2021.
//

import UIKit

class PreviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var previews: UITableView!
	
	// MARK: - Properties
	private var recordsLists: [RecordsList] = []
	private let cellSpacingHeight: CGFloat = 5
	private let previewColors: [UIColor] = [UIColor.systemRed,
											UIColor.systemGreen,
											UIColor.systemBlue,
											UIColor.systemPink,
											UIColor.systemBrown,
											UIColor.systemCyan,
											UIColor.systemPurple,
											UIColor.systemYellow,
											UIColor.systemMint]
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// TODO
		// 1. Update RecordsList model with all relevant attributes (assume all are checked record)
		// 2. Create Record Model
		// 3. Create RecordsList controller with a table view and segue to it on preview press
		// 4. Continue learning DB - min 42
		
		
//		recordsLists.append(RecordsList(id: "111", name: "first", details: "details"))
//		recordsLists.append(RecordsList(id: "222", name: "second", details: "details oh many many details. you can't imagine how many"))
//		recordsLists.append(RecordsList(id: "333", name: "third", details: ""))
//		recordsLists.append(RecordsList(id: "444", name: "fourth", details: "details"))
//		recordsLists.append(RecordsList(id: "555", name: "fifth", details: "details"))
//		recordsLists.append(RecordsList(id: "333", name: "6", details: ""))
//		recordsLists.append(RecordsList(id: "444", name: "7", details: "details"))
//		recordsLists.append(RecordsList(id: "555", name: "8", details: "details"))
//		recordsLists.append(RecordsList(id: "6333", name: "9", details: ""))
//		recordsLists.append(RecordsList(id: "7444", name: "10", details: "details"))
//		recordsLists.append(RecordsList(id: "8555", name: "11", details: "details"))
//		recordsLists.append(RecordsList(id: "9333", name: "12", details: ""))
//		recordsLists.append(RecordsList(id: "10444", name: "13", details: "details"))
//		recordsLists.append(RecordsList(id: "11555", name: "14", details: "details"))
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	
		// todo show loader
		Model.instance.getAllLists { data in
			self.recordsLists = data
			self.previews.reloadData()
		}
	}

	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	// MARK: - TableView
	
	func numberOfSections(in tableView: UITableView) -> Int {
		   return self.recordsLists.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = previews.dequeueReusableCell(withIdentifier: "ListPreviewCell", for: indexPath) as! ListPreviewCell
		
		let currentList = recordsLists[indexPath.section]
		
		cell.name?.text = currentList.name
		cell.details?.text = currentList.details
		
		// add border and color
		cell.backgroundColor = previewColors[indexPath.section % previewColors.count]
//		cell.layer.borderColor = UIColor.clear.cgColor
		cell.layer.borderWidth = 0
		cell.layer.cornerRadius = 8
		cell.clipsToBounds = true
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 90
	}
	
	// There is just one row in every section
	  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		  return 1
	  }
	  
	  // Set the spacing between sections
	  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		  return cellSpacingHeight
	  }
	  
	  // Make the background color show through
	  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		  let headerView = UIView()
		  headerView.backgroundColor = UIColor.clear
		  return headerView
	  }
	
	// method to run when table view cell is tapped
	   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		   // note that indexPath.section is used rather than indexPath.row
		   print("You tapped cell number \(indexPath.section).")

		   self.performSegue(withIdentifier: "previewsToRecordsList", sender: indexPath.section)
	   }
	
	// MARK: - Segue
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "previewsToRecordsList") {
			let selectedRow = sender as! Int
			
			let destinationVC = segue.destination as! RecordsListViewController
			destinationVC.listId = recordsLists[selectedRow].id
		}
	}
}
