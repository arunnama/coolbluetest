import Foundation

protocol SearchServiceProtocol {
    func getProducts(query: [String: String]) async -> Result<SearchResponse, RequestError>
}

class SearchSevice: NetworkingServiceProtocol, SearchServiceProtocol {
    func getProducts(query: [String: String]) async -> Result<SearchResponse, RequestError> {
        return await fetchItems(matching: query, endpoint: SearchEndpoint.searchProduct, responseModel: SearchResponse.self)
    }
}
