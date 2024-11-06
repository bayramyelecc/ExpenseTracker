//
//  ExpensesCell.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 5.11.2024.
//

import UIKit

class ExpensesCell: UICollectionViewCell {
    
    @IBOutlet weak var expenseName: UILabel!
    @IBOutlet weak var expenseFiyat: UILabel!
    
    var items: Expenses?
    
    func setup(){
        expenseName.text = items?.title
        expenseFiyat.text = "\(items?.fiyat ?? 00) TL"
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 0.2)
    }
    
}
