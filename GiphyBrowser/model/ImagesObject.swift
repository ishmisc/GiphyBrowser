//
//  ImagesObject.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import Foundation


struct GiphyMp4 : Decodable {
    var width : String
    var height : String
    var size : String
    var url : URL


    enum CodingKeys: String, CodingKey
    {
        case width, height
        case size = "mp4_size"
        case url = "mp4"
    }
}


struct GiphyImage : Decodable {
    var url : URL
    var width : String
    var height : String
    var size : String?
}


struct ImagesObject : Decodable {
    var fixedWidthStill : GiphyImage
    var fixedWidthDownsampled : GiphyImage
    var originalMP4 : GiphyMp4

    enum CodingKeys: String, CodingKey
    {
        case fixedWidthStill = "fixed_width_still"
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case originalMP4 = "original_mp4"
    }
}
