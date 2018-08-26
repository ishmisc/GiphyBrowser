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


    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib.init(nibName: "GiphyIconCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "Cell")


        let task = GIFFetcher.shared.fetchTrending(limit: 20, offset: 0) { (gifs, pag, meta) in
            if  meta.status == 200,
                let gifs = gifs,
                let pagination = pag
            {
                self.gifs = gifs
                self.collectionView.reloadData()
            } else {
                // TODO: deal with error
            }
        }

        task?.resume()
    }
}


extension BrowserViewController : UICollectionViewDelegateFlowLayout {

}


extension BrowserViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GiphyIconCollectionViewCell

        let gif = self.gifs[indexPath.row]

        if let image = ImageMemCache.shared.image(forURL: gif.images.fixedWidthStill.url, completion: { [weak cell] (image, error) in
            cell?.imageView.image = image
        }) {
            cell.imageView.image = image
        }

        return cell
    }
}
