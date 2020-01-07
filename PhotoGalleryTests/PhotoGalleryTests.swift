//
//  PhotoGalleryTests.swift
//  PhotoGalleryTests
//
//  Created by SINCY on 06/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import XCTest
@testable import PhotoGallery

class PhotoGalleryTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testFlickrImageSearchAPIIsWorking() {

        NetworkHandler.shared.getImagesFor(searchString: "kittens", page: 11) { (response) in
            switch response {
            case .success(let result):
                XCTAssertNil(result, "API did not give any response")
            case .failure( _):
                XCTFail("Fail - error received")
            }

        }
    }
    
    func testFlickrImageSearchAPIResponsePageCorrectness() {
        let page = 11
        NetworkHandler.shared.getImagesFor(searchString: "kittens", page: page) { (response) in
            switch response {
            case .success(let pageResults):
                XCTAssertTrue(pageResults.currentPage == page, "Incorrect Page Results")
                
            case .failure( _):
                XCTFail("Fail")
            }

        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
