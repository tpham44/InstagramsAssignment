//  ********* THIS IS A WORKING VERSION  *********
//  PhotosViewController.swift
//  Instagram
//
//  Created by JP on 1/21/16.
//  Copyright © 2016 Thanh Pham (JEREMY) and Noureddine . All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var isMoreDataLoading = false
    var refreshControl: UIRefreshControl!
    var instagram: [NSDictionary]? //Declare variable to retrieve data from API
    
/***********************______________*******************/
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        
        tableView.rowHeight = 320 //set static row height to the table view

        // infinite scroll: call loadMoreData
        loadMoreData()

    }

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
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
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        self.delay(4.0, closure: {MBProgressHUD.showHUDAddedTo(self.view, animated: true)})
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.isMoreDataLoading = false

                            self.instagram = responseDictionary["data"] as? [NSDictionary]
                            //self.tableView.dataSource = self
                            self.tableView.reloadData()
                            // Hide HUD once the network request comes back (must be done on main UI thread)
                            self.delay(4.0, closure: {MBProgressHUD.hideHUDForView(self.view, animated: true)})

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
