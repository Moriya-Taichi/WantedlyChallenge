//
//  RecruitmentCatalogViewController.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/21.
//  Copyright © 2020 Mori. All rights reserved.
//

import ReactorKit
import RxSwift
import UIKit

final class RecruitmentCatalogViewController: UIViewController {

    private var recruitmentCatalogView: RecruitmentCatalogView?
    private let dispodseBag = DisposeBag()
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
        recruitmentCatalogView.selectedCellStream
            .subscribe(onNext: { [weak self] id in
                self?.router?.showRecruitment(id: id)
            })
            .disposed(by: dispodseBag)
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
