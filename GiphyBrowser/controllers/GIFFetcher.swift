//
//  GIFFetcher.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import Foundation


class GIFFetcher {

    static let shared = GIFFetcher.init(withSessionConfiguration: .default)

    private var session : URLSession


    init(withSessionConfiguration sConfig : URLSessionConfiguration) {

        self.session = URLSession.init(configuration: sConfig)

    }


    func fetchTrending(limit: Int,
                       offset: Int,
                       completion: @escaping ([GIFObject]?, PaginationObject?, MetaObject) -> Void)
        -> URLSessionTask?
    {
        var url = GiphyDefs.baseURL
        url.appendPathComponent(GiphyDefs.APIVersion)
        url.appendPathComponent("gifs/trending")
        guard var components = URLComponents.init(url: url, resolvingAgainstBaseURL: false) else { return nil }

        let apiKey = URLQueryItem.init(name: "api_key", value: GiphyDefs.APIKey)
        let limit = URLQueryItem.init(name: "limit", value: String(describing: limit))
        let offset = URLQueryItem.init(name: "offset", value: String(describing: offset))

        components.queryItems = [apiKey, limit, offset]

        guard let finalURL = components.url else { return nil }

        let task = self.session.dataTask(with: finalURL) { (data, response, error) in
            if let data = data, error == nil {

                do {
                    let trendingResponse = try JSONDecoder().decode(TrendingResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(trendingResponse.data, trendingResponse.pagination, trendingResponse.meta)
                    }
                } catch let error {
                    print("Couldn't parse data: " + String.init(data: data, encoding: .utf8)! )

                    DispatchQueue.main.async {
                        completion(nil, nil, MetaObject.createFailedToParse())
                    }
                }
            } else {
                if let error = error {
                    print(error)
                } else {
                    print("Unkown error while loading songs for artist")
                }
                
                var failedToLoadError = MetaObject.createFailedToLoad()
                failedToLoadError.underlyingError = error

                DispatchQueue.main.async {
                    completion(nil, nil, failedToLoadError)
                }
            }
        }

        return task
    }
}
