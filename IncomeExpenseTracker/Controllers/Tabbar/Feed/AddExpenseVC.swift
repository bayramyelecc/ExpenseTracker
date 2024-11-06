//
//  AddExpenseVC.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 5.11.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddExpenseVC: UIViewController {

    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var nameTexfField: UITextField!
    @IBOutlet weak var fiyatTextField: UITextField!
    
    var items: Categories?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI(){
        customImageView.layer.cornerRadius = 70
        customImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        customImageView.clipsToBounds = true
        fiyatTextField.keyboardType = .numberPad
    }
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        addData(name: nameTexfField.text!, price: fiyatTextField.text!, category: items!.title)
    }
    
    func addData(name: String, price: String, category: String){
        if !name.isEmpty && !price.isEmpty {
            
            guard let userMail = Auth.auth().currentUser?.email else {return}
            let db = Firestore.firestore()
            db.collection("expenses").addDocument(data: [
                "expense":name,
                "price": price,
                "email": userMail,
                "category": category
            ]) { error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                } else {
                    print("kayıt başarılı")
                    self.dismiss(animated: true)
                }
                
                
            }
            
        } else {
            alertShow(message: "Tüm alanları doldurun!")
        }
    }
    
    func saveData(){
        
    }
    
    func alertShow(message: String){
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

