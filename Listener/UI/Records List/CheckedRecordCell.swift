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
	private var downloadTask: DownloadTask?

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
		imagePickerDelegate?.pickImage(forRecord: self.record!)
	}
	
	// MARK: Override
	
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
		
		setIsChecked()
	}
}
