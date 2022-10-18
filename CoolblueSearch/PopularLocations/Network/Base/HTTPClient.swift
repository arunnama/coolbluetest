
import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
    func fetchItems(matching query: [String: String]) async -> Result<SearchResponse, RequestError>
}


extension HTTPClient {
    
    func fetchItems(matching query: [String: String]) async -> Result<SearchResponse, RequestError> {
        var urlComponents = URLComponents(string: "https://bdk0sta2n0.execute-api.eu-west-1.amazonaws.com/ios-assignment/search")!
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            
            return .failure(.invalidURL)
        }
        print(url.absoluteString)
        var request = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            
            print(response)
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(SearchResponse.self, from: data) else {
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

    
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> { 
        var urlComponents = URLComponents()
        print(endpoint)
        
        urlComponents.scheme = endpoint.scheme
        
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        
        guard let url = urlComponents.url else {
            
            return .failure(.invalidURL)
        }
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
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
}
