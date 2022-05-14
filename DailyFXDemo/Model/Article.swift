//
//  Article.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 09/05/2022.
//

import Foundation

// MARK: - Article
struct Article: Codable, Identifiable, Hashable {
    let id = UUID()
    let title: String?
    let url: String?
    let description: String?
    let content, firstImageURL: String?
    let headlineImageURL: String?
    let articleImageURL, backgroundImageURL: String?
    let videoType, videoID: String?
    let videoURL: String?
    let videoThumbnail: String?
    let newsKeywords: String?
    let authors: [Author]
    let instruments: [String]?
    let tags: [String]?
    let categories: [String]?
    let displayTimestamp, lastUpdatedTimestamp: Int
    
    var region: Region? = nil

    enum CodingKeys: String, CodingKey {
        case title, url
        case description = "description"
        case content
        case firstImageURL = "firstImageUrl"
        case headlineImageURL = "headlineImageUrl"
        case articleImageURL = "articleImageUrl"
        case backgroundImageURL = "backgroundImageUrl"
        case videoType
        case videoID = "videoId"
        case videoURL = "videoUrl"
        case videoThumbnail, newsKeywords, authors, instruments, tags, categories, displayTimestamp, lastUpdatedTimestamp
    }
}

extension Article {
    
    // TODO: Handle multiple names
    var authorNameTitle: String {
        (authors.first?.name ?? "No name") + "," + (authors.first?.title ?? "")
    }

    static var MockArticle: Article {
        return Bundle.main.decode(Article.self, from: "Article.json") as Article
    }
    
    // URL append `webview` so visually it looks nice.
    var webpage: String {
        guard let url = url else {
            return ""
        }
        return url + "/webview"
    }
    
    var regionImageName: String {
        switch region {
        case .EU:
            return "globe.europe.africa"
        case .US:
            return "globe.americas"
        case .ASIA:
            return "globe.asia.australia"
        case .none:
            return ""
        }
    }
}

// MARK: - Author
struct Author: Codable, Hashable {
    let name, title: String?
    let bio: String?
    let email, phone, facebook: String?
    let twitter: String?
    let googleplus, subscription, rss: String?
    let descriptionLong, descriptionShort: String?
    let photo: String?
}
