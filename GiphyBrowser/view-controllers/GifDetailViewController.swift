//
//  GifDetailViewController.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import UIKit

import Gifu


class GifDetailViewController: UIViewController {

    @IBOutlet var backContainer: UIView!
    @IBOutlet var imageContainer: UIView!
    @IBOutlet var imageView: GIFImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var gif : GIFObject? {
        didSet {
            if let gif = self.gif {
                self.startPlayingGif(gif)
            } else {
                self.stopPlayingGif()
            }
        }
    }


    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.contentMode = .scaleAspectFit

        if let gif = self.gif {
            self.startPlayingGif(gif)
        }
    }


    // MARK: -

    private func startPlayingGif(_ gif : GIFObject) {
        guard self.isViewLoaded else { return }

        self.backContainer.isHidden = false
        self.activityIndicator.startAnimating()

        self.imageContainer.isHidden = true

        GifFileCache.shared.gifFileURL(forGif: gif) { [weak self] (fileUrl, error) in
            self?.imageContainer.isHidden = false
            self?.backContainer.isHidden = true

            if let fileUrl = fileUrl {
                self?.imageView.animate(withGIFURL: fileUrl)
            }
        }
    }


    private func stopPlayingGif() {
        self.imageView.stopAnimatingGIF()
    }
}
