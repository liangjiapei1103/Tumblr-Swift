//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Jiapei Liang on 2/9/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!

    var post: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.isUserInteractionEnabled = true
    avatarImageView.setImageWith(URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        
        if let publishDate = post["date"] as? String {
            publishDateLabel.text = publishDate
        }
        
        
        if let summary = post["caption"] as? String {
            
            var attrStr = try! NSAttributedString(
                data: summary.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            
            summaryLabel.text = attrStr.string
            summaryLabel.sizeToFit()
            
        }
        
        
        
        if let photos = post.value(forKey: "photos") as? [NSDictionary] {
            
            
            
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            
            if let imageUrl = URL(string: imageUrlString!) {
                photoImageView.setImageWith(imageUrl)
            }
            
        } else {
            
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func showImage(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showImageInFullScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! FullScreenImageViewController
        
        destination.post = self.post
    
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
