//
//  ImageProcessor.swift
//  VandyHacks Organizer
//
//  Created by Bruce Brookshire on 11/3/18.
//  Copyright © 2018 bruce-brookshire.com. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

struct ImageWrapper {
    let imageData: Data
    let relativeTime: Int
    let id: Int
}


class ImageManager {
    
    private var contents: Queue<ImageWrapper>!
    
    func startSession() {
        contents = Queue<ImageWrapper>()
    }
    
    func acceptImage(image: UIImage,
                     relativeTime: Int,
                     id: Int)
    {
        guard let contents = contents else {return}
        contents.insert(
            ImageWrapper(imageData: image.jpegData(compressionQuality: 0.25)!,
                         relativeTime: relativeTime,
                         id: id)
        )
    }
    
    func endSession() -> Queue<ImageWrapper> {
        defer {contents = nil}
        return contents
    }
}


