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
	
	// MARK: Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Check if there's a user logged in
		if (Model.instance.getLoggedUser() != nil) {
			self.performSegue(withIdentifier: "loginToPreviews", sender: self)
		}
    }
	
	// MARK: Actions
    
	@IBAction func onSignUpClick(_ sender: UIButton) {
		loader.startAnimating()
		
		Model.instance.signUp(email: emailText.text ?? "", name: nameText.text ?? "", password: passwordText.text ?? "") { isSuccess in
			if (isSuccess) {
				self.performSegue(withIdentifier: "loginToPreviews", sender: self)
			}
			
			self.loader.stopAnimating()
		}
	}
}
