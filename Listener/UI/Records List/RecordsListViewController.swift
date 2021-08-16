//
//  RecordsListViewController.swift
//  RecordsListViewController
//
//  Created by Ellie Gadiel on 07/08/2021.
//

import UIKit

class RecordsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ImagePickerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
	
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
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Save all changes in remote and local:
		
		// Update the items' records
		recordsList?.updateRecords()
		
		Model.instance.addList(recordsList: self.recordsList!){isSuccess in}
	}
	
	@IBAction func onAddRecordClick(_ sender: UIButton) {
		if (recordsList != nil) {
			// Check if the last record is not empty
			if (recordsList!.getRecords().isEmpty || recordsList!.getRecords()[recordsList!.getRecords().count - 1].text != "") {
				recordsList?.add(record: CheckedRecord(text: "", imgPath: "", isChecked: false))
				recordsTable.reloadData()
			}
		}
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
		cell.imagePickerDelegate = self
		cell.selectionStyle = UITableViewCell.SelectionStyle.none
		
		return cell
	}
	
	
	// There is just one row in every section
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	// MARK: ImagePicker
	
	var imageCell: CheckedRecordCell?
	
	func pickImage(cell: CheckedRecordCell) {
		if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
			self.imageCell = cell
			
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
			imagePicker.allowsEditing = true
			self.present(imagePicker, animated: true, completion: nil)
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
		let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
		
		if (image != nil) {
			Model.instance.saveRecordAttachment(name: self.recordsList!.name! + "-" + String(Int64(Date().timeIntervalSince1970 * 1000)),
												img: image!,
												callback: {url in
				self.imageCell?.setAttachment(image: image, imgPath: url)
			})
			
			self.dismiss(animated: true, completion: nil)
		}
	}
}
