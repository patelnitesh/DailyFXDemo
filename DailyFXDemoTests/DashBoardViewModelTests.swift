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
        print("**",#function)
        
        let newsArticles = Bundle.main.decode(ArticlesResponse.self, from: "NewsArticles.json")
        mockDailyFxService = MockDailyFxService()
        mockDailyFxService.fetchArticles = Result.success(newsArticles).publisher.eraseToAnyPublisher()
        subject = DashBoardViewModel(service: mockDailyFxService)
    }

    override func tearDownWithError() throws {
        print("**",#function)
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        subject = nil
        mockDailyFxService = nil
    }

    func test_VMLoaded() throws {
        print("**",#function)
        XCTAssertTrue(mockDailyFxService.getArticlesCalled)
    }
    
    func testGetArticlesPopulated() {
        print("**",#function)
        let expectation = XCTestExpectation(description: "Articles received and state set to success")
        var expectedState:ResultState?
        
        subject.$state.sink { state in
            print("** State",state)
            expectedState = state
            
            //TODO: Expected state should have change from .loading to Success - check if we can compare enum value e.g.
            // XCTAssertEqual(state, .success)
            
            expectation.fulfill()
          }.store(in: &cancellable)

        subject.getArticles()

        // VM state should have change to Success as API successfully finished
        XCTAssertNotNil(expectedState)
        
        // Expecting to have 3 Sections
        XCTAssertEqual(subject.sectionItems().count, 4)
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetArticlesPopulated_Failed() {
        print("**",#function)
        
        let expectation = XCTestExpectation(description: "Articles should not have received and state set to failed")
        var expectedState:ResultState?
        
        subject.$state.sink { state in
            print("** State",state)
            expectedState = state
            
            //TODO: Expected state should have change from .loading to Success - check if we can compare enum value e.g.
            // XCTAssertEqual(state, .success)
            
            expectation.fulfill()
          }.store(in: &cancellable)

        // Manupulated API to return error
        
        mockDailyFxService.fetchArticles = Fail(error: .unknown).eraseToAnyPublisher()
        subject.getArticles()

        // VM state should have change to Failed with Error Type  DailyFXDemo.APIError.unknown as API failed
        XCTAssertNotNil(expectedState)
        
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
