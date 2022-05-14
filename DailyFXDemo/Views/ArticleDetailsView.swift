//
//  ArticleDetailsView.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 07/05/2022.
//

import SwiftUI

struct ArticleDetailsView: View {
    let articles: [Article]
    let selectedArticle: Article
    
    @State private var currentIndex = UUID()
    
    var body: some View {
        // Tabview used so we can swip left or right to see other News Articles..
        
        TabView(selection: $currentIndex){
            ForEach(articles, id: \.id) { article in
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Title
                    Text(article.title ?? "").font(.title2)
                    
                    // Author Info
                    HStack(alignment: .center, spacing: 10) {
                        AsyncImageView(url: article.authors.first?.photo ?? "")
                            .frame(width: 50, height: 50, alignment: .center)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(article.authorNameTitle).font(.callout)
                            Text(article.displayTimestamp.convertToDisplayDate()).font(.caption2)
                        }
                    }
                    .tag(article.id)
                    
                    Divider()
                    
                    // Load Article URL in WebView
                    if let url = URL(string: article.webpage) {
                        WebView(url:url)
                    }
                    Spacer()
                }.padding(10)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            currentIndex = selectedArticle.id
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    actionSheet()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    func actionSheet() {
        guard let article = articles.first (where: { $0.id == currentIndex }),
              let url = article.url,
              let urlShare = URL(string: url) else {
            return
        }
        let activityVC = UIActivityViewController(activityItems: [urlShare],
                                                  applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC,
                                                                        animated: true,
                                                                        completion: nil)
    }
}

struct ArticleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailsView(articles: [Article.MockArticle,Article.MockArticle,Article.MockArticle],
                           selectedArticle: Article.MockArticle)
    }
}
