//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Jiapei Liang on 2/2/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var posts: [NSDictionary] = []
    var comments: [String] = []
    
    var blogTitle: String!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        
        // Do any additional setup after loading the view.
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
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
                    
                }
            }
        }
        
        task.resume()
        
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
