//
//  SignInViewController.swift
//  SignInViewController
//
//  Created by Ellie Gadiel on 17/08/2021.
//

import UIKit

class SignInViewController: UIViewController {
	
	// MARK: Outlets
	
	@IBOutlet weak var emailText: UITextField!
	@IBOutlet weak var passwordText: UITextField!
	@IBOutlet weak var loader: UIActivityIndicatorView!
	@IBOutlet weak var validation: UILabel!
	
	// MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
	// MARK: Actions
	
	@IBAction func onSignInClick(_ sender: UIButton) {
		loader.startAnimating()
		
		// Validate input
		validate() { errorString in
			// Show/Hide Validation Label
			self.displayError(errorString)
			
			self.loader.stopAnimating()
			
			// No error
			if (errorString == "") {
				self.loader.startAnimating()
				
				Model.instance.signIn(email: self.emailText.text!, password: self.passwordText.text!) { isSuccess in
					if (isSuccess) {
						self.navigationController?.popViewController(animated: true)
					}
					else {
						self.displayError("Unknown error")
					}
					
					self.loader.stopAnimating()
				}
			}
		}
	}
	
	
	// MARK: Methods
	
	func validate(callback: @escaping (String)->Void) {
		let emptyEmailErr = "Email field can't be empty!"
		let shortPassErr = "Password must have at least 6 characters!"
		
		if (emailText.text == nil || emailText.text == "")  {
			callback(emptyEmailErr)
		}
		else if (passwordText.text?.count ?? 0 < 6) {
			callback(shortPassErr)
		}
		else {
			callback("")
		}
	}
	
	func displayError(_ errorMsg: String) {
		self.validation.text = errorMsg
		
		UIView.animate(withDuration: 0.5, animations: {
			self.validation.isHidden = errorMsg == ""
		})
	}
}
