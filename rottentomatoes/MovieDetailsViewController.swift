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
    @IBOutlet weak var detailsTextTitle: UILabel!
    @IBOutlet weak var detailsMovieScores: UILabel!
    @IBOutlet weak var detailsMovieMpaaRating: UILabel!
    @IBOutlet weak var detailsMovieSynopsis: UILabel!
    
    var movie: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = self.movie {
            self.title = movie["title"] as String?
            
            if let posters = movie["posters"] as? NSDictionary {
                var posterUrl = posters["original"] as String
                posterUrl = posterUrl.stringByReplacingOccurrencesOfString("_tmb", withString: "_org")
                self.coverImage.setImageWithURL(NSURL(string: posterUrl))
            }
            
            
            self.detailsTextTitle.text = movie["title"] as String?
            if let ratings = movie["ratings"] as? NSDictionary {
                let critics_score = ratings["critics_score"] as Int,
                    audience_score = ratings["audience_score"] as Int
                self.detailsMovieScores.text = "Critics Score: \(critics_score), Audience Score: \(audience_score)"
            }
            self.detailsMovieMpaaRating.text = movie["mpaa_rating"] as String?
            self.detailsMovieSynopsis.text = movie["synopsis"] as String?
            self.detailsMovieSynopsis.numberOfLines = 0
            self.detailsMovieSynopsis.sizeToFit()
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
