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
                    print("Couldn't parse data:", error)

                    var failedToParseError = MetaObject.createFailedToParse()
                    failedToParseError.underlyingError = error

                    DispatchQueue.main.async {
                        completion(nil, nil, failedToParseError)
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


    func downloadGif(_ gif : GIFObject, toFileURL fileURL : URL, completion: @escaping (Error?) -> Void ) -> URLSessionDownloadTask {
        let remoteURL = gif.images.gifURL()
        return self.downloadFile(downloadURL: remoteURL, toFileURL: fileURL, completion: completion)
    }


    func downloadFile(downloadURL : URL, toFileURL fileURL : URL, completion: @escaping (Error?) -> Void ) -> URLSessionDownloadTask {
        let downloadTask = self.session.downloadTask(with: downloadURL, completionHandler: { (dURL, response, error) in

            if  let dURL = dURL,
                (200...299).contains((response as! HTTPURLResponse).statusCode),
                error == nil
            {
                do {
                    try? FileManager.default.removeItem(at: fileURL)
                    try FileManager.default.copyItem(at: dURL, to: fileURL)

                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } catch let fileError {
                    DispatchQueue.main.async {
                        completion(fileError)
                    }
                }
            }
            else
            {
                var finalError : Error
                if let sError = error {
                    finalError = sError
                } else {
                    finalError = NSError.init(domain: "GIFFetcher", code: -2, userInfo: nil)
                }
                DispatchQueue.main.async {
                    completion(finalError)
                }
            }
        })

        return downloadTask
    }
}
