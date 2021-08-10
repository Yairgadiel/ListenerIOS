//
//  ListPreviewCell.swift
//  ListPreviewCell
//
//  Created by Ellie Gadiel on 05/08/2021.
//

import UIKit

class ListPreviewCell: UITableViewCell {

	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var details: UILabel!


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
	}
	
}
