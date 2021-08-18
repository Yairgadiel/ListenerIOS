//
//  LoginViewController.swift
//  LoginViewController
//
//  Created by Ellie Gadiel on 06/08/2021.
//

import UIKit

class LoginViewController: UIViewController {
	
	// MARK: Outlets
	
	@IBOutlet weak var emailText: UITextField!
	@IBOutlet weak var nameText: UITextField!
	@IBOutlet weak var passwordText: UITextField!
	@IBOutlet weak var loader: UIActivityIndicatorView!
	@IBOutlet weak var validation: UILabel!
	
	// MARK: Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		// Check if there's a user logged in
		if (Model.instance.getLoggedUser() != nil) {
			self.performSegue(withIdentifier: "loginToPreviews", sender: self)
		}
		
		super.viewWillAppear(animated)
	}
	
	// MARK: Actions
    
	@IBAction func onSignUpClick(_ sender: UIButton) {
		loader.startAnimating()
		
		// Validate input
		validate() { errorString in
			// Show/Hide Validation Label
			self.displayError(errorString)
			
			self.loader.stopAnimating()
			
			// No error
			if (errorString == "") {
				self.loader.startAnimating()
				
				Model.instance.signUp(email: self.emailText.text!, name: self.nameText.text!, password: self.passwordText.text!) { isSuccess in
					if (isSuccess) {
						self.performSegue(withIdentifier: "loginToPreviews", sender: self)
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
		let emptyNameErr = "Username field can't be empty!"
		let shortPassErr = "Password must have at least 6 characters!"
		let emailTakenErr = "The email address is already in use!"
		
		if (emailText.text == nil || emailText.text == "")  {
			callback(emptyEmailErr)
		}
		else if (nameText.text == nil || nameText.text == "") {
			callback(emptyNameErr)
		}
		else if (passwordText.text?.count ?? 0 < 6) {
			callback(shortPassErr)
		}
		else {
			Model.instance.getAllUsers(withEmail: emailText.text!) { users in
				callback(users.isEmpty ? "" : emailTakenErr)
			}
		}
	}
	
	func displayError(_ errorMsg: String) {
		self.validation.text = errorMsg
		
		UIView.animate(withDuration: 0.5, animations: {
			self.validation.isHidden = errorMsg == ""
		})
	}
}
