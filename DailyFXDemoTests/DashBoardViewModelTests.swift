//
//  DashBoardViewModel.swift
//  DailyFXDemoTests
//
//  Created by Nitesh Patel on 07/05/2022.
//

import XCTest
import Combine
@testable import DailyFXDemo

class DashBoardViewModelTests: XCTestCase {

    var subject: DashBoardViewModel!
    var mockDailyFxService: MockDailyFxService!
    private var cancellable: Set<AnyCancellable> = []

    
    override func setUpWithError() throws {
        let newsArticles = Bundle.main.decode(ArticlesResponse.self, from: "NewsArticles.json")
        mockDailyFxService = MockDailyFxService()
        mockDailyFxService.fetchArticles = Result.success(newsArticles).publisher.eraseToAnyPublisher()
        subject = DashBoardViewModel(service: mockDailyFxService)
    }

    override func tearDownWithError() throws {
        subject = nil
        mockDailyFxService = nil
    }

    func test_VMLoaded() throws {
        XCTAssertTrue(mockDailyFxService.getArticlesCalled)
    }
    
    func testGetArticlesPopulated() {
        let expectation = XCTestExpectation(description: "Articles received and state set to success")
        var expectedState:ResultState?
        
        subject.$state.dropFirst().sink { state in
            expectedState = state
            expectation.fulfill()
          }.store(in: &cancellable)
        
        subject.getArticles()

        // VM state should have change to Success as API successfully finished
        XCTAssertNotNil(expectedState)
        XCTAssertEqual(expectedState, .success)
        
        // Expecting to have 3 Sections
        XCTAssertEqual(subject.sectionItems().count, 4)
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetArticlesPopulated_Failed() {
        let expectation = XCTestExpectation(description: "Articles should not have received and state set to failed")
        var expectedState:ResultState?
        let expectedError = APIError.unknown

        subject.$state.dropFirst(2).sink { state in
            expectedState = state
            XCTAssertEqual(expectedState, .failed(APIError.unknown.toEquatableError()))
            expectation.fulfill()
          }.store(in: &cancellable)

        // Manipulated API to return error
        mockDailyFxService.fetchArticles = Fail(error: expectedError).eraseToAnyPublisher()
        subject.getArticles()

        // VM state should have change to Failed with Error Type  DailyFXDemo.APIError.unknown as API failed
        XCTAssertNotNil(expectedState)
        XCTAssertEqual(expectedState, .failed(expectedError.toEquatableError()))

        // Expecting to have 3 Sections
        XCTAssertEqual(subject.sectionItems().count, 0)
     
        wait(for: [expectation], timeout: 1)
      }
    
    func test_sections_articles_rows() {
        let allNewsSections = subject.sectionItems()
        
        let topNews = allNewsSections.filter { $0.header == .topNews}
        XCTAssertEqual(topNews.first?.rows.count, 3)
        
        // This still need to handle as per Region
        
        let dailyBriefings = allNewsSections.filter { $0.header == .dailyBriefings }
        XCTAssertEqual(dailyBriefings.first?.rows.count, 3)
        
        let specialReport = allNewsSections.filter { $0.header == .specialReport }
        XCTAssertEqual(specialReport.first?.rows.count, 5)
    
        let technicalAnalysis = allNewsSections.filter { $0.header == .technicalAnalysis }
        XCTAssertEqual(technicalAnalysis.first?.rows.count, 5)
    }
}
