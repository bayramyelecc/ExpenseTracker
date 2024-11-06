//
//  GelirVC.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 4.11.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class GelirVC: UIViewController {
    
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var gelirTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        gelirKontrol()
    }
    
    private func setupUI(){
        uiView.layer.cornerRadius = 20
        gelirTextField.keyboardType = .numberPad
    }
    
    private func gelirKontrol() {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let db = Firestore.firestore()
        
        
        db.collection("gelir").whereField("email", isEqualTo: userEmail).getDocuments { (snapshot, error) in
            if let error = error {
                print("Gelir verileri alınamadı: \(error.localizedDescription)")
                return
            }
            
            
            if let documents = snapshot?.documents, !documents.isEmpty {
                let vc = self.storyboard?.instantiateViewController(identifier: "tabbar")
                vc!.modalPresentationStyle = .fullScreen
                vc!.modalTransitionStyle = .coverVertical
                self.present(vc!, animated: true)
            }
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: "gelir")
        
        if let gelir = gelirTextField.text, !gelir.isEmpty {
            
            let userMail = Auth.auth().currentUser?.email
            let db = Firestore.firestore()
            db.collection("gelir").addDocument(data: [
                "gelir": gelir,
                "email": userMail as Any
            ]) { error in
                if error != nil {
                    print("Veri kaydedilmedi")
                } else {
                    print("Başarılı")
                    
                    let vc = self.storyboard?.instantiateViewController(identifier: "tabbar")
                    vc!.modalPresentationStyle = .fullScreen
                    vc!.modalTransitionStyle = .coverVertical
                    self.present(vc!, animated: true)
                }
            }
            
        } else {
            alertShow()
        }
    }
    
    func alertShow(){
        let alert = UIAlertController(title: "Uyarı", message: "Lütfen gelirinizi giriniz!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
