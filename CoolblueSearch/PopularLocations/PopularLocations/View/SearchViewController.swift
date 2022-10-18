//
//  SearchViewController.swift
//  PopularLocations
//
//  Created by Arun Kumar Nama on 16/8/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: Views
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: Properties
    
    private(set) var searchProductsViewModel: SearchProductsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.activityIndicatorView = activityIndicatorView
        
        searchProductsViewModel = SearchProductsViewModel(delegate: self)
        searchProductsViewModel?.fetchData()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (searchProductsViewModel?.products.count == 0) {
            activityIndicatorView.startAnimating()
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(UINib(nibName: "SearchProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchProductsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension  SearchViewController: SearchProductsViewModelDelegate {
    
    func onFetchCompleted() {
        tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    func onFetchFailed(with reason: String) {
        self.activityIndicatorView.stopAnimating()
        let alert = UIAlertController(title: "Sorry for Inconvinience", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - TableView Methods

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchProductsViewModel?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell :  SearchProductsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "SearchProductsTableViewCell", for: indexPath) as? SearchProductsTableViewCell
        guard let cell = tableCell else {
            fatalError("SearchProductsTableViewCell not found")
        }
        self.activityIndicatorView.stopAnimating()
        cell.configure(with: self.searchProductsViewModel?.products[indexPath.row])
        return cell
    }

}

