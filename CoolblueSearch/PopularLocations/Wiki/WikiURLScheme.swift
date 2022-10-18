//
//  URLSchema.swift
//  PopularLocations
//
//  Created by Arun Kumar Nama on 16/8/22.
//
import Foundation
import UIKit

public struct WikiURLScheme {
    
    let URLScheme = "wikipedia"
    let host: String = "places"

    func open(_ location: Location) {
        if let url = composeURL(location: location) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }

    private func composeURL(location: Location) -> URL? {

        guard let lat = location.lat, let long = location.long else {
            return nil
        }
        
        var components = URLComponents()
        components.scheme = URLScheme
        components.host = host
        
        var wikiName = ""
        if let name = location.name {
            wikiName = name.replacingOccurrences(of: " ", with: "_")
        }

        let queryItemString = "https://en.wikipedia.org/wiki/\(wikiName)?name=\(wikiName)&lat=\(lat)&long=\(long)"
        let queryItemStringEscaped = queryItemString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        components.queryItems = [
            URLQueryItem(name: "WMFArticleURL", value: queryItemStringEscaped),
        ]

        return components.url
    }

}
