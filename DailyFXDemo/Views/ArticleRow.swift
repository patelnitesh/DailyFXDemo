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
                Text(region).font(.headline)
            }
            Text(newsArticle.title).font(.headline)
            Text(newsArticle.specialReportDescription).font(.callout)
            Text(newsArticle.displayTimestamp.convertToDisplayDate()).font(.caption2)
        }.padding(10)
    }
}

struct ArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRow(newsArticle: Article.MockArticle)
    }
}
