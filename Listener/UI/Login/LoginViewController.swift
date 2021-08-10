//
//  LoginViewController.swift
//  LoginViewController
//
//  Created by Ellie Gadiel on 06/08/2021.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// TODO check if there's a user logged in
		if true {
			self.performSegue(withIdentifier: "loginToPreviews", sender: self)
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
