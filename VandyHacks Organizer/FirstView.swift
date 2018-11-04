//
//  FirstView.swift
//  VandyHacks Organizer
//
//  Created by Bruce Brookshire on 11/2/18.
//  Copyright © 2018 bruce-brookshire.com. All rights reserved.
//

import Foundation
import UIKit


class FirstView: UIVC {
    
    @IBOutlet weak var tappedPics: UIButton!
    
    override func viewDidLoad() {
        tappedPics.layer.cornerRadius = 10
        tappedPics.layer.borderColor = self.view.tintColor.cgColor
        tappedPics.layer.borderWidth = 2
        
        self.title = "Welcome"
        
    }
    
    @IBAction func tappedTakePics(_ sender: Any) {
        self.navigationController?.pushViewController(InitializeCaptureView(), animated: true)
        
    }
    
}
