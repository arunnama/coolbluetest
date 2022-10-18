//
//  SearchProductsDiffableDataSource.swift
//  CoolblueSearch
//
//  Created by Arun Kumar Nama on 17/10/22.
//

import Foundation

import UIKit

class SearchProductsDiffableDataSource: UITableViewDiffableDataSource<String, ProductCellViewModel>{
   
    init(tableView: UITableView) {
        super.init(tableView: tableView) { (tableView, indexPath, product) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchProductsTableViewCell", for: indexPath) as! SearchProductsTableViewCell
            cell.configure(with: product)
            
            return cell
        }
    }
}
