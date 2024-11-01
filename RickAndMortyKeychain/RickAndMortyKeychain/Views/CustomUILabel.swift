//
//  CustomUILabel.swift
//  RickAndMortyKeychain
//
//  Created by Ибрагим Габибли on 01.11.2024.
//

import Foundation
import UIKit

final class CustomUILabel: UILabel {
    var textInsets = UIEdgeInsets(top: 5, left: 9, bottom: 5, right: 9)

    override func drawText(in rect: CGRect) {
        let paddedRect = rect.inset(by: textInsets)
        super.drawText(in: paddedRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                       height: size.height + textInsets.top + textInsets.bottom)
    }
}
