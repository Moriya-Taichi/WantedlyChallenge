//
//  UIViewController+Reactive.swift
//
//  Created by Suguru Kishimoto on 2016/12/06.
//  reference: https://qiita.com/sgr-ksmt/items/e259e00f5c0a2f3109ff
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIViewController {
    public var viewDidLoad: Observable<Void> {
        return sentMessage(#selector(Base.viewDidLoad))
            .map { _ in }
            .share(replay: 1)
    }
}
