//
//  MovieDetailsViewController.swift
//  rottentomatoes
//
//  Created by Paul Lo on 9/14/14.
//  Copyright (c) 2014 Paul Lo. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var detailsTextView: MoveDetailsTextView!

    var movie: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = self.movie {
            self.title = movie["title"] as String?
            var posters = movie["posters"] as NSDictionary
            var posterUrl = posters["original"] as String
            posterUrl = posterUrl.stringByReplacingOccurrencesOfString("_tmb", withString: "_org")            
            coverImage.setImageWithURL(NSURL(string: posterUrl))
        }
    }

    @IBAction func panMovieDetailsTextView(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(detailsTextView)
        detailsTextView.center = CGPointMake(detailsTextView.center.x,
            detailsTextView.center.y + translation.y)
        sender.setTranslation(CGPointMake(0,0), inView: detailsTextView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
