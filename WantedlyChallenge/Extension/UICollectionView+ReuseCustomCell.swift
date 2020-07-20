//
//  UICollectionView+ReuseCustomCell.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/20.
//  Copyright © 2020 Mori. All rights reserved.
//

import UIKit

extension UICollectionView {
    func dequeReusableCell<T: UICollectionViewCell>(_ cellType: T.Type,
                                                    indexPath: IndexPath)
        -> T?
    {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: cellType),
                                        for: indexPath) as? T
    }
}
