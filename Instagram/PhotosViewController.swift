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
    
    
    var instagram: [NSDictionary]? //Declare variable to retrieve data from API

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        
        tableView.rowHeight = 320 //set static row height to the table view

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
                            
                            self.instagram = responseDictionary["data"] as? [NSDictionary]
                            self.tableView.dataSource = self
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
        
        let posterPath = instagramElement.valueForKeyPath("images.low_resolution.url") as! String
        
       
        
        let imageUrl = NSURL(string: posterPath)
        
        cell.instagramImage.setImageWithURL(imageUrl!)
        
        return cell
    
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
