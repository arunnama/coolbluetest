
import Foundation

protocol SearchResultsViewModelDelegate: AnyObject {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

final class SearchResultsViewModel {
    
    private weak var delegate: SearchResultsViewModelDelegate?
   
    private let service: SearchServiceProtocol
    
    var viewModel = [ProductCellViewModel]()
    
    init(delegate: SearchResultsViewModelDelegate,
         service: SearchServiceProtocol = SearchSevice()) {
        self.delegate = delegate
        self.service = service
    }
    
    func fetchData(_ searchTerm: String, page: Int) -> Void {
        Task(priority: .background) {
            let result = await service.getProducts(query: ["query" : searchTerm, "page": String(page)])
            print(result)
            switch result {
            case .success(let response):
                self.createProductCellViewModel(products: response.products ?? [])
                await MainActor.run{
                    delegate?.onFetchCompleted()
                }
            case .failure(let error):
                await MainActor.run{
                    delegate?.onFetchFailed(with: error.localizedDescription)
                }
            }
        }
    }
    
    func createProductCellViewModel(products: [Product]) {
        viewModel = [ProductCellViewModel]()
        for product in products {
            
            guard let productName = product.productName else {
                continue
            }
            var cellViewModel = ProductCellViewModel(productName: productName)

            if let review = product.reviewInformation?.reviewSummary?.reviewAverage {
                cellViewModel.rating = String(review)
            }
            if let price = product.salesPriceIncVat {
                cellViewModel.price = Constants.currencySymbol + String(price)
            }
            if let imageUrl = product.productImage {
                cellViewModel.imageUrl = imageUrl
            }
            viewModel.append(cellViewModel)
        }
    }
}

struct ProductCellViewModel: Hashable {
    var productName: String
    var rating: String?
    var price: String?
    var imageUrl: String?
}
