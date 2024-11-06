//
//  FeedVC.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 4.11.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FeedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var uiView2: UIView!
    @IBOutlet weak var coView: UIView!
    @IBOutlet weak var kalanMoney: UILabel!
    
    var models: [Categories] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        collectionView.reloadData()
        setupUI()
        fetchGelirText()
        fetchUserName()
        view.backgroundColor = .systemGray6
        fetchCategories()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchTotalExpenses()
        dateFormat()
    }
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        if gesture.state == .began {
            if let indexPath = collectionView.indexPathForItem(at: location) {
                let selectedCategory = models[indexPath.row]
                showDeleteAlert(for: selectedCategory.title)
            }
        }
    }

    private func showDeleteAlert(for categoryName: String) {
        let alert = UIAlertController(title: "UYARI", message: "\(categoryName) adlı kategoriyi silmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Evet", style: .destructive, handler: { _ in
            self.deleteCategory(categoryName: categoryName)
            self.collectionView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Hayır", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    
    
    
    func dateFormat(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let todayDate = Date()
        let formattedDate = dateFormatter.string(from: todayDate)
        dateLabel.text = formattedDate
        
    }
    
    private func configure(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
    }
    private func setupUI(){
        greenView.layer.cornerRadius = 10
        redView.layer.cornerRadius = 10
        uiView.layer.cornerRadius = 50
        uiView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        uiView.clipsToBounds = true
        categoriesView.backgroundColor = UIColor.systemGray4
        coView.backgroundColor = .systemGray6
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Kategori Giriniz", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Kategori ismi.."
        }
        alert.addAction(UIAlertAction(title: "Ekle", style: .default, handler: { _ in
            if let kategoriText = alert.textFields?.first?.text, !kategoriText.isEmpty {
                let yeniKategori = Categories(title: kategoriText)
                self.models.append(yeniKategori)
                self.collectionView.reloadData()
                
                let userMail = Auth.auth().currentUser?.email
                let db = Firestore.firestore()
                db.collection("categories").addDocument(data: [
                    "category":kategoriText,
                    "email": userMail as Any
                ]) { error in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                    } else {
                        print("kayıt başarılı")
                        self.collectionView.reloadData()
                    }
                }
                
                
            }
        }))
        alert.addAction(UIAlertAction(title: "İptal", style: .destructive))
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCell
        let model = models[indexPath.row]
        cell.items = model
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 2) - 15
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = models[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
            detailVC.items = selectedItem
            detailVC.modalPresentationStyle = .fullScreen
            detailVC.modalTransitionStyle = .coverVertical
            present(detailVC, animated: true)
        }
        
    }
    
    private func fetchGelirText() {
        let db = Firestore.firestore()
        db.collection("gelir").whereField("email", isEqualTo: Auth.auth().currentUser?.email ?? "").getDocuments { snapshot, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("Veri yok")
                return
            }
            
            for document in documents {
                let data = document.data()
                if let gelirText = data["gelir"] as? String {
                    self.incomeLabel.text = "₺\(gelirText)"
                    
                    
                    if let gelir = Int(gelirText) {
                        self.kalanMoney.text = "₺\(gelir)"
                        
                        
                        if let expense = Int(self.expenseLabel.text ?? "0") {
                            self.kalanMoney.text = "₺\(gelir - expense)"
                        }
                        
                    } else {
                        print("Gelir değeri geçersiz")
                    }
                }
            }
        }
    }

    private func fetchTotalExpenses() {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let db = Firestore.firestore()
        db.collection("expenses").whereField("email", isEqualTo: userEmail).getDocuments { snapshot, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("Veri yok")
                return
            }
            
            var totalExpenses = 0
            
            for document in documents {
                let data = document.data()
                if let priceText = data["price"] as? String, let price = Int(priceText) {
                    totalExpenses += price
                }
            }
            
            self.expenseLabel.text = "₺\(totalExpenses)"
            
            
            if let gelirText = self.incomeLabel.text?.replacingOccurrences(of: "₺", with: ""), let gelir = Int(gelirText) {
                self.kalanMoney.text = "₺\(gelir - totalExpenses)"
                
                if (gelir - totalExpenses) < 0 {
                    self.kalanMoney.textColor = .red
                } else {
                    self.kalanMoney.textColor = .black
                }
            } else {
                print("Gelir veya harcama değeri geçersiz")
            }
        }
    }

    
    private func fetchUserName(){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            
            guard let document = snapshot, document.exists else {
                print("veri yok")
                return
            }
            
            let data = document.data()
            if let userName = data?["fullName"] as? String {
                self.fullNameLabel.text = userName
            }
            
        }
    }
    
    private func fetchCategories(){
        guard let userMail = Auth.auth().currentUser?.email else {return}
        let db = Firestore.firestore()
        db.collection("categories").whereField("email", isEqualTo: userMail).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("veri yok")
                return
            }
            
            for document in documents {
                
                let data = document.data()
                if let categoryName = data["category"] as?  String {
                    
                    let category = Categories(title: categoryName)
                    self.models.append(category)
                    self.collectionView.reloadData()
                    
                }
                
            }
            
        }
    }


    func deleteCategory(categoryName: String) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            print("Kullanıcı girişi yapılmamış.")
            return
        }
        let db = Firestore.firestore()
        
        let batch = db.batch()
        
        let categoryRef = db.collection("categories")
            .whereField("email", isEqualTo: userEmail)
            .whereField("category", isEqualTo: categoryName)
        
        categoryRef.getDocuments { snapshot, error in
            if let error = error {
                print("Kategori silinirken hata: \(error.localizedDescription)")
                return
            }
            
            guard let categoryDocuments = snapshot?.documents, !categoryDocuments.isEmpty else {
                print("Kategori bulunamadı.")
                return
            }
            
            let categoryDocument = categoryDocuments.first!
            batch.deleteDocument(categoryDocument.reference)
            
            let expensesRef = db.collection("expenses")
                .whereField("category", isEqualTo: categoryName)
                .whereField("email", isEqualTo: userEmail)
            
            expensesRef.getDocuments { snapshot, error in
                if let error = error {
                    print("Giderler silinirken hata: \(error.localizedDescription)")
                    return
                }
                
                guard let expenseDocuments = snapshot?.documents else {
                    print("Giderler bulunamadı.")
                    return
                }
                
                for expenseDocument in expenseDocuments {
                    batch.deleteDocument(expenseDocument.reference)
                }
                
                batch.commit { error in
                    if let error = error {
                        print("Batch işlemi sırasında hata: \(error.localizedDescription)")
                    } else {
                        print("Kategori ve giderler başarıyla silindi.")
                        
                        self.models.removeAll { $0.title == categoryName }
                        self.collectionView.reloadData() // Koleksiyon görünümünü yeniden yükle
                    }
                }
            }
        }
    }

    
    
}


