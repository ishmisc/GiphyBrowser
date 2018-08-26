//
//  TrendingResponse.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import Foundation


struct TrendingResponse : Decodable {
    var data : [GIFObject]
    var pagination : PaginationObject
    var meta : MetaObject
}
