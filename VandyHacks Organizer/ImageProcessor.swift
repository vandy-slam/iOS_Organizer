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
    let accelerometerData: CMAccelerometerData
    let magnetometerData: CMMagnetometerData
    let gyroData: CMGyroData
}


class ImageManager {
    
    private var contents: Queue<ImageWrapper>!
    
    func startSession() {
        contents = Queue<ImageWrapper>()
    }
    
    func acceptImage(image: UIImage, accelerometerData: CMAccelerometerData, magnetometerData: CMMagnetometerData, gyroData: CMGyroData) {
        guard let contents = contents else {return}
        contents.insert(
            ImageWrapper(imageData: image.jpegData(compressionQuality: 0.25)!,
                         accelerometerData: accelerometerData,
                         magnetometerData: magnetometerData,
                         gyroData: gyroData)
        )
    }
    
    func endSession() -> Queue<ImageWrapper> {
        defer {contents = nil}
        return contents
    }
}


