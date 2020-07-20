//
//  UIScrollView+Rx.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/20.
//  Copyright © 2020 Mori. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIScrollView {
    var isReachedBottom: Observable<Void> {
        let source = self.contentOffset
            .filter { [weak base] offset -> Bool in
                guard let base = base else { return false }
                let offsetToBottom = base.contentOffset.y + base.bounds.height
                return offsetToBottom >= base.contentSize.height - base.bounds.height / 3
            }
            .map { _ in Void() }
        return source
    }
}
