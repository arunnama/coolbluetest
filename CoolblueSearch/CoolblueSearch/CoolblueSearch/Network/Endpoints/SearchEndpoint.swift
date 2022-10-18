enum SearchEndpoint {
    case searchProduct
}

extension SearchEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .searchProduct:
            return "/ios-assignment/search"
        }
    }
    
    var host: String {
        switch self {
        case .searchProduct:
            return "bdk0sta2n0.execute-api.eu-west-1.amazonaws.com"
        }
    }

    var method: RequestMethod {
        switch self {
        case .searchProduct:
            return .get
        }
    }
}
