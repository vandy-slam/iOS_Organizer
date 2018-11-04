//
//  Utilities.swift
//  VandyHacks Organizer
//
//  Created by Bruce Brookshire on 11/3/18.
//  Copyright © 2018 bruce-brookshire.com. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    func fadeInLoadingView() {
        
    }
    
    func fadeOutLoadingView() {
        
    }
}

extension UIImage {
    func normalizeOrientation() -> UIImage? {
        if self.imageOrientation == .up {return self}
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
        let normalized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalized
    }
}
