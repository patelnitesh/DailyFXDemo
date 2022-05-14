//
//  ArticlesViewModel.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 06/05/2022.
//

import Foundation
import Combine

enum ArticleType: String {
    case breakingNews = "Breaking News"
    case topNews = "Top News"
    case dailyBriefings = "Daily Briefings"
    case technicalAnalysis = "Technical Analysis"
    case specialReport = "Special Report"
}

enum Region: String {
    case EU = "Europe"
    case US = "United States"
    case ASIA = "Asia & Oceania"
}

public class DashBoardViewModel: ObservableObject {
    
    private let service: DailyFxService
    private(set) var dashboardResponse: ArticlesResponse?
    @Published private(set) var state: ResultState = .loading
    private var cancellable = Set<AnyCancellable>()

    init(service: DailyFxService) {
        self.service = service
        self.getArticles()
    }
    
    func getArticles() {
        self.state = .loading
        let cancellable = self.service
            .requestArticles(from: .getArticles)
            .sink { (res) in
                switch res {
                case .failure(let error):
                    self.dashboardResponse = nil
                    self.state = .failed(error.toEquatableError())
                case .finished:
                    self.state = .success
                }
            } receiveValue: { res in
                self.dashboardResponse = res
            }
        
        self.cancellable.insert(cancellable)
    }
    
    // TODO: Handle Breaking News and Daily briefing
    func sectionItems() -> [DisplayableArticlesSections]  {
        guard let newsArticles = dashboardResponse else {
            return []
        }
        var dashboardData: [DisplayableArticlesSections]
        
        dashboardData = [DisplayableArticlesSections(header: .topNews, rows: newsArticles.topNews)]
        dashboardData.append(contentsOf: regionSpecificArticles())
        dashboardData.append(contentsOf: [DisplayableArticlesSections(header: .technicalAnalysis, rows: newsArticles.technicalAnalysis),
                             DisplayableArticlesSections(header: .specialReport, rows: newsArticles.specialReport)])
        return dashboardData
    }
    
    // This definitely need Refactor
    func regionSpecificArticles()-> [DisplayableArticlesSections] {
        guard let newsArticles = dashboardResponse else {
            return []
        }
        var regionArticles: [DisplayableArticlesSections] = []
        
        var dailyBriefingsRows: [Article] = []
        dailyBriefingsRows = newsArticles.dailyBriefings.eu.map { article -> Article in
            var newArticle = article
            newArticle.region = .EU
            return newArticle
        }
        
        dailyBriefingsRows.append(contentsOf: newsArticles.dailyBriefings.asia.map { article -> Article in
            var newArticle = article
            newArticle.region = .ASIA
            return newArticle
        })
        
        dailyBriefingsRows.append(contentsOf: newsArticles.dailyBriefings.us.map { article -> Article in
            var newArticle = article
            newArticle.region = .US
            return newArticle
        })
        
        regionArticles = [DisplayableArticlesSections(header:.dailyBriefings, rows: dailyBriefingsRows)]
        
        return regionArticles
    }
    
    var breakingNews: String? {
        dashboardResponse?.breakingNews ?? nil
    }
}

struct DisplayableArticlesSections: Hashable {
    static func == (lhs: DisplayableArticlesSections, rhs: DisplayableArticlesSections) -> Bool {
        lhs.header == rhs.header && lhs.rows == rhs.rows
    }
    let id = UUID()
    let header: ArticleType
    let rows: [Article]
}
