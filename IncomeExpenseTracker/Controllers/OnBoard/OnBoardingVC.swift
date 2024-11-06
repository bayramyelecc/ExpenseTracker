//
//  OnBoardingVC.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 4.11.2024.
//

import UIKit

class OnBoardingVC: UIViewController{

    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var uiView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    private func configure(){
        
        customImageView.layer.cornerRadius = 70
        customImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        customImageView.clipsToBounds = true
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: "isOnBoarding")
        
        let vc = storyboard?.instantiateViewController(identifier: "authid")
        vc!.modalPresentationStyle = .fullScreen
        vc!.modalTransitionStyle = .coverVertical
        present(vc!, animated: true)
        
    }
    
    
}
