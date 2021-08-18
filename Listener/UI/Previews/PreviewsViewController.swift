//
//  PreviewsViewController.swift
//  PreviewsViewController
//
//  Created by Ellie Gadiel on 04/08/2021.
//

import UIKit

class PreviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var previews: UITableView!
	var refreshControl = UIRefreshControl()
	
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
	
	// MARK: Lifecycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.setHidesBackButton(true, animated: true)
		
		self.previews.addSubview(refreshControl)
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		
		self.reloadData()
		
		Model.instance.notificaionRecordsList.observe {
			self.reloadData()
		}
    }
	
	// MARK: Actions
	
	@IBAction func signOut(_ sender: Any) {
		Model.instance.signOut()
		self.navigationController?.popViewController(animated: true)
	}
	
	
	// MARK: Methods
	
	@objc func refresh(_ sender: AnyObject) {
		self.reloadData()
	}
	
	func reloadData() {
		// Show loader
		self.refreshControl.beginRefreshing()
		
		Model.instance.getAllLists { data in
			self.recordsLists = data
			self.previews.reloadData()
			self.refreshControl.endRefreshing()
		}
	}

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
		cell.layer.borderWidth = 0
		cell.layer.cornerRadius = 8
		cell.clipsToBounds = true
		cell.selectionStyle = .none
		
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
