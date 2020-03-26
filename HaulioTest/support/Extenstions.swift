//
//  Extenstions.swift
//  HaulioTest
//
//  Created by Phyo Htet Arkar on 3/25/20.
//  Copyright © 2020 Haulio. All rights reserved.
//

import UIKit
import GoogleSignIn
import AlamofireImage

extension UIViewController {
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        GIDSignIn.sharedInstance()?.signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIImageView {
    func load(imageUrl: URL?) {
        if let url = imageUrl {
            let filter = AspectScaledToFitSizeFilter(size: frame.size)
            self.af.setImage(withURL: url, placeholderImage: UIImage(named: "Placeholder"), filter: filter)
        }
        
    }
}
