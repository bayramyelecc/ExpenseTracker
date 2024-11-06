//
//  CategoriesCell.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 5.11.2024.
//

import UIKit

class CategoriesCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var items: Categories?
    
    func setup(){
        titleLabel.text = items?.title
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(hue: 0, saturation: 1, brightness: 0.9, alpha: 1)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 5
        layer.masksToBounds = false
    }
    
}
