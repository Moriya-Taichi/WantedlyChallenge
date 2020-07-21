//
//  RecruitmentCatalogViewController.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/21.
//  Copyright © 2020 Mori. All rights reserved.
//

import ReactorKit
import UIKit

final class RecruitmentCatalogViewController: UIViewController {

    private var recruitmentCatalogView: RecruitmentCatalogView?
    var reactor: RecruitmentCatalogViewReactor?
    weak var router: RecruitmentRouter?

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        recruitmentCatalogView = RecruitmentCatalogView(frame: self.view.bounds)
        guard
            let recruitmentCatalogView = recruitmentCatalogView,
            let reactor = reactor
            else {
            return
        }
        recruitmentCatalogView.reactor = reactor
        self.view.addSubview(recruitmentCatalogView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "募集"
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
    }
}
