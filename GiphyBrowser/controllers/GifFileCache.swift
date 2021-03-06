//
//  GifFileCache.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import Foundation


// MARK: -
// MARK: -

class FileCache {

    let cacheDirURL : URL

    init(cacheDirURL : URL) {
        self.cacheDirURL = cacheDirURL
    }

    func fileURL(forFileWithName filename : String, downloadURL : URL, completion: @escaping (URL?, Error?) -> Void) {
        DispatchQueue.global().async {

            let fileURL = self.cacheDirURL.appendingPathComponent(filename)

            if FileManager.default.fileExists(atPath: fileURL.path) {
                DispatchQueue.main.async {
                    completion(fileURL, nil)
                }
            } else {
                GIFFetcher.shared.downloadFile(downloadURL: downloadURL, toFileURL: fileURL, completion: { (downloadError) in
                    if downloadError == nil {
                        DispatchQueue.main.async {
                            completion(fileURL, nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil, downloadError!)
                        }
                    }
                }).resume()
            }

        }
    }
}


// MARK: -
// MARK: -

class GifFileCache : FileCache {

    static let cacheDir = URL.init(fileURLWithPath: DirLocations.cachesDir, isDirectory: true)

    static let shared = GifFileCache.init(cacheDirURL: GifFileCache.cacheDir)

    func gifFileURL(forGif gif : GIFObject, completion: @escaping (URL?, Error?) -> Void) {

        let filename = gif.id + ".gif"
        let downloadURL = gif.images.gifURL()

        return self.fileURL(forFileWithName: filename, downloadURL: downloadURL, completion: completion)
    }
}


// MARK: -
// MARK: -

enum DirLocations {
    static private(set) var cachesDir : String = {

        if var cachesDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                             FileManager.SearchPathDomainMask.userDomainMask,
                                                             true).first
        {
            cachesDir = (cachesDir as NSString).appendingPathComponent("gif-browser") as String

            if !FileManager.default.fileExists(atPath: cachesDir) {
                do {
                    try FileManager.default.createDirectory(atPath: cachesDir,
                                                            withIntermediateDirectories: true,
                                                            attributes: nil)
                }
                catch {
                    fatalError("Couldn't create caches directory")
                }
            }
            return cachesDir
        }
        else
        {
            fatalError("Couldn't get standard caches directory")
        }
    }()
}
