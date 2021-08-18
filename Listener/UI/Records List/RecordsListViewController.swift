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
	@IBOutlet weak var loader: UIActivityIndicatorView!
	
	var listId: String?
	
	private var recordsList: RecordsList?
	
	// MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setLoading(true)
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
					self.setLoading(false)
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
	
	// MARK: Actions
	
	@IBAction func onAddRecordClick(_ sender: UIButton) {
		if (recordsList != nil) {
			// Check if the last record is not empty
			if (recordsList!.getRecords().isEmpty || recordsList!.getRecords()[recordsList!.getRecords().count - 1].text != "") {
				recordsList?.add(record: CheckedRecord(text: "", imgPath: "null", isChecked: false))
				recordsTable.reloadData()
			}
		}
	}
	
	@IBAction func onLeaveClick(_ sender: Any) {
		let user = Model.instance.getLoggedUser()
		
		if (user != nil) {
			self.recordsList?.remove(userId: user!.id)
		}
		
		self.navigationController?.popViewController(animated: true)
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
	
	var imageRecord: CheckedRecord?
	
	func pickImage(forRecord: CheckedRecord) {
		self.imageRecord = forRecord
		
		if (forRecord.imgPath == "null") {
			if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
				setLoading(true)
				
				let imagePicker = UIImagePickerController()
				imagePicker.delegate = self
				imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
				imagePicker.allowsEditing = true
				self.present(imagePicker, animated: true, completion: nil)
			}
			else {
				print("Photo library unavailable")
			}
		}
		else {
			//If there's already a pic, present the dialog
			self.displayAttachmentDialog(forRecord: forRecord)
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.setLoading(false)
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
		let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
		
		if (image != nil) {
			Model.instance.saveRecordAttachment(name: self.recordsList!.name! + "-" + String(Int64(Date().timeIntervalSince1970 * 1000)),
												img: image!,
												callback: {url in
				self.imageRecord!.imgPath = url
				self.displayAttachmentDialog(forRecord: self.imageRecord!)
				self.setLoading(false)
				
			})
			
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	func displayAttachmentDialog(forRecord: CheckedRecord) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let myAlert = storyboard.instantiateViewController(withIdentifier: "alert") as! ImageAlertViewController
		myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
		myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
		myAlert.record = forRecord
		myAlert.imagePickerDelegate = self
		self.present(myAlert, animated: true, completion: nil)
	}
	
	// MARK: Methods
	
	func setLoading(_ isLoading: Bool) {
		if (isLoading) {
			self.loader.startAnimating()
		}
		else {
			self.loader.stopAnimating()
		}
	}
}
