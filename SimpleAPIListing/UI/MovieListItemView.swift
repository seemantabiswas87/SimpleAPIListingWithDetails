//
//  MovieListItemView.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import SwiftUI

struct MovieListItemView: View {
    let imageURL: URL?
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.spacing8) {
            AsyncCachedImage(url: imageURL,
                       content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 100, maxHeight: 100)
            })

            VStack(alignment: .leading, spacing: Spacing.spacing8) {
                DesignText(title, style: .titleBold, overrideForegroundColor: .primary)

                DesignText(description, style: .bodyRegular, overrideForegroundColor: .secondary)
                    .lineLimit(3)

            }
            .multilineTextAlignment(.leading)
            Spacer(minLength: Spacing.spacing8)
        }
    }
}


struct MovieListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListItemView(imageURL: URL(string: "http://image.tmdb.org/t/p/w200/238"), title: "", description: "")
    }
}

