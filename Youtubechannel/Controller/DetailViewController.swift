//
//  DetailViewController.swift
//  Youtubechannel
//
//  Created by Francisco Caro Diaz on 28/01/15.
//  Copyright (c) 2015 AreQua. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    var detailItem: YoutubeVideo? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: YoutubeVideo = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.title as? String
                self.title = detail.title as? String
            }
            let idVideo = detail.id as? String
            var videoPlayerViewController: XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: idVideo);
            videoPlayerViewController.presentInView(self.view);
            videoPlayerViewController.moviePlayer.controlStyle = MPMovieControlStyle.None
            videoPlayerViewController.moviePlayer.play()
            self.view.addSubview(videoPlayerViewController.view)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

