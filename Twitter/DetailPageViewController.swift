//
//  DetailPageViewController.swift
//  Twitter
//
//  Created by Xinxin Xie on 2/27/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit

class DetailPageViewController: UIViewController {

    
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var retweet: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var reply: UIButton!
    
    var tweet: Tweet!
    
    weak var delegate: DetailPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadPage()
    }
    


    @IBAction func onRetweet(sender: AnyObject) {
        let id = tweet.id
        TwitterClient.sharedInstance.retweetWithId(id) { (tweet, error) -> () in
            if let tweet = tweet {
                self.tweet = tweet
                self.delegate?.detailPageViewController(self, tweetDidUpdate: tweet)
                self.reloadPage()
            }
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        let id = tweet.id
        TwitterClient.sharedInstance.favoriteWithId(id) { (tweet, error) -> () in
            if let tweet = tweet {
                self.tweet = tweet
                self.delegate?.detailPageViewController(self, tweetDidUpdate: tweet)
                self.reloadPage()
            }
        }
    }
    
    func reloadPage()
    {
        if let urlString = tweet.user.profileImageUrl, let url = NSURL(string: urlString) {
            profilePicture.setImageWithURL(url)
        }
        userName.text = tweet.user.name
        tweetText.text = tweet.text
        timeStamp.text = tweet.displayCreateAt
        retweetCount.text = String(tweet.retweetCount)
        retweet.selected = tweet.retweeted
        favorite.selected = tweet.favorited
        favoriteCount.text = String(tweet.favoritesCount)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

protocol DetailPageViewControllerDelegate: class {
    func detailPageViewController(viewController: DetailPageViewController, tweetDidUpdate tweet: Tweet)
    
}
