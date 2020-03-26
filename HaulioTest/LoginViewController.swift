//
//  LoginViewController.swift
//  HaulioTest
//
//  Created by Phyo Htet Arkar on 3/25/20.
//  Copyright © 2020 Haulio. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Do any additional setup after loading the view.
        signInButton.colorScheme = .dark
        signInButton.style = GIDSignInButtonStyle.wide
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoadingView.instance.showLoading()
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            LoadingView.instance.dismiss()
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            LoadingView.instance.dismiss()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "JobsNavigationController")
            self.show(controller, sender: nil)
        }
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        LoadingView.instance.refresh()
    }

}
