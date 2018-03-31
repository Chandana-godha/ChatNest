//
//  Spinner.swift
//  ChatNest
//
//  Created by chandana on 2/22/18.
//  Copyright © 2018 chandana. All rights reserved.
//

import Foundation
import UIKit


 @IBOutlet weak var spinner: UIActivityIndicatorView!
func showLoading(state: Bool)  {
    if state {
        self.darkView.isHidden = false
        self.spinner.startAnimating()
        UIView.animate(withDuration: 0.3, animations: {
            self.darkView.alpha = 0.5
        })
    } else {
        UIView.animate(withDuration: 0.3, animations: {
            self.darkView.alpha = 0
        }, completion: { _ in
            self.spinner.stopAnimating()
            self.darkView.isHidden = true
        })
    }
}

//inside 
