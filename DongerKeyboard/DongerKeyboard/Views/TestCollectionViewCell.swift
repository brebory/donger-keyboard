//
//  TestCollectionViewCell.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 8/11/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import UIKit
import Cartography

class TestCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupConstraints()
    }

    func setupConstraints() {
        constrain(textLabel) { label in
            guard let superview = label.superview
                else { return }

            label.top == superview.topMargin
            label.bottom == superview.bottomMargin
            label.left == superview.leftMargin
            label.right == superview.rightMargin
        }
    }
}
