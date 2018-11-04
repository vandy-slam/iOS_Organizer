//
//  InitializeCaptureView.swift
//  VandyHacks Organizer
//
//  Created by Bruce Brookshire on 11/3/18.
//  Copyright © 2018 bruce-brookshire.com. All rights reserved.
//

import UIKit
import Foundation


class InitializeCaptureView: UIViewController {
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var locationField: UITextField!
    
    
    override func viewDidLoad() {
        nextBtn.layer.borderColor = self.view.tintColor.cgColor
        nextBtn.layer.borderWidth = 2
        nextBtn.layer.cornerRadius = 10
    }
    
    @IBAction func tappedNext() {
        let captureView = CaptureView()
        captureView.location = locationField.text ?? ""
        self.navigationController?.pushViewController(captureView, animated: true)
    }
    
    
    
}
