//
//  ViewController.swift
//  YVLeadrboard
//
//  Created by Yash Vyas on 16/11/17.
//  Copyright © 2017 Yash Vyas. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = LoginButton(readPermissions: [.publicProfile, .email, .userAboutMe, .userBirthday, .userFriends])
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let rightBarButtonItem = navigationItem.rightBarButtonItem {
            if let _ = AccessToken.current {
                rightBarButtonItem.isEnabled = true
                rightBarButtonItem.tintColor = .black
            } else {
                rightBarButtonItem.isEnabled = false
                rightBarButtonItem.tintColor = .clear
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        switch result {
        case .success(_, _, let token):
            loginButton.center = CGPoint(x: view.center.x, y: view.frame.size.height - loginButton.frame.size.height - 20)
            //print("User access token: %@", accessToken)
            
            let userDetailsRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, email, gender, age_range, is_verified, about, address, birthday"])
            userDetailsRequest.start({ (response, result) in
                switch result {
                case .success(let value):
                    self.textView.text = "\(token.authenticationToken)\n\n\(value.dictionaryValue ?? [:])"
                case .failed(let error):
                    print(error.localizedDescription)
                }
            })
        case .failed(let error):
            print(error.localizedDescription)
        case .cancelled:
            print("Cancelled")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        textView.text = ""
        loginButton.center = view.center
    }
}

