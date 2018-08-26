//
//  MetaObject.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import Foundation


struct MetaObject : Decodable {
    let status : Int
    let message : String?
    let responseID : String?
    var underlyingError : Error? = nil


    // MARK: -

    init(status: Int, message: String?, responseID : String?, underlyingError : Error?) {
        self.status = status
        self.message = message
        self.responseID = responseID
        self.underlyingError = underlyingError
    }

    
    // MARK: -

    enum CodingKeys: String, CodingKey
    {
        case status
        case message
        case responseID = "response_id"
    }
}


// MARK: -
// MARK: -

extension MetaObject {
    enum ErrorCodes {
        static let failedToParse : Int = -9
        static let failedToLoad : Int = -2
    }


    static func createFailedToParse() -> MetaObject {
        return MetaObject(status: MetaObject.ErrorCodes.failedToParse,
                          message: nil,
                          responseID: nil,
                          underlyingError: nil)
    }


    static func createFailedToLoad() -> MetaObject {
        return MetaObject(status: MetaObject.ErrorCodes.failedToLoad,
                          message: nil,
                          responseID: nil,
                          underlyingError: nil)
    }
}
