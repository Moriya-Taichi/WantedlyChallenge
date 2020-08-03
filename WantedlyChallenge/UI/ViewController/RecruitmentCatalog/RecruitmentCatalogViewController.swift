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
        recruitmentCatalogView = RecruitmentCatalogView(frame: view.bounds)
        guard
            let recruitmentCatalogView = recruitmentCatalogView,
            let reactor = reactor
        else {
            return
        }
        recruitmentCatalogView.reactor = reactor
        recruitmentCatalogView.transitionEventStream
            .subscribe(onNext: { [weak self] event in
                switch event {
                case let .showRecruitment(id):
                    self?.router?.showRecruitment(id: id)
                default:
                    break
                }
            })
            .disposed(by: dispodseBag)
        navigationItem.searchController = recruitmentCatalogView.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        view.addSubview(recruitmentCatalogView)
        recruitmentCatalogView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        recruitmentCatalogView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        recruitmentCatalogView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        recruitmentCatalogView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "募集"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.shadowImage = UIImage()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor(named: "systemWhite")
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.navigationController?.navigationBar.standardAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = UIColor(named: "systemWhite")
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "systemBlack")]
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.window?.endEditing(true)
    }
}
