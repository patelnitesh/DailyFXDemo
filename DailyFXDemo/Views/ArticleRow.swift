//
//  ArticleRow.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 06/05/2022.
//

import SwiftUI

struct ArticleRow: View {
    let newsArticle: Article
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let region = newsArticle.region {
                HStack(alignment: .center, spacing: 5) {
                    Image(systemName: newsArticle.regionImageName)
                    Text(region.rawValue).font(.headline)
                }
            }
            Text(newsArticle.title ?? "").font(.headline)
            Text(newsArticle.description ?? "").font(.callout)
            Text(newsArticle.displayTimestamp.convertToDisplayDate()).font(.caption2)
        }.padding(10)
    }
}

struct ArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRow(newsArticle: Article.MockArticle)
    }
}
