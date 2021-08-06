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
	let cellSpacingHeight: CGFloat = 5
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		recordsLists.append(RecordsList(id: "111", name: "first", details: "details"))
		recordsLists.append(RecordsList(id: "222", name: "second", details: "details oh many many details. you can't imagine how many"))
		recordsLists.append(RecordsList(id: "333", name: "third", details: ""))
		recordsLists.append(RecordsList(id: "444", name: "fourth", details: "details"))
		recordsLists.append(RecordsList(id: "555", name: "fifth", details: "details"))
		
//		previews.contentInset = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: -20)
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
	
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		recordsLists.count
//	}
	func numberOfSections(in tableView: UITableView) -> Int {
		   return self.recordsLists.count
	   }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = previews.dequeueReusableCell(withIdentifier: "ListPreviewCell", for: indexPath) as! ListPreviewCell
		cell.name?.text = recordsLists[indexPath.section].name
		cell.details?.text = recordsLists[indexPath.section].details
		
		// add border and color
		cell.backgroundColor = UIColor.systemGreen
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
	   }
}
