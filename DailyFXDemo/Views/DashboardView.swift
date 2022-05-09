//
//  NewsArticlesView.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 06/05/2022.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = DashBoardViewModel(service: DailyFxServiceImpl())
    
    var body: some View {
        
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .failed(let error):
            ErrorView(error: error) {
                self.viewModel.getArticles()
            }
        case .success:
            
            NavigationView {
                VStack{
                    List {
                        // BreakingNews section
                        if let breakingNews = viewModel.breakingNews {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(ArticleType.breakingNews.rawValue).font(.title3)
                                Text(breakingNews)
                            }
                        }
                        
                        // All other sections
                        ForEach(viewModel.sectionItems(), id: \.id) { section in
                            Section(header: Text(section.header.rawValue)) {
                                ForEach(section.rows, id: \.id) { article in
                                    
                                    // TODO: Pass on all News articles not only section specific
                                    NavigationLink(destination:ArticleDetailsView(articles: section.rows,
                                                                                  selectedArticle: article)){
                                        ArticleRow(newsArticle: article)
                                    }// nav link
                                }// foreach
                            }// section
                        }// foreach
                    }// List
                }
                .navigationTitle(Text("Articles"))
                .refreshable {
                    viewModel.getArticles()
                }
            }// Nav
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
