//
//  BrowserViewController.swift
//  GiphyBrowser
//
//  Created by Iurii Shevchuk on 2018-08-26.
//  Copyright © 2018 Iurii Shevchuk Code reference. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {

    @IBOutlet var backContainer: UIView!
    @IBOutlet var collectionContainer: UIView!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!


    var gifs : [GIFObject] = []

    var lastPageInfo : PaginationObject = PaginationObject(totalCount: 1000, count: 0, offset: 0)


    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib.init(nibName: "GiphyIconCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "Cell")


        self.backContainer.isHidden = false
        self.collectionContainer.isHidden = true

        let task = GIFFetcher.shared.fetchTrending(limit: 100, offset: 0) { [weak self] (gifs, pag, meta) in
            if  meta.status == 200,
                let gifs = gifs,
                let pagination = pag
            {
                self?.gifs = gifs
                self?.collectionView.reloadData()
                self?.lastPageInfo = pagination
            } else {
                // TODO: deal with error
            }

            self?.backContainer.isHidden = true
            self?.collectionContainer.isHidden = false
        }

        task?.resume()
    }


    func loadMore() {

        let task = GIFFetcher.shared.fetchTrending(limit: 20, offset: self.gifs.count) { [weak self] (gifs, pag, meta) in
            if  meta.status == 200,
                let gifs = gifs,
                let pagination = pag
            {
                self?.gifs.append(contentsOf: gifs)
                self?.collectionView.reloadData()
                self?.lastPageInfo = pagination
            } else {
                // TODO: deal with error
            }

            self?.backContainer.isHidden = true
            self?.collectionContainer.isHidden = false
        }

        task?.resume()
    }
}


extension BrowserViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = self.gifs[indexPath.row]

        let detailVC = GifDetailViewController.init(nibName: "GifDetailViewController", bundle: nil)
        detailVC.gif = gif
        self.navigationController?.pushViewController(detailVC, animated: true)
    }


    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath)
    {
        if indexPath.row + 1 == self.gifs.count && self.gifs.count < self.lastPageInfo.totalCount {
            self.loadMore()
        }
    }
}


extension BrowserViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GiphyIconCollectionViewCell

        let gif = self.gifs[indexPath.row]

        cell.imageView.setImage(fromURL: gif.images.fixedWidthStill.url, placeholder: nil)

        return cell
    }
}
