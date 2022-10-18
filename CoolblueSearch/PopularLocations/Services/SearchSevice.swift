import Foundation

protocol SearchSeviceable {
    func getProducts() async -> Result<SearchResponse, RequestError>
}

struct SearchSevice: HTTPClient, SearchSeviceable {
    func getProducts() async -> Result<SearchResponse, RequestError> {
    //  return await sendRequest(endpoint: SearchEndpoint.searchProduct, responseModel: SearchResponse.self)
        return await fetchItems(matching: ["query": "apple", "page" : "1"])
    }
}
