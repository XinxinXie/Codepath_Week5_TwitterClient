//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Xinxin Xie on 2/28/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var editTextField: UITextField!
    
    var currentUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser = User.currentUser


        profileImage.setImageWithURL(NSURL(string: (currentUser.profileImageUrl)!)!)
        userName.text = String(currentUser.name!)

        
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func onNewTweet(sender: AnyObject) {
        if let tweetMessage = editTextField.text {
            TwitterClient.sharedInstance.composeNewTweet(tweetMessage, completion: { _ in
                self.performSegueWithIdentifier("unwindToMainMenu", sender: nil)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
