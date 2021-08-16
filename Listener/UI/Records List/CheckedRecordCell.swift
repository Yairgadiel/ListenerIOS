//
//  RecordCell.swift
//  RecordCell
//
//  Created by Ellie Gadiel on 10/08/2021.
//

import UIKit
import Kingfisher

class CheckedRecordCell: UITableViewCell {
	// MARK: Properties
	private var record: CheckedRecord?
	var imagePickerDelegate: ImagePickerDelegate?

	// MARK: Outlets
	
	@IBOutlet weak var recordTextField: UITextField!
	@IBOutlet weak var isCheckedBtn: UIButton!
	@IBOutlet weak var attachmentBtn: UIButton!
	
	@IBAction func onCheckedClicked(_ sender: UIButton) {
		record?.isChecked.toggle()

		setIsChecked()
	}
	
	@IBAction func onTextChanged(_ sender: UITextField) {
		record?.text = sender.text ?? ""
	}
	
	@IBAction func onAttachmentClicked(_ sender: UIButton) {
		imagePickerDelegate?.pickImage(cell: self)
	}
	
	// MARK: Lifecycle
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	// MARK: Methods
	
	func setIsChecked() {
		if (record?.isChecked == true) {
			isCheckedBtn.setImage(UIImage(named: "checked"), for: .normal)
		}
		else {
			isCheckedBtn.setImage(UIImage(named: "unchecked"), for: .normal)
		}
	}
	
	func setRecord(record: CheckedRecord) {
		self.record = record
		
		// Init views
		recordTextField.text = record.text
		self.setAttachmentImg()
		
		setIsChecked()
	}
	
	func setAttachment(imgPath: String) {
		if (imgPath != "") {
			self.record?.imgPath = imgPath

			self.setAttachmentImg()
		}
	}
	
	private func setAttachmentImg() {
		if (record != nil && record?.imgPath != "" && record?.imgPath != "null") {
			KF.url(URL(string: record!.imgPath))
				  .set(to: attachmentBtn.imageView!)
		}
	}
}
