//
//  UIImage+Extensions.swift
//  Notes
//
//  Created by Azat Almeev on 26.04.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import UIKit

extension UIImage {

    func normalizedImage() -> UIImage {
        guard self.imageOrientation != .up else { return self }
        return self.resized(size: self.size) ?? self
    }

    func previewImage() -> UIImage {
        self.resized(size: CGSize(width: 100, height: 100)) ?? self
    }

    private func resized(size: CGSize) -> UIImage? {
        let hScale = self.size.width / size.width
        let vScale = self.size.height / size.height
        let scale = max(hScale, vScale)
        let resultSize = CGSize(width: self.size.width / scale, height: self.size.height / scale)
        UIGraphicsBeginImageContextWithOptions(resultSize, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: resultSize))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
