//
//  RecruitmentStaffCollectionViewCell.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/22.
//  Copyright © 2020 Mori. All rights reserved.
//

import UIKit

final class RecruitmentStaffCollectionViewCell: UICollectionViewCell {

    private var imageView: UIImageView?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        imageView = UIImageView(frame: self.frame)
        setupImageView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: self.frame)
        setupImageView()
    }

    private func setupImageView() {
        guard let imageView = imageView else { return }
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.backgroundColor = UIColor(
            red: 17 / 255,
            green: 146 / 255,
            blue: 196 / 255,
            alpha: 1
        )
        imageView.center = self.contentView.center
        self.addSubview(imageView)
    }

    func setCellContents(staff: Staff) {

    }
}
