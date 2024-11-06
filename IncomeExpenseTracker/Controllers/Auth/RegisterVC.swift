//
//  RegisterVC.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 4.11.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController {
    
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
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
        stackView.layer.shadowOffset = CGSize(width: 2, height: 2)
        stackView.layer.shadowRadius = 7
        
        fullnameTextField.layer.cornerRadius = 25
        fullnameTextField.layer.masksToBounds = true
        emailTextField.layer.cornerRadius = 25
        emailTextField.layer.masksToBounds = true
        passwordTextField.layer.cornerRadius = 25
        passwordTextField.layer.masksToBounds = true
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        if let email = emailTextField.text, !email.isEmpty,
           let password = passwordTextField.text, !password.isEmpty,
           let fullName = fullnameTextField.text, !fullName.isEmpty {
            
            if email.contains("@") && email.contains(".") && password.count >= 6 {
                registerUser(email: emailTextField.text!, password: passwordTextField.text!, fullName: fullnameTextField.text!)
            } else {
                alertShow(message: "Lütfen geçerli bir email veya şifre girin!")
            }
            
        } else {
            alertShow(message: "Lütfen tüm alanları doldurun!")
        }
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func registerUser(email: String, password: String, fullName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
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
            
            guard let user = result?.user else {return}
            self.saveUserFullName(userId: user.uid, fullName: fullName)
            
        }
    }
    
    private func saveUserFullName(userId: String, fullName: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).setData([
            "fullName": fullName,
            "email": Auth.auth().currentUser?.email ?? ""
        ]) { error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                print("başarılı")
            }
        }
    }
    
    func alertShow(message: String){
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
