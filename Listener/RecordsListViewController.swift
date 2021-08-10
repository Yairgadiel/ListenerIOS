//
//  RecordsListViewController.swift
//  RecordsListViewController
//
//  Created by Ellie Gadiel on 07/08/2021.
//

import UIKit

class RecordsListViewController: UIViewController {
	
	@IBOutlet weak var listIdLabel: UILabel!
	@IBOutlet weak var listDetailsLabel: UILabel!
	
	var listId: String?
	
	private var recordsList: RecordsList?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if (listId == nil) {
			navigationController?.popViewController(animated: true)
		}
		else {
			recordsList = Model.instance.getListById(id: listId!)
			
			listIdLabel.text = listId
			listDetailsLabel.text = recordsList?.details
			self.navigationItem.title = recordsList?.name
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

}
