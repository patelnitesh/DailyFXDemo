//
//  AsyncImageView.swift
//  DailyFXDemo
//
//  Created by Nitesh Patel on 07/05/2022.
//

import SwiftUI

struct AsyncImageView: View {
    var url: String

    var body: some View {
        AsyncImage(url: URL(string: url)) { media in
            if let image = media.image {
                image
                    .resizable()
                    .scaledToFit()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                            .shadow(radius: 1)
            } else if media.error != nil {
                ZStack(alignment: .bottomTrailing){
                    Image(systemName: "photo.artframe")
                        .resizable()
                        .scaledToFill()
                }
            } else {
                ProgressView()
            }
        }
        .aspectRatio(contentMode: .fit)    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(url:"")
    }
}
