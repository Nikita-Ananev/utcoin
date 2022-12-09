//
//  SearchViewController.swift
//  utcoin
//
//  Created by Никита Ананьев on 24.11.2022.
//

import UIKit

final class SearchViewController: UIViewController  {
    //MARK: Properties
    var isSearch = false
    let network = Networking()
    var campaigns = [Campaign]()
    var products = [Product]()
    var searchTimer: Timer?
    //MARK: Views
    
    let backButton = UIButton()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Поиск.."
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        searchTextField.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.register(CollectionViewCell.self, forCellReuseIdentifier: "CollectionViewCell")
        
        setConstraints()
        
    }
    
    private func setConstraints(){
        view.addSubview(searchTextField)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            searchTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        var searchText  = textField.text! + string
        
        if string  == "" {
            searchText = (searchText as String).substring(to: searchText.index(before: searchText.endIndex))
        }
        
        if searchText == "" {
            isSearch = false
        }
        else{
            searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                DispatchQueue.main.async {
                    self.network.fetchSearchingData(searchText) {[weak self] result in
                        switch result {
                        case .success(let data):
                            self?.campaigns = data.campaigns
                            self?.products = data.products
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            })
        }
        
        return true
    }
}
extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // this checks for whether contentOffset.x is around 10 (contented shifted to the right by 10 points)
        
    }
}
// MARK: TableView


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? ProductCell {
            let product = products[indexPath.row + (campaigns.count > 0 ? -1 : 0)]
            let VC = ProductDescriptionController()
            VC.product = product
            navigationController?.pushViewController(VC, animated: true)
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count + (campaigns.count > 0 ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if campaigns.count > 1 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.campaings = campaigns
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let product = products[indexPath.row + (campaigns.count > 0 ? -1 : 0)]
        let productImage = URL(string: "\(product.imageUrls[0])")!
        let campaignImage = URL(string: "\(product.campaignImageUrl)")!
        
        cell.productNameLabel.text = product.name
        cell.cashbackLabel.text = product.cashback
        cell.priceLabel.text = product.price
        cell.displayCampaignImage(image: nil)
        cell.displayProductImage(image: nil)
        
        
        network.downloadWithUrlSession(url: productImage) { image in
            DispatchQueue.main.async {
                cell.displayProductImage(image: image)
            }
        }
        network.downloadWithUrlSession(url: campaignImage) { image in
            DispatchQueue.main.async {
                cell.displayCampaignImage(image: image)
            }
        }
        
        
        return cell
    }
}
extension SearchViewController: SelectCollectionDelegate {
    func didSelectCampaingCell(indexPath: IndexPath) {
        let campaign = campaigns[indexPath.row]
        
        let vc = CampaignDescriptionController()
        vc.campaign = campaign
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
