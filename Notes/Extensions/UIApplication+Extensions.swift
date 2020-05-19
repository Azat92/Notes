//
//  UIApplication+Extensions.swift
//  Notes
//
//  Created by Azat Almeev on 22.04.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import UIKit

extension UIApplication {

    func resignFirstResponder() {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
