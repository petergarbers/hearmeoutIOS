//
//  ViewController.swift
//  HearmeoutIOS
//
//  Created by Peter on 10/25/16.
//  Copyright © 2016 Peter. All rights reserved.
//

import Alamofire
import UIKit
import TwitterKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "name") == nil) {
            // Passing in userdefaults like this is ugly
            twitterLogin(defaults: defaults)
        } else {
            print("NOTHING TO SEE HERE")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Passing in userdefaults like this is ugly
    func twitterLogin(defaults: UserDefaults) {
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                                              message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.alert
                )
                // When I figure out how to pass an object, I should do that
                self.createApiUser(name: unwrappedSession.userName, twitterId: unwrappedSession.userID,
                                   authToken: unwrappedSession.authToken, authTokenSecret: unwrappedSession.authTokenSecret);
                defaults.setValue(unwrappedSession.userName, forKey: "name")
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present    (alert, animated: true, completion: nil)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
        // TODO: Change where the log in button is positioned in your view
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }
    
    func createApiUser(name: String, twitterId: String, authToken: String, authTokenSecret: String) {
        let parameters: Parameters = [
            "user": [
                "name": name,
                "twitter_id": twitterId,
                "auth_token": authToken,
                "auth_secret_token": authTokenSecret
            ]
        ]

        Alamofire.request("http://127.0.0.1:4000/api/v1/users", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("XXXXXX");
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
        
    }

}

