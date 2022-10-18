//
//  LocationUITableViewCell.swift
//  PopularLocations
//
//  Created by Arun Kumar Nama on 16/8/22.
//

import UIKit

class SearchProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var listPriceIncVat: UILabel!
    @IBOutlet weak var reviewAverage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with product: Product?) {
        guard let product = product else {
            return
        }
        
        productName.text = product.productName
        
        if let avg = product.reviewInformation?.reviewSummary?.reviewAverage {
            reviewAverage.text = String(avg)
        }
        
        if let price = product.listPriceIncVat {
            listPriceIncVat.text = String(price)
        }
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      configure(with: .none)
    }
}
