//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Jiapei Liang on 2/2/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var posts: [NSDictionary] = []
    var comments: [String] = []
    
    var blogTitle: String!
    
    var isMoreDataLoading = false
    var offset = 5
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        refreshControlAction(refreshControl)
        
        // Do any additional setup after loading the view.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoTableViewCell
        
        let post = posts[indexPath.row]
        
        let timestamp = post["timestamp"] as? String
        
        
        
        cell.avatarImageView.setImageWith(URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        
        cell.avatarImageView.layer.cornerRadius = 25
        cell.avatarImageView.clipsToBounds = true
        
        if let publishDate = post["date"] as? String {
            cell.publishDateLabel.text = publishDate
        }
        
        
        if let summary = post["caption"] as? String {
            
            var attrStr = try! NSAttributedString(
                data: summary.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            
            cell.captionLabel.text = attrStr.string
            cell.captionLabel.sizeToFit()
            
        }
        
        
        
        if let photos = post.value(forKey: "photos") as? [NSDictionary] {
            
            
            
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            
            if let imageUrl = URL(string: imageUrlString!) {
                cell.photoImageView.setImageWith(imageUrl)
            }
            
        } else {
            
        }
        
        
        
        
        
        return cell
        
    }
    
    private func stringFromHtml(string: String) -> NSAttributedString? {
        do {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil)
                return str
            }
        } catch {
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PhotoDetailsViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let cell = sender as! PhotoTableViewCell
            
            let post = posts[indexPath.row]
            
            destination.post = post
            
        }
        
        
        
        
        
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&limit=5")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let data = data {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    // print(responseDictionary)
                    let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                    
                    print(responseFieldDictionary)
                    
                    self.blogTitle = responseFieldDictionary.value(forKeyPath: "blog.title") as! String
                    
                    print(self.blogTitle)
                    
                    self.navigationItem.title = self.blogTitle
                    
                    self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                    
                    self.tableView.reloadData()
                    
                    // Tell the refreshControl to stop spinning
                    refreshControl.endRefreshing()
                    
                }
            }
        }
        
        task.resume()
        
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // ... Code to load more results ...
                loadMoreData()
            }
            
        }
        
    }
    
    func loadMoreData() {
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&limit=5&offset=\(offset)")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let data = data {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    // print(responseDictionary)
                    let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                    
                    if let posts = responseFieldDictionary["posts"] as? [NSDictionary] {
                        for post in posts {
                            self.posts.append(post)
                        }
                    }
                    
                    
                    self.offset += 5
                    
                    // Update flag
                    self.isMoreDataLoading = false

                    
                    self.tableView.reloadData()
                    
                }
            }
        }
        
        task.resume()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
