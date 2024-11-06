//
//  ProfileVC.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 4.11.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileVC: UIViewController {

    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var uiView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupUI()
    }
    
    private func setupUI(){
        uiView.layer.cornerRadius = 70
        uiView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        uiView.clipsToBounds = true
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            
            let vc = storyboard?.instantiateViewController(identifier: "authid")
            vc!.modalPresentationStyle = .fullScreen
            vc!.modalTransitionStyle = .coverVertical
            present(vc!, animated: true)
            
        } catch {
            print("çıkış yapılamadı!")
        }
    }
    
    private func fetchUser(){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Belge yok")
                return
            }
            
            let data = document.data()
            if let fullName = data?["fullName"] as? String {
                self.fullName.text = fullName
            }
            if let email = data?["email"] as? String {
                self.emailLabel.text = email
            }
        }
    }

    
}
