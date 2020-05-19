//
//  NoPaddingTextView.swift
//  Notes
//
//  Created by Azat Almeev on 22.04.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import UIKit

final class NoPaddingTextView: UITextView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
    }
}
