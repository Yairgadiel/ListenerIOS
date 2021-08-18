//
//  ExistingListCell.swift
//  ExistingListCell
//
//  Created by Ellie Gadiel on 18/08/2021.
//

import UIKit

class ExistingListCell: UITableViewCell {

	// MARK: Outlets
	
	@IBOutlet weak var idLabel: UILabel!
	
	// MARK: Override
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	// MARK: Methods
	
	func setList(_ list: RecordsList) {
		idLabel.text = list.id
	}
}
