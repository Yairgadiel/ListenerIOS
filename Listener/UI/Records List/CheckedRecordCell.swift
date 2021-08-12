//
//  RecordCell.swift
//  RecordCell
//
//  Created by Ellie Gadiel on 10/08/2021.
//

import UIKit

class CheckedRecordCell: UITableViewCell {

	@IBOutlet weak var recordTextField: UITextField!
	@IBOutlet weak var isCheckedBtn: UIButton!
	
	private var record: CheckedRecord?
	

	@IBAction func onCheckedClicked(_ sender: UIButton) {
		record?.isChecked.toggle()

		setIsChecked()
	}
	
	@IBAction func onTextChanged(_ sender: UITextField) {
		record?.text = sender.text ?? ""
	}
	
	
	// Button Function ( Can also add to custome class )
	func setIsChecked() {
		switch record?.isChecked {
			  case true:
					// Chnage backgroundImage to hart image
					isCheckedBtn.setImage(UIImage(named: "checked"), for: .normal)
			  default:
					isCheckedBtn.setImage(UIImage(named: "unchecked"), for: .normal)
		 }
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
	}
	
	func setRecord(record: CheckedRecord) {
		self.record = record
		
		// Init views
		recordTextField.text = record.text
		
		setIsChecked()
	}
}
