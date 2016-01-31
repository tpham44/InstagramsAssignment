//  ********* THIS IS A WORKING VERSION  *********
//  PhotosViewController.swift
//  Instagram
//
//  Created by JP on 1/21/16.
//  Copyright © 2016 Thanh Pham (JEREMY) and Noureddine . All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var isMoreDataLoading = false

    var instagram: [NSDictionary]? //Declare variable to retrieve data from API

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let refreshControl = UIRefreshControl()
        
        tableView.delegate = self
        
        tableView.rowHeight = 320 //set static row height to the table view

        // infinite scroll: call loadMoreData
        loadMoreData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Count total of cells available
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let instagram = instagram {
            return instagram.count
        }
        else {
            return 0
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellView", forIndexPath: indexPath) as! CellView
        
        let instagramElement = instagram![indexPath.row]  // parse the element of the Instagram's array.
        
        if let posterPath = instagramElement.valueForKeyPath("images.low_resolution.url") as? String {
        
        let imageUrl = NSURL(string: posterPath)
            cell.instagramImage.setImageWithURL(imageUrl!)
        }
        
        return cell
    
    }
    
    //infite scroll
    func loadMoreData() {
        // Do any additional setup after loading the view.
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.isMoreDataLoading = false

                            self.instagram = responseDictionary["data"] as? [NSDictionary]
                            self.tableView.dataSource = self
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }



    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                loadMoreData()
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let photoDetailsViewController = segue.destinationViewController as! PhotoDetailsViewController
        
        let Instagram = instagram![indexPath!.row]
        photoDetailsViewController.detailsInstagram = Instagram
        
        // Get the new view controller using segue.destinationViewController.
        //print("Prepae for Seque....")
        // Pass the selected object to the new view controller.
    }
    

}
