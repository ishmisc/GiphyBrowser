//
//  GiphyIconCollectionViewCell.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import UIKit

class GiphyIconCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    

    override func prepareForReuse() {
        super.prepareForReuse()

        self.imageView.image = nil
    }
}
