//
//  RecruitmentViewController.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/21.
//  Copyright © 2020 Mori. All rights reserved.
//

import ReactorKit
import RxSwift
import UIKit

final class RecruitmentViewController: UIViewController {

    private var recruitmentView: RecruitmentView?
    var reactor: RecruitmentViewReactor?

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        recruitmentView = RecruitmentView(frame: self.view.bounds)
        guard let recruitmentView = recruitmentView else {
            return
        }
        recruitmentView.reactor = reactor
        self.view.addSubview(recruitmentView)
    }
}
