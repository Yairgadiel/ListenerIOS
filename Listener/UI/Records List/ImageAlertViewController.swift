//
//  ImageAlertViewController.swift
//  ImageAlertViewController
//
//  Created by Ellie Gadiel on 17/08/2021.
//

import UIKit
import Kingfisher

class ImageAlertViewController: UIViewController {
		
	@IBOutlet weak var imageView: UIImageView?
	
	var record: CheckedRecord?
	var imagePickerDelegate: ImagePickerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if (record == nil || imageView == nil) {
			// Not supposed to happen
			self.dismiss()
		}
		else {
			imageView!.kf.indicatorType = .activity
			imageView!.kf.cancelDownloadTask()
			imageView!.kf.setImage(with: URL(string: record!.imgPath), options: [.transition(.fade(0.7))]) { result in
				switch result {
				case .success(_):
					print("success")
				case .failure(_):
					print("fail")
					self.dismiss()
				}
			}
		}
	}
	
	@IBAction func overviewClick(_ sender: Any) {
		self.dismiss()
	}
	
	@IBAction func onDeleteClick(_ sender: Any) {
		// Delete the current image
		deleteCurrImage{ isSuccess in
			self.dismiss()
		}
	}
	
	@IBAction func onReplaceClick(_ sender: Any) {
		// Delete the current image
		deleteCurrImage{ isSuccess in
			self.dismiss()
			
			// Pick another one
			self.imagePickerDelegate?.pickImage(forRecord: self.record!)
		}
	}
	
	func deleteCurrImage(callback: @escaping (Bool)-> Void) {
		Model.instance.deleteRecordAttachment(name: record!.imgPath) { isSuccess in
			// Remove image from cache
			ImageCache.default.removeImage(forKey: self.record!.imgPath)
			self.record!.imgPath = "null"
		
			
			callback(isSuccess)
		}
	}
	
	func dismiss() {
		self.dismiss(animated: true, completion: nil)
	}
}
