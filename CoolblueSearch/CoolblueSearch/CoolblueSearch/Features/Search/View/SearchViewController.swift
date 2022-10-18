//
//  SearchViewController.swift
//  PopularLocations
//
//  Created by Arun Kumar Nama on 16/8/22.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: Views
    weak var activityIndicatorView: UIActivityIndicatorView!
    let searchController = UISearchController()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: Properties
    private var tableViewDataSource: UITableViewDiffableDataSource<String, ProductCellViewModel>!
    private var productsSnapshot = NSDiffableDataSourceSnapshot<String, ProductCellViewModel>()
    
    private(set) lazy var searchProductsViewModel = SearchResultsViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationAndSearchUI()
       
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        self.activityIndicatorView = activityIndicatorView

        setupTableView()
    }
    
    fileprivate func setupNavigationAndSearchUI() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor().lightSkyBlue()
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = Constants.searchText
        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationItem.searchController = searchController
        searchController.automaticallyShowsSearchResultsController = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(UINib(nibName: "SearchProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchProductsTableViewCell")
        configureTableViewDataSource(tableView)
    }

    func configureTableViewDataSource(_ tableView: UITableView) {
        tableViewDataSource = SearchProductsDiffableDataSource(tableView: tableView)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchController.searchBar.text ?? ""
        if !searchTerm.isEmpty {
            activityIndicatorView.startAnimating()
            searchProductsViewModel.fetchData(searchTerm, page: 1)
        }
    }
    
    func createSectionedSnapshot(from items: [ProductCellViewModel]) -> NSDiffableDataSourceSnapshot<String, ProductCellViewModel> {

        var snapshot = NSDiffableDataSourceSnapshot<String, ProductCellViewModel>()
        snapshot.appendSections([""])
        snapshot.appendItems(items)
        return snapshot
    }
}

extension  SearchViewController: SearchResultsViewModelDelegate {

    func onFetchCompleted() {
        activityIndicatorView.stopAnimating()
        tableView.isHidden = false
        productsSnapshot.deleteAllItems()
        let searchTerm = searchController.searchBar.text ?? ""
        guard  searchTerm == self.searchController.searchBar.text else {
            return
        }
            
        let currentSnapshotItems = productsSnapshot.itemIdentifiers
        productsSnapshot = createSectionedSnapshot(from: currentSnapshotItems + searchProductsViewModel.viewModel)
        tableViewDataSource.apply(productsSnapshot, animatingDifferences: false, completion: nil)
    }

    
    func onFetchFailed(with reason: String) {
        self.activityIndicatorView.stopAnimating()
        let alert = UIAlertController(title: "Sorry for Inconvinience", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
