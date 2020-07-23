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
    var router: RecruitmentPresentable?

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
        self.navigationItem.searchController = recruitmentCatalogView.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.view.addSubview(recruitmentCatalogView)
        recruitmentCatalogView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        recruitmentCatalogView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        recruitmentCatalogView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        recruitmentCatalogView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "募集"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor(named: "systemWhite")
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.navigationController?.navigationBar.standardAppearance = appearance
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor(named: "systemWhite")
            self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "systemBlack")]
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
    }
}
