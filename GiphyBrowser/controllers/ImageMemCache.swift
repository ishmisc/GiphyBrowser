//
//  ImageMemCache.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import UIKit


/// Should be used in Main thread only
class ImageMemCache {

    static let shared = ImageMemCache.init()

    private var imageCache : [URL : UIImage] = [:]

    private var currentRequests : [URL : ImageRequest] = [:]

    private var session : URLSession = URLSession.init(configuration: .default)


    func image(forURL url : URL,
               forceUpdate : Bool = false,
               completion: @escaping ImageRequestCompletion)
        -> UIImage?
    {
        if let image = self.imageCache[url], forceUpdate == false {
            return image
        }

        if let imRequest = self.currentRequests[url] {
            imRequest.complClosures.append(completion)
            self.currentRequests[url] = imRequest
        } else {

            let imRequest = ImageRequest.init(imCache: self, url: url)

            let task = self.session.dataTask(with: url) { (data, response, error) in

                var image : UIImage? = nil
                if let data = data {
                    image = UIImage.init(data: data)
                }
                DispatchQueue.main.async {
                    imRequest.finishRequest(image: image, error: error)
                }
            }

            imRequest.task = task
            imRequest.complClosures = [completion]

            self.currentRequests[url] = imRequest

            task.resume()
        }


        return nil
    }


    func finishImageRequest(_ imRequest : ImageRequest, image : UIImage?, error : Error?) {
        if let image = image {
            self.imageCache[imRequest.url] = image
        }

        self.currentRequests[imRequest.url] = nil
    }
}


extension ImageMemCache {

    typealias ImageRequestCompletion = ((UIImage?, Error?) -> Void)

    class ImageRequest {

        unowned var imCache : ImageMemCache

        let url : URL
        var task : URLSessionTask!
        var complClosures : [ImageRequestCompletion] = []

        init(imCache : ImageMemCache, url : URL) {
            self.imCache = imCache
            self.url = url
        }


        func finishRequest(image: UIImage?, error: Error?) {

            self.imCache.finishImageRequest(self, image: image, error: error)

            for complClosure in self.complClosures {
                complClosure(image, error)
            }

            self.task = nil
            self.complClosures.removeAll()
        }
    }
}
