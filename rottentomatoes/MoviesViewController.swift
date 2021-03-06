//
//  ViewController.swift
//  rottentomatoes
//
//  Created by Paul Lo on 9/10/14.
//  Copyright (c) 2014 Paul Lo. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var progressView: M13ProgressViewRing!
    @IBOutlet weak var moviesScrollView: UIScrollView!
    @IBOutlet weak var movieList: UITableView!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet var mainView: UIView!

    var refreshControl: ISRefreshControl? = ISRefreshControl()
    var movies: [NSDictionary] = []
    let boxOfficeURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=y8acjuuqktge56q4tftbsfkk&limit=20&country=us"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieList.delegate = self
        self.movieList.dataSource = self

        self.mainView.bringSubviewToFront(self.progressView)
        self.progressView.hidden = false
        self.progressView.indeterminate = true
                
        self.movieList.addSubview(self.refreshControl!)
        self.refreshControl?.addTarget(self, action: "refreshMovieList", forControlEvents: .ValueChanged)
        
        self.loadMovieListFromSource()
    }
    
    func loadMovieListFromSource() {
        var url = self.boxOfficeURL
        var request = NSURLRequest(URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            self.mainView.sendSubviewToBack(self.progressView)
            self.progressView.hidden = true
            if data?.length > 0 && error == nil {
                if var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                    self.movies = object["movies"] as [NSDictionary]
                    self.movieList.reloadData()
                }
                self.mainView.sendSubviewToBack(self.warningView)
                self.warningView.hidden = true
            } else {
                self.mainView.bringSubviewToFront(self.warningView)
                self.warningView.hidden = false
            }
            self.refreshControl!.endRefreshing()
        }
    }
    
    func refreshMovieList() {
        self.loadMovieListFromSource()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        
        var movie = self.movies[indexPath.row]
        cell.movie = movie
        cell.movieTitleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        if let posters = movie["posters"] as? NSDictionary {
            var posterUrl = posters["thumbnail"] as String
            cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        }
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new
        //var movieDetailsController = segue.destinationViewController as? MovieDetailsViewController
        if var movieDetailsController = segue.destinationViewController as? MovieDetailsViewController {
            movieDetailsController.movie = (sender as? MovieCell)?.movie
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

