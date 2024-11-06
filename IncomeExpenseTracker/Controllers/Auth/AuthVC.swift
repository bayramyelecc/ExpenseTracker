//
//  AuthVC.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 4.11.2024.
//

import UIKit

class AuthVC: UIViewController {

    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        customImageView.layer.cornerRadius = 70
        customImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        customImageView.clipsToBounds = true
        
        signInButton.layer.shadowColor = UIColor.black.cgColor
        signInButton.layer.shadowOpacity = 0.5
        signInButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        signInButton.layer.shadowRadius = 10
        
        signUpButton.layer.shadowColor = UIColor.black.cgColor
        signUpButton.layer.shadowOpacity = 0.5
        signUpButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        signUpButton.layer.shadowRadius = 10
        
    }
    

    @IBAction func signInButton(_ sender: UIButton) {
        
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
    }
    
}
