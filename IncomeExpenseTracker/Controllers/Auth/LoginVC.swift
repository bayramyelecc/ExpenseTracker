//
//  LoginVC.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 4.11.2024.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        customImageView.layer.cornerRadius = 70
        customImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        customImageView.clipsToBounds = true
        
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.1
        stackView.layer.shadowOffset = CGSize(width: 5, height: 5)
        stackView.layer.shadowRadius = 7
        
        emailTextField.layer.cornerRadius = 25
        emailTextField.layer.masksToBounds = true
        passwordTextField.layer.cornerRadius = 25
        passwordTextField.layer.masksToBounds = true
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        
        if let email = emailTextField.text, !email.isEmpty,
           let password = passwordTextField.text, !password.isEmpty {
            
            if email.contains("@") && email.contains(".") && password.count >= 6 {
                loginUser(email: email, password: password)
                
            } else {
                alertShow(message: "Lütfen geçerli bir email veya şifre girin!")
            }
            
        } else {
            alertShow(message: "Lütfen tüm alanları doldurun!")
        }
        
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    private func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            if (result?.user) != nil {
                let vc = self.storyboard?.instantiateViewController(identifier: "gelir")
                vc!.modalPresentationStyle = .fullScreen
                vc!.modalTransitionStyle = .flipHorizontal
                self.present(vc!, animated: true)
            } else {
                return
            }
        }
    }
    
    func alertShow(message: String){
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
