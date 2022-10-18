
import Foundation

protocol SearchProductsViewModelDelegate: AnyObject {
  func onFetchCompleted()
  func onFetchFailed(with reason: String)
}

final class SearchProductsViewModel {
  private weak var delegate: SearchProductsViewModelDelegate?
  
  private var currentPage = 1
  private var total = 0
  private var isFetchInProgress = false
  
  private(set) var products: [Product] = []
  private let service: SearchSeviceable
  
  init(delegate: SearchProductsViewModelDelegate) {
    self.delegate = delegate
    self.service = SearchSevice()
  }
  
  var totalCount: Int {
    return total
  }
  
  func products(at index: Int) -> Product {
    return products[index]
  }
 
  func fetchData() -> Void {
      Task(priority: .background) {
        let result = await service.getProducts()
        print(result)
        switch result {
        case .success(let response):
            self.products = response.products ?? []
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
}
