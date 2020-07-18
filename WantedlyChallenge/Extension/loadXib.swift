//
//  loadXib.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/18.
//  Copyright © 2020 Mori. All rights reserved.
//

import UIKit

extension UIView {
    func loadXib() {
        let layout = Bundle
            .main
            .loadNibNamed(String(describing: type(of: self)),
                          owner: self)!.first as! UIView
        layout.frame = self.bounds
        self.addSubview(layout)
    }
}