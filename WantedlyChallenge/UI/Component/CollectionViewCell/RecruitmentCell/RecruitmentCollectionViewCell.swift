//
//  RecrutingCollectionViewCell.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/18.
//  Copyright © 2020 Mori. All rights reserved.
//

import UIKit

final class RecruitmentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var recrutingCellView: RecruitmentCellView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 5
    }

    func setCellContents(recruitment: Recruitment) {
        recrutingCellView.setContents(recruitment: recruitment)
    }
}
