//
//  RecrutingCellView.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/18.
//  Copyright © 2020 Mori. All rights reserved.
//

import UIKit
import SDWebImage

final class RecruitmentCellView: UIView {

    @IBOutlet private weak var recruitImageView: UIImageView!

    @IBOutlet private weak var lookingForLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet private weak var companyIconView: UIImageView! {
        didSet {
            companyIconView.layer.cornerRadius = companyIconView.frame.width / 2
        }
    }
    @IBOutlet private weak var companyNameLabel: UILabel!
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }

    func setContents(recruitment: Recruitment) {

        titleLabel.text = recruitment.title
        lookingForLabel.text = recruitment.lookingFor
        companyNameLabel.text = recruitment.company.name

        companyIconView.sd_setImage(with: URL(string: recruitment.company.avatar.original))
        recruitImageView.sd_setImage(with: URL(string: recruitment.image.original))
    }

}
