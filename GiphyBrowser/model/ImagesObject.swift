//
//  ImagesObject.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import Foundation


struct GiphyImage : Decodable {
    var url : URL?
    var width : String?
    var height : String?


    enum CodingKeys: String, CodingKey
    {
        case url, width, height
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try? values.decode(URL.self, forKey: .url)
        self.width = try values.decodeIfPresent(String.self, forKey: .width)
        self.height = try values.decodeIfPresent(String.self, forKey: .height)
    }
}


struct ImagesObject : Decodable {
    var fixedWidthStill : GiphyImage?
    var fixedHeightStill : GiphyImage?
    var fixedWidthDownsampled : GiphyImage?
    var fixedHeightDownsampled : GiphyImage?
    var original : GiphyImage?

    enum CodingKeys: String, CodingKey
    {
        case fixedWidthStill = "fixed_width_still"
        case fixedHeightStill = "fixed_height_still"
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case fixedHeightDownsampled = "fixed_height_downsampled"
        case original
    }


    func gifURL() -> URL {
        var finalUrl : URL

        if let url = self.original?.url {
            finalUrl = url
        } else if let url = self.fixedWidthDownsampled?.url {
            finalUrl = url
        } else if let url = self.fixedHeightDownsampled?.url {
            finalUrl = url
        } else {
            // Fallback "Thank you" gif
            finalUrl = URL.init(string: "https://media3.giphy.com/media/jTHaR5a3B5L3jND7fP/giphy.gif")!
        }

        return finalUrl
    }


    func thumbURL() -> URL {
        var finalUrl : URL

        if let url = self.fixedWidthStill?.url {
            finalUrl = url
        } else if let url = self.fixedHeightStill?.url {
            finalUrl = url
        } else {
            // Fallback "Thank you gif"
            finalUrl = URL.init(string: "https://media3.giphy.com/media/jTHaR5a3B5L3jND7fP/200_s.gif")!
        }

        return finalUrl
    }
}
