//
//  GIFObject.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import Foundation


struct GIFObject : Decodable {
    var type : String
    var id : String
    var title : String
    var images : ImagesObject
}
