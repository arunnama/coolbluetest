
import Foundation
import UIKit

protocol NetworkingServiceProtocol {
    func fetchItems<T: Decodable>(matching query: [String: String], endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
    
}

extension NetworkingServiceProtocol {
    
    func fetchItems<T: Decodable>(matching query: [String: String], endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        print(endpoint)
        
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            print(response)
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, RequestError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(.unknown))
            } else if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(.imageDataMissing))
            }
        }
        task.resume()
    }
}
