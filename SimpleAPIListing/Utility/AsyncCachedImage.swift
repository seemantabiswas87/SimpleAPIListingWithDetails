//
//  AsyncCachedImage.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import SwiftUI
enum ImageError: Error {
    case invalidUrl
    case connectionFailed
    case unknown
}
struct AsyncCachedImage<Content: View>: View {
    private let url: URL?

    @State private var image: UIImage?
    @State private var imageError: ImageError?

    @ViewBuilder var content: (Image) -> Content

    init(url: URL?, @ViewBuilder content: @escaping (Image) -> Content) {
        self.url = url
        self.content = content
    }


    var body: some View {
        VStack {
            if let image = image {
                content(Image(uiImage: image))
            } else if imageError != nil {
                Image("placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView().onAppear { loadImage() }
            }
        }
    }

    private func loadImage() {
        guard let url = url else {
            imageError = .invalidUrl
            return
        }

        let urlRequest = URLRequest(url: url)

        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest),
           let image = UIImage(data: cachedResponse.data) {
            self.image = image
        } else {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in

                guard error == nil else {
                    self.imageError = .connectionFailed
                    return
                }
                if let data = data, let response = response, let image = UIImage(data: data) {
                    let cachedResponse = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                } else {
                    self.imageError = .unknown
                }
            }.resume()
        }
    }
}

struct AsyncCachedImage_Previews: PreviewProvider
{
    static var previews: some View
    {
        AsyncCachedImage(url: URL(string: "http://image.tmdb.org/t/p/w200/l6hQWH9eDksNJNiXWYRkWqikOdu.jpg")) {image in
            image
                .resizable()
        }
    }
}
