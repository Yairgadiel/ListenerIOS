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
	
	// MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
	// MARK: Actions
	
	@IBAction func onSignInClick(_ sender: UIButton) {
		loader.startAnimating()
		
		Model.instance.signIn(email: emailText.text ?? "", password: passwordText.text ?? "") { isSuccess in
			if (isSuccess) {
				self.navigationController?.popViewController(animated: true)
			}
			
			self.loader.stopAnimating()
		}
	}
}
