//
//  TransitionalView.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/08/04.
//

import RxSwift
import UIKit

protocol TransitionalView where Self: UIView {
    var transitionEventStream: Observable<TransitionEvent> { get }
}
