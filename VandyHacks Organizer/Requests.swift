//
//  Requests.swift
//  VandyHacks Organizer
//
//  Created by Bruce Brookshire on 11/3/18.
//  Copyright © 2018 bruce-brookshire.com. All rights reserved.
//

import Foundation


class Requests {
    
    static func uploadImages(imageData: Queue<ImageWrapper>, progressCallback: @escaping (Double) -> Void) {
        uploadImages(imageData: imageData, progressCallback: progressCallback, total:  Double(imageData.getSize()))
    }
    
    private static func uploadImages(imageData: Queue<ImageWrapper>, progressCallback: @escaping (Double) -> Void, total: Double) {
        print("uploading")
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(1)) {
            let pic = imageData.getNext()
            print(imageData.getSize())
            progressCallback( ((total - Double(imageData.getSize()))/total) * 100 )
            if imageData.getSize() > 0 {
                self.uploadImages(imageData: imageData, progressCallback: progressCallback, total: total)
            }
        }
//        var request = URLRequest(url: URL(string: "something")!)
//        request.httpMethod = "PUT"
//        let wrapper = imageData.getNext()
//
//        let body: [String: Any] = [
//            "a_x": "\(wrapper.accelerometerData.acceleration.x)",
//            "a_y": "\(wrapper.accelerometerData.acceleration.y)",
//            "a_z": "\(wrapper.accelerometerData.acceleration.z)",
//            "g_x": "\(wrapper.gyroData.rotationRate.x)",
//            "g_y": "\(wrapper.gyroData.rotationRate.y)",
//            "g_z": "\(wrapper.gyroData.rotationRate.z)",
//            "m_x": "\(wrapper.magnetometerData.magneticField.x)",
//            "m_y": "\(wrapper.magnetometerData.magneticField.y)",
//            "m_z": "\(wrapper.magnetometerData.magneticField.z)",
//            "image": wrapper.imageData,
//            ]
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
//
//        request.httpBody = httpBody
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            progressCallback( (total - Double(imageData.getSize()))/total )
//            if imageData.getSize() > 0 {
//                self.uploadImages(imageData: imageData, progressCallback: progressCallback, total: total)
//            }
//        }
    }
    
}
