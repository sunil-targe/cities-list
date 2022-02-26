//
//  ViewModel.swift
//  cities-list
//
//  Created by Sunil Targe on 2022/2/26.
//

import Foundation
import UIKit

class ViewModel {
    let apiService: APIServiceProtocol

    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var cities: [City]? {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var searchedCities: [City]? {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
        
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    
    // MARK:- Init api service
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    // MARK:- fetch and manage data
    func initFetch() {
        self.isLoading = true
        apiService.fetchDataFromServer() { [weak self] (result, error) in
            if let error = error {
                self?.isLoading = false
                self?.alertMessage = error.rawValue
                return
            }
            
            if let result = result {
                self?.cities = result.sorted(by: { $0.name < $1.name })
            } else {
                self?.alertMessage = APIError.noData.rawValue
            }
            
            self?.isLoading = false
        }
    }

    func searching(by text: String) {
        self.foundCities(text) { [weak self] (result) in
            self?.searchedCities = result
        }
    }
    
    func foundCities(_ text: String, completion: (_ result: [City]) -> ()) {
        if !text.isEmpty, let result = cities?.filter ({$0.name.prefix(text.count).lowercased() == text.lowercased()}) {
            completion(result)
        } else {
            completion([])
        }
    }
}
