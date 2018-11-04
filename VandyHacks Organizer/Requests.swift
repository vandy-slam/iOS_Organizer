//
//  Requests.swift
//  VandyHacks Organizer
//
//  Created by Bruce Brookshire on 11/3/18.
//  Copyright © 2018 bruce-brookshire.com. All rights reserved.
//

import Foundation


class Requests {
    
    static func uploadImages(imageData: Queue<ImageWrapper>, location: String, progressCallback: @escaping (Double) -> Void) {
        uploadImages(imageData: imageData, progressCallback: progressCallback, total:  Double(imageData.getSize()), location: location)
    }
    
    private static func uploadImages(imageData: Queue<ImageWrapper>, progressCallback: @escaping (Double) -> Void, total: Double, location: String) {
        let wrapper = imageData.getNext()
        
        var request = URLRequest(url: URL(string: "https://www.googleapis.com/upload/storage/v1/b/vandy-slam/o?uploadType=media&name=images/\(location)/\(wrapper.id)_\(wrapper.relativeTime)")!)
        request.httpMethod = "POST"
        
        
        request.httpBody = wrapper.imageData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            progressCallback( ((total - Double(imageData.getSize()))/total) * 100)
            if imageData.getSize() > 0 {
                self.uploadImages(imageData: imageData, progressCallback: progressCallback, total: total, location: location)
            }
        }.resume()
        
        
    }
    
}
