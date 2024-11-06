//
//  DetailVC.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 5.11.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryName: UILabel!
    
    var items: Categories?
    
    var models: [Expenses] = []
    
    var filteredModels: [Expenses] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryName.text = items?.title
        
        if let selectedCategory = items?.title {
            filteredModels = models.filter { $0.category == selectedCategory }
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        collectionView.contentInset = UIEdgeInsets(top: 7, left: 5, bottom: 7, right: 5)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchExpenses()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(identifier: "addEx") as? AddExpenseVC {
            vc.items = items
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ExpensesCell
        let model = filteredModels[indexPath.row]
        cell.items = model
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 70)
    }
    
    func fetchExpenses() {
        guard let categoryTitle = items?.title,
              let userEmail = Auth.auth().currentUser?.email else { return }
        
        let db = Firestore.firestore()
        db.collection("expenses")
          .whereField("category", isEqualTo: categoryTitle)
          .whereField("email", isEqualTo: userEmail)
          .getDocuments { (snapshot, error) in
            if let error = error {
                print("Veri alınırken hata oluştu: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            self.filteredModels = documents.compactMap { doc -> Expenses? in
                let data = doc.data()
                let title = data["expense"] as? String ?? ""
                let price = data["price"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                
                return Expenses(title: title, fiyat: Int(price)!, category: category)
            }
            
            self.collectionView.reloadData()
        }
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        
        if gesture.state == .began {
            if let indexPath = collectionView.indexPathForItem(at: location) {
                let expenseToDelete = filteredModels[indexPath.row]
                
                showDeleteConfirmationAlert(at: indexPath, expenseToDelete: expenseToDelete)
            }
        }
    }
    
    func showDeleteConfirmationAlert(at indexPath: IndexPath, expenseToDelete: Expenses) {
        let alert = UIAlertController(title: "Silme Onayı", message: "\(expenseToDelete.title) adlı gideri silmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Evet", style: .destructive) { _ in
            self.deleteExpense(at: indexPath, expenseToDelete: expenseToDelete)
            self.collectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteExpense(at indexPath: IndexPath, expenseToDelete: Expenses) {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        
        let db = Firestore.firestore()
        
        db.collection("expenses")
            .whereField("category", isEqualTo: expenseToDelete.category)
            .whereField("expense", isEqualTo: expenseToDelete.title)
            .whereField("email", isEqualTo: userEmail)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Veri silinirken hata oluştu: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                for document in documents {
                    document.reference.delete { error in
                        if let error = error {
                            print("Silme hatası: \(error.localizedDescription)")
                        } else {
                            self.filteredModels.remove(at: indexPath.row)
                            self.collectionView.deleteItems(at: [indexPath])
                        }
                    }
                }
            }
    }
}
