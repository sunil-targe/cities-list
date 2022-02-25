//
//  APIService.swift
//  country-list
//
//  Created by Sunil Targe on 2022/2/26.
//

import Foundation
import SystemConfiguration

enum APIError: String {
    case noNetwork = "No Network 🐒"
    case noData = "No data 🙊"
    case errorOccured = "Error occured 🙈"
}

protocol APIServiceProtocol {
    func fetchDataFromServer(complete: @escaping (_ result: [City]?, _ error: APIError? )->() )
}

class APIService: APIServiceProtocol {
    func fetchDataFromServer(complete: @escaping (_ result: [City]?, _ error: APIError? )->() ) {
        let urlString = "https://raw.githubusercontent.com/SiriusiOS/ios-assignment/main/cities.json"
        
        // encode url string
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            return complete(nil, APIError.errorOccured)
        }
        
        // set up URLRequest
        guard let urlRequest = URL(string: encodedURLString) else {
            return complete(nil, APIError.errorOccured)
        }
        
        // make a request
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            // check for error
            guard error == nil else {
                if self.isNetworkAvailable() {
                    complete(nil, APIError.errorOccured)
                } else {
                    complete(nil, APIError.noNetwork)
                }
                return
            }
            
            // make sure we got data in the response
            guard let data = data else {
                complete(nil, APIError.noData)
                return
            }
            
            do {
                let result = try? JSONDecoder().decode([City].self, from: data)
                complete(result, nil)
            }
        }
        task.resume()
    }
    
    
    // Network/Mobile data check function
    private func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

