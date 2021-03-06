//
//  NSData.swift
//  Rex
//
//  Created by Ilya Laryionau on 10/05/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension NSData {
    /// Read the data at the URL.
    /// Sends the data or the error.
    public class func rex_dataWithContentsOfURL(url: NSURL, options: NSDataReadingOptions = NSDataReadingOptions()) -> SignalProducer<NSData, NSError> {
        return SignalProducer<NSData, NSError> { observer, disposable in
            do {
                let data = try NSData(contentsOfURL: url, options: options)
                observer.sendNext(data)
                observer.sendCompleted()
            } catch {
                observer.sendFailed(error as NSError)
            }
        }
    }
}
