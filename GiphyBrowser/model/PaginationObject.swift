//
//  PaginationObject.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import Foundation


struct PaginationObject : Decodable {
    var totalCount : Int
    var count : Int
    var offset : Int


    enum CodingKeys: String, CodingKey
    {
        case count, offset
        case totalCount = "total_count"
    }
}
