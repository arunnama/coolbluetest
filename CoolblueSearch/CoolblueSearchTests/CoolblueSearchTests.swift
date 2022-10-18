//
//  CoolblueSearchTests.swift
//  CoolblueSearchTests
//
//  Created by Arun Kumar Nama on 15/10/22.
//

import XCTest
@testable import CoolblueSearch

final class CoolblueSearchTests: XCTestCase, SearchServiceProtocol {

    private var callbackExpectation: XCTestExpectation!
    private var viewModelDelegateExpectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func test_searchViewModel_init() {
        let delegate = MockVMDelegeate()
        let vm = SearchResultsViewModel(delegate: delegate)
        XCTAssert(vm.viewModel.count == 0)
    }
    
    func test_createViewModelFromModel() {
        let delegate = MockVMDelegeate()
        let vm = SearchResultsViewModel(delegate: delegate)
        let product = Product(productID: 1213, productName: "sdfsdf", reviewInformation: nil, usps: nil, availabilityState: nil, salesPriceIncVat: nil, productImage: nil, coolbluesChoiceInformationTitle: nil, promoIcon: nil, nextDayDelivery: nil, listPriceIncVat: nil, listPriceExVat: nil)
        vm.createProductCellViewModel(products: [product, product])
        
        XCTAssert(vm.viewModel.count == 2)
    }
    
    func test_viewmodel_data() {
        let delegate = MockVMDelegeate()
        let vm = SearchResultsViewModel(delegate: delegate)
        let product = Product(productID: 1213, productName: "sdfsdf", reviewInformation: nil, usps: nil, availabilityState: nil, salesPriceIncVat: nil, productImage: nil, coolbluesChoiceInformationTitle: nil, promoIcon: nil, nextDayDelivery: nil, listPriceIncVat: nil, listPriceExVat: nil)
        vm.createProductCellViewModel(products: [product, product])
        
        XCTAssert(vm.viewModel.first?.productName == "sdfsdf")
        XCTAssertNil(vm.viewModel.first?.imageUrl)
        XCTAssertNil(vm.viewModel.first?.rating)
    }
    
    func test_viewmodel_service() {
        let delegate = MockVMDelegeate()
        let vm = SearchResultsViewModel(delegate: delegate, service: self)
        callbackExpectation = expectation(description: "callback expectation")
        vm.fetchData("hello", page: 0)
        waitForExpectations(timeout: 2)
    }

    func getProducts(query: [String: String]) async -> Result<SearchResponse, RequestError> {
        callbackExpectation.fulfill()
        
        return .success(SearchResponse(products: nil, currentPage: nil, pageSize: nil, totalResults: nil, pageCount: nil))
    }
}

class MockVMDelegeate: SearchResultsViewModelDelegate {
    func onFetchCompleted() {
        print("call completed")
    }
    func onFetchFailed(with reason: String) {
        print("call failed")
    }
}

