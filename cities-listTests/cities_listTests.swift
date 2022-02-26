//
//  cities_listTests.swift
//  cities-listTests
//
//  Created by Sunil Targe on 2022/2/26.
//

import XCTest
@testable import cities_list

class cities_listTests: XCTestCase {

    var apiService: APIService?
    var viewModel: ViewModel?
    
    override func setUpWithError() throws {
        apiService = APIService()
        viewModel = ViewModel()
    }

    override func tearDownWithError() throws {
        apiService = nil
        viewModel = nil
    }

    func testAPIResponse() throws {
        let expectation = XCTestExpectation(description: "data fetched")
        // api operation is asyncronous, so expectation will wait untile finishing
        
        var responseError: APIError?
        var responseResult: [City]?
        
        apiService?.fetchDataFromServer(complete: { result, error in
            responseError = error
            responseResult = result
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 20) // 20 secs timeout because of large data
        XCTAssertNil(responseError)
        XCTAssertNotNil(responseResult)
    }
    
    func testSearchResultByPassingValidPrefix() throws {
        // get data first and then start searching
        let fetchDataExpectation = XCTestExpectation(description: "data fetched")
        apiService?.fetchDataFromServer(complete: { [weak self] (result, error) in
            self?.viewModel?.cities = result
            fetchDataExpectation.fulfill()
        })
        wait(for: [fetchDataExpectation], timeout: 20)
        
        let searchResultExpectation = XCTestExpectation(description: "get result")
        viewModel?.foundCities("Al", completion: { result in
            XCTAssertNotEqual(result.count, 0)
            XCTAssertTrue(result.count>0)
            searchResultExpectation.fulfill()
        })
    }
    
    func testSearchResultByPassingInValidPrefix() throws {
        // get data first and then start searching
        let fetchDataExpectation = XCTestExpectation(description: "data fetched")
        apiService?.fetchDataFromServer(complete: { [weak self] (result, error) in
            self?.viewModel?.cities = result
            fetchDataExpectation.fulfill()
        })
        wait(for: [fetchDataExpectation], timeout: 20)
        
        let searchResultExpectation = XCTestExpectation(description: "get result")
        viewModel?.foundCities("&%#@", completion: { result in
            XCTAssertEqual(result.count, 0)
            searchResultExpectation.fulfill()
        })
    }
    
    func testSearchResultByPassingEmptyPrefix() throws {
        // get data first and then start searching
        let fetchDataExpectation = XCTestExpectation(description: "data fetched")
        apiService?.fetchDataFromServer(complete: { [weak self] (result, error) in
            self?.viewModel?.cities = result
            fetchDataExpectation.fulfill()
        })
        wait(for: [fetchDataExpectation], timeout: 20)
        
        let searchResultExpectation = XCTestExpectation(description: "get result")
        viewModel?.foundCities("", completion: { result in
            XCTAssertEqual(result.count, 0)
            searchResultExpectation.fulfill()
        })
    }
    
    func testSearchResultByPassingWhitespacePrefix() throws {
        // get data first and then start searching
        let fetchDataExpectation = XCTestExpectation(description: "data fetched")
        apiService?.fetchDataFromServer(complete: { [weak self] (result, error) in
            self?.viewModel?.cities = result
            fetchDataExpectation.fulfill()
        })
        wait(for: [fetchDataExpectation], timeout: 20)
        
        let searchResultExpectation = XCTestExpectation(description: "get result")
        viewModel?.foundCities("       ", completion: { result in
            XCTAssertEqual(result.count, 0)
            searchResultExpectation.fulfill()
        })
    }

}
