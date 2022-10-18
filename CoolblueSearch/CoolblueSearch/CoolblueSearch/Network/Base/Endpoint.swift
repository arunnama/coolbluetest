//
//  RequestPath.swift
//  RequestApp
protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    var header: [String: String]? {
        return nil
    }
    var body: [String: String]? {
        return nil
    }
}
