//
//  NetImageView.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import UIKit

class NetImageView: UIImageView {

    private var netHelper : NetHelper?

    func setImage(fromURL url : URL, placeholder : UIImage? = nil) {

        self.netHelper = nil

        let nHelper = NetHelper.init()
        nHelper.imageView = self

        self.netHelper = nHelper

        if let image = ImageMemCache.shared.image(forURL: url, completion: { [weak nHelper] (image, error) in
            nHelper?.imageView?.image = image
        }) {
            self.image = image
        } else {
            self.image = placeholder
        }
    }


    func cancelRequest() {
        self.netHelper = nil
    }

}


extension NetImageView {
    class NetHelper {
        weak var imageView : NetImageView? = nil
    }
}
