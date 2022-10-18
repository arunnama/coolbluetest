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
    @IBOutlet weak var imgViewProduct: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with cellViewModel: ProductCellViewModel, service: SearchServiceProtocol = SearchSevice()) {
        productName.text = cellViewModel.productName
        reviewAverage.text = cellViewModel.rating
        listPriceIncVat.text = cellViewModel.price
        
        if let imgUrl = cellViewModel.imageUrl, let Url = URL(string: imgUrl) {
            SearchSevice().fetchImage(from: Url) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.imgViewProduct.image = image
                    case .failure(let error):
                        self.imgViewProduct.image = UIImage(systemName: "photo")
                        print("Error fetching image: \(error)")
                    }
                }
            }
        }
    }
}
