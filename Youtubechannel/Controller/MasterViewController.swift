//
//  MasterViewController.swift
//  Youtubechannel
//
//  Created by Francisco Caro Diaz on 28/01/15.
//  Copyright (c) 2015 AreQua. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController,UISearchBarDelegate, UISearchDisplayDelegate {

    var detailViewController: DetailViewController? = nil
    var theVideos = [YoutubeVideo]()
    var filteredVideos = [YoutubeVideo]()
    typealias SomeHandler = (AnyObject! , Bool!) -> Void
    @IBOutlet weak var searchBarElement: UISearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clearsSelectionOnViewWillAppear = false
        self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var youtubechannelname: String
        if (defaults.objectForKey(kYOUTUBE_NAME) as String != "") {
        youtubechannelname = defaults.objectForKey(kYOUTUBE_NAME) as String!
        }else{
        youtubechannelname = "Carnavales de Cadiz"
        }
        self.title = youtubechannelname
        */
        
        self.title = REQ_YOUTUBE_DEFAULT_NAME
        
        self.createLoader(MSG_LOADING)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "editYoutubeChannel:")
        self.navigationItem.rightBarButtonItem = addButton
        
        let path = PATH_GET_VIDEOS;
        let responseObject: AnyObject = ""
        Manager.makeGet(path, completionHandler: { (responseObject, errorValue) -> Void in
            if !errorValue{
                var str:String = ""
                if let responseDict = responseObject.objectForKey(OBJ_RESPONSE_DATA) as? NSDictionary {
                    var emptyArray:NSArray! = Array<AnyObject>()
                    emptyArray = responseDict.valueForKey(OBJ_RESPONSE_ITEMS) as? NSArray
                    let video: AnyObject = ""
                    for video in emptyArray {
                        
                        let id = video[OBJ_ID];
                        let description = video[OBJ_DESC];
                        let updated = video[OBJ_UPDATED];
                        let title = video[OBJ_TITLE];
                        let duration = video[OBJ_DURATION];
                        let thumbnail = video.objectForKey(OBJ_THUMB) as? NSDictionary
                        let hqDefault: AnyObject? = thumbnail?.objectForKey(OBJ_HQ);
                        
                        let youtubeVideo = YoutubeVideo()
                        youtubeVideo.id = id as String
                        youtubeVideo.description = description as String
                        youtubeVideo.updated = updated as String
                        youtubeVideo.title = title as String
                        youtubeVideo.duration = duration as Int
                        youtubeVideo.thumbnail = hqDefault as String

                        self.theVideos.append(youtubeVideo)
                        
                        self.tableView.reloadData()
                    }
                }
            }
            let controllers = self.splitViewController!.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        })
        
    }
    
    func editYoutubeChannel(sender: AnyObject){
    
        var inputTextFieldName: UITextField?
        var inputTextField: UITextField?
        let actionSheetController: UIAlertController = UIAlertController(title: "Youtube channel", message: "Name of the channel", preferredStyle: .Alert)
    
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        // Do not save channel name
        }
        actionSheetController.addAction(cancelAction)
    
        let nextAction: UIAlertAction = UIAlertAction(title: "Next", style: .Default) { action -> Void in
            println(inputTextField?.text)
            let name = inputTextFieldName?.text
            let youtubechannel = inputTextFieldName?.text
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(name, forKey: kYOUTUBE_NAME)
            defaults.setObject(youtubechannel, forKey: kYOUTUBE_ID)
            defaults.synchronize()
        }
        actionSheetController.addAction(nextAction)
    
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            textField.textColor = UIColor.blueColor()
            textField.placeholder = "Name of the channel"
            inputTextFieldName = textField
        }
        
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            textField.textColor = UIColor.blueColor()
            textField.placeholder = "Channel id"
            inputTextField = textField
        }
    
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_DETAIL_VC {
            var empty = (searchBarElement.text == "")
            
            if empty {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let videoYoutube = theVideos[indexPath.row] as YoutubeVideo
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                controller.detailItem = videoYoutube
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            } else {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let videoYoutube = filteredVideos[indexPath.row] as YoutubeVideo
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                controller.detailItem = videoYoutube
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
            
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredVideos.count
        } else {
            return self.theVideos.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var videoYoutube : YoutubeVideo
        if tableView == self.searchDisplayController!.searchResultsTableView {
            videoYoutube = self.filteredVideos[indexPath.row] as YoutubeVideo
        } else {
            videoYoutube = self.theVideos[indexPath.row] as YoutubeVideo
        }
        
        
        cell.textLabel?.text = videoYoutube.title as? String
        
        let pictureURL = videoYoutube.thumbnail as String;
        let url = NSURL(string: pictureURL);
        let picData = NSData(contentsOfURL: url!);
        let img = UIImage(data: picData!);
        cell.imageView?.image = img
        cell.imageView?.contentMode = .ScaleAspectFit
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // MARK: Table View filter
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredVideos = self.theVideos.filter({( video: YoutubeVideo) -> Bool in
            let title = video.title as String;
            let stringMatch = title.rangeOfString(searchText)
            return (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    // MARK: Loader
    
    func createLoader(title: String) {
        let loadingHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingHUD.mode = MBProgressHUDModeIndeterminate
        loadingHUD.labelText = title
    }


}

