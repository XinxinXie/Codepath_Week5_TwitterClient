//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Xinxin Xie on 2/28/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweet: Tweet!
    var tweets: [Tweet] = []
    
    var maxId: String?
    var isLoadingData = false
    var isAtBottom = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        headerImage.setImageWithURL(NSURL(string: (tweet.user.backgroundPicUrl)!)!)
        profileImage.setImageWithURL(NSURL(string: (tweet.user.profileImageUrl)!)!)
        profileName.text = String(tweet.user.name!)
        tweetCount.text = String(tweet.user.tweetsCount ?? 0)
        followerCount.text = String(tweet.user.followerCount ?? 0)
        followingCount.text = String(tweet.user.followingCount ?? 0)

        loadNextPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.configure(tweet)
        //cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("profileToDetail", sender: indexPath)
    }
    
    func loadNextPage() {
        
        var params = [String: AnyObject]()
        if let id = maxId {
            params["max_id"] = id
        }
        params["screen_name"] = tweet.user.screenname
        
        if isLoadingData {
            return
        }
        isLoadingData = true
        
        TwitterClient.sharedInstance.getUserTweets(params, completion: { (tweets, error) -> () in
            self.isLoadingData = false
            if let tweets = tweets {
                self.tweets += tweets
                if let tweet = tweets.first {
                    self.maxId = tweet.id
                }
                self.tableView.reloadData()
            } else {
                print(error)
            }
            
        })
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentSize.height >= scrollView.frame.height {
            if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height {
                if !isAtBottom {
                    isAtBottom = true
                    loadNextPage()
                }
            } else {
                isAtBottom  = false
            }
            
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "profileToDetail" {
            let destinationVC = segue.destinationViewController as! DetailPageViewController
            //destinationVC.delegate = self
            let indexPath = sender as! NSIndexPath
            let tweet = tweets[indexPath.row]
            destinationVC.tweet = tweet
            
        }

    }

}
