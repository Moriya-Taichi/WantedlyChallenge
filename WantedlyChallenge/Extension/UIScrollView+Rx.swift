//
//  UIScrollView+Rx.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/20.
//  Copyright © 2020 Mori. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIScrollView {
    var isReachedBottom: Observable<Void> {
        let source = contentOffset
            .filter { [weak base] _ -> Bool in
                guard let base = base else { return false }
                let offsetToBottom = base.contentOffset.y + base.bounds.height
                return offsetToBottom >= base.contentSize.height - base.bounds.height / 2
            }
            .map { _ in () }
        return source
    }
}
