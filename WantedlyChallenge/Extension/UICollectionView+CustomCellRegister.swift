//
//  UICollectionView+CustomCellRegister.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/20.
//  Copyright © 2020 Mori. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(
            UINib(
                nibName: String(describing: cellType),
                bundle: nil
            ),
            forCellWithReuseIdentifier: String(describing: cellType)
        )
    }
}
