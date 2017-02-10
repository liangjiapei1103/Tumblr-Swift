//
//  FullScreenImageViewController.swift
//  Tumblr
//
//  Created by Jiapei Liang on 2/9/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var photoImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoImageViewTrailingConstraint: NSLayoutConstraint!
    
    
    
    
    var post: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.delegate = self
        
        scrollView.contentSize = view.bounds.size
        
        scrollView.isUserInteractionEnabled = true
        
        if let photos = post.value(forKey: "photos") as? [NSDictionary] {
            
            
            
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            
            if let imageUrl = URL(string: imageUrlString!) {
                photoImageView.setImageWith(imageUrl)
            }
            
        } else {
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //photoImageViewTopConstraint.constant = 210;
    }
    
    @IBAction func exitFullScreen(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
