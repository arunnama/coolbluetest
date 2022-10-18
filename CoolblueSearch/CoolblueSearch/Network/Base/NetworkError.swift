import Foundation

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case imageDataMissing
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        case .imageDataMissing:
            return "Image data missing"
        default:
            return "Unknown error"
        }
    }
}

