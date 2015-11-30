//
//  UIImageView.swift
//  Rex
//
//  Created by Andy Jacobs on 21/10/15.
//  Copyright © 2015 Neil Pankey. All rights reserved.
//

import ReactiveCocoa
import UIKit

extension UIImageView {
    /// Wraps a imageView's `image` value in a bindable property.
    public var rex_image: MutableProperty<UIImage?> {
        return rex_valueProperty(&image, { [weak self] in self?.image }, { [weak self] in self?.image = $0 })
    }
    
    /// Wraps a imageView's `highlightedImage` value in a bindable property.
    public var rex_highlightedImage: MutableProperty<UIImage?> {
        return rex_valueProperty(&highlightedImage, { [weak self] in self?.highlightedImage }, { [weak self] in self?.highlightedImage = $0 })
    }
}

private var image: UInt8 = 0
private var highlightedImage: UInt8 = 0