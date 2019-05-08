//
//  LoginController.swift
//  MusicProject
//
//  Created by Ilan Zerdoun on 11/04/2019.
//  Copyright © 2019 Ilan Zerdoun. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {

    @IBOutlet weak var userMail: UITextField!{
        didSet {
            userMail.tintColor = UIColor.lightGray
            userMail.setIcon(UIImage(named: "icon-user")!)
        }
    }
    @IBOutlet weak var userPassword: UITextField!{
        didSet {
            userPassword.tintColor = UIColor.lightGray
            userPassword.setIcon(UIImage(named: "icon-password")!)
        }
    }
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBAction func signUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: userMail.text!, password: userPassword.text!) { authResult, error in
            
            if(error != nil) {
                let alert : UIAlertView = UIAlertView(title: "Error", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Cancel")
                alert.show()
            }
            else {
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "goAccount") as! UINavigationController
                self.present(secondVC, animated:true, completion:nil)
            }
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: userMail.text!, password: userPassword.text!) { [weak self] user, error in
        
        if(error != nil) {
            let alert : UIAlertView = UIAlertView(title: "Error", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
        }
        else {
            let secondVC = self!.storyboard?.instantiateViewController(withIdentifier: "goAccount") as! UINavigationController
            self!.present(secondVC, animated:true, completion:nil)
        }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        userMail.placeholder = "Entrez un mail"
        userMail.underlined()
        userPassword.placeholder = "Votre mot de passe"
        userPassword.underlined()
        
        signInBtn.layer.cornerRadius = 15
        signUpBtn.layer.cornerRadius = 15

        // Do any additional setup after loading the view.
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


extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 0, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 30, y: self.frame.size.height - width, width:  self.frame.size.width - 30, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
