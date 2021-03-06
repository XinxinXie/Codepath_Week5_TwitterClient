//
//  User.swift
//  Twitter
//
//  Created by Xinxin Xie on 2/14/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "currentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {

    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var followingCount: Int?
    var followerCount: Int?
    var tweetsCount: Int?
    var backgroundPicUrl: String?
    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        followingCount = dictionary["friends_count"] as? Int
        followerCount = dictionary["followers_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
        backgroundPicUrl = dictionary["profile_background_image_url"] as? String
        
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        
    }
    
    class var currentUser: User? {
        get {
        
            if _currentUser == nil {
        
            let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    let dictionary = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary!)
        
                }
        
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                let data = try? NSJSONSerialization.dataWithJSONObject(user!.dictionary, options:[])
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()

        }
        
    }
}
